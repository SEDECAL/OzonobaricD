// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright (C) 2024 Sedecal S.A.
// This file is part of OzonobaricD.
// See LICENSE file for details.

import QtQuick 2.0

Item {
    anchors.fill: parent
    z: 1000

    Rectangle {
        id: poiniterRect
        z: 1000
        height: 76
        width: 76
        radius: 38
        color: "tomato"
        opacity: 0
        visible: opacity > 0

        SequentialAnimation {
            id: pointerflashAnim
            running: false

            PropertyAnimation {
                target: poiniterRect
                property: "opacity"
                from: 0
                to: 1
                duration: 100
            }

            PauseAnimation {
                duration: 100
            }

            PropertyAnimation {
                target: poiniterRect
                property: "opacity"
                from: 1
                to: 0
                duration: 300
            }
        }
    }


    MouseArea {
        z: 1000
        anchors.fill: parent
        propagateComposedEvents: true
        enabled: parent.enabled

        onPressed: {
            console.log("Pantalla pulsada", mouse.x, mouse.y)
            poiniterRect.x = mouse.x - poiniterRect.width * 0.5
            poiniterRect.y = mouse.y - poiniterRect.height * 0.5
            mouse.accepted = false
            pointerflashAnim.restart()
        }
    }

}
