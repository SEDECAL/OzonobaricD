// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright (C) 2024 Sedecal S.A.
// This file is part of OzonobaricD.
// See LICENSE file for details.

import QtQuick 2.0
import QtQuick.Controls 2.5
import AppStyle 1.0
import QtGraphicalEffects 1.0

Item {
    id: confirmation

    property bool gridView: false

    property double buttonSize: 90 * 0.8
    property double buttonRadius: buttonSize * 0.055
    property color  buttonColor: Style.deviceInfo.buttonColor
    property bool   includeProgress: true
    property bool   progressRunning: false
    property bool   yesEnabled: true
    property bool   noEnabled: true
    property bool   btnEndVisible: true
    property bool   delayedCancelConfirmation: false
    property string btnStartImgSource: "Images/ic_done_white_48dp.png"
    property string btnEndImgSource: "Images/baseline_clear_white_48.png"

    signal yes
    signal no

    signal delay

    state: "waiting"
    states: [
        State {
            name: "progress"
            PropertyChanges { target: confirmation; yesEnabled: false }
            PropertyChanges { target: confirmation; noEnabled:  true }
            PropertyChanges { target: confirmation; progressRunning: true }
            PropertyChanges { target: buttonsRow;   visible: true }
            PropertyChanges { target: reusltButton; visible: false }
        },
        State {
            name: "waiting"
            PropertyChanges { target: confirmation; yesEnabled: true }
            PropertyChanges { target: confirmation; noEnabled:  false }
            PropertyChanges { target: confirmation; progressRunning: false }
            PropertyChanges { target: buttonsRow;   visible: true }
            PropertyChanges { target: reusltButton; visible: false }
        },
        State {
            name: "completed"
            PropertyChanges { target: buttonsRow;   visible: false }
            PropertyChanges { target: reusltButton; visible: true }
            PropertyChanges { target: reusltButton; image: "Images/baseline_check_circle_outline_white_24.png" }
            PropertyChanges { target: confirmation; progressRunning: false }
        },
        State {
            name: "cancelled"
            PropertyChanges { target: buttonsRow;   visible: false }
            PropertyChanges { target: reusltButton; visible: true }
            PropertyChanges { target: reusltButton; image: "Images/baseline_highlight_off_white_24.png" }
            PropertyChanges { target: confirmation; progressRunning: false }
        },
        State {
            name: "error"
            PropertyChanges { target: buttonsRow;   visible: false }
            PropertyChanges { target: reusltButton; visible: true }
            PropertyChanges { target: reusltButton; image: "Images/outline_error_outline_white_24.png" }
            PropertyChanges { target: confirmation; progressRunning: false }
        },
        State {
            name: "delay"
            PropertyChanges { target: confirmation;  yesEnabled: false }
            PropertyChanges { target: confirmation;  noEnabled:  false }
            PropertyChanges { target: confirmation;  progressRunning: false }
            PropertyChanges { target: buttonsRow;    visible: true }
            PropertyChanges { target: reusltButton;  visible: false }
            PropertyChanges { target: auxDelayTimer; running: true }
        }
    ]

    ProgressBar {
        id: progressBar
        indeterminate: progressRunning
        width: parent.width * 0.7
        height: parent.height * 0.2
        visible: includeProgress
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        from: 0
        to: 1
        value: 1
        Rectangle {border.color: "plum"; color: "transparent"; anchors.fill: parent; visible: gridView}
    }

    Row{
        id: buttonsRow
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
//      anchors.topMargin: !includeProgress ? (parent.height - buttonSize) * 0.5 : (parent.height - (buttonSize * 0.8) - progressBar.height) * 0.6
        anchors.topMargin: !includeProgress ? (parent.height - buttonSize) * 0.5 : (parent.height - buttonSize - progressBar.height) * 0.6
        spacing: 25
        Repeater{
            model: 2
            Rectangle{
//              height: includeProgress ? buttonSize * 0.8 : buttonSize
                height: buttonSize
                width:  height
                color:  buttonColor
                radius: buttonRadius
                enabled: index ? noEnabled : yesEnabled
                opacity: enabled ? 1 : 0.3
                visible: index ? btnEndVisible : true
                layer.enabled: Style.deviceInfo.buttonShadowEnable
                layer.effect: DropShadow { radius: Style.deviceInfo.buttonShadowRadius; color: Style.deviceInfo.buttonShadowColor }
                Image {
                    anchors.fill: parent
                    source: index ? btnEndImgSource : btnStartImgSource
                }
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        if(index){
                            no()
//                            progressBar.indeterminate = false
//                            confirmation.state = "waiting"
                            confirmation.state = "cancelled"
                        }
                        else{
                            yes()
//                            progressBar.indeterminate = true
                            confirmation.state = "progress"
                        }
                    }
                }
            }
        }
    }

    Rectangle{
        id: reusltButton
        property string image: "Images/ic_done_white_48dp.png"
        height: buttonSize
        width:  height * 4
        color:  "transparent"
        anchors.centerIn: parent
        visible: false
        Image {
            height: parent.height
            width:  height
            anchors.centerIn: parent
            source: reusltButton.image
        }
        MouseArea{
            anchors.fill: parent
            onClicked: {
                if(confirmation.state === "cancelled"){
                    confirmation.state = delayedCancelConfirmation ? "delay" : "waiting"
                }
                else {
                    confirmation.state = "waiting"
                }
            }
        }
    }

    Timer{
        id: auxDelayTimer
        interval: 3000
        running: false
        onTriggered: confirmation.state = "waiting"
    }


    Rectangle {border.color: "green"; color: "transparent"; anchors.fill: parent; visible: gridView}
}
