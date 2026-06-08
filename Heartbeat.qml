// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright (C) 2024 Sedecal S.A.
// This file is part of OzonobaricD.
// See LICENSE file for details.

import QtQuick 2.15
import QtQuick.Window 2.15

Item {
    property alias target: downEffect.target

    property bool   running: false
    property bool   quickStart: false
    property int    upTime: 1000
    property int    downTime: 300
    property int    cadence: 5000
    property double lowOpacityLevel: 0.2
    property double hightOpacityLevel: 1

    signal blinkFinished()

    onRunningChanged: {
        if(quickStart){
            waitTimer.interval = 1000
        }
        waitTimer.running = running
    }
    OpacityAnimator {
        id: downEffect
        target: target
        from: hightOpacityLevel
        to: lowOpacityLevel
        duration: downTime
        running: false
        onFinished: uptEffect.running = true
    }
    OpacityAnimator {
        id: uptEffect
        target: downEffect.target
        from: lowOpacityLevel
        to: hightOpacityLevel
        duration: upTime
        running: false
        onFinished: {
            blinkFinished()
            if(running){
                waitTimer.restart()
            }
        }
    }
    Timer{
        id: waitTimer
        interval: cadence
        running: false
        repeat: true
        onTriggered: {
            if(quickStart){
                interval = cadence
            }
            downEffect.running = true
        }
    }

}
