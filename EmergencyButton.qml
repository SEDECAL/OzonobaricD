// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright (C) 2024 Sedecal S.A.
// This file is part of OzonobaricD.
// See LICENSE file for details.

import QtQuick 2.15
import QtQuick.Controls 2.5
import QtGraphicalEffects 1.12

Item{
    id: emergencyButton
    property bool gridView: false

    property int    opacityDuration: 1000
    property int    blinkRate: 5000
    property double frameOpacity: 0.6
    property double symbolOpacity: 0.8
    property string buttonState: "play"//"pause"

    property var allowedViewKeys: ["ej1", "ej2"]

    signal clicked(string action)

    function setPlay(){
        if(emergencyButton.visible){
        console.log("Set play")
        emergencyButton.buttonState =  "play"
        }
    }
    function setPause(){
        if(emergencyButton.visible){
        console.log("Set pause")
        emergencyButton.buttonState =  "pause"
        }
    }

    function resolveVisibility(key){
        var ret = false

        for(var value in allowedViewKeys){
            if(allowedViewKeys[value] === key){
                ret = true
                break;
            }
        }
        emergencyButton.visible = ret

        // Since "emergencyButton.setPause" is connected to "toolBar.playClicked", emergencybutton
        // results worng initialized when play is pressed to start the therapy
//        setPlay()
    }

    state: ""
    states: [
        State {
            name: "expanded"
            PropertyChanges { target: expandControls; state: "big" }
            PropertyChanges { target: emergencyButton; opacityDuration: 0}
            PropertyChanges { target: actionImg; opacity: 0}
            PropertyChanges { target: pulseTimer; interval: 800}
            PropertyChanges { target: pulseTimer; running: true}
        },
        State {
            name: "reduced"
            PropertyChanges { target: expandControls; state: "small" }
            PropertyChanges { target: pulseTimer; running: false}
        }
    ]

    onVisibleChanged: emergencyButton.state = visible ? "expanded" : "reduced"

    Image{
        id: reduceButton
        x: 10//parent.width - width
        y: 10
        source: "Images/Minimizar_00.png"
        width: parent.width * 0.1
        height: width
        z:3
        MouseArea{
            anchors.fill: parent
            onClicked: emergencyButton.state = (emergencyButton.state === "expanded") ? "reduced" : "expanded"
        }
        opacity: emergencyButton.frameOpacity
    }

    ExpandArea{
        id: expandControls

        x: 0//parent.width
        y: 0
        x_s: 0//parent.width
        y_s: 0
        x_b: 0
        y_b: 0
        width_b: height_b
        height_b: parent.height
        color: "transparent"

        onRetractionEnd: reduceButton.source = "Images/Max_L_00.png"
        onExpansionEnd:  reduceButton.source = "Images/Min_L_01.png"

        Image{
            id: frameImg
            height: parent.height
            width: height
            source: "Images/base_01"
            anchors.centerIn: parent
            opacity: emergencyButton.frameOpacity
        }

        Image{
            id: actionImg
            property int opacityDelay: 0
            height: parent.height
            width: height
            source: buttonState === "play" ? "Images/play_5px_01.png" : "Images/pause_5px_01.png"
            anchors.centerIn: parent

            OpacityAnimator {
                id: actionImgOpacityAnimator
                target: actionImg;
                from: 0;
                running: false
            }
        }

        MouseArea{
            anchors.fill: parent
            onClicked: {
                emergencyButton.clicked(buttonState);
                console.log("Emergency button clicked...", buttonState)
                pulseTimer.interval = 1
            }
        }

        Timer{
            id: pulseTimer
            interval: blinkRate
            repeat: true
            onTriggered: {
                interval = blinkRate
                actionImg.opacity = emergencyButton.symbolOpacity
                auxTimer1.running = true
            }
        }

        Timer{
            id: auxTimer1
            interval: 100
            onTriggered: {
                actionImgOpacityAnimator.from = emergencyButton.symbolOpacity
                actionImgOpacityAnimator.to = 0
                actionImgOpacityAnimator.duration = 2000//emergencyButton.opacityDuration
                actionImgOpacityAnimator.running = true
            }
        }
    }

    Rectangle {border.color: "plum"; color: "transparent"; anchors.fill: parent; visible: gridView}
}
