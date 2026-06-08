// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright (C) 2024 Sedecal S.A.
// This file is part of OzonobaricD.
// See LICENSE file for details.

import QtQuick 2.0
import QtQuick.Controls 2.5

Item {
    id: btConnection
    property bool gridView: false

    property double buttonSize: 90 * 0.8
    property double buttonRadius: buttonSize * 0.065
    property color  buttonColor: "#5F6367"//"#1A1A1A"
    property bool   includeProgress: true
    property bool   progressRunning: false
    property bool   startEnabled: true
    property bool   cancelEnabled: true
    property bool   configPending: true

    property variant searchImage: ["Images/outline_bluetooth_searching_white_48.png",
                                   "Images/outline_bluetooth_searching_no_waves_white_48.png"]
    property int searchImageIndex: 0


    signal start
    signal cancel

    state: "disconnected"
    states: [
        State {
            name: "connected"
            PropertyChanges { target: icon;         source: "Images/outline_link_white_48.png" }
            PropertyChanges { target: btConnection; startEnabled: true }
            PropertyChanges { target: btConnection; cancelEnabled: false }
            PropertyChanges { target: btConnection; configPending: false }
        },
        State {
            name: "disconnected"
            PropertyChanges { target: icon;         source: "Images/outline_link_off_white_48.png" }
            PropertyChanges { target: btConnection; startEnabled: true }
            PropertyChanges { target: btConnection; cancelEnabled: false }
            PropertyChanges { target: btConnection; configPending: false }
        },
        State {
            name: "searching"
            PropertyChanges { target: btConnection; startEnabled: false }
            PropertyChanges { target: btConnection; cancelEnabled: true }
            PropertyChanges { target: btConnection; searchImageIndex: 0 }
            PropertyChanges { target: btConnection; configPending: true }
        },
        State {
            name: "noTargetDev"
            PropertyChanges { target: icon;         source: "Images/outline_build.png" }
            PropertyChanges { target: btConnection; startEnabled:  false }
            PropertyChanges { target: btConnection; cancelEnabled: false }
            PropertyChanges { target: btConnection; configPending: true }
        }
    ]


    Item{
        anchors.centerIn: parent
        height: icon.height + buttonsRow.height + buttonsRow.anchors.topMargin
        width: parent.width

        Image {
            id: icon
            height: buttonSize * 1.2
            width:  height
            anchors.horizontalCenter: parent.horizontalCenter
            source: searchImage[searchImageIndex]
            opacity: 0.9
            Rectangle {border.color: "tomato"; color: "transparent"; anchors.fill: parent; visible: gridView}
        }
        Row{
            id: buttonsRow
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: icon.bottom
            anchors.topMargin: 1.4 * spacing
            spacing: 25
            Repeater{
                model: 2
                Rectangle{
                    height: buttonSize
                    width:  buttonSize
                    color:  buttonColor
                    radius: buttonRadius
                    enabled: index ? cancelEnabled : startEnabled
                    opacity: enabled ? 1 : 0.3
                    Image {
                        anchors.fill: parent
                        source: index ? "Images/baseline_stop_white_24.png" : "Images/baseline_play_arrow_white_24.png" // Azure Bug 10885: (SDV 2) Wrong icons on Bluetooth connection option
                    }
                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            if(index){
                                cancel()
                                btConnection.state = "disconnected"
                            }
                            else{
                                start()
                                btConnection.state = "searching"
                            }
                        }
                    }
                }
            }
        }
    }
    Timer{
        id: searchingTimer
        running: (state === "searching")
        interval: 1000
        repeat: true
        onTriggered: searchImageIndex = searchImageIndex ? 0 : 1
    }
    Timer{
        id: searchTout
        running: (state === "searching")
        interval: 30000
        onTriggered: cancel()
    }


    Rectangle {border.color: "green"; color: "transparent"; anchors.fill: parent; visible: gridView}
}
