// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright (C) 2024 Sedecal S.A.
// This file is part of OzonobaricD.
// See LICENSE file for details.

import QtQuick 2.15
import QtQml.StateMachine 1.5
import AppConstants 1.0
import "SocketProtocol.js" as SP

//State {                                                                                                                       // @disable-check M128
//    id: s1
//    // create a transition from s1 to s2 when the button is clicked
//    SignalTransition { targetState: s2; signal: mySignal }                                                                    // @disable-check M128  @disable-check M16
//    // do something when the state enters/exits
//    onEntered:{                                                                                                               // @disable-check M16
//        currentState = dbtools.idName(s1)
//        console.log("State machine:", currentState, "entered")
//    }
//    onExited:{                                                                                                                // @disable-check M16
//        console.log("State machine:", currentState, "exited")
//    }
//}

StateMachine {                                                                                                                          // @disable-check M129
    id: stateMachine
    property bool   demoMode: false  // DEBUG PURPOSE: "true" value allows to remain in waiting for therapy selection
                                     // after going out from config mode when config mode was accesed inmediatelly
                                     // after bluethood connection.
    property string currentState: ""
    property var    startState: waitingForProtocol
    property bool   vacuumPauseOccurred: false // Azure Bug 10423: (SDV) Image glitch when generating vacuum by time or by pressure

    property alias  waitingForProtocol: waitingForProtocol
//  property alias  startUpUnlinked : startUpUnlinked
    property alias  startUpConnecting : startUpConnecting
    property alias  waitingForSetup : waitingForSetup

    signal setupDelayEnd()

    initialState: noError                                                                                                               // @disable-check M16 @disable-check M31
    running: false

    State {
        id: noError
        initialState: startState
//      SignalTransition { targetState: error; signal: simulator.error } /* example of simulator signal for debug */                    // @disable-check M128 @disable-check M16 @disable-check M31
        SignalTransition { targetState: error; signal: fsmSignals.error }                                                               // @disable-check M128 @disable-check M16 @disable-check M31

        State {                                                                                                                         // @disable-check M128
            id: waitingForSetup
            SignalTransition { targetState: startUpConnecting; signal: setupDelayEnd }                                               // @disable-check M128 @disable-check M16 @disable-check M31
            onEntered:{                                                                                                                 // @disable-check M16  @disable-check M31
                currentState = dbtools.idName(waitingForSetup);
                console.log("State machine:", currentState, "entered")
                startUp.state = "connecting"
                appSplash.state = "fadeOut"
                android.keepScreenOn(true)
                restartConnectionGuard.restart()
                setupDealyTimer.restart()
            }
            onExited:{                                                                                                                  // @disable-check M16  @disable-check M31
                console.log("State machine:", currentState, "exited")
            }
        }



        State {                                                                                                                         // @disable-check M128
            id: waitingForProtocol
            SignalTransition { targetState: protocolEditing; signal: protocolSelector.protocolSelected }                                // @disable-check M128 @disable-check M16 @disable-check M31
            SignalTransition { targetState: configEditing;   signal: configArea.editing }                                               // @disable-check M128 @disable-check M16 @disable-check M31
            onEntered:{                                                                                                                 // @disable-check M16  @disable-check M31
                currentState = dbtools.idName(waitingForProtocol);
                console.log("State machine:", currentState, "entered")

                toolBar.disableItems([Const.controls.play, Const.controls.pause, Const.controls.stop, Const.controls.help])
                protocolSelector.enabled = true
                customerName.visible = true
                protocolSwipeArea.enabled = true
                startUp.state = "hide"
                pageIndicator.visible = true
                pressureGadget.visible = false
                android.keepScreenOn(false)
            }
            onExited:{                                                                                                                  // @disable-check M16  @disable-check M31
                console.log("State machine:", currentState, "exited")
                protocolSwipeArea.enabled = false
          //     toolBar.enableItems()
            }
        }
        State {                                                                                                                         // @disable-check M128
            id: protocolEditing
            SignalTransition { targetState: protocolEditingParameter; signal: inputSelector.editing }                                   // @disable-check M128 @disable-check M16 @disable-check M31
            SignalTransition { targetState: gadgetEditing;            signal: pressureGadget.editing }                                  // @disable-check M128 @disable-check M16 @disable-check M31
            SignalTransition { targetState: waitingForProtocol;       signal: protocolSelector.protocolDeselected }                     // @disable-check M128 @disable-check M16 @disable-check M31
            SignalTransition { targetState: configEditing;            signal: configArea.editing }                                      // @disable-check M128 @disable-check M16 @disable-check M31
            SignalTransition { targetState: adjusting;                signal: fsmSignals.adjusting }                                    // @disable-check M128 @disable-check M16 @disable-check M31
            SignalTransition { targetState: vacuum;                   signal: fsmSignals.vacuum }                                       // @disable-check M128 @disable-check M16 @disable-check M31

            // Azure Bug 10734: (SDV2) Pressure gadget not disbled in time.
            SignalTransition {                                        signal: toolBar.playClicked                                       // @disable-check M128 @disable-check M16
                               onTriggered: { toolBar.disableItems()                                                                    // @disable-check M16
                                              protocolSelector.enabled = false
                                              inputSelector.disableNoSelectecItems(-1)
                                              advertising.active = true
                                              pressureGadget.visible = false
                                              resultView.close()} }
            onEntered:{                                                                                                                 // @disable-check M16  @disable-check M31
                currentState = dbtools.idName(protocolEditing)
                console.log("State machine:", currentState, "entered")

                advertising.active = false
                toolBar.disableItems([Const.controls.pause, Const.controls.stop])
                protocolSelector.enabled = true
                inputSelector.enableItems()
                pressureGadget.load(protocolSelector.currentProtocol)                
                customerName.visible = true
                resultView.close()
                protocolSwipeArea.enabled = true
                android.keepScreenOn(false)
            }
            onExited:{                                                                                                                  // @disable-check M16@disable-check M31
                console.log("State machine:", currentState, "exited")
                protocolSwipeArea.enabled = false
            }
        }
        State {                                                                                                                         // @disable-check M128
            id: protocolEditingParameter
            SignalTransition { targetState: protocolEditing; signal: inputSelector.editionEnd }                                         // @disable-check M128 @disable-check M16@disable-check M31
            onEntered:{                                                                                                                 // @disable-check M16  @disable-check M31
                currentState = dbtools.idName(protocolEditingParameter)
                console.log("State machine:", currentState, "entered")

                toolBar.enableItems([Const.controls.help])
                helpMenu.disableItems(["manual", "diagram", "protocol_video"])
                protocolSelector.enabled = false
                pressureGadget.enabled = false
            }
            onExited:{                                                                                                                  // @disable-check M16  @disable-check M31
                console.log("State machine:", currentState, "exited")

                toolBar.enableItems()
                helpMenu.enableItems()
                protocolSelector.enabled = true
                pressureGadget.enabled = true
            }
        }
        State {                                                                                                                         // @disable-check M128
            id: adjusting
//          SignalTransition { targetState: protocolEditing; signal: toolBar.stopClicked }                                              // @disable-check M128 @disable-check M16 @disable-check M31
            SignalTransition { targetState: protocolEditing; signal: fsmSignals.endGeneration }                                         // @disable-check M128 @disable-check M16 @disable-check M31
            SignalTransition { targetState: generating;      signal: fsmSignals.generating }                                            // @disable-check M128 @disable-check M16 @disable-check M31
            onEntered:{                                                                                                                 // @disable-check M16  @disable-check M31
                currentState = dbtools.idName(adjusting)
                console.log("State machine:", currentState, "entered")

                toolBar.enableItems([Const.controls.stop])
                protocolSelector.enabled = false
                inputSelector.disableNoSelectecItems(-1)
                waitingAnimator.visible = true
                advertising.active = true
                pressureGadget.visible = false
                resultView.close()

                // comming from vacuum
                customerName.visible = true
                progressView.hide()
                pressureMetter.hide()
                android.keepScreenOn(true)
            }
            onExited:{                                                                                                                  // @disable-check M16 @disable-check M31
                console.log("State machine:", currentState, "exited")

                waitingAnimator.visible = false
                //          pressureGadget.load(protocolSelector.currentProtocol)
                //          remove when app be ready...............
                //          advertising.active = false
                //          toolBar.enableItems()
                //          protocolSelector.enabled = true
                //          inputSelector.enableItems()
            }
        }
        State {                                                                                                                         // @disable-check M128
            id: generating
//          SignalTransition { targetState: pause;   signal: toolBar.pauseClicked }                                                     // @disable-check M128 @disable-check M16 @disable-check M31
            SignalTransition { targetState: cancel;  signal: toolBar.stopClickedDelayed }                                               // @disable-check M128 @disable-check M16 @disable-check M31
            SignalTransition { targetState: end;     signal: fsmSignals.endGeneration }                                                 // @disable-check M128 @disable-check M16 @disable-check M31
            SignalTransition { targetState: vacuum;  signal: fsmSignals.vacuum }                                                        // @disable-check M128 @disable-check M16 @disable-check M31
            SignalTransition { targetState: waiting; signal: fsmSignals.waiting }                                                       // @disable-check M128 @disable-check M16 @disable-check M31
            SignalTransition { targetState: pause;   signal: fsmSignals.pause }                                                         // @disable-check M128 @disable-check M16 @disable-check M31
            onEntered:{                                                                                                                 // @disable-check M16  @disable-check M31
                currentState = dbtools.idName(generating)
                console.log("State machine:", currentState, "entered")

                customerName.visible = false
//              toolBar.enableItems(["pause", "stop"])
//              toolBar.enableItems(["stop", protocolSelector.pauseNeeded[protocolSelector.currentProtocol]])
//              toolBar.enableItems([protocolSelector.needPlay(protocolSelector.currentProtocol), protocolSelector.needPause(protocolSelector.currentProtocol), Const.controls.stop])
                toolBar.enableItems(protocolSelector.generatingControls(protocolSelector.currentProtocol))
                progressView.show()
                pressureMetter.show()
                emergencyButton.resolveVisibility(protocolSelector.currentProtocol)
            }
            onExited:{                                                                                                                  // @disable-check M16  @disable-check M31
                console.log("State machine:", currentState, "exited")
//                progressView.hide()
//                pressureMetter.hide()
            }
        }
        State {                                                                                                                         // @disable-check M128
            id: vacuum
            SignalTransition { targetState: pause;     signal: fsmSignals.pauseVac                                                      // @disable-check M128 @disable-check M16 @disable-check M31
                               onTriggered: vacuumPauseOccurred = true }  // Azure Bug 10423: (SDV) Image glitch when generating vacuum by time or by pressure @disable-check M16
            SignalTransition { targetState: end;       signal: fsmSignals.endGeneration }                                               // @disable-check M128 @disable-check M16 @disable-check M31
            SignalTransition { targetState: adjusting; signal: fsmSignals.adjusting }                                                   // @disable-check M128 @disable-check M16 @disable-check M31
            onEntered:{                                                                                                                 // @disable-check M16  @disable-check M31
                currentState = dbtools.idName(vacuum)
                console.log("State machine:", currentState, "entered")
                // comming from protocolEditing
                customerName.visible = false
                protocolSelector.enabled = false
                inputSelector.disableNoSelectecItems(-1)
                advertising.active = true
                pressureGadget.visible = false
                resultView.close()

                // allways necessary
//              toolBar.enableItems([Const.controls.play, Const.controls.stop])
                toolBar.enableItems(protocolSelector.generatingControls(protocolSelector.currentProtocol))

                if(!vacuumPauseOccurred) // Azure Bug 10423: (SDV) Image glitch when generating vacuum by time or by pressure (refresh only at the very first time)
                {
                    progressView.show()
                }
                vacuumPauseOccurred = false

                SP.showPressureMetterDuringVacuum()
            }
            onExited:{                                                                                                                  // @disable-check M16  @disable-check M31
                console.log("State machine:", currentState, "exited")
            }
        }
        State {                                                                                                                         // @disable-check M128
            id: waiting
            SignalTransition { targetState: vacuum;  signal: fsmSignals.vacuum }                                                        // @disable-check M128 @disable-check M16 @disable-check M31
            SignalTransition { targetState: end;     signal: fsmSignals.endGeneration }                                                 // @disable-check M128 @disable-check M16 @disable-check M31
            onEntered:{                                                                                                                 // @disable-check M16  @disable-check M31
                currentState = dbtools.idName(waiting)
                console.log("State machine:", currentState, "entered")
            }
            onExited:{                                                                                                                  // @disable-check M16  @disable-check M31
                console.log("State machine:", currentState, "exited")
            }
        }
        State {                                                                                                                         // @disable-check M128
            id: pause
//          SignalTransition { targetState: generating; signal: toolBar.playClicked }                                                   // @disable-check M128 @disable-check M16 @disable-check M31
            SignalTransition { targetState: generating; signal: fsmSignals.play }                                                       // @disable-check M128 @disable-check M16 @disable-check M31
            SignalTransition { targetState: end;        signal: fsmSignals.endGeneration }                                              // @disable-check M128 @disable-check M16 @disable-check M31
            SignalTransition { targetState: vacuum;     signal: fsmSignals.vacuum }                                                     // @disable-check M128 @disable-check M16 @disable-check M31
            SignalTransition { targetState: cancel;     signal: toolBar.stopClickedDelayed }                                            // @disable-check M128 @disable-check M16 @disable-check M31
            onEntered:{                                                                                                                 // @disable-check M16  @disable-check M31
                currentState = dbtools.idName(pause)
                console.log("State machine:", currentState, "entered")
                toolBar.enableItems([Const.controls.play, Const.controls.stop])
            }
            onExited:{                                                                                                                  // @disable-check M16  @disable-check M31
                console.log("State machine:", currentState, "exited")
            }
        }
        State {                                                                                                                         // @disable-check M128
            id: end
            SignalTransition { targetState: protocolEditing; signal: resultView.done                                                    // @disable-check M128 @disable-check M16 @disable-check M31
                               onTriggered: consoleSocket.sendData("{CNL_SIM\r") }                                                      // @disable-check M16
            SignalTransition { targetState: adjusting;                signal: fsmSignals.adjusting }                                    // @disable-check M128 @disable-check M16 @disable-check M31
            SignalTransition { targetState: vacuum;                   signal: fsmSignals.vacuum }                                       // @disable-check M128 @disable-check M16 @disable-check M31
            onEntered:{                                                                                                                 // @disable-check M16  @disable-check M31
                currentState = dbtools.idName(end)
                console.log("State machine:", currentState, "entered")

                if(protocolSelector.currentProtocol === Const.protocol.syringe_auto) // Azure Bug 10505: (SDV) Play button after complete functionality lost.
                {
                    toolBar.disableItems() // Azure Bug 10378: (SDV) Therapy restarting from cancelled screen fails.
                }
                else{
                    toolBar.enableItems([Const.controls.play])
                }

                advertising.active = false
//              progressView.clearProgress()
                resultView.expand()
                progressView.hide()
                pressureMetter.hide()
                emergencyButton.visible = false
                android.keepScreenOn(false)
            }
            onExited:{                                                                                                                  // @disable-check M16 @disable-check M31
                console.log("State machine:", currentState, "exited")
            }
        }
        State {                                                                                                                         // @disable-check M128
            id: cancel
            SignalTransition { targetState: protocolEditing; signal: resultView.done }                                                  // @disable-check M128 @disable-check M16 @disable-check M31
            SignalTransition { targetState: adjusting;       signal: fsmSignals.adjusting }                                             // @disable-check M128 @disable-check M16 @disable-check M31
            SignalTransition { targetState: vacuum;          signal: fsmSignals.vacuum }                                                // @disable-check M128 @disable-check M16 @disable-check M31
            onEntered:{                                                                                                                 // @disable-check M16  @disable-check M31
                currentState = dbtools.idName(cancel)
                console.log("State machine:", currentState, "entered")

                advertising.active = false
                toolBar.enableItems([Const.controls.play])
//////                progressView.clearProgress()
                resultView.expand()
                progressView.hide()
                pressureMetter.hide()
                emergencyButton.visible = false
                android.keepScreenOn(false)
            }
            onExited:{                                                                                                                  // @disable-check M16  @disable-check M31
                console.log("State machine:", currentState, "exited")
            }
        }

        State {                                                                                                                         // @disable-check M128
            id: gadgetEditing
            SignalTransition { targetState: protocolEditing; signal: pressureGadget.editionEnd                                          // @disable-check M128 @disable-check M16 @disable-check M31
                               onTriggered: consoleSocket.sendData("{CNL_SIM\r") }  //Bug 10901: (SDV 2) Wrong color on led status bar  // @disable-check M16
//          SignalTransition { targetState: gadgetAdjusting; signal: pressureGadget.start }                                             // @disable-check M128 @disable-check M16 @disable-check M31
            SignalTransition { targetState: gadgetAdjusting; signal: fsmSignals.adjusting }                                             // @disable-check M128 @disable-check M16 @disable-check M31
            onEntered:{                                                                                                                 // @disable-check M16  @disable-check M31
                currentState = dbtools.idName(gadgetEditing)
                console.log("State machine:", currentState, "entered")

                SP.configurePressureGadget()

                toolBar.enableItems([Const.controls.help])
                helpMenu.disableItems(["manual", "diagram", "protocol_video"])
                protocolSelector.enabled = false
                inputSelector.disableNoSelectecItems(-1)
                pressureGadget.pressureTestState = "none"//pressureGadget.pressureTestStates.none
                android.keepScreenOn(false)
            }
            onExited:{                                                                                                                  // @disable-check M16  @disable-check M31
                console.log("State machine:", currentState, "exited")

                helpMenu.enableItems()
//              toolBar.enableItems()
//              protocolSelector.enabled = true
//              inputSelector.enableItems()
            }
        }
        State {                                                                                                                         // @disable-check M128
            id: gadgetAdjusting
            SignalTransition { targetState: protocolEditing;  signal: pressureGadget.editionEnd }                                       // @disable-check M128 @disable-check M16 @disable-check M31
//          SignalTransition { targetState: gadgetEditing;    signal: pressureGadget.stop }                                             // @disable-check M128 @disable-check M16 @disable-check M31
            SignalTransition { targetState: gadgetEditing;    signal: fsmSignals.endGeneration }                                        // @disable-check M128 @disable-check M16 @disable-check M31
            SignalTransition { targetState: gadgetGenerating; signal: fsmSignals.generating }                                           // @disable-check M128 @disable-check M16 @disable-check M31
            onEntered:{                                                                                                                 // @disable-check M16  @disable-check M31
                currentState = dbtools.idName(gadgetAdjusting)
                console.log("State machine:", currentState, "entered")

                toolBar.disableItems()
                pressureGadget.pressureTestState = "waiting"//pressureGadget.pressureTestStates.waiting
                android.keepScreenOn(true)
            }
            onExited:{                                                                                                                  // @disable-check M16  @disable-check M31
                console.log("State machine:", currentState, "exited")
            }
        }
        State {                                                                                                                         // @disable-check M128
            id: gadgetGenerating
            SignalTransition { targetState: protocolEditing;    signal: pressureGadget.editionEnd }                                     // @disable-check M128 @disable-check M16 @disable-check M31
//          SignalTransition { targetState: gadgetEditing;      signal: pressureGadget.stop }                                           // @disable-check M128 @disable-check M16 @disable-check M31
            SignalTransition { targetState: gadgetEditing;      signal: fsmSignals.endGeneration }                                      // @disable-check M128 @disable-check M16 @disable-check M31
            SignalTransition { targetState: gadgetOverpressure; signal: fsmSignals.gadgetOverpressure }                                 // @disable-check M128 @disable-check M16 @disable-check M31
            onEntered:{                                                                                                                 // @disable-check M16  @disable-check M31
                currentState = dbtools.idName(gadgetGenerating)
                console.log("State machine:", currentState, "entered")

                toolBar.disableItems()
                pressureGadget.pressureTestState = "generating"//pressureGadget.pressureTestStates.generating
            }
            onExited:{                                                                                                                  // @disable-check M16  @disable-check M31
                console.log("State machine:", currentState, "exited")
            }
        }
        State {                                                                                                                         // @disable-check M128
            id: gadgetOverpressure
            SignalTransition { targetState: protocolEditing; signal: pressureGadget.editionEnd }                                        // @disable-check M128 @disable-check M16 @disable-check M31
            SignalTransition { targetState: gadgetEditing;   signal: pressureGadget.resetError                                          // @disable-check M128 @disable-check M16 @disable-check M31
                               onTriggered: consoleSocket.sendData("{CNL_SIM\r") }                                                      // @disable-check M16
            onEntered:{                                                                                                                 // @disable-check M16  @disable-check M31
                currentState = dbtools.idName(gadgetOverpressure)
                console.log("State machine:", currentState, "entered")

                toolBar.enableItems([Const.controls.help])
                pressureGadget.pressureTestState = "overpressure"//pressureGadget.pressureTestStates.overpressure
                android.keepScreenOn(false)
            }
            onExited:{                                                                                                                  // @disable-check M16  @disable-check M31
                console.log("State machine:", currentState, "exited")
            }
        }

//        startUp.linkStatus
//demoMode
        /*
            SignalTransition { targetState: waitingForProtocol; signal: configArea.editionEnd; guard:  appMain.startUpComplete & !protocolSelector.isExecutableProtocol}  // @disable-check M128 @disable-check M16 @disable-check M31
            SignalTransition { targetState: protocolEditing;    signal: configArea.editionEnd; guard:  appMain.startUpComplete &  protocolSelector.isExecutableProtocol}  // @disable-check M128 @disable-check M16 @disable-check M31
            SignalTransition { targetState: startUpConnected;   signal: configArea.editionEnd; guard: !appMain.startUpComplete &  startUp.linkStatus;     // @disable-check M128 @disable-check M16 @disable-check M31
                               onTriggered: restartConnectionGuard.restart() }                                                                            // @disable-check M128 @disable-check M16 @disable-check M31
            SignalTransition { targetState: startUpConnecting;  signal: configArea.editionEnd; guard: !appMain.startUpComplete & !startUp.linkStatus}     // @disable-check M128 @disable-check M16 @disable-check M31

*/
        State {                                                                                                                                           // @disable-check M128
            id: configEditing
            SignalTransition { targetState: waitingForProtocol; signal: configArea.editionEnd; guard:  demoMode;                                                                     // @disable-check M128 @disable-check M16 @disable-check M31
                               onTriggered: consoleSocket.sendData("{SET_SKIP_ERROR,0\r") }                                                                                          // @disable-check M16
            SignalTransition { targetState: waitingForProtocol; signal: configArea.editionEnd; guard: !demoMode &  appMain.startUpComplete & !protocolSelector.isExecutableProtocol; // @disable-check M128 @disable-check M16 @disable-check M31
                               onTriggered: consoleSocket.sendData("{SET_SKIP_ERROR,0\r") }                                                                                          // @disable-check M16                                                                           // @disable-check M128 @disable-check M16 @disable-check M31
            SignalTransition { targetState: protocolEditing;    signal: configArea.editionEnd; guard: !demoMode &  appMain.startUpComplete &  protocolSelector.isExecutableProtocol; // @disable-check M128 @disable-check M16 @disable-check M31
                               onTriggered: consoleSocket.sendData("{SET_SKIP_ERROR,0\r") }                                                                                          // @disable-check M16                                                      // @disable-check M128 @disable-check M16 @disable-check M31
            SignalTransition { targetState: startUpConnected;   signal: configArea.editionEnd; guard: !demoMode & !appMain.startUpComplete &  startUp.linkStatus;                    // @disable-check M128 @disable-check M16 @disable-check M31
                               onTriggered: {restartConnectionGuard.restart(); consoleSocket.sendData("{SET_SKIP_ERROR,0\r")} }                                                                                                        // @disable-check M128 @disable-check M16 @disable-check M31
            SignalTransition { targetState: startUpConnecting;  signal: configArea.editionEnd; guard: !demoMode & !appMain.startUpComplete & !startUp.linkStatus}                    // @disable-check M128 @disable-check M16 @disable-check M31
            SignalTransition { targetState: configLoading;      signal: configArea.deviceInfo.loadParamInfo.yes }                                                                    // @disable-check M128 @disable-check M16 @disable-check M31
            SignalTransition { targetState: configConnecting;   signal: configArea.deviceInfo.bluetoothInfo.start }                                                                  // @disable-check M128 @disable-check M16 @disable-check M31
            SignalTransition { targetState: configSaving;       signal: configArea.deviceCalibration.saveParamInfo.yes }                                                             // @disable-check M128 @disable-check M16 @disable-check M31
            SignalTransition { targetState: configPeriod;       signal: configArea.deviceCalibration.periodCalibrationInfo.yes }                                                     // @disable-check M128 @disable-check M16 @disable-check M31
            SignalTransition { targetState: configResetTime;    signal: configArea.deviceCalibration.resetTimeInfo.yes }                                                             // @disable-check M128 @disable-check M16 @disable-check M31
            SignalTransition { targetState: configSearching;    signal: configArea.deviceCalibration.linkGeneratorInfo.buttonClicked}                                                // @disable-check M128 @disable-check M16 @disable-check M31
            SignalTransition { targetState: configPressure;     signal: configArea.deviceCalibration.calibrationStart; guard: (calibType === "pressure")}                            // @disable-check M128 @disable-check M16 @disable-check M31 @disable-check M325
            SignalTransition { targetState: configFlow;         signal: configArea.deviceCalibration.calibrationStart; guard: (calibType === "flow")}                                // @disable-check M128 @disable-check M16 @disable-check M31 @disable-check M325
            SignalTransition { targetState: configO3;           signal: configArea.deviceCalibration.calibrationStart; guard: (calibType === "O3")}                                  // @disable-check M128 @disable-check M16 @disable-check M31 @disable-check M325
            onEntered:{                                                                                                                                                              // @disable-check M16  @disable-check M31
                currentState = dbtools.idName(configEditing)
                console.log("State machine:", currentState, "entered")
                consoleSocket.sendData("{GETVER\r")
                consoleSocket.sendData("{CNL_SIM\r")
                consoleSocket.sendData("{SET_SKIP_ERROR,1\r")
//              inputSelector.load()
//              pressureGadget.load()
                toolBar.disableItems()
                protocolSelector.enabled = false
                protocolSelector.closeTabs()
                startUp.state = "hide"
                pageIndicator.visible = false
                android.keepScreenOn(false)
            }
            onExited:{                                                                                                                                    // @disable-check M16  @disable-check M31
                console.log("State machine:", currentState, "exited")
            }
        }
        State {                                                                                                                         // @disable-check M128
            id: configLoading
            SignalTransition { targetState: configEditing; signal: configArea.deviceInfo.loadParamInfo.no }                             // @disable-check M128 @disable-check M16 @disable-check M31
            SignalTransition { targetState: configEditing; signal: fsmSignals.loadParamEnd                                              // @disable-check M128 @disable-check M16 @disable-check M31
                               onTriggered: configArea.deviceInfo.loadParamInfo.state = loadError ? "error" : "completed"               // @disable-check M16
            }
            onEntered:{                                                                                                                 // @disable-check M16  @disable-check M31
                currentState = dbtools.idName(configLoading)
                console.log("State machine:", currentState, "entered")
                android.keepScreenOn(true)
                consoleSocket.sendData("{LOADPAR\r")
                consoleSocket.sendData("{ENT_SIM\r")
            }
            onExited:{                                                                                                                  // @disable-check M16  @disable-check M31
                console.log("State machine:", currentState, "exited")
            }
        }
        State {                                                                                                                         // @disable-check M128
            id: configConnecting
            SignalTransition { targetState: configEditing; signal: configArea.deviceInfo.bluetoothInfo.cancel                           // @disable-check M128 @disable-check M16 @disable-check M31
                               onTriggered: { configArea.deviceInfo.bluetoothInfo.state = "disconnected"                                // @disable-check M16
                                              consoleSocket.sendData("{SERIAL_STOP_BOOT\r") }
            }
            SignalTransition { targetState: configEditing; signal: fsmSignals.bluetoothLinked                                           // @disable-check M128 @disable-check M16 @disable-check M31
                               onTriggered: { configArea.deviceInfo.bluetoothInfo.state = "connected" }                                 // @disable-check M16
            }
            onEntered:{                                                                                                                 // @disable-check M16  @disable-check M31
                currentState = dbtools.idName(configConnecting)
                console.log("State machine:", currentState, "entered")
              //consoleSocket.sendData("{SERIAL_BOOT\r")
                SP.startConnection(configArea.deviceCalibration.linkGeneratorInfo.linkedDevice)
                android.keepScreenOn(true)
            }
            onExited:{                                                                                                                  // @disable-check M16  @disable-check M31
                console.log("State machine:", currentState, "exited")
            }
        }
        State {                                                                                                                         // @disable-check M128
            id: configSaving
            SignalTransition { targetState: configEditing; signal: configArea.deviceCalibration.saveParamInfo.no }                      // @disable-check M128 @disable-check M16 @disable-check M31
            SignalTransition { targetState: configEditing; signal: fsmSignals.saveParamEnd                                              // @disable-check M128 @disable-check M16 @disable-check M31
                               onTriggered: configArea.deviceCalibration.saveParamInfo.state = saveError ? "error" : "completed"        // @disable-check M16
            }
            onEntered:{                                                                                                                 // @disable-check M16  @disable-check M31
                currentState = dbtools.idName(configSaving)
                console.log("State machine:", currentState, "entered")
                consoleSocket.sendData("{SAVEPAR\r")
                consoleSocket.sendData("{ENT_SIM\r")
            }
            onExited:{                                                                                                                  // @disable-check M16  @disable-check M31
                console.log("State machine:", currentState, "exited")
            }
        }
        State {                                                                                                                         // @disable-check M128
            id: configPeriod
            SignalTransition { targetState: configEditing; signal: configArea.deviceCalibration.periodCalibrationInfo.no }              // @disable-check M128 @disable-check M16 @disable-check M31
            SignalTransition { targetState: configEditing; signal: configArea.deviceCalibration.calibrationEnd                          // @disable-check M128 @disable-check M16 @disable-check M31
                               onTriggered: configArea.deviceCalibration.periodCalibrationInfo.state = "completed"                      // @disable-check M16
            }
//            SignalTransition { targetState: configEditing; signal: configArea.deviceCalibration.calibrationError                        // @disable-check M128 @disable-check M16 @disable-check M31
//                               onTriggered: configArea.deviceCalibration.periodCalibrationInfo.state = "error"                          // @disable-check M16
//            }
            onEntered:{                                                                                                                 // @disable-check M16  @disable-check M31
                currentState = dbtools.idName(configPeriod)
                console.log("State machine:", currentState, "entered")
                android.keepScreenOn(true)
                consoleSocket.sendData("{CALPER\r")
            }
            onExited:{                                                                                                                  // @disable-check M16  @disable-check M31
                console.log("State machine:", currentState, "exited")
            }
        }
        State {                                                                                                                         // @disable-check M128
            id: configResetTime
            SignalTransition { targetState: configEditing; signal: configArea.deviceCalibration.resetTimeInfo.no }                      // @disable-check M128 @disable-check M16 @disable-check M31
            onEntered:{                                                                                                                 // @disable-check M16  @disable-check M31
                currentState = dbtools.idName(configResetTime)
                console.log("State machine:", currentState, "entered")
            }
            onExited:{                                                                                                                  // @disable-check M16  @disable-check M31
                console.log("State machine:", currentState, "exited")
            }
        }
        State {                                                                                                                         // @disable-check M128
            id: configSearching
            SignalTransition { targetState: configEditing;   signal: configArea.deviceCalibration.linkGeneratorInfo.buttonClicked }     // @disable-check M128 @disable-check M16 @disable-check M31
            SignalTransition { targetState: configSearchEnd; signal: configArea.deviceCalibration.linkGeneratorInfo.searchEnd }         // @disable-check M128 @disable-check M16 @disable-check M31
            SignalTransition { targetState: configLinking;   signal: configArea.deviceCalibration.linkGeneratorInfo.devClicked          // @disable-check M128 @disable-check M16 @disable-check M31
                               onTriggered: SP.startConnection(device, index) }                                                         // @disable-check M128 @disable-check M16 @disable-check M31
            onEntered:{                                                                                                                 // @disable-check M16  @disable-check M31
                currentState = dbtools.idName(configSearching)
                console.log("State machine:", currentState, "entered")
                consoleSocket.sendData("{SERIAL_DISC\r")
                android.keepScreenOn(true)
            }
            onExited:{                                                                                                                  // @disable-check M16  @disable-check M31
                console.log("State machine:", currentState, "exited")
                consoleSocket.sendData("{SERIAL_STOP_DISC\r")
            }
        }
        State {                                                                                                                         // @disable-check M128
            id: configSearchEnd
            SignalTransition { targetState: configEditing;   signal: configArea.deviceCalibration.linkGeneratorInfo.backButtonClicked } // @disable-check M128 @disable-check M16 @disable-check M31
            SignalTransition { targetState: configSearching; signal: configArea.deviceCalibration.linkGeneratorInfo.buttonClicked }     // @disable-check M128 @disable-check M16 @disable-check M31
            SignalTransition { targetState: configLinking;   signal: configArea.deviceCalibration.linkGeneratorInfo.devClicked          // @disable-check M128 @disable-check M16 @disable-check M31
                               onTriggered: SP.startConnection(device, index) }                                                         // @disable-check M128 @disable-check M16 @disable-check M31
            onEntered:{                                                                                                                 // @disable-check M16  @disable-check M31
                currentState = dbtools.idName(configSearchEnd)
                console.log("State machine:", currentState, "entered")
                configArea.deviceCalibration.linkGeneratorInfo.state = "searchEnd"
            }
            onExited:{                                                                                                                  // @disable-check M16  @disable-check M31
                console.log("State machine:", currentState, "exited")
            }
        }
        State {                                                                                                                         // @disable-check M128
            id: configLinking
            SignalTransition { targetState: configEditing; signal: configArea.deviceCalibration.linkGeneratorInfo.buttonClicked }       // @disable-check M128 @disable-check M16 @disable-check M31
            SignalTransition { targetState: configEditing; signal: configArea.deviceCalibration.linkGeneratorInfo.linked }              // @disable-check M128 @disable-check M16 @disable-check M31
            SignalTransition { targetState: configEditing; signal: configArea.deviceCalibration.linkGeneratorInfo.unLinked              // @disable-check M128 @disable-check M16 @disable-check M31
                               onTriggered: consoleSocket.sendData("{SERIAL_STOP_BOOT\r") }                                             // @disable-check M16
            onEntered:{                                                                                                                 // @disable-check M16  @disable-check M31
                currentState = dbtools.idName(configLinking)
                console.log("State machine:", currentState, "entered")
                configArea.deviceCalibration.linkGeneratorInfo.state = "linking"
            }
            onExited:{                                                                                                                  // @disable-check M16  @disable-check M31
                console.log("State machine:", currentState, "exited")
                configArea.deviceCalibration.linkGeneratorInfo.state = "showStatus"
            }
        }
        State {                                                                                                                         // @disable-check M128
            id: configPressure
          SignalTransition { targetState: configEditing; signal: configArea.deviceCalibration.calibrationEnd }                          // @disable-check M128 @disable-check M16 @disable-check M31
//            SignalTransition { targetState: configEditing; signal: configArea.deviceCalibration.calibrationChanged                    // @disable-check M128 @disable-check M16 @disable-check M31
//                               onTriggered:{consoleSocket.sendData("{ENT_SIM\r")}}                                                    // @disable-check M16
//            SignalTransition { targetState: configEditing; signal: configArea.deviceCalibration.calibrationNotChanged                 // @disable-check M128 @disable-check M16 @disable-check M31
//                               onTriggered: consoleSocket.sendData("{CNL_SIM\r") }                                                    // @disable-check M16
            onEntered:{                                                                                                                 // @disable-check M16  @disable-check M31
                currentState = dbtools.idName(configPressure)
                console.log("State machine:", currentState, "entered")
                android.keepScreenOn(true)
                consoleSocket.sendData("{CALPRESS\r")
            }
            onExited:{                                                                                                                  // @disable-check M16  @disable-check M31
                console.log("State machine:", currentState, "exited")
            }
        }
        State {                                                                                                                         // @disable-check M128
            id: configFlow
            SignalTransition { targetState: configEditing; signal: configArea.deviceCalibration.calibrationEnd }                        // @disable-check M128 @disable-check M16 @disable-check M31
            onEntered:{                                                                                                                 // @disable-check M16  @disable-check M31
                currentState = dbtools.idName(configFlow)
                console.log("State machine:", currentState, "entered")
                android.keepScreenOn(true)
                consoleSocket.sendData("{CALFLOW\r")
            }
            onExited:{                                                                                                                  // @disable-check M16  @disable-check M31
                console.log("State machine:", currentState, "exited")
            }
        }
        State {                                                                                                                         // @disable-check M128
            id: configO3
            SignalTransition { targetState: configEditing; signal: configArea.deviceCalibration.calibrationEnd }                        // @disable-check M128 @disable-check M16 @disable-check M31
            SignalTransition { targetState: configEditing; signal: fsmSignals.configO3end                                               // @disable-check M128 @disable-check M16 @disable-check M31
                               onTriggered: configArea.deviceCalibration.closeAllCards() }                                              // @disable-check M16
            onEntered:{                                                                                                                 // @disable-check M16  @disable-check M31
                currentState = dbtools.idName(configO3)
                console.log("State machine:", currentState, "entered")
                android.keepScreenOn(true)
                consoleSocket.sendData("{CALO3\r")
            }
            onExited:{                                                                                                                  // @disable-check M16  @disable-check M31
                console.log("State machine:", currentState, "exited")
                android.keepScreenOn(true)
            }
        }
//        State {                                                                                                                         // @disable-check M128
//            id: startUpUnlinked
//            SignalTransition { targetState: configEditing; signal: startUp.onExitToSettings }                                           // @disable-check M128 @disable-check M16 @disable-check M31
//            onEntered:{                                                                                                                 // @disable-check M16  @disable-check M31
//                currentState = dbtools.idName(startUpUnlinked)
//                console.log("State machine:", currentState, "entered")
//                startUp.state = "noLink"
//                android.keepScreenOn(false)
//            }
//            onExited:{                                                                                                                  // @disable-check M16  @disable-check M31
//                console.log("State machine:", currentState, "exited")
//            }
//        }
        State {                                                                                                                         // @disable-check M128
            id: startUpConnecting
            SignalTransition { targetState: startUpConnectionFail;               signal: startUp.cancelConnection }                     // @disable-check M128 @disable-check M16 @disable-check M31
            SignalTransition { targetState: startUpGhostConnectingSecondAttempt; signal: startUp.connectionTout }                       // @disable-check M128 @disable-check M16 @disable-check M31
            SignalTransition { targetState: startUpConnected;                    signal: fsmSignals.bluetoothLinked }                   // @disable-check M128 @disable-check M16 @disable-check M31
            onEntered:{                                                                                                                 // @disable-check M16  @disable-check M31
                currentState = dbtools.idName(startUpConnecting)
                console.log("State machine:", currentState, "entered")
                startUp.state = "connecting"
                SP.startConnection(configArea.deviceCalibration.linkGeneratorInfo.linkedDevice)
                configArea.x = configArea.x_s  // no efective on Component.onCompleted event of the declaration
                configArea.y = configArea.y_s  // no efective on Component.onCompleted event of the declaration
            }
            onExited:{                                                                                                                  // @disable-check M16  @disable-check M31
                console.log("State machine:", currentState, "exited")
            }
        }
        State {                                                                                                                         // @disable-check M128
            id: startUpGhostConnectingSecondAttempt
            SignalTransition { targetState: startUpConnectionFail; signal: startUp.cancelConnection }                                   // @disable-check M128 @disable-check M16 @disable-check M31
            SignalTransition { targetState: startUpConnectionFail; signal: startUp.connectionTout }                                     // @disable-check M128 @disable-check M16 @disable-check M31
            SignalTransition { targetState: startUpConnected;      signal: fsmSignals.bluetoothLinked }                                    // @disable-check M128 @disable-check M16 @disable-check M31
            onEntered:{                                                                                                                 // @disable-check M16  @disable-check M31
                currentState = dbtools.idName(startUpGhostConnectingSecondAttempt)
                console.log("State machine:", currentState, "entered")
                startUp.connectingTout.running = true
                startUp.state = "connecting"
                consoleSocket.sendData("{SERIAL_STOP_BOOT\r")
                SP.startConnection(configArea.deviceCalibration.linkGeneratorInfo.linkedDevice)
            }
            onExited:{                                                                                                                  // @disable-check M16  @disable-check M31
                console.log("State machine:", currentState, "exited")
            }
        }
        State {                                                                                                                         // @disable-check M128
            id: startUpConnectionFail
            SignalTransition { targetState: startUpConnecting;  signal: startUp.restartConnection }                                     // @disable-check M128 @disable-check M16 @disable-check M31
            SignalTransition { targetState: configEditing;   signal: startUp.exitToSettings }                                           // @disable-check M128 @disable-check M16 @disable-check M31
//          SignalTransition { targetState: waitingForProtocol; signal: startUp.exitToProtocolSelector                                  // @disable-check M128 @disable-check M16 @disable-check M31
//                             onTriggered: { consoleSocket.sendData("{FSM_BOOT\r"); consoleSocket.sendData("{SERVICE\r") }             // @disable-check M16
//          }
            onEntered:{                                                                                                                 // @disable-check M16  @disable-check M31
                currentState = dbtools.idName(startUpConnectionFail)
                console.log("State machine:", currentState, "entered")
                startUp.state = "connectionFail"
                consoleSocket.sendData("{SERIAL_STOP_BOOT\r")
                android.keepScreenOn(false)
            }
            onExited:{                                                                                                                  // @disable-check M16  @disable-check M31
                console.log("State machine:", currentState, "exited")
            }
        }
        State {                                                                                                                         // @disable-check M128
            id: startUpConnected
            SignalTransition { targetState: configEditing;   signal: startUp.exitToSettings }                                           // @disable-check M128 @disable-check M16 @disable-check M31
            SignalTransition { targetState: startUpStarting; signal: startUp.readyToStart }                                             // @disable-check M128 @disable-check M16 @disable-check M31
            onEntered:{                                                                                                                 // @disable-check M16  @disable-check M31
                currentState = dbtools.idName(startUpConnected)
                console.log("State machine:", currentState, "entered")
                startUp.state = "gotoSettings"
                consoleSocket.sendData("{FSM_BOOT\r")
            }
            onExited:{                                                                                                                  // @disable-check M16  @disable-check M31
                console.log("State machine:", currentState, "exited")
            }
        }
        State {                                                                                                                         // @disable-check M128
            id: startUpStarting
            SignalTransition { targetState: waitingForProtocol; signal: startUp.checked; guard: !restartConnectionGuard.running         // @disable-check M128 @disable-check M16 @disable-check M31
                               onTriggered: appMain.startUpComplete = true                                                              // @disable-check M16
            }
            SignalTransition { targetState: startUpConnecting;  signal: startUp.restartConnection }                                     // @disable-check M128 @disable-check M16 @disable-check M31
            onEntered:{                                                                                                                 // @disable-check M16  @disable-check M31
                currentState = dbtools.idName(startUpStarting)
                console.log("State machine:", currentState, "entered")
                restartConnectionGuard.restart()
                startUp.state = "starting"
                consoleSocket.sendData("{INIT\r")
            }
            onExited:{                                                                                                                  // @disable-check M16  @disable-check M31
                console.log("State machine:", currentState, "exited")
            }
        }
    }
    State {                                                                                                                                    // @disable-check M31
        id: error
        SignalTransition { targetState: waitingForProtocol; signal: resultView.done;           guard: !protocolSelector.isExecutableProtocol}  // @disable-check M128 @disable-check M16 @disable-check M31
        SignalTransition { targetState: protocolEditing;    signal: resultView.done;           guard:  protocolSelector.isExecutableProtocol}  // @disable-check M128 @disable-check M16 @disable-check M31
        SignalTransition { targetState: protocolEditing;    signal: fsmSignals.returnToActive; guard:  protocolSelector.isExecutableProtocol}  // @disable-check M128 @disable-check M16 @disable-check M31
        onEntered:{                                                                                                                            // @disable-check M16  @disable-check M31
            currentState = dbtools.idName(error)
            console.log("State machine:", currentState, "entered")

            inputSelector.reduceAndRestoreItems() // Azure Bug 10740: (SDV 2) Error with magnitude selector opened
            advertising.active = false
            toolBar.enableItems([Const.controls.help])
//          progressView.clearProgress()
            protocolSelector.enabled = false
            inputSelector.disableNoSelectecItems(-1)            
            if(pressureGadget.state === "big"){
                pressureGadget.closePressureGadget()
            }
            pressureGadget.visible = false
            customerName.visible = false
            progressView.hide()
            pressureMetter.hide()
            emergencyButton.visible = false

            configArea.deviceCalibration.closeAllCards()
            configArea.retract()

            // resultView.retract() is usefull in the case error condition appears when resultView is
            // already opened (showing results in 'cancel' or 'end' states).
            // In this situation resultView keeps frame size (corresponding to previous showing result size
            // since expand function doesn't restore error frame size because expand area state is already 'big'.
            // In this case retract function forces expand area state to 'small', then next calling to expand
            // function will generate the right frame size.
            resultView.retract()

            resultView.expand()
        }
        onExited:{                                                                                                                    // @disable-check M16  @disable-check M31
            console.log("State machine:", currentState, "exited")
            resultView.close()
            SP.clearError()
        }
    }

    Timer{
        id: restartConnectionGuard
        interval: 20000
        running: false
        onRunningChanged: console.log("restartConnectionGuard timer (running):", running)
    }

    Timer{
        id: setupDealyTimer
        interval: 2000
        running: false
        onTriggered: setupDelayEnd()
        onRunningChanged: console.log("setupDealyTimer running state:", running,  Qt.formatTime(new Date(), "hh:mm:ss"))
    }
}
