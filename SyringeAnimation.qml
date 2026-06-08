// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright (C) 2024 Sedecal S.A.
// This file is part of OzonobaricD.
// See LICENSE file for details.

import QtQuick 2.0

Item{
    property bool gridView: false
    property bool running: false
    property int  frameBefore: 0

    height: 200
    width: 100

    AnimatedImage {
//      height: implicitHeight * 0.5
//      width: implicitWidth * 0.5
        anchors.centerIn: parent
        source: "Images/SyringeFill_V_00.gif"
        playing: running
        onVisibleChanged: {
            currentFrame = 0
            frameBefore = 0

            if(!visible){
                running = false
            }
        }
        onPlayingChanged: {
            if(playing){
                currentFrame = frameBefore
            }
            else{
                frameBefore = currentFrame
            }
        }
    }
    Rectangle {border.color: "blue"; color: "transparent"; anchors.fill: parent; visible: gridView}
}
