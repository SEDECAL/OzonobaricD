// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright (C) 2024 Sedecal S.A.
// This file is part of OzonobaricD.
// See LICENSE file for details.

import QtQuick 2.15
import QtQuick.Controls 2.15
import "Database.js" as DB

Item {
    property bool  gridView: false
    property color buttonColor: "darkGrey"
    property int   buttonSize: parent.height * 0.06
    property int   visibleSimulator: 0

    signal generating
    signal vacuum
    signal endGeneration
    signal error
    signal gadgetGenerating
//  signal gadgetError
    signal loadParamEnd(bool loadError)
    signal saveParamEnd(bool saveError)
    signal periodEnd(bool periodError)
    signal resetTimeEnd(bool resetTimeError)
    signal btconnect(bool btConnectError)
    signal searchEnd()
    signal deviceFound(string deviceId)
    signal linkEnd(bool linkResult)
    signal connectionTout()
    signal connected()
    signal startUpEnd()
    signal startUpError(int errorCode)

    property var simulators:[
        fakeSimulator,
        normalRunSimulator,
        editingConfigInfoSimulator,
        editingCalibrationSimulator,
        startUpSimulator
    ]

    function nextSimulator(){
        for(var i=0; i<simulators.length; i++){
            if(simulators[i].visible){
                simulators[i].visible = false
                simulators[ (i === simulators.length - 1) ? 0 : i + 1 ].visible = true
                break;
            }
        }
    }

    Component.onCompleted: {
        simulatorButton.visible = true
        fakeSimulator.visible = true
//      normalRunSimulator.visible = true
//      editingConfigInfoSimulator.visible = true
//      editingCalibrationSimulator.visible = true
//      startUpSimulator.visible = true
    }

    anchors.fill: parent

    Rectangle{
        id: simulatorButton
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        Text{ text: "Sim"; color: buttonColor; anchors.fill: parent; verticalAlignment: Text.AlignVCenter; horizontalAlignment:  Text.AlignHCenter }
        height: buttonSize * 0.8 ; width: height ; color: "transparent"; border.color: buttonColor; radius: height * 0.05
        visible: false
        MouseArea{
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            height: parent.height * 1.6
            width: height * 2
            onClicked: nextSimulator()
            Rectangle {border.color: "green"; color: "transparent"; anchors.fill: parent; visible: false}
        }
    }

    Item{
        id: fakeSimulator
        // no simulator control view
    }
    Row{
        id: normalRunSimulator
        height: buttonSize
        spacing: 5
        anchors.horizontalCenter: parent.horizontalCenter
        visible: false

        Rectangle{
            Text{ text: "Generating"; color: buttonColor; anchors.fill: parent; verticalAlignment: Text.AlignVCenter; horizontalAlignment:  Text.AlignHCenter }
            height: parent.height; width: height * 2; color: "transparent"; border.color: buttonColor; radius: height * 0.05
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    generating()
                    progressView.showProgress("dose", 0, 2000)
                    progressView.showProgress("time_m", 0, 11150)
                    progressView.showProgress("pressure",0, 100)
                    progressView.showProgress("gosth_0")
                    progressView.updateProgress("dose", 590)
                    progressView.updateProgress("time_m", 7820)
                    progressView.updateProgress("pressure", 23)

                    pressureMetter.reset(500)

                }
            }
        }
        Rectangle{
            Text{ text: "vacuum"; color: buttonColor; anchors.fill: parent; verticalAlignment: Text.AlignVCenter; horizontalAlignment:  Text.AlignHCenter }
            height: parent.height; width: height * 2; color: "transparent"; border.color: buttonColor; radius: height * 0.05
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    vacuum()
                }
            }
        }
        Rectangle{
            Text{ text: "End"; color: buttonColor; anchors.fill: parent; verticalAlignment: Text.AlignVCenter; horizontalAlignment:  Text.AlignHCenter }
            height: parent.height; width: height * 2; color: "transparent"; border.color: buttonColor; radius: height * 0.05
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    resultView.clearResults()
                    resultView.buttonColor = "green"
                    resultView.buttonImage = "Images/outline_check_circle_white_48.png"
//                    resultView.addResult("25", "ug", "deepskyblue")
//                    resultView.addResult("3000", "ml", "forestgreen")
                    resultView.addResult("12:03", "min", "darkgoldenrod")
//                    resultView.addResult("968","mbar", "indianred")
                    configArea.deviceInfo.workingTime = configArea.deviceInfo.workingTime + 3661 // 1h 1m 1s
                    endGeneration() // Paid attention! Prepare results first, then generate signal
                }
            }
        }
        Rectangle{
            Text{ text: "Error"; color: buttonColor; anchors.fill: parent; verticalAlignment: Text.AlignVCenter; horizontalAlignment:  Text.AlignHCenter }
            height: parent.height; width: height * 2; color: "transparent"; border.color: buttonColor; radius: height * 0.05
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    resultView.clearResults()
                    resultView.buttonText = "18"
                    resultView.buttonColor = "orange"
                    resultView.buttonImage = "Images/outline_error_outline_white_48.png"
                    error()  // Paid attention! Prepare results first, then generate signal
                }
            }
        }
        Rectangle{
            Text{ text: "Gadget gen"; color: buttonColor; anchors.fill: parent; verticalAlignment: Text.AlignVCenter; horizontalAlignment:  Text.AlignHCenter }
            height: parent.height; width: height * 2; color: "transparent"; border.color: buttonColor; radius: height * 0.05
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    gadgetGenerating()
                }
            }
        }
        Rectangle{
            Text{ text: "Gadget err"; color: buttonColor; anchors.fill: parent; verticalAlignment: Text.AlignVCenter; horizontalAlignment:  Text.AlignHCenter }
            height: parent.height; width: height * 2; color: "transparent"; border.color: buttonColor; radius: height * 0.05
            MouseArea{
                anchors.fill: parent
                onClicked: {
//                    gadgetError()
                }
            }
        }

    }

    Column{
        id: editingConfigInfoSimulator
        width: buttonSize * 2
        height: buttonSize
        spacing: width * 0.2
        anchors.top: parent.top
        anchors.left: parent.left
        visible: false

        Rectangle{
            Text{ text: "Load p. error"; color: buttonColor; anchors.fill: parent; verticalAlignment: Text.AlignVCenter; horizontalAlignment:  Text.AlignHCenter }
            height: parent.height; width: parent.width; color: "transparent"; border.color: buttonColor; radius: height * 0.05
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    loadParamEnd(true)
                }
            }
        }
        Rectangle{
            Text{ text: "Load p. ok"; color: buttonColor; anchors.fill: parent; verticalAlignment: Text.AlignVCenter; horizontalAlignment:  Text.AlignHCenter }
            height: parent.height; width: parent.width; color: "transparent"; border.color: buttonColor; radius: height * 0.05
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    loadParamEnd(false)
                }
            }
        }
        Rectangle{
            Text{ text: "BT ok"; color: buttonColor; anchors.fill: parent; verticalAlignment: Text.AlignVCenter; horizontalAlignment:  Text.AlignHCenter }
            height: parent.height; width: parent.width; color: "transparent"; border.color: buttonColor; radius: height * 0.05
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    btconnect(false)
                }
            }
        }
        Rectangle{
            Text{ text: "BT error"; color: buttonColor; anchors.fill: parent; verticalAlignment: Text.AlignVCenter; horizontalAlignment:  Text.AlignHCenter }
            height: parent.height; width: parent.width; color: "transparent"; border.color: buttonColor; radius: height * 0.05
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    btconnect(true)
                }
            }
        }

    }

    Column{
        id: editingCalibrationSimulator
        width: buttonSize * 2
        height: buttonSize
        spacing: width * 0.2
        anchors.top: parent.top
        anchors.left: parent.left
        visible: false

        Rectangle{
            Text{ text: "Save p. error"; color: buttonColor; anchors.fill: parent; verticalAlignment: Text.AlignVCenter; horizontalAlignment:  Text.AlignHCenter }
            height: parent.height; width: parent.width; color: "transparent"; border.color: buttonColor; radius: height * 0.05
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    saveParamEnd(true)
                }
            }
        }
        Rectangle{
            Text{ text: "Save p. ok"; color: buttonColor; anchors.fill: parent; verticalAlignment: Text.AlignVCenter; horizontalAlignment:  Text.AlignHCenter }
            height: parent.height; width: parent.width; color: "transparent"; border.color: buttonColor; radius: height * 0.05
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    saveParamEnd(false)
                }
            }
        }
        Rectangle{
            Text{ text: "Period error"; color: buttonColor; anchors.fill: parent; verticalAlignment: Text.AlignVCenter; horizontalAlignment:  Text.AlignHCenter }
            height: parent.height; width: parent.width; color: "transparent"; border.color: buttonColor; radius: height * 0.05
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    periodEnd(true)
                }
            }
        }
        Rectangle{
            Text{ text: "Period ok"; color: buttonColor; anchors.fill: parent; verticalAlignment: Text.AlignVCenter; horizontalAlignment:  Text.AlignHCenter }
            height: parent.height; width: parent.width; color: "transparent"; border.color: buttonColor; radius: height * 0.05
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    periodEnd(false)
                }
            }
        }
        Rectangle{
            Text{ text: "reset time ok"; color: buttonColor; anchors.fill: parent; verticalAlignment: Text.AlignVCenter; horizontalAlignment:  Text.AlignHCenter }
            height: parent.height; width: parent.width; color: "transparent"; border.color: buttonColor; radius: height * 0.05
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    resetTimeEnd(false)
                }
            }
        }
        Rectangle{
            Text{ text: "reset time error"; color: buttonColor; anchors.fill: parent; verticalAlignment: Text.AlignVCenter; horizontalAlignment:  Text.AlignHCenter }
            height: parent.height; width: parent.width; color: "transparent"; border.color: buttonColor; radius: height * 0.05
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    resetTimeEnd(true)
                }
            }
        }
        Rectangle{
            Text{ text: "search end"; color: buttonColor; anchors.fill: parent; verticalAlignment: Text.AlignVCenter; horizontalAlignment:  Text.AlignHCenter }
            height: parent.height; width: parent.width; color: "transparent"; border.color: buttonColor; radius: height * 0.05
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    searchEnd()
                }
            }
        }
        Rectangle{
            Text{ text: "add link"; color: buttonColor; anchors.fill: parent; verticalAlignment: Text.AlignVCenter; horizontalAlignment:  Text.AlignHCenter }
            height: parent.height; width: parent.width; color: "transparent"; border.color: buttonColor; radius: height * 0.05
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    deviceFound("RA 4578")
                }
            }
        }
        Rectangle{
            Text{ text: "link fail"; color: buttonColor; anchors.fill: parent; verticalAlignment: Text.AlignVCenter; horizontalAlignment:  Text.AlignHCenter }
            height: parent.height; width: parent.width; color: "transparent"; border.color: buttonColor; radius: height * 0.05
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    linkEnd(false)
                }
            }
        }
        Rectangle{
            Text{ text: "link ok"; color: buttonColor; anchors.fill: parent; verticalAlignment: Text.AlignVCenter; horizontalAlignment:  Text.AlignHCenter }
            height: parent.height; width: parent.width; color: "transparent"; border.color: buttonColor; radius: height * 0.05
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    linkEnd(true)
                    DB.dbStorage_Update("linked_device", "NEW ID...")
                }
            }
        }
    }

    Column{
        id: startUpSimulator
        width: buttonSize * 2
        height: buttonSize
        spacing: width * 0.2
        anchors.top: parent.top
        anchors.left: parent.left
        visible: false

        Rectangle{
            Text{ text: "conect tout"; color: buttonColor; anchors.fill: parent; verticalAlignment: Text.AlignVCenter; horizontalAlignment:  Text.AlignHCenter }
            height: parent.height; width: parent.width; color: "transparent"; border.color: buttonColor; radius: height * 0.05
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    onClicked: connectionTout()
                }
            }
        }
        Rectangle{
            Text{ text: "connected"; color: buttonColor; anchors.fill: parent; verticalAlignment: Text.AlignVCenter; horizontalAlignment:  Text.AlignHCenter }
            height: parent.height; width: parent.width; color: "transparent"; border.color: buttonColor; radius: height * 0.05
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    onClicked: connected()
                }
            }
        }
        Rectangle{
            Text{ text: "starUp End"; color: buttonColor; anchors.fill: parent; verticalAlignment: Text.AlignVCenter; horizontalAlignment:  Text.AlignHCenter }
            height: parent.height; width: parent.width; color: "transparent"; border.color: buttonColor; radius: height * 0.05
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    onClicked: startUpEnd()
                }
            }
        }
        Rectangle{
            Text{ text: "starUp Error"; color: buttonColor; anchors.fill: parent; verticalAlignment: Text.AlignVCenter; horizontalAlignment:  Text.AlignHCenter }
            height: parent.height; width: parent.width; color: "transparent"; border.color: buttonColor; radius: height * 0.05
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    onClicked: startUpError(6)
                }
            }
        }
        Rectangle{
            Text{ text: "starUp add info"; color: buttonColor; anchors.fill: parent; verticalAlignment: Text.AlignVCenter; horizontalAlignment:  Text.AlignHCenter }
            height: parent.height; width: parent.width; color: "transparent"; border.color: buttonColor; radius: height * 0.05
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    onClicked: { startUp.addInfo("more info...")}
                }
            }
        }
    }

    Rectangle {border.color: "sienna"; color: "transparent"; anchors.fill: parent; visible: gridView}
}
