// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright (C) 2024 Sedecal S.A.
// This file is part of OzonobaricD.
// See LICENSE file for details.

import QtQuick 2.0


Item{
    id: animation

    property int  conversionDuration: 0
    property int  animationTime: 1000
    property int  appearanceAngle: 90
    property int  pauseTime: 2000
    property bool playing: false

    property int t1: animationTime * ( appearanceAngle / 360 )
    property int t2: animationTime * ( (360 - appearanceAngle) / 360 )


    property var statesList:[
        "init",
        "rotation1",
        "rotation2"
    ]

    function nextState(){
        if(playing){
            for(var i=0; i<statesList.length; i++){
                if(statesList[i] === animation.state){
                    animation.state = statesList[ (i === statesList.length - 1) ? 0 : i + 1 ]
                    break;
                }
            }
        }
    }

    width: 250
    height: width

//    just for time adjustment during debug
//    Component.onCompleted: {
//        console.log("t1:", t1)
//        console.log("t2:", t2)
//    }

    onPlayingChanged: {
        if(playing){
            delay.running = true
            delay.interval = 0
            animation.state = "init"
        }
    }

    state: "init"
    states: [
        State {
            name: "init"
            PropertyChanges { target: animation; conversionDuration: 0 }
            PropertyChanges { target: twoAtoms; rotation: 0 }
            PropertyChanges { target: twoAtoms; opacity: 1 }
            PropertyChanges { target: delay;    interval: pauseTime }
            PropertyChanges { target: delay;    running: true }
        },
        State {
            name: "rotation1"
            PropertyChanges { target: animation; conversionDuration: t1}
            PropertyChanges { target: twoAtoms; rotation: appearanceAngle }
        },
        State {
            name: "rotation2"
            PropertyChanges { target: animation; conversionDuration: 750}//t2} // TODO
            PropertyChanges { target: twoAtoms; rotation: 360 }
            PropertyChanges { target: twoAtoms; opacity: 0 }
            PropertyChanges { target: delay;    interval: pauseTime + t2}
            PropertyChanges { target: delay;    running: true }
        }
    ]


    Image{
        id: twoAtoms
        anchors.fill: parent
        source: "Images/molecula O2 h_2.png"
        Behavior on rotation {
            NumberAnimation{ duration: conversionDuration}
        }
        Behavior on opacity {
            NumberAnimation{ duration: conversionDuration}
        }
        onRotationChanged: (rotation === appearanceAngle) ? animation.state = "rotation2" : null
    }
    Image{
        id: threeAtoms
        anchors.fill: parent
        source: "Images/molecula O3_2.png"
        opacity: 1 - twoAtoms.opacity
        rotation: twoAtoms.rotation
    }

    Timer{
        id: delay
        running: false
        interval: pauseTime
        onTriggered: nextState()
    }
}
