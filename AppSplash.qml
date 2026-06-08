// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright (C) 2024 Sedecal S.A.
// This file is part of OzonobaricD.
// See LICENSE file for details.

import QtQuick 2.12

Rectangle{
    id: appSplash
    property bool gridView: false

    states: [
        State {
            name: "on"
            PropertyChanges { target: appSplash; visible: true }
        },
        State {
            name: "delayedOff"
            PropertyChanges { target: delayedOffTimer; running: true }
        },
        State {
            name: "fadeOut"
            PropertyChanges { target: splashImgOpacityAnimator; running: true }
        }
    ]

    color: "#151515"
    anchors.fill: parent
    state: "on"

    Image {
    id: splashImg
        anchors.centerIn: parent
        source: "Images/outline_settings_white_48.png"
        visible: true
        RotationAnimator on rotation {
            from: 0;
            to: 360;
            duration: 2000
            running: false
            loops: Animation.Infinite;
        }
    }

    OpacityAnimator {
        id: splashImgOpacityAnimator
        target: splashImg;
        from: 1
        to: 0
        running: false
        duration: 2000
        easing.type: Easing.InQuart
        onFinished: appSplash.state = "delayedOff"
    }

    Timer{
        id: delayedOffTimer
        interval: 500
        running: false
        onTriggered: appSplash.visible = false
    }

    Rectangle {border.color: "green"; color: "transparent"; anchors.fill: parent; visible: gridView}
}
