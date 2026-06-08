// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright (C) 2024 Sedecal S.A.
// This file is part of OzonobaricD.
// See LICENSE file for details.

import QtQuick 2.15
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import AppStyle 1.0

Progress{
    id: gp

    property bool allowDebug: false
    property bool allowValuesDebug: false

    property color unitsColor: allowDebug ? "#444444" : "transparent"
    property color valueColor: allowDebug ? "#222222" : "transparent"
    property double upperColorPosition: 0
    property double middleColorPosition1: 0.3
    property double middleColorPosition2: 0.7
    property double lowerColorPosition: 1

    from: 400
    to: 800
    value: 700
    mainColor: unitsColor
    backColor: valueColor
    opacity: 0

    function reset(resetValue){
        if(arguments.length) {
            gp.value = resetValue
        }

        lineYBehavior.enabled = false
        line.y = gp.indicator
        maxIndicator.y = gp.indicator - (maxIndicator.width * 0.5)
        minIndicator.y = gp.indicator - (minIndicator.width * 0.5)
        lineYBehavior.enabled = true
    }

    function show(){
        opacityAnimator.running = true
    }

    function hide(){
        opacityAnimator.running = false
        opacity = 0
    }

    onIndicatorChanged: {       // necessary despite of 'y' binding on 'line'
        line.y = gp.indicator   // definition (don't know why)
    }

    OpacityAnimator {
        id: opacityAnimator
        target: gp
        from: 0
        to: 1
        duration: 300
        running: false
    }

    Rectangle {
        width: parent.width
        height: gp.barHeihgt
        y: gp.barY
        radius: gp.itemRadius
        gradient: Gradient {
            GradientStop { position: upperColorPosition;   color: Style.gradientProgress.upColor }
            GradientStop { position: middleColorPosition1; color: Style.gradientProgress.midColor }
            GradientStop { position: middleColorPosition2; color: Style.gradientProgress.midColor }
            GradientStop { position: lowerColorPosition;   color: Style.gradientProgress.lowColor }
        }
        x: allowDebug ? parent.height * 0.5 : 0 // just for debug
    }

    Rectangle{
        id: line
        width: parent.width * 0.9
        anchors.horizontalCenter: parent.horizontalCenter
        height: 2
        opacity: 0.85
        y: gp.indicator
        Behavior on y {
            id: lineYBehavior
            SmoothedAnimation { velocity: 150 }
        }
        onYChanged: {
            if (maxIndicator.y > (y - (maxIndicator.width * 0.5))){
                maxIndicator.y =  y - (maxIndicator.width * 0.5)
            }if(minIndicator.y < (y - (minIndicator.width * 0.5))){
                minIndicator.y =  y - (minIndicator.width * 0.5)
            }
        }
    }

    Rectangle{
        id: maxIndicator
        width: parent.width * 0.1
        height: width
        radius: width * 0.5
        x: width * -1.5
        opacity: 0.75
    }

    Rectangle{
        id: minIndicator
        width: maxIndicator.width
        height: width
        radius: width * 0.5
        x: parent.width - maxIndicator.x - width
        opacity: maxIndicator.opacity
    }

//
//  debug
//
    Row {
        visible: allowDebug
        width: parent.width
        spacing: 10
        Button {
            width: parent.width * 0.6
            height: width
            text: "+"
            onClicked: gp.value = gp.value + 30
            autoRepeat: true
        }
        Button {
            width: parent.width * 0.6
            height: width
            text: "-"
            onClicked: gp.value = gp.value - 30
            autoRepeat: true
        }
    }

    Label{
        id: valueDebug
        text: "value: " + gp.value
        color: "white"
        width: 20
        height: 20
        anchors.left: gp.right
        visible: allowValuesDebug
    }
    Label{
        id: fromDebug
        text: "from: " + gp.from
        color: "white"
        width: 20
        height: 20
        anchors.left: gp.right
        anchors.top: valueDebug.bottom
        visible: allowValuesDebug
    }
    Label{
        id: toDebug
        text: "to: " + gp.to
        color: "white"
        width: 20
        height: 20
        anchors.left: gp.right
        anchors.top: fromDebug.bottom
        visible: allowValuesDebug
    }
}


