// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright (C) 2024 Sedecal S.A.
// This file is part of OzonobaricD.
// See LICENSE file for details.

import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.15
import QtQuick.Controls 1.4  as QQC1
import QtQuick.Controls.Styles 1.4
import QtQuick.LocalStorage 2.0
import "Database.js" as DB
import "SocketProtocol.js" as SP


//import org.docviewer.poppler 1.0


import AppConstants 1.0
import AppStyle 1.0

import Qt.labs.platform 1.1

// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!1
// Paid attention to this line (dependencies) on
// bundle.gradle file (ekkescorner implementation)
// compile 'com.android.support:support-v4:25.3.1'
// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!1

/*
  16/11/2021

  Screen orientation study conclusions:
  - 'Qt.PortraitOrientation': 1 (camera on top)
  - 'Qt.LandscapeOrientation’: 2 (camera on left)
  - 'Qt.InvertedPortraitOrientation':  4
  - 'Qt.InvertedLandscapeOrientation': 8

  - 'Screen.primaryOrientation' is always updated
  - 'Screen.orientation' is updated depending on 'Screen.orientationUpdateMask'

  Test:
    1. Set 'Screen.orientationUpdateMask' to 15 (or of 'Qt.PortraitOrientation'…)
    2. Rotate all four positions reading 'Screen.primaryOrientation' and 'Screen.orientation'.

  Results:
    Sometimes 'Screen.primaryOrientation' doesn’t follows the real device position, while 'Screen.orientation' does it always.
*/

/*
  27/06/2022

  When any application in Qt for android starts in landscape mode and then change to portrait, a black line appears across the
  screen. That not happens when the application starts in portrait mode.

  A walkaround have been developed to solve that:
  - Configure fixed portrait mode in android manifest.
  - When application has started change screen orientation management to sersor mode.

  In this way the problem is solved, althoug there is an apreciable orientation change during landscape mode start.
*/

/*
  12/07/2022

  It is mandatory that application mantains hearbit with generatotor even when it is in background. To allow this, incude
  this line in android manifest:

  <meta-data android:name="android.app.background_running" android:value="true"/>
*/

/*
  14/07/2022

  It seems that the performance decreases when application goes to background. Due to that period is increased on periodic
  processes. This could be a problem for the communication heartbit system.
  By the moment, heartbit period has been reduced (on Sock2BSPP library) to avoid communication errors when application goes
  to background.
*/



ApplicationWindow {
    id: appMain


//  readonly property string version: "V0.R0.P0" // First SDV attempt 04/09/2024
//  readonly property string version: "V0.R0.P1" // First SDV attempt bugs corrections:
                                                 // Azure bug 10365: (SDV) Orange rectangle on magnitude selector predefined buttons (solved 11/09/2024).
                                                 // Azure bug 10369: (SDV) Incorrect information during automatic syringe filling cancellation (solved 11/09/2024).
                                                 // Azure Bug 10431: (SDV) Pressure calibration menu improvement. (solved 12/09/2024).
                                                 // Azure Bug 10429: (SDV) Uncontrolled enabled resources (hang). (solved 12/09/2024).
//  readonly property string version: "V0.R0.P2" // Second SDV attempt bugs corrections 14/10/2024
//  readonly property string version: "V0.R0.P2" // Third SDV attempt bugs corrections 23/10/2024 (keep version name)
//  readonly property string version: "V0.R0.P2" // Third SDV attempt bugs corrections 25/10/2024 (keep version name)
                                                 // Azure Bug 10966: (SDV 2.1) Fail in screen rotation
//  readonly property string version: "V0.R0.P3" // Just rename after all validation findings resolution 05/03/2025
//  readonly property string version: "V0.R0.P3" // Azure Bug 13272: App exits when swipe back is done when it is pinned 13/03/2025 (same name, since the tags was created some hours before it was remplaced)
//  readonly property string version: "V1.R0.P0" // Azure Bug 13607: Fail on calibration card width (Renamed version to formalize the first attempt at a commercial version following the company's naming convention.)
//  readonly property string version: "V1.R0.P1" // Azure task 13979: Include error 10 (transformer disconnect error) as part of the startup test (09/04/2025).
//  readonly property string version: "V1.R0.P2" // Azure Task 14932: Change pressure calibration method. Use two reference point. Azure task 14936: Include error skip command (10/07/2025).
                                                 // Azure Task 15012: Show interface and control software version during quick start (27/08/2025)
                                                 // Azure Task 15133: Change starting slider value on flow calibration (28/08/2025)
                                                 // Azure Task 15141: Modify Skip error supervision functionality implementation (05/09/2025)
                                                 // Azure Bug 15010: Infinite loop cleaning for O3 calibration (05/09/2025)
//  readonly property string version: "V1.R0.P3" // Azure Task 15512: Modify flow calibration slider range due to a new restrictor (white color one) (31/10/2025).
                                                 // Azure Task 15540: Modify second reference pressure calibration point from 1000 to 500 (06/11/2025).

    readonly property string version: "V1.R0.P4" // Azure Task 15957: Include screen touch pointer (16/01/26)
                                                 // Azure Bug 15984: Include ug/Nml as literal in O3 calibration cards (20/01/26)


    visible: true
//  title: qsTr("OzonzbaricD")
//  color: "#000000" // "darkslategray"
    color: Style.main.backColor

    property bool gridView: false
    property bool startUpComplete: false
    readonly property int android_SCREEN_ORIENTATION_SENSOR: 4

    Screen.orientationUpdateMask: Qt.PortraitOrientation | Qt.LandscapeOrientation | Qt.InvertedPortraitOrientation | Qt.InvertedLandscapeOrientation //15

//    property bool pcSimulation: true
//    property double factor: 0.6
//    property bool isPortrait: true
//    property bool isLandScape: !isPortrait
//    width: isLandScape ? 1240 * factor : 760 * factor // 1280 * factor : 800 * factor
//    height: isLandScape ? 760 * factor : 1240 * factor // 800 * factor : 1280 * factor

    property bool pcSimulation: false
    property double factor: 1
    width: Screen.desktopAvailableWidth
    height: Screen.desktopAvailableHeight
    property bool isPortrait: (Screen.orientation === Qt.PortraitOrientation  || Screen.orientation === Qt.InvertedPortraitOrientation)
    property bool isLandScape: (Screen.orientation === Qt.LandscapeOrientation || Screen.orientation === Qt.InvertedLandscapeOrientation)


//  property bool   devLinked: true      // TODO analyse relation with DeviceLink module
//  property string linkedDevice: ""     // TODO analyse relation with DeviceLink module
    property string language: ""// TODO analyse relation with DeviceLink module
    property string systemUnits: ""

    property bool   devConnected: false
    property double workingTime: 0

    property int currentFsmState: SP.fsmStates.STATE_MAX   // Azure Bug 10432: (SDV) Temperature error persistence.

    property int fsmStateDbg: 0

    property int pressAtmDbg: 0

    function updateSytemUnits(newUnits){
        appMain.systemUnits = newUnits
    }

    onClosing: (close) => {
        console.log("Closing attempt detected...")
        close.accepted = false // Prevents the application from closing
    }

    onIsPortraitChanged: {
        console.log("isPortrait", isPortrait)
    }
    onIsLandScapeChanged:{
        console.log("isLandScape", isLandScape)
    }
    Component.onCompleted: {
        DB.dbConfig_Init()
        if (!DB.dbConfig_Exists()) dbCreator.createConfigDB()

        DB.dbStorage_Init()
        if (!DB.dbStorage_Exists()) dbCreator.createStorageDB()

        DB.dbLang_Init()
        if (!DB.dbLang_Exists()) dbCreator.createLangDB()

        DB.dbHelp_Init()
        if (!DB.dbHelp_Exists()) dbCreator.createHelpDB()

//      console.log("db language:", DB.dbStorage_Get("language"))
//      console.log("db language update:", DB.dbStorage_Update("language", "polish"))

        advertising.visible =   true  // avoid visual effects during start up
        customerName.visible =  true  // avoid visual effects during start up
        pageIndicator.visible = true  // avoid visual effects during start up

//      inputSelector.height = isPortrait ? Screen.desktopAvailableWidth * 0.95 : Screen.desktopAvailableHeight

        console.log( "Loading runtime dependencies")
        if( socket2BSPP.load() )
        {
            console.log("'socket2BSPP' load success...")
            consoleSocket.startConnection()
//          startBleDealy.running = true // socket2BSPP.startBle()
        }

//      initialDelayTimer.running = true
        console.log("ApplicationWindow.onCompleted at:", Qt.formatTime(new Date(), "hh:mm:ss"))

//        console.log("isPortrait", isPortrait)
//        console.log("isLandScape", isLandScape)
//        console.log("Qt.PortraitOrientation:", Qt.PortraitOrientation)
//        console.log("Qt.LandscapeOrientation:", Qt.LandscapeOrientation)
//        console.log("Qt.InvertedPortraitOrientation:", Qt.InvertedPortraitOrientation)
//        console.log("Qt.InvertedLandscapeOrientation:", Qt.InvertedLandscapeOrientation)
//        console.log("Screen.desktopAvailableHeight:", Screen.desktopAvailableHeight)
//        console.log("Screen.desktopAvailableWidth:", Screen.desktopAvailableWidth)
//        console.log("Screen.height:", Screen.height)
//        console.log("Screen.width:", Screen.width)
//        console.log("offlineStoragePath:", offlineStoragePath) // file:///data/user/0/org.qtproject.example.OZP_GUI/files/QML/OfflineStorage
    }

    ScreenPointer{
        enabled: false
    }

    Timer{
        id: startBleDealy
        interval: 5000
        running: false
        onTriggered: socket2BSPP.startBle()

        Component.onCompleted: console.log("startBleDealy.onCompleted at:", Qt.formatTime(new Date(), "hh:mm:ss"))
    }

//  Timer{
//      id: initialDelayTimer
//      interval: 1
//      running: false
//      onTriggered: {
//        console.log("Initial", interval, "ms delay triggered...")
//        android.setScreenOrientation(android_SCREEN_ORIENTATION_SENSOR);
//      }
//
//      Component.onCompleted: console.log("initialDelayTimer.onCompleted at:", Qt.formatTime(new Date(), "hh:mm:ss"))
//  }

    Connections {
        target: consoleSocket
        function onFailure(token) {
            console.log("consoleSocket failure: ", token)
        }
        function onConnected() {
//          consoleSocket.syncState();
            console.log("consoleSocket connected...")
            stateMachine.running = true
            bluetoothSupervisor.running = true
//          consoleSocket.sendData("{SERIAL_ST\r")
            consoleSocket.sendData("{SET_P_INFO," + "1000" + "\r")
        }
        function onDisconnected() {
            console.log("consoleSocket disconnected...")
        }
        function onBusActivity(busPayload) {
            console.log("consoleSocket bus activitiy(", Qt.formatTime(new Date(), "hh:mm:ss"),"):", busPayload)
            SP.decodeSocket(busPayload)
        }
        function onCompleted() {
            console.log("consoleSocket completed...")
        }
    }

    Connections {
        target: Qt.application
//        onStateChanged: {
        function onStateChanged() {
            //we're back from idle
            //applicationWindow.show()
            //going to background
            //applicationWindow.hide()
            //  https://doc.qt.io/qt-6/qt.html#ApplicationState-enum
            console.debug("applicationStateChanged: " + Qt.application.state)

            if(startUpComplete) consoleSocket.sendData("{APP_MODE," + ( (Qt.application.state === Qt.ApplicationActive) ? 1 : 0 ) + "\r")

            switch (Qt.application.state){
            case Qt.ApplicationActive:    console.log("application goes to active mode...");
                                          if(startUpComplete){
                                              // scenery 1
                                              // 1. Select doc help (as example)
                                              // 2. Enter into reader application
                                              // 3. Go out in four seconds (aprox) returning to app
                                              // -> After a little while error 8 appears
                                              commsErrorGuardTimer.start()

                                              // scenery 2
                                              // 1. Select doc help (as example)
                                              // 2. Enter into reader application
                                              // 3. Stay reading enough time to force error 8 (10-15 secs)
                                              // 4. Return to app
                                              // -> Error 8 have already appears
                                              consoleSocket.sendData("{CNL_SIM\r"); // avoid communication errors in case they have already happened
                                              fsmSignals.returnToActive()
                                          }
                                          break;
            case Qt.ApplicationHidden:    console.log("application goes to hidden mode...");    break;
            case Qt.ApplicationSuspended: console.log("application goes to suspended mode..."); break;
            case Qt.ApplicationInactive:  console.log("application goes to inactive mode...");
                                          SP.stopProtocol();
/*                                        SP.extendCommunicationErrorTout()

            TODO: when application goes to suspend or inactive mode it seems there is a delay in serial heartbeat timer. Due
            to that error 8 appears. Since there is no problem with this heartbit during normal running it seems necessary to
            implement a temporal error 8 controlled hide mechanism while serial heartbeat recovers normal.
            It is interesting to hide error 8 in origin (generator controller board) to avoid that all involucred fsm states
            (control board, socket2BSPP library and GUI) went out of sequence.
*/
                                          break;
            }
        }
    }

    Timer{
        id: commsErrorGuardTimer
        interval: 7000
        running: false
        Component.onCompleted: console.log("comErrorGuardTimer.onCompleted at:", Qt.formatTime(new Date(), "hh:mm:ss"))
    }

    Timer{
        id: bluetoothSupervisor
        interval: 5000
        running: false
        repeat: true
        onTriggered: consoleSocket.sendData("{SERIAL_ST\r")

        Component.onCompleted: console.log("bluetoothSupervisor.onCompleted at:", Qt.formatTime(new Date(), "hh:mm:ss"))
    }
//    MouseArea{
//        width: 60
//        height: width
////        x: parent.width - width
////        y: parent.height - height
//        onClicked:{
//            isPortrait = !isPortrait
//            factor = (factor === 0.8) ? 0.5 : 0.8
//        }
//        Rectangle {border.color: "pink"; color: "transparent"; anchors.fill: parent; visible: true}//gridView}
//    }

    DBcreator{
        id: dbCreator

        Component.onCompleted: console.log("dbCreator.onCompleted at:", Qt.formatTime(new Date(), "hh:mm:ss"))
    }

    StateMachine {
        id: stateMachine
//        startState: devLinked ? stateMachine.startUpConnecting : stateMachine.startUpUnlinked
//        startState: stateMachine.waitingForProtocol
          startState: stateMachine.waitingForSetup
//        startState: stateMachine.startUpConnecting
//        startState: stateMachine.startUpUnlinked

          Component.onCompleted: console.log("stateMachine.onCompleted at:", Qt.formatTime(new Date(), "hh:mm:ss"))
    }
    FsmSignals{
        id: fsmSignals

        Component.onCompleted: console.log("fsmSignals.onCompleted at:", Qt.formatTime(new Date(), "hh:mm:ss"))
    }
    StartUp{
        id: startUp
        z: 10
        color: Style.main.backColor
//      state: "connecting"  // first image shown on screen after splashscreen

        onClearError: { SP.clearError(); console.log("Start up clear error signal emitted...") }
        onChecked: console.log("Start up checked signal emitted...")
        onCancelConnection: console.log("Start up cancel connection signal emitted...")
        onRestartConnection: console.log("Start up restart connection signal emitted...")

        onExitToSettings: {
            configArea.expand();
            consoleSocket.sendData("{SERVICE\r")
            console.log("Start up exit to settings signal emitted...")
        }

        Component.onCompleted: console.log("startUp.onCompleted at:", Qt.formatTime(new Date(), "hh:mm:ss"))
    }

    InputSelector{
        id: inputSelector
        height: ( (isLandScape) ? Screen.desktopAvailableHeight :  Screen.desktopAvailableWidth * 0.95 ) * factor
        width: height
        anchors.centerIn: parent
        anchors.horizontalCenterOffset: (isLandScape) ? width * 0.06 : 0
        anchors.verticalCenterOffset: (isLandScape) ? 0 : width * 0.075

        ProgressView {
            id: progressView
            height: parent.height * 0.6
            width: parent.width
            itemSpacing: 90
            itemWidth: 80
            anchors.top: parent.top
            anchors.topMargin: parent.height * 0.38//0.3
            Component.onCompleted: {
                // update app values with db stored values
                progressView.updatePressureUnits(DB.dbStorage_Get("units"))
                console.log("progressView.onCompleted at:", Qt.formatTime(new Date(), "hh:mm:ss"))
            }
            Rectangle {border.color: "blue"; color: "transparent"; anchors.fill: parent; visible: gridView}
        }

        GradientProgress{
            id: pressureMetter
            x: progressView.gosth_0_x
            y: progressView.y
            height: progressView.gosth_0_H
            width: progressView.gosth_0_w
            Rectangle {border.color: "blue"; color: "transparent"; anchors.fill: parent; visible: gridView}

            Component.onCompleted: console.log("pressureMetter.onCompleted at:", Qt.formatTime(new Date(), "hh:mm:ss"))
        }

        SyringeAnimation{
            id: syringeAnimation
            x: progressView.gosth_1_x
            y: progressView.y
            height: progressView.gosth_1_H
            width: progressView.gosth_1_w
            visible: (progressView.opacity && progressView.exists(Const.param.view.gosth_1))

            Component.onCompleted: console.log("syringeAnimation.onCompleted at:", Qt.formatTime(new Date(), "hh:mm:ss"))
        }
//        Item{
//            id: syringeAnimation
//            x: progressView.gosth_1_x
//            y: progressView.y
//            height: progressView.gosth_1_H
//            width: progressView.gosth_1_w
//            visible: (progressView.opacity !==0) ? true : false

//            AnimatedImage {
//                height: implicitHeight * 0.5
//                width: implicitWidth * 0.5
//                anchors.centerIn: parent
//                source: "Images/SyringeFill_03.gif"
//                onVisibleChanged: currentFrame = 0
//            }
//            Rectangle {border.color: "blue"; color: "transparent"; anchors.fill: parent; visible: gridView}
//        }

        ResultView {
            id: resultView
            y_b: inputSelector.height * 0.5
            height_b: inputSelector.expandedHeight * 0.45
            Rectangle {border.color: "blue"; color: "transparent"; anchors.fill: parent; visible: gridView}

            Component.onCompleted: console.log("resultView.onCompleted at:", Qt.formatTime(new Date(), "hh:mm:ss"))
        }

        Advertising{
            id: advertising
            height: parent.height * 0.08
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: parent.height * 0.29
            visible: false // avoid visual effects during start up
            Rectangle {border.color: "lime"; color: "transparent"; anchors.fill: parent; visible: gridView}

            Component.onCompleted: console.log("advertising.onCompleted at:", Qt.formatTime(new Date(), "hh:mm:ss"))
        }

        CustomerName{
            id: customerName

            function updateText(value) { text = value }

            height: parent.height * 0.2
            width: parent.width * 0.8
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: parent.height * 0.70//0.65
         /////////////   text: "OzonobaricD"
            Component.onCompleted: {
                // update app values with db stored values
                text = DB.dbStorage_Get("device_name")
                console.log("customerName.onCompleted at:", Qt.formatTime(new Date(), "hh:mm:ss"))
            }
            visible: false // avoid visual effects during start up
            Rectangle {border.color: "plum"; color: "transparent"; anchors.fill: parent; visible: gridView}
        }

        PressureGadget{
            id: pressureGadget
            width_b: inputSelector.expandedWidth
            height_b: inputSelector.expandedHeight
            x_b: inputSelector.expandedX
            y_b: inputSelector.expandedY
            onStart: SP.startPressureGadget(flow)
            onStop: SP.stopProtocol()
            onEditing: {
                fromFlow = SP.getProtocolMinFlow(protocolSelector.currentProtocol)
                toFlow = SP.getProtocolMaxFlow(protocolSelector.currentProtocol)
                flowValue = SP.getProtocolFlow(protocolSelector.currentProtocol)
            }

            Component.onCompleted: {
                // update app values with db stored values
                pressureGadget.updatePressureUnits(DB.dbStorage_Get("units"))
                console.log("pressureGadget.onCompleted at:", Qt.formatTime(new Date(), "hh:mm:ss"))
            }
        }

        WaitingAnimator{
            id: waitingAnimator
            height: parent.height * 0.3
            width: height
            anchors.centerIn: parent
            anchors.verticalCenterOffset: parent.height * 0.06

            Component.onCompleted: console.log("waitingAnimator.onCompleted at:", Qt.formatTime(new Date(), "hh:mm:ss"))
        }

        EmergencyButton{
            id: emergencyButton
            width: height
            height: parent.height
            visible: false
            z: 30
            Component.onCompleted: {
                allowedViewKeys[0] = "rectal_insufflation"
                allowedViewKeys[1] = "vaginal_insufflation"

                console.log("emergencyButton.onCompleted at:", Qt.formatTime(new Date(), "hh:mm:ss"))
            }
            onClicked: {
                if(action === "play")  { toolBar.playClicked()  }
                if(action === "pause") { toolBar.pauseClicked() }
                console.log("action:", action)
            }
            onVisibleChanged: {
                if(visible)
                    emergencyButton.setPlay()
            }
        }

        Rectangle {border.color: "tomato"; color: "transparent"; anchors.fill: parent; visible: gridView}       
        Component.onCompleted: console.log("inputSelector.onCompleted at:", Qt.formatTime(new Date(), "hh:mm:ss"))
    }

    ConfigurationArea{
        id: configArea
        z: inputSelector.z + 1
        anchors.centerIn: inputSelector
        width_b: inputSelector.width
        height_b: inputSelector.height
        x_b: 0
        y_b: 0
        visible: true
        onStartUpNeeded: startUpComplete = false
        Component.onCompleted: {
            configArea.deviceInfo.guiVersion = version

            // update app values with db stored values
            configArea.deviceInfo.databaseVersion = DB.dbStorage_Get("db_version")
            appMain.systemUnits = DB.dbStorage_Get("units")
            configArea.deviceInfo.unitsAndLanguageInfo.setUnitsCheckedPosition(DB.dbStorage_Get("units"))
            configArea.deviceInfo.unitsAndLanguageInfo.setLanguageCheckedPosition(DB.dbStorage_Get("language"))
            configArea.deviceInfo.workingTime = DB.dbStorage_Get("working_time")
            configArea.deviceInfo.deviceNameText = DB.dbStorage_Get("device_name")
            configArea.deviceCalibration.linkGeneratorInfo.linkedDevice = DB.dbStorage_Get("linked_device")

            // Walk around
            // When configArea.dev...nfo.linkedDevice = "" consoleSocket from socket2BSPP
            // fails (no effective communication throgth sockect channel).
            // Keep this provisional solution until solved.
            var tmp = configArea.deviceCalibration.linkGeneratorInfo.linkedDevice
            configArea.deviceCalibration.linkGeneratorInfo.linkedDevice =  tmp === "" ? "        " : tmp
            configArea.deviceInfo.bluetoothInfo.state = "disconnected"

            // connect saving to db functions to app data change signals
            configArea.deviceInfo.unitsAndLanguageInfo.unitsChange.connect(DB.dbStorage_UpdateUnits)
            configArea.deviceInfo.unitsAndLanguageInfo.languageChange.connect(DB.dbStorage_UpdateLanguage)
            configArea.deviceInfo.workingTimeChange.connect(DB.dbStorage_UpdateWorkingTime)
            configArea.deviceInfo.deviceNameTextChange.connect(DB.dbStorage_UpdateDeviceName)
            configArea.deviceCalibration.linkGeneratorInfo.linked.connect(DB.dbStorage_UpdateLinkedDevice)

            // other connections
            configArea.deviceInfo.deviceNameTextChange.connect(customerName.updateText)
            configArea.deviceInfo.unitsAndLanguageInfo.languageChange.connect(configArea.deviceCalibration.changeLanguage)
            configArea.deviceInfo.unitsAndLanguageInfo.languageChange.connect(configArea.deviceInfo.changeLanguage)
            configArea.deviceInfo.unitsAndLanguageInfo.unitsChange.connect(pressureGadget.updatePressureUnits)
            configArea.deviceInfo.unitsAndLanguageInfo.unitsChange.connect(progressView.updatePressureUnits)
            deviceInfo.unitsAndLanguageInfo.unitsChange.connect(updateSytemUnits)

            console.log("configArea.onCompleted at:", Qt.formatTime(new Date(), "hh:mm:ss"))
        }
    }

    SwipeArea{
        id: protocolSwipeArea
        z: 2
        anchors.fill: inputSelector
        enabled: false
        onSwipeLeft: protocolSelector.swipeProtocol("left")
        onSwipeRight: protocolSelector.swipeProtocol("right")

      //Rectangle {border.color: "plum"; color: "transparent"; anchors.fill: parent; visible: parent.enabled} // just for debug

        Component.onCompleted: console.log("protocolSwipeArea.onCompleted at:", Qt.formatTime(new Date(), "hh:mm:ss"))
    }

    PageIndicator {
        id: pageIndicator
        count: protocolSelector.swipeContext.length
        currentIndex: (protocolSelector.swipeIndex < 0) ? 0 : protocolSelector.swipeIndex
        anchors.bottom: protocolSwipeArea.bottom
        anchors.bottomMargin: protocolSwipeArea.height * 0.008//0.015
        anchors.horizontalCenter: protocolSwipeArea.horizontalCenter

        delegate: Rectangle {
               implicitWidth: 8
               implicitHeight: implicitWidth
               radius: width * 0.5
               color: Style.pageIndicator.color
               opacity: (index === pageIndicator.currentIndex) ? 0.95 : 0.35 // @disable-check M325
               Behavior on opacity { OpacityAnimator { duration: 100 } }
           }
        visible: false // avoid visual effects during start up
        Rectangle {border.color: "forestGreen"; color: "transparent"; anchors.fill: parent; visible: gridView}

        Component.onCompleted: console.log("pageIndicator.onCompleted at:", Qt.formatTime(new Date(), "hh:mm:ss"))
    }

    ProtocolSelector{
        id: protocolSelector
        psIsPortrait: isPortrait
        onProtocolSelected: {
            switch (selectionMethod){
              case "swipeLeft":  inputSelector.shiftLoad(protocolId, "left"); break
              case "swipeRight": inputSelector.shiftLoad(protocolId, "right"); break
              case "click":      inputSelector.load(protocolId); break
            }

            pressureGadget.load(protocolId)
            console.log("Protocol selected:", protocolId, "by", selectionMethod, "method")
        }
        onProtocolDeselected: {
            inputSelector.load()
        }

        Component.onCompleted: console.log("protocolSelector.onCompleted at:", Qt.formatTime(new Date(), "hh:mm:ss"))
    }

    Rectangle{
        id: helpImgViewerSahdow
        anchors.fill: parent
        color: appMain.color
        z: toolBar.z + 1
        visible: (helpImgViewer.state === "big")
        opacity: 0.8
        MouseArea{
            anchors.fill: parent
        }
    }

    HelpImgViewer{
        id: helpImgViewer
        z: inputSelector.z + 3
        anchors.centerIn: inputSelector
        width_b: inputSelector.width
        height_b: inputSelector.height
        x_b: 0
        y_b: 0
        visible: true
    }

    ToolBar{
        id: toolBar
        signal stopClickedDelayed()
        tobIsPortrait: isPortrait
        tobScreenFraction: 6
        onHelpClicked: helpMenu.popUp()
        onSettingsClicked: configArea.expand()
        onPlayClicked: {
            SP.startClicked()
            syringeAnimation.running = (protocolSelector.currentProtocol === Const.protocol.syringe_auto)
        }
        onPauseClicked: {
            SP.pauseProtocol()
        }
        onStopClicked: {
            SP.stopProtocol()
        }
        onPlayPressAndHold:{
            SP.pressAndHoldClicked()  // Azure Bug 10489: (SDV) Simple play buton touch on manual syringe starts generating
            syringeAnimation.running = true
        }
        onPlayReleased:{
            SP.pauseProtocol()
            syringeAnimation.running = false
        }

        Component.onCompleted: {
            toolBar.pauseClicked.connect(emergencyButton.setPlay)
            toolBar.playClicked.connect(emergencyButton.setPause)

            console.log("toolBar.onCompleted at:", Qt.formatTime(new Date(), "hh:mm:ss"))
        }

//        onTobClicked:{
//            console.log("ToolBar signal received: ", tobIndex, actionName)

//            if(actionName === "play"){
//                progressView.showProgress("dose", 0, 2000)
//                progressView.showProgress("time_m", 0, 11150)
//                progressView.showProgress("pressure",0, 100)
//                progressView.showProgress("gosth_0")
//                progressView.updateProgress("dose", 590);
//                progressView.updateProgress("time_m", 7820);
//                progressView.updateProgress("pressure", 23);
//            }
//            if(actionName === "stop"){
//                progressView.clearProgress()
//            }
//            if(actionName === "help"){
//                helpMenu.popUp()
//            }
//            if(actionName === "settings"){
//            }
//        }

        Rectangle{
            id: helpMenuPositioner
            x: (isLandScape) ? 0 : toolBar.getX(Const.controls.help)
            y: (isLandScape) ? toolBar.getY(Const.controls.help) : 0
            width: (isLandScape) ? toolBar.width : toolBar.getSize(Const.controls.help)
            height: (isLandScape) ? toolBar.getSize(Const.controls.help) : toolBar.height
            color: "transparent"
          //border.color: "lime"

            Component.onCompleted: console.log("helpMenuPositioner.onCompleted at:", Qt.formatTime(new Date(), "hh:mm:ss"))
        }

        HelpMenu{
            id: helpMenu
            anchors.centerIn: helpMenuPositioner
            pmIsPortrait: isPortrait
            width: 330
            hmViewTime: 3000
            onCliked: {
                console.log("help menu selection:", helpType)

                var hepSubject = protocolSelector.currentProtocol

                switch(stateMachine.currentState){
                case "gadgetEditing":
                case "protocolEditingParameter": hepSubject = stateMachine.currentState; break;
                }
//              Help view based on external apps
//              switch(helpType){
//              case "manual":         sharefile.viewPdfFile("/data/user/0/org.qtproject.example/files/sedecal_share_files/" + DB.dbHelp_Get(hepSubject, helpType)); break
//              case "diagram":        sharefile.viewPngFile("/data/user/0/org.qtproject.example/files/sedecal_share_files/" + DB.dbHelp_Get(hepSubject, helpType)); break
//              case "tutorial_video": sharefile.viewMp4File("/data/user/0/org.qtproject.example/files/sedecal_share_files/" + DB.dbHelp_Get(hepSubject, helpType)); break
//              case "protocol_video": sharefile.viewMp4File("/data/user/0/org.qtproject.example/files/sedecal_share_files/" + DB.dbHelp_Get(hepSubject, helpType)); break
//              }

//              Help view based on internal resources
                switch(helpType){
                case "diagram":      //helpImgViewer.source = "Images/Diagrams/" + DB.dbHelp_Get(hepSubject, helpType)
                                     //  helpImgViewer.source = "file:///data/user/0/com.sedecal.ozonobaricd/files/sedecal_share_files/" + DB.dbHelp_Get(hepSubject, helpType)
                                     //  helpImgViewer.expand()
                                     //  break
                case "tutorial_video": //sharefile.viewMp4File("/data/user/0/com.sedecal.ozonobaricd/files/sedecal_share_files/" + DB.dbHelp_Get(hepSubject, helpType)); break
                case "manual":
                case "protocol_video": helpImgViewer.source = "file:///data/user/0/com.sedecal.ozonobaricd/files/sedecal_share_files/" + DB.dbHelp_Get(hepSubject, helpType)
                                       helpImgViewer.expand()
                                       break
                }


            }

            Component.onCompleted: console.log("helpMenu.onCompleted at:", Qt.formatTime(new Date(), "hh:mm:ss"))
        }
    }

    AppSplash{
        id: appSplash
        state: "on"
        z: 1000
        color: Style.main.backColor

        Component.onCompleted: console.log("appSplash.onCompleted at:", Qt.formatTime(new Date(), "hh:mm:ss"))
    }

    Timer{
        id: batteryInfoTimer
        property int delayInfo: 0

        interval: 1000
        running: true
        repeat: true
        onTriggered: {
            toolBar.batteryLevel = batteryInfo.getBatteryLevel()
            toolBar.isBatteryCharging = batteryInfo.isCharging()

            delayInfo = delayInfo + 1
            if(delayInfo === 5){
                delayInfo = 0
                console.log("Battery info:" + batteryInfo.getBatteryLevel() + "% " + (batteryInfo.isCharging() ? "Charger on" : "Charger off"))
            }
        }

        Component.onCompleted: console.log("batteryInfoTimer.onCompleted at:", Qt.formatTime(new Date(), "hh:mm:ss"))
    }
/*
    MultiMediaPlayer{
        anchors.fill: parent
        mmIsLandScape: isLandScape
    }
*/

//    PDFView {
//      id: pdfView
//      anchors.fill: parent
//      focus: true
//      path: fileDialog.file.toString().substring(6)

//      ScrollBar.vertical: ScrollBar {
//        minimumSize: 0.04
//      }

//      onSearchRestartedFromTheBeginning: {
//        notifyLabel.text = qsTr("Search restarted from the beginning")
//        notifyAnimation.start()
//      }

//      onSearchNotFound: {
//        notifyLabel.text = qsTr('"%1" not found').arg(searchField.text)
//        notifyAnimation.start()
//      }

//      Keys.onPressed: {
//        if (event.modifiers === Qt.ControlModifier) {
//          if (event.key === Qt.Key_Minus) {
//            zoomSlider.decrease()
//            event.accepted = true
//          } else if (event.key === Qt.Key_Plus) {
//            zoomSlider.increase()
//            event.accepted = true
//          } else if (event.key === Qt.Key_0) {
//            zoomSlider.value = 1
//            event.accepted = true
//          } else if (event.key === Qt.Key_F) {
//            searchField.forceActiveFocus()
//          }
//        } else if (event.modifiers === Qt.NoModifier) {
//          if (event.key === Qt.Key_Home) {
//            pagesView.positionViewAtBeginning()
//            event.accepted = true
//          } else if (event.key === Qt.Key_End) {
//            pagesView.positionViewAtEnd()
//            event.accepted = true
//          }
//        }
//      }
//    }



    //Debug

    Label{
        id: debugLabel
        visible: false
//      text: stateMachine.currentState + " - " + protocolSelector.currentProtocol + " - " + fsmStateDbg // + " - "  + protocolSelector.swipeIndex
//      text: stateMachine.currentState + " - " + protocolSelector.currentProtocol + " - " + fsmStateDbg + " - linkStatus: "  + startUp.linkStatus
//      text: stateMachine.currentState + " - " + protocolSelector.currentProtocol + " - " + fsmStateDbg + " - startUpComplete: "  + startUpComplete
//      text: stateMachine.currentState + " - " + protocolSelector.currentProtocol + " - " + fsmStateDbg + " - screenOn: "  + android.screenOnStatus
//      text: "isPortrait: " + isPortrait + "  -  "  + "psIsPortrait: " + protocolSelector.psIsPortrait + "  -  "  + "Screen.orientation: " + Screen.orientation +  "  -  "  + "Screen.primaryOrientation: " + Screen.primaryOrientation
//      text: stateMachine.currentState + " - " + protocolSelector.currentProtocol + " - " + fsmStateDbg + " - startUp.state : "  + startUp.state
////    text: stateMachine.currentState + " - " + protocolSelector.currentProtocol + " - " + fsmStateDbg + " - pressAtm: "  + pressAtmDbg
//      text: stateMachine.currentState + " - " + protocolSelector.currentProtocol + " - " + fsmStateDbg + " - currentProtocol: "  + protocolSelector.currentProtocol + " - isExecutableProtocol: " + protocolSelector.isExecutableProtocol
//      text: stateMachine.currentState + " - " + protocolSelector.currentProtocol + " - " + fsmStateDbg + " - configArea x,y b: "  + configArea.x_b + "," + configArea.y_b  + " - configArea x,y s: "  + configArea.x_s + "," + configArea.y_s + " - configArea x,y: "  + configArea.x + "," + configArea.y
//      text: stateMachine.currentState + " - " + protocolSelector.currentProtocol + " - " + fsmStateDbg + " - configArea.deviceCalibration.enableMasck : "  + configArea.deviceCalibration.enableMasck

        text: "Nivel de batería: " + batteryInfo.getBatteryLevel() + "%" + (batteryInfo.isCharging() ? "Cargador conectado" : "Cargador desconectado")

        opacity: 0.5
        height: 25
        width: 200
        color: "white"
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment:  Text.AlignHCenter
        anchors.bottom: parent.bottom
//      anchors.horizontalCenter: parent.horizontalCenter
        anchors.left: inputSelector.left
        z: 100

        Component.onCompleted: console.log("debugLabel.onCompleted at:", Qt.formatTime(new Date(), "hh:mm:ss"))
    }

    Simulator{            // just for debug purposes
        id: simulator
        visible: false
        z: 100

        Component.onCompleted: console.log("simulator.onCompleted at:", Qt.formatTime(new Date(), "hh:mm:ss"))
    }






/*
//  Example of how to access to a general folder (download) and to an app particular folder
    AnimatedImage{
        anchors.fill: parent
        //source: "file:///storage/emulated/0/Download/SyringeFill_V_00.gif"
        source: "file:///data/user/0/org.qtproject.example/files/Test_rsm/SyringeFill_V_00.gif"
    }
*/
/*


  Item {
      property variant items: [1, 2, 3, "four", "five"]
      property variant attributes: { 'color': 'red', 'width': 100 }

      Component.onCompleted: {
          items[0] = 10
          console.log(items[0])     // This will still be '1'!
          attributes.color = 'blue'
          console.log(attributes.color)     // This will still be 'red'!
      }
  }

 property var arr: [{ info1: "test", info2: 1}, { info1: "info" }]

// A Js struct
var person = {
       firstName : "John",
       age : 50,
       male : true
};

// Array of struct
var array = [
      { firstName : "John", age: 50, male: true },
      { firstName : "Jenny", age: 25, male: false },
];

*/



    function logScreenProperties(){
        console.log("Screen properties debug...",)
        console.log("desktopAvailableHeight:", Screen.desktopAvailableHeight)
        console.log("desktopAvailableWidth:", Screen.desktopAvailableWidth)
        console.log("devicePixelRatio:", Screen.devicePixelRatio)
        console.log("height:", Screen.height)
        console.log("width:", Screen.width)
        console.log("manufacturer:", Screen.manufacturer)
        console.log("model:", Screen.model)
        console.log("name:", Screen.name)
        console.log("orientation:", Screen.orientation)
        console.log("orientationUpdateMask:", Screen.orientationUpdateMask)
        console.log("pixelDensity:", Screen.pixelDensity)
        console.log("primaryOrientation:", Screen.primaryOrientation)
        console.log("serialNumber:", Screen.serialNumber)
        console.log("virtualX:", Screen.virtualX)
        console.log("virtualY:", Screen.virtualY)
    }




    Rectangle{
        z:100
        id: showScreenProperties
        width: 100
        height: 100
        color:"transparent"
        border.color: "lightgray"
        visible: false
        QQC1.TextArea{
            id: showScreenPropertiesText
            width: appMain.width * 0.5
            height: appMain.height * 0.5
            text: ""
            visible: false
            anchors.top: parent.bottom

            style: TextAreaStyle {
                textColor: "black"
                backgroundColor: "transparent"
            }
        }
        MouseArea{
            anchors.fill: parent
            onPressAndHold: consoleSocket.sendData("{SET_P_INFO," + "3000" + "\r")
            onClicked: {
                console.log("----------------------------------- debug button------------------------------------------")
                configArea.x = configArea.x_s//640
                configArea.y = configArea.y_s//380
//               configArea.deviceInfo.blocked = !configArea.deviceInfo.blocked
//                configArea.deviceCalibration.test()
               // consoleSocket.sendData("{SERIAL_DISC\r")
                fsmSignals.quitar()
//                configArea.deviceCalibration.enableMasck = !configArea.deviceCalibration.enableMasck
//               configArea.deviceInfo.enableMasck = !configArea.deviceInfo.enableMasck
//                android.restarApp()
                //configArea.deviceCalibration.test()
//                configArea.deviceCalibration.rightRepeater.itemAt(2).nextStep()



//                console.log("*---> startUp.text: ", startUp.text)

//                configArea.deviceInfo.statrUpText = startUp.text
//                console.log("configArea.deviceInfo.statrUpText (before): ",configArea.deviceInfo.statrUpText)
//                configArea.deviceInfo.refreshStartUpInfo(startUp.text)
//                console.log("configArea.deviceInfo.statrUpText (after): ",configArea.deviceInfo.statrUpText)

//                configArea.deviceInfo.refreshPressTempInfo(72.6,25)
                //sharefile.keepScreenOn()
//              android.keepScreenOn(true)
//              android.setScreenOnStatus(true)


//              helpMenu.testHsettings()

                //pressureGadget.controlsOpacity = 0.2
//                SP.lookForMaxAvailableFlow("Max available flow: sad5")
//                console.log("inputSelector.maxAvailableFlow:", inputSelector.maxAvailableFlow)
//                SP.lookForMaxAvailableFlow("Max available flow:")
//                console.log("inputSelector.maxAvailableFlow:", inputSelector.maxAvailableFlow)
//                SP.lookForMaxAvailableFlow("Max available flow: ")
//                console.log("inputSelector.maxAvailableFlow:", inputSelector.maxAvailableFlow)
//                SP.lookForMaxAvailableFlow("Max available flow: 61")
//                console.log("inputSelector.maxAvailableFlow:", inputSelector.maxAvailableFlow)
//                SP.lookForMaxAvailableFlow("Max available flow: 37 ")
//                console.log("inputSelector.maxAvailableFlow:", inputSelector.maxAvailableFlow)
//                SP.lookForMaxAvailableFlow("Max available flow: 4 ")
//                console.log("inputSelector.maxAvailableFlow:", inputSelector.maxAvailableFlow)
//                SP.lookForMaxAvailableFlow("Max available flow: 3")
//                console.log("inputSelector.maxAvailableFlow:", inputSelector.maxAvailableFlow)
//                SP.lookForMaxAvailableFlow("Max available flow:9")
//                console.log("inputSelector.maxAvailableFlow:", inputSelector.maxAvailableFlow)



//                sharefile.viewPdfFile("/data/user/0/org.qtproject.example/files/sedecal_share_files/" + DB.dbHelp_Get(protocolSelector.currentProtocol, "manual"))
//              sharefile.viewPdfFile("/data/user/0/org.qtproject.example/files/sedecal_share_files/" + DB.dbHelp_Get(Const.protocol.syringe_auto, "manual"))
//              sharefile.viewPngFile("/data/user/0/org.qtproject.example/files/sedecal_share_files/" + DB.dbHelp_Get(Const.protocol.syringe_auto, "diagram"))
//              sharefile.viewMp4File("/data/user/0/org.qtproject.example/files/sedecal_share_files/" + DB.dbHelp_Get(Const.protocol.syringe_auto, "tutorial_video"))
//              sharefile.viewMp4File("/data/user/0/org.qtproject.example/files/sedecal_share_files/" + DB.dbHelp_Get(Const.protocol.syringe_auto, "protocol_video"))

//              sharefile.viewHtmlFile("/data/user/0/org.qtproject.example/files/sedecal_share_files/sample3.html")
//              sharefile.viewPdfFile("/data/user/0/org.qtproject.example/files/sedecal_share_files/share_file_2.pdf")
//              sharefile.viewPdfFile("/data/user/0/org.qtproject.example/files/sedecal_share_files/BLE_RN4870_53406949_Guide.pdf")
//              sharefile.viewPdfFile("/data/user/0/org.qtproject.example/files/sedecal_share_files/OM-0507RA_EN_SED (211201-DRAFT) BOOKMARK.pdf")
//              sharefile.viewPdfFile("/data/user/0/org.qtproject.example/files/sedecal_share_files/BLE_RN4870_53406949_Guide.pdf#page=3")
//                sharefile.viewMp4File("/data/user/0/org.qtproject.example/files/sedecal_share_files/BloodVolume_Gadget.mp4")
//                sharefile.viewPngFile("/data/user/0/org.qtproject.example/files/sedecal_share_files/IS1443SDDA_P1105_Ozonette_RevI-002.png")

                //                SP.startProtocol()
//                SP.getLast()
//               consoleSocket.sendData("{TVACSTR,30,-800\r")
//                 consoleSocket.sendData("{O3STR,15,10,5,0,700\r")
//                console.log("ret:", inputSelector.values())
//                consoleSocket.sendData("{SET_P_INFO," + "400" + "\r")
//             consoleSocket.sendData("{SET_P_INFO," + "1000" + "\r")
//               consoleSocket.sendData("{SET_P_INFO,400\r")
//               consoleSocket.sendData("{SERIAL_ST\r")
//               consoleSocket.sendData("{SERIAL_NAME\r")
//                consoleSocket.sendData("{SERIAL_GET_ADD\r")
//                consoleSocket.sendData("{SERIAL_SET_ADD, NEW_ADD\r")
//                consoleSocket.sendData("{SERIAL_GET_ADD\r")
//                consoleSocket.sendData("{SERIAL_GET_NAME\r")
//                consoleSocket.sendData("{SERIAL_SET_NAME, NEW_NAME\r")
//                consoleSocket.sendData("{SERIAL_GET_NAME\r")
//                consoleSocket.sendData("{SERIAL_DISC\r")
//                console.log("ppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp")
//                consoleSocket.sendData("{SERIAL_STOP_DISC\r")
//                  consoleSocket.sendData("{SERIAL_GET_DISC\r")
//                consoleSocket.sendData("{SERIAL_SET_NAME, NEW_NAME\r")
//                  consoleSocket.sendData("{SERIAL_GET_NAME\r")
//                consoleSocket.sendData("{SERIAL_STOP_BOOT\r")
//               consoleSocket.sendData("{SET_P_INFO," + "10000" + "\r")
//               consoleSocket.sendData("{FSM_BOOT\r")

//                configArea.deviceInfo.workingTime = 333//DB.dbStorage_Get("working_time")
//                console.log("configArea.deviceInfo.workingTime: ", configArea.deviceInfo.workingTime)
//                protocolSelector.swipeProtocol("left")
//                pressureMetter.value += 30
//                resultView.expand()
//                showScreenPropertiesText.visible = !showScreenPropertiesText.visible
//                logScreenProperties()
//                showScreenPropertiesText.text = "Screen properties debug...\n"
//                showScreenPropertiesText.text += "desktopAvailableHeight:" + Screen.desktopAvailableHeight + "\n"
//                showScreenPropertiesText.text += "desktopAvailableWidth:" + Screen.desktopAvailableWidth + "\n"
//                showScreenPropertiesText.text += "devicePixelRatio:" + Screen.devicePixelRatio + "\n"
//                showScreenPropertiesText.text += "height:" + Screen.height + "\n"
//                showScreenPropertiesText.text += "width:" + Screen.width + "\n"
//                showScreenPropertiesText.text += "manufacturer:" + Screen.manufacturer + "\n"
//                showScreenPropertiesText.text += "model:" + Screen.model + "\n"
//                showScreenPropertiesText.text += "name:" + Screen.name + "\n"
//                showScreenPropertiesText.text += "orientation:" + Screen.orientation + "\n"
//                showScreenPropertiesText.text += "orientationUpdateMask:" + Screen.orientationUpdateMask + "\n"
//                showScreenPropertiesText.text += "pixelDensity:" + Screen.pixelDensity + "\n"
//                showScreenPropertiesText.text += "primaryOrientation:" + Screen.primaryOrientation + "\n"
//                showScreenPropertiesText.text += "serialNumber:" + Screen.serialNumber + "\n"
//                showScreenPropertiesText.text += "virtualX:" + Screen.virtualX + "\n"
//                showScreenPropertiesText.text += "virtualY:" + Screen.virtualY + "\n"
            }
        }
    }
}


//ApplicationWindow {
//    id: appMain
//    visible: true
//    title: qsTr("Hello World!")
//    color: "darkslategray"//"#000000"

//    property bool gridView: true
//    property double factor: 1

////    property bool pcSimulation: true
////    property bool isPortrait: false
////    property bool isLandScape: !isPortrait
////    width: isLandScape ? 1240 * factor : 760 * factor // 1280 * factor : 800 * factor
////    height: isLandScape ? 760 * factor : 1240 * factor // 800 * factor : 1280 * factor

//    property bool pcSimulation: false
//    width: Screen.desktopAvailableWidth   // width
//    height: Screen.desktopAvailableHeight // height
//    property bool isPortrait:  (Screen.primaryOrientation === Qt.PortraitOrientation  || Screen.primaryOrientation === Qt.InvertedPortraitOrientation)
//    property bool isLandScape: (Screen.primaryOrientation === Qt.LandscapeOrientation || Screen.primaryOrientation === Qt.InvertedLandscapeOrientation)

//    onIsPortraitChanged: {
//        console.log("isPortrait", isPortrait)
//        logScreenProperties()
//    }
//    onIsLandScapeChanged:{
//        console.log("isLandScape", isLandScape)
//    }

//    Component.onCompleted: {
//        console.log("isPortrait", isPortrait)
//        console.log("isLandScape", isLandScape)

//        Screen.orientationUpdateMask = Qt.PortraitOrientation | Qt.LandscapeOrientation | Qt.InvertedPortraitOrientation | Qt.InvertedLandscapeOrientation //15

//        console.log("Qt.PortraitOrientation:", Qt.PortraitOrientation)
//        console.log("Qt.LandscapeOrientation:", Qt.LandscapeOrientation)
//        console.log("Qt.InvertedPortraitOrientation:", Qt.InvertedPortraitOrientation)
//        console.log("Qt.InvertedLandscapeOrientation:", Qt.InvertedLandscapeOrientation)
//        inputSelector.height = setInputSelectorSize() * factor

//    }

//    function logScreenProperties(){
//        console.log("Screen properties debug...",)
//        console.log("desktopAvailableHeight:", Screen.desktopAvailableHeight)
//        console.log("desktopAvailableWidth:", Screen.desktopAvailableWidth)
//        console.log("devicePixelRatio:", Screen.devicePixelRatio)
//        console.log("height:", Screen.height)
//        console.log("width:", Screen.width)
//        console.log("manufacturer:", Screen.manufacturer)
//        console.log("model:", Screen.model)
//        console.log("name:", Screen.name)
//        console.log("orientation:", Screen.orientation)
//        console.log("orientationUpdateMask:", Screen.orientationUpdateMask)
//        console.log("pixelDensity:", Screen.pixelDensity)
//        console.log("primaryOrientation:", Screen.primaryOrientation)
//        console.log("serialNumber:", Screen.serialNumber)
//        console.log("virtualX:", Screen.virtualX)
//        console.log("virtualY:", Screen.virtualY)
//    }

//    function setInputSelectorSize(){
//        if(pcSimulation){
//            console.log("setInputSelectorSize, pcSimulation: ", pcSimulation)
//            return 760
//        }
//        console.log("setInputSelectorSize, isPortrait:", isPortrait)
//        if(isPortrait){
//            var noAvailableArea = Screen.height - Screen.desktopAvailableHeight
//            console.log("setInputSelectorSize, Screen.height:", Screen.height)//////----->1264????????????????????
//            console.log("setInputSelectorSize, Screen.width:", Screen.width)
//            console.log("setInputSelectorSize, Screen.desktopAvailableHeight:", Screen.desktopAvailableHeight)
//            console.log("setInputSelectorSize, noAvailableArea:", noAvailableArea)
//            console.log("setInputSelectorSize, Screen.width - noAvailableArea:", Screen.width - noAvailableArea)
//            return Screen.width - noAvailableArea
//        }else{
//            return Screen.desktopAvailableHeight
//        }
//    }

//    MouseArea{
//        width: 60
//        height: width
//        x: parent.width - width
//        y: parent.height - height
//        onClicked:{
//            isPortrait = !isPortrait
//        }
//        Rectangle {border.color: "pink"; color: "transparent"; anchors.fill: parent; visible: gridView}
//    }

//    InputSelector{
//        id: inputSelector
////      x: (isLandScape) ? 220 * factor : 0
////      y: (isLandScape) ? 0 : 220 * factor
////      height: 760 * factor
////      width: 760 * factor

//        height:1// setInputSelectorSize() * factor
//        width: height

//        anchors.centerIn: parent
//        Rectangle {border.color: "tomato"; color: "transparent"; anchors.fill: parent; visible: gridView}
//    }

//    ProtocolSelector{
//        psIsPortrait: isPortrait
//        onProtocolSelected: {
//            inputSelector.load(protocolId)
//        }
//    }

//    Rectangle{
//        id: showScreenProperties
//        width: 100
//        height: 100
//        color:"orange"
//        QQC1.TextArea{
//            id: showScreenPropertiesText
//            width: appMain.width * 0.5
//            height: appMain.height * 0.5
//            text: ""
//            visible: false
//            anchors.top: parent.bottom

//            style: TextAreaStyle {
//                textColor: "black"
//                backgroundColor: "transparent"
//            }
//        }
//        MouseArea{
//            anchors.fill: parent
//            onClicked: {
//                showScreenPropertiesText.visible = !showScreenPropertiesText.visible
//                logScreenProperties()
//                showScreenPropertiesText.text = "Screen properties debug...\n"
//                showScreenPropertiesText.text += "desktopAvailableHeight:" + Screen.desktopAvailableHeight + "\n"
//                showScreenPropertiesText.text += "desktopAvailableWidth:" + Screen.desktopAvailableWidth + "\n"
//                showScreenPropertiesText.text += "devicePixelRatio:" + Screen.devicePixelRatio + "\n"
//                showScreenPropertiesText.text += "height:" + Screen.height + "\n"
//                showScreenPropertiesText.text += "width:" + Screen.width + "\n"
//                showScreenPropertiesText.text += "manufacturer:" + Screen.manufacturer + "\n"
//                showScreenPropertiesText.text += "model:" + Screen.model + "\n"
//                showScreenPropertiesText.text += "name:" + Screen.name + "\n"
//                showScreenPropertiesText.text += "orientation:" + Screen.orientation + "\n"
//                showScreenPropertiesText.text += "orientationUpdateMask:" + Screen.orientationUpdateMask + "\n"
//                showScreenPropertiesText.text += "pixelDensity:" + Screen.pixelDensity + "\n"
//                showScreenPropertiesText.text += "primaryOrientation:" + Screen.primaryOrientation + "\n"
//                showScreenPropertiesText.text += "serialNumber:" + Screen.serialNumber + "\n"
//                showScreenPropertiesText.text += "virtualX:" + Screen.virtualX + "\n"
//                showScreenPropertiesText.text += "virtualY:" + Screen.virtualY + "\n"
//            }
//        }
//    }
//}
