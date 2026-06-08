// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright (C) 2024 Sedecal S.A.
// This file is part of OzonobaricD.
// See LICENSE file for details.

import QtQuick 2.15
import QtQuick.Controls 2.15

Rectangle{
    id: startUp
    property bool gridView: false

    color: "#151515"
    anchors.fill: parent

    property bool linkStatus: false
    property bool skipErrorAllowed: true
    property int topMargin: height * 0.05
    property int bottomMargin: topMargin
    property int gotoSettingsTout: 3000
    property string dataAreaVisibleReason: "user" // "error"

    property alias text: textArea.text
    property alias errorCode: errorCode.text
    property alias errorImg: errorImg
    property alias connectingTout: connectingTout

    function addInfo(info){
        textArea.text = textArea.text + "<p1 style=\"font-size:19px; color:#AAAAAA\">" + info + "</p1>"
        dataArea.contentY = ( (dataArea.contentHeight - dataArea.height) < 0 ) ? 0 : (dataArea.contentHeight - dataArea.height)
    }
    function error(error){
        errorImg.visible = true
        dataArea.visible = true
        dataAreaVisibleReason = "error"
//      errorCode.text = error
    }
//    function end(){
//        if(dataArea.visible){ // wait until user checks start up results
//            infoButton.visible = false
//            okButton.visible = true
//            onWorkingImg.visible = false
//        }
//        else{ // exit start up by simulating user check
//            checked()
//        }
//    }
    function end(){
//      if(dataArea.visible && (dataAreaVisibleReason === "user")){ // wait until user checks start up results
        if(dataArea.visible){ // wait until user checks start up results, doesn't mind if info is shown by user action or automatically due to an error managemet
            infoButton.visible = false
            okButton.visible = true
            onWorkingImg.visible = false
        }
        else{ // exit start up by simulating user check
            checked()
        }
    }

    signal clearError()
    signal checked()
    signal exitToSettings()
    signal exitToProtocolSelector()
    signal cancelConnection()
    signal restartConnection()
    signal readyToStart()
    signal connectionTout()

    // hide:           no visible interface
    // noLink:         no OZD already attached to this tablet
    // connecting:     tryint to stablish BT connection
    // connectionFail: stablish BT connection time out
    // gotoSettings:   waiting for user action to choose go to settings or let start up after a little tiem out
    // starting:       starting up equipment

    state: "hide"
    states: [
        State {
            name: "hide"
            PropertyChanges { target: startUp;         visible: false }
            PropertyChanges { target: connectingTout;  running: false }
        },
        State {
            name: "noLink"
            PropertyChanges { target: startUp;         visible: true  }
            PropertyChanges { target: tabletImg;       visible: false }
            PropertyChanges { target: linkImg;         visible: false }
            PropertyChanges { target: connectingImg;   visible: false }
            PropertyChanges { target: ozdImg;          visible: true  }
            PropertyChanges { target: cancelButton;    visible: false }
            PropertyChanges { target: settingsButton;  visible: true  }
            PropertyChanges { target: retryButton;     visible: false }
            PropertyChanges { target: skipButton;      visible: false }
            PropertyChanges { target: progressBar;     visible: false }
            PropertyChanges { target: startUpControls; visible: false }
            PropertyChanges { target: connectingTout;  running: false }
        },
        State {
            name: "connecting"
            PropertyChanges { target: startUp;         visible: true  }
            PropertyChanges { target: tabletImg;       visible: true  }
            PropertyChanges { target: linkImg;         visible: false }
            PropertyChanges { target: connectingImg;   visible: true  }
            PropertyChanges { target: ozdImg;          visible: true  }
            PropertyChanges { target: cancelButton;    visible: true  }
            PropertyChanges { target: settingsButton;  visible: false }
            PropertyChanges { target: retryButton;     visible: false }
            PropertyChanges { target: skipButton;      visible: false }
            PropertyChanges { target: progressBar;     visible: false }
            PropertyChanges { target: startUpControls; visible: false }
            PropertyChanges { target: connectingTout;  running: true  }
        },
        State {
            name: "connectionFail"
            PropertyChanges { target: startUp;         visible: true  }
            PropertyChanges { target: tabletImg;       visible: true  }
            PropertyChanges { target: linkImg;         visible: true  }
            PropertyChanges { target: connectingImg;   visible: false }
            PropertyChanges { target: ozdImg;          visible: true  }
            PropertyChanges { target: cancelButton;    visible: false }
            PropertyChanges { target: settingsButton;  visible: false }
            PropertyChanges { target: retryButton;     visible: true  }
            PropertyChanges { target: skipButton;      visible: true  }
            PropertyChanges { target: progressBar;     visible: false }
            PropertyChanges { target: startUpControls; visible: false }
            PropertyChanges { target: connectingTout;  running: false }
        },
        State {
            name: "gotoSettings"
            PropertyChanges { target: startUp;         visible: true  }
            PropertyChanges { target: tabletImg;       visible: false }
            PropertyChanges { target: linkImg;         visible: false }
            PropertyChanges { target: connectingImg;   visible: false }
            PropertyChanges { target: ozdImg;          visible: false }
            PropertyChanges { target: cancelButton;    visible: false }
            PropertyChanges { target: settingsButton;  visible: true  }
            PropertyChanges { target: retryButton;     visible: false }
            PropertyChanges { target: skipButton;      visible: false }
            PropertyChanges { target: progressBar;     visible: true  }
            PropertyChanges { target: startUpControls; visible: true  }
            PropertyChanges { target: infoButton;      visible: false }
            PropertyChanges { target: okButton;        visible: false }
            PropertyChanges { target: errorImg;        visible: false }
            PropertyChanges { target: dataArea;        visible: false }
            PropertyChanges { target: onWorkingImg;    visible: true  }
            PropertyChanges { target: onWorkingImg;    playing: false }
            PropertyChanges { target: connectingTout;  running: false }
        },
        State {
            name: "starting"
            PropertyChanges { target: startUp;         visible: true  }
            PropertyChanges { target: tabletImg;       visible: false }
            PropertyChanges { target: linkImg;         visible: false }
            PropertyChanges { target: connectingImg;   visible: false }
            PropertyChanges { target: ozdImg;          visible: false }
            PropertyChanges { target: cancelButton;    visible: false }
            PropertyChanges { target: settingsButton;  visible: false }
            PropertyChanges { target: retryButton;     visible: false }
            PropertyChanges { target: skipButton;      visible: false }
            PropertyChanges { target: progressBar;     visible: false }
            PropertyChanges { target: startUpControls; visible: true  }
            PropertyChanges { target: infoButton;      visible: true  }
            PropertyChanges { target: okButton;        visible: false }
            PropertyChanges { target: errorImg;        visible: false }
            PropertyChanges { target: dataArea;        visible: false }
            PropertyChanges { target: onWorkingImg;    visible: true  }
            PropertyChanges { target: onWorkingImg;    playing: true & !errorImg.visible }
            PropertyChanges { target: connectingTout;  running: false }
        }
    ]


    onLinkStatusChanged: {
        if( !linkStatus &&errorImg. visible ){
            textArea.text = ""
            addInfo("Bluetooth connection lost...")
        }
    }

    MouseArea{
        // Walk around
        // Full screen mouse area. It catches all touches in the screen avoiding propagation
        // to hidden controls by StartUp. This simplifies program flow since in this way it is
        // not necessary to enable and disable hidden controls while Startup is active.
        anchors.fill: parent
    }

    Item{
        id: squareArea
        height: parent.height < parent.width ? parent.height : parent.width
        width: height
        anchors.centerIn: parent

        Label{
            id: tittle
            text: "Ozonobaric D"
            color: "#DDDDDD"
            height: parent.height * 0.1
            width: parent.width
            anchors.top: parent.top
            anchors.topMargin: startUp.topMargin
            anchors.horizontalCenter: parent.horizontalCenter
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment:  Text.AlignHCenter
            font.pixelSize: height
            Rectangle {border.color: "tomato"; color: "transparent"; anchors.fill: parent; visible: gridView}
        }

        Row{
            id: activityRow
            height: parent.height * 0.3
            anchors.centerIn: parent
            Image{
                id: tabletImg
                height: parent.height
                width: height
                source: "Images/tablet_02.png"
            }
            Image{
                id: linkImg
                height: parent.height * 0.6
                width: height
                anchors.verticalCenter: parent.verticalCenter
                source: linkStatus ? "Images/outline_link_white_48.png" : "Images/outline_link_off_white_48.png"
            }
            Image{
                id: connectingImg
                property int searchImageIndex: 0
                property variant searchImage: ["Images/outline_bluetooth_searching_white_48.png",
                                               "Images/outline_bluetooth_searching_no_waves_white_48.png"]
                onVisibleChanged: searchImageIndex = 0
                height: linkImg.height
                width: height
                anchors.verticalCenter: parent.verticalCenter
                source: searchImage[searchImageIndex]
                Timer{
                    repeat: true
                    interval: 1000
                    running: visible
                    onTriggered: parent.searchImageIndex = parent.searchImageIndex ? 0 : 1
                }
            }
            Image{
                id: ozdImg
                height: parent.height
                width: height
                source: startUp.state === "noLink" ? "Images/OZD_unlink_09.png" : "Images/OZD_09.png"
            }
        }
        Rectangle {border.color: "tomato"; color: "transparent"; x: activityRow.x; y: activityRow.y; width: activityRow.width; height: activityRow.height; visible: gridView}

        Row{
            id: connectionButtons
            height: parent.height * 0.13
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: startUp.bottomMargin
            spacing: height * 0.4
            Image{
                id: cancelButton
                height: parent.height
                width: height
                source: "Images/outline_cancel_white_48.png"
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        cancelConnection()
                        startUp.state = "connectionFail"
                    }
                }
            }
            Image{
                id: settingsButton
                height: parent.height
                width: height
                source: "Images/outline_settings_white_48.png"
                MouseArea{
                    anchors.fill: parent
                    onClicked: exitToSettings()
                }
                Behavior on opacity {
                   NumberAnimation { duration: gotoSettingsTout }
                }
            }
            Image{
                id: retryButton
                height: parent.height
                width: height
                source: "Images/outline_replay_white_48.png"
                MouseArea{
                    anchors.fill: parent
                    onClicked: restartConnection()
                }
            }
            Image{
                id: skipButton
                height: parent.height
                width: height
                source: "Images/outline_redo_white_48.png"
                MouseArea{
                    anchors.fill: parent
                    onClicked: exitToSettings()
//                  onClicked: exitToProtocolSelector()
                }
            }
        }

        ProgressBar {
            id: progressBar
            width: connectionButtons.width * 2.5
            height: connectionButtons.height * 0.2
            anchors.top: connectionButtons.bottom
            anchors.topMargin: connectionButtons.height * 0.05
            anchors.horizontalCenter: parent.horizontalCenter
            rotation: 180
            from: 0
            to: gotoSettingsTout
            value: 0
            visible: false
            onVisibleChanged: {
                value = visible ? gotoSettingsTout : 0
                settingsButton.opacity = visible ? 0.1 : 1
            }
            Behavior on value {
                SmoothedAnimation { duration: gotoSettingsTout }
            }
            onValueChanged: value === gotoSettingsTout ? readyToStart() : null
        }


        // start up controls
        Item{
            id: startUpControls
            anchors.fill: parent
            Image{
                id: infoButton
                height: connectionButtons.height
                width: height
                source: dataArea.visible ? "Images/outline_no_info_white_48_03.png" : "Images/outline_info_white_48_03.png"
                anchors.left: parent.left
                anchors.leftMargin: startUp.bottomMargin * 0.5
                anchors.bottom: parent.bottom
                anchors.bottomMargin: startUp.bottomMargin
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        dataArea.visible = !dataArea.visible
                        dataAreaVisibleReason = "user"
                    }
                }
                Rectangle {border.color: "tomato"; color: "transparent"; anchors.fill: parent; visible: gridView}
            }
            Image{
                id: okButton
                height: connectionButtons.height
                width: height
                source: "Images/outline_check_circle_outline_white_48.png"
                x: infoButton.x
                y: infoButton.y
                anchors.bottomMargin: startUp.bottomMargin
                MouseArea{
                    anchors.fill: parent
                    onClicked: checked()
                }
            }

            Image{
                id: errorImg
                height: connectionButtons.height
                width: height
//              source: "Images/outline_error_outline_white_48.png"
                source: linkStatus ? "Images/outline_error_outline_white_48.png" : "Images/outline_link_off_white_48.png"
                anchors.right: parent.right
                anchors.rightMargin: startUp.bottomMargin * 0.5
                anchors.bottom: parent.bottom
                anchors.bottomMargin: startUp.bottomMargin
                visible: false
                onVisibleChanged: {
                    if( !linkStatus && visible ){
                        textArea.text = ""
                        addInfo("Bluetooth connection lost...")
                    }
                }
                Label{
                    id: errorCode
                    text: "18"
                    color: "#DDDDDD"
                    height: parent.height * 0.2
                    width: parent.width
                    visible: parent.visible & linkStatus
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: -height * 0.4
                    verticalAlignment: Text.AlignBottom
                    horizontalAlignment:  Text.AlignRight
                    font.pixelSize: height
                    Rectangle {border.color: "khaki"; color: "transparent"; anchors.fill: parent; visible: gridView}
                }
                Rectangle {border.color: "green"; color: "transparent"; anchors.fill: parent; visible: gridView}
            }
            Image{
                id: skipErrorButton
                height: connectionButtons.height
                width: height
                source: "Images/outline_redo_white_48.png"
//              visible: errorImg.visible
//              visible: errorImg.visible & linkStatus
                visible: skipErrorAllowed & errorImg.visible & linkStatus
                anchors.right: errorImg.right
                anchors.bottom: errorImg.top
                anchors.bottomMargin: height * 0.2
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        clearError()
                        errorImg.visible = false
                    }
                }
                Rectangle {border.color: "green"; color: "transparent"; anchors.fill: parent; visible: gridView}
            }

            Image{
                id: restartTestButton
                height: connectionButtons.height
                width: height
                source: "Images/outline_replay_white_48.png"
                visible: errorImg.visible
                anchors.right: errorImg.right
//              anchors.bottom: skipErrorButton.top
                anchors.bottom: linkStatus ? skipErrorButton.top : errorImg.top
                anchors.bottomMargin: height * 0.2
                onVisibleChanged: restartHeartBeat.running = visible
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        if( !linkStatus  ){
                            restartConnection()
                        }else{
                            consoleSocket.sendData("{ENTREL_SIM\r")
                            startUp.addInfo("<br>Restart...")
                        }

                        //                        consoleSocket.sendData("{ENTREL_SIM\r")
                        //                        startUp.addInfo("<br>Restart...")
                        errorImg.visible = false

                        auxDelayTimer.running = false
                        skipErrorHeartBeat.running = false
                        restartHeartBeat.running = false
                    }
                }
                Rectangle {border.color: "green"; color: "transparent"; anchors.fill: parent; visible: gridView}
            }

            TextArea {
                id: dataAreaTittle
                width: dataArea.width
                height: parent.height * 0.05
                anchors.top : onWorkingImg.bottom
                anchors.topMargin: startUp.bottomMargin
                anchors.horizontalCenter: parent.horizontalCenter
                visible: dataArea.visible
                enabled: false
                textFormat: TextEdit.RichText
                color: "#DDDDDD"
                text: "<p1 style=\"font-size:19px; color:#AAAAAA\">Start up info<br></p1>" // +
                Rectangle {border.color: "tomato"; color: "transparent"; anchors.fill: parent; visible: gridView}
            }

            Flickable{
                id: dataArea
                width: parent.width * 0.5
//              height: parent.height * 0.32
                enabled: true
                flickableDirection: Flickable.VerticalFlick
                anchors.top: dataAreaTittle.bottom
                anchors.bottom: parent.bottom
                anchors.bottomMargin: startUp.bottomMargin
                anchors.horizontalCenter: parent.horizontalCenter

                ScrollBar.vertical: ScrollBar {
                    anchors.right: parent.right
                    policy: {
                        if(textArea.contentHeight > dataArea.height)
                        {
                            ScrollBar.AlwaysOn
                        }
                        else{
                            ScrollBar.AsNeeded // ScrollBar.AlwaysOn
                        }
                    }
                }
                // Avoid small position sinchronization on first touch
//              contentX: originX
//              contentY: originY

                TextArea.flickable: TextArea {
                    id: textArea
                    textFormat: TextEdit.RichText
                    enabled: false
                    color: "#DDDDDD"
                    text: ""
//                  text: "<p1 style=\"font-size:19px; color:#AAAAAA\">Example text: 250<br></p1>" +
                    Rectangle {border.color: "gold"; color: "transparent"; anchors.fill: parent; visible: gridView}
                }
            }

            Molecule{
                id: onWorkingImg
                height: activityRow.height
                width: height
                playing: false
                anchors.centerIn: parent
                anchors.verticalCenterOffset: -height * 0.2
                Rectangle {border.color: "pink"; color: "transparent"; anchors.fill: parent; visible: gridView}
            }
        }
        Rectangle {border.color: "gray"; color: "transparent"; anchors.fill: parent; visible: gridView}
    }

    Timer{
        id: connectingTout
        interval: 20000
        onRunningChanged: interval = interval
        onTriggered: connectionTout()
    }
    Rectangle {border.color: "plum"; color: "transparent"; anchors.fill: parent; visible: gridView}

    Heartbeat{
        id: restartHeartBeat
        target: restartTestButton
        quickStart: true
        onBlinkFinished: {
            skipErrorHeartBeat.running = true
            restartHeartBeat.running = false
        }
    }

    Heartbeat{
        id: skipErrorHeartBeat
        target: skipErrorButton
        quickStart: true
        onBlinkFinished: {
            auxDelayTimer.running = true
            skipErrorHeartBeat.running = false
        }
    }

    Timer{
        id: auxDelayTimer
        interval: 3000
        running: false
        onTriggered: restartHeartBeat.running = true
    }



}




