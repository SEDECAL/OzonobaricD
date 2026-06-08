// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright (C) 2024 Sedecal S.A.
// This file is part of OzonobaricD.
// See LICENSE file for details.

import QtQuick 2.15
import QtQuick.Controls 2.12
import QtQuick.Controls 1.4  as QQC1
import QtQuick.Controls.Styles 1.4
import QtGraphicalEffects 1.12
import AppStyle 1.0

Rectangle{
    id: pt
    property bool   viewGrid: false

    property double buttonSize: height * 0.17
    property double buttonRadius: height * 0.01
    property color  buttonColor: Style.input.buttonColor
    property double onPressButtonOpacity: 0.4
    property double hLineDivisionOpacity: 0
    property double vLineDivisionOpacity: 0.1
    property double generalSideMargin: height * 0.05
    property double disabledControlsOpacity: 0//0.5
    property bool   enableControls: true
    property bool   enableSelection: false
    property int    divisionLineWidth: 6

    property alias toFlow: slider.maximumValue
    property alias fromFlow: slider.minimumValue
    property alias flowValue: slider.value
    property alias toPressure: gradientProgress.to
    property alias fromPressure: gradientProgress.from
    property alias pressureValue: gradientProgress.value
    property alias pressureUnits: gradientProgress.units
    property alias progressLine: progressLine

    property int testTime: 1 // minutes

    signal start(int flow)
    signal stop()
    signal close()
    signal resetError()


    function closeTest(){
        if( (state === "waiting") || (state === "generating") ){
            stop()
        }
        close()
    }

    function reset(value){
        gradientProgress.reset(value)
    }

    width: 745
    height: 500
    color: Style.pressureTest.backColor
    radius: 4

    state: "none"

    states: [
        State {
            name: "none"
            PropertyChanges { target: infoArea; color: "transparent" }
            PropertyChanges { target: infoAreaImage; source: "" }
            PropertyChanges { target: infoAreaHearbit; running: false }
            PropertyChanges { target: progressLine; visible: false }
            PropertyChanges { target: infoAreaAnimatedImage; visible: false }
            PropertyChanges { target: rotationAnimator; running: false }
            PropertyChanges { target: playButton; enabled: true }
            PropertyChanges { target: stopButton; enabled: false }
            PropertyChanges { target: pt; enableControls: true }
        },
        State {
            name: "waiting"
            PropertyChanges { target: infoArea; color: "transparent" }
            PropertyChanges { target: infoAreaImage; source: "" }
            PropertyChanges { target: infoAreaHearbit; running: false }
            PropertyChanges { target: progressLine; visible: true }
            PropertyChanges { target: infoAreaAnimatedImage; visible: true }
            PropertyChanges { target: rotationAnimator; running: false }
            PropertyChanges { target: playButton; enabled: false }
            PropertyChanges { target: stopButton; enabled: true }
            PropertyChanges { target: pt; enableControls: false }
        },
        State {
            name: "generating"
            PropertyChanges { target: infoArea; color: "transparent" }
            PropertyChanges { target: infoAreaImage; source: "" }
            PropertyChanges { target: infoAreaHearbit; running: false }
            PropertyChanges { target: progressLine; visible: true }
            PropertyChanges { target: infoAreaAnimatedImage; visible: true }
            PropertyChanges { target: rotationAnimator; running: true }
            PropertyChanges { target: playButton; enabled: false }
            PropertyChanges { target: stopButton; enabled: true }
            PropertyChanges { target: pt; enableControls: false }

        },
        State {
            name: "overpressure"
            PropertyChanges { target: infoArea; color: Style.pressureTest.backColor }
            PropertyChanges { target: infoAreaImage; source: "Images/OverPressure_01.png" }
            PropertyChanges { target: infoAreaHearbit; running: true }
            PropertyChanges { target: progressLine; visible: false }
            PropertyChanges { target: infoAreaAnimatedImage; visible: false }
            PropertyChanges { target: rotationAnimator; running: false }
            PropertyChanges { target: playButton; enabled: false }
            PropertyChanges { target: stopButton; enabled: false }
            PropertyChanges { target: pt; enableControls: false }
        }
    ]

    GradientProgress{
        id: gradientProgress
        width: 80
        height: 456
        opacity:1
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.leftMargin: 50
        anchors.topMargin: 50
        unitsColor: Style.pressureTest.metterUnitsColor
        valueColor: Style.pressureTest.metterValueColor
        units: "mbar"
        Component.onCompleted: reset()
    }
    Rectangle{
        id: verticalDivision
        width: divisionLineWidth
        height: 500
        x: gradientProgress.width + (50 * 2)
        color: Style.pressureTest.lineColor
        opacity: vLineDivisionOpacity
    }

    Image {
        id: icon
        width: parent.height * 0.25
        height: parent.height * 0.25
        anchors.left: verticalDivision.right
        anchors.top: parent.top
        anchors.topMargin: generalSideMargin * 0.5
        anchors.leftMargin: generalSideMargin
        source: "Images/Flow_white.png"

        Rectangle {border.color: "plum"; color: "transparent"; anchors.fill: parent; visible: viewGrid}
    }

    Text {
        id: unitsLabel
        anchors.top: parent.top
        anchors.right: backButton.left
        anchors.topMargin: generalSideMargin
        anchors.rightMargin: generalSideMargin
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignRight
        text: "l/h"
        font.family: "Helvetica"
        font.pointSize: parent.height * 0.07
        color: Style.pressureTest.unitsColor
        Rectangle {border.color: "silver"; color: "transparent"; anchors.fill: parent; visible: viewGrid}
    }

    Text {
        id: valueLabel
        height: parent.height * 0.4

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.horizontalCenterOffset: verticalDivision.x * 0.5
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: -(parent.height - horizontalDivision.y) * 0.5
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        text: slider.value.toString()
        font.family: "Helvetica"
        font.pointSize: parent.height * 0.30
        color: Style.pressureTest.valueColor
        fontSizeMode: Text.Fit

        Rectangle {border.color: "khaki"; color: "transparent"; anchors.fill: parent; visible: viewGrid}
    }

    Item {
        id: sliderPositioner
        z: 3 // paid atention to swipe area z value
        anchors.left: minusButton.left
        anchors.right: plusButton.right
        anchors.bottom: horizontalDivision.top
        anchors.bottomMargin: generalSideMargin
        height: parent.height * 0.1
        enabled: (parent.state === "small") ? false : (true & enableControls & enableSelection)
        opacity: enabled ? 1 : disabledControlsOpacity

        QQC1.Slider {
            id: slider
            width: parent.width
            height: parent.height
            anchors.centerIn: parent
            stepSize: 1
            maximumValue: 100
            minimumValue: 0
            value: 35
            property double handleWidth: pt.height * 0.1

            style: SliderStyle {
                groove: Rectangle {
                    implicitHeight: pt.height * 0.02
                    radius: implicitHeight * 0.5
                    color: (slider.value >= 0) ? "white" : unitsLabel.color
                    width: parent.width

                    Rectangle {
                        color: (slider.value >= 0) ? unitsLabel.color : "white"
                        radius: parent.radius
                        implicitHeight: parent.height
                        implicitWidth: styleData.handlePosition + (slider.handleWidth * 0.5)
                    }
                }
                handle: Rectangle {
                    id: handleId
                    anchors.centerIn: parent
                    color: control.pressed ? valueLabel.color : unitsLabel.color
                    implicitWidth: slider.handleWidth
                    implicitHeight: implicitWidth
                    radius: implicitWidth * 0.7
                }
            }
        }
        Rectangle {border.color: "khaki"; color: "transparent"; anchors.fill: parent; visible: viewGrid}
    }

    Rectangle{
        id: backButton
        width: buttonSize
        height: buttonSize
        color: buttonColor
        radius: buttonRadius
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.topMargin: generalSideMargin
        anchors.rightMargin: generalSideMargin
        enabled: enableControls
        opacity: enabled ? 1 : disabledControlsOpacity

        Image{
            anchors.fill: parent
            source: "Images/ic_back_white_48dp_02.png"
            opacity: backButtonButton.pressed ? onPressButtonOpacity : 1
        }
        MouseArea {
            id: backButtonButton
            anchors.fill: parent
            onClicked: closeTest()
        }
        layer.enabled: Style.pressureTest.buttonShadowEnable
        layer.effect: DropShadow { radius: Style.pressureTest.buttonShadowRadius; color: Style.pressureTest.buttonShadowColor }
    }

    Rectangle{
        id: plusButton
        z: 3 // paid atention to swipe area z value
        width: buttonSize
        height: buttonSize
        color: buttonColor
        radius: buttonRadius
        anchors.bottom: sliderPositioner.top
        anchors.right: parent.right
        anchors.bottomMargin: generalSideMargin
        anchors.rightMargin: generalSideMargin
        enabled: enableControls & enableSelection
        opacity: enabled ? 1 : disabledControlsOpacity

        Label{
            color: unitsLabel.color
            text: "+"
            anchors.fill: parent
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.pointSize: parent.height
            opacity: plusButtonButton.down ? onPressButtonOpacity : 1
        }

        Button{
            id: plusButtonButton
            opacity: 0
            autoRepeat: true // @disable-check M16
            anchors.fill: parent
            onClicked: (slider.value >= 0) ? (slider.value = slider.value + slider.stepSize) : (slider.value = slider.value - slider.stepSize)
        }
        layer.enabled: Style.pressureTest.buttonShadowEnable
        layer.effect: DropShadow { radius: Style.pressureTest.buttonShadowRadius; color: Style.pressureTest.buttonShadowColor }
    }

    Rectangle{
        id: minusButton
        z: 3 // paid atention to swipe area z value
        width: buttonSize
        height: buttonSize
        color: buttonColor
        radius: buttonRadius
        anchors.bottom: plusButton.bottom
        anchors.left: verticalDivision.right
        anchors.leftMargin: generalSideMargin
        enabled: enableControls & enableSelection
        opacity: enabled ? 1 : disabledControlsOpacity

        Label{
            color: unitsLabel.color
            text: "_"
            anchors.fill: parent
            anchors.bottomMargin: parent.height * 0.25
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignBottom
            font.pointSize: parent.height
            opacity: minusButtonButton.down ? onPressButtonOpacity : 1
        }

        Button{
            id: minusButtonButton
            opacity: 0
            autoRepeat: true // @disable-check M16
            anchors.fill: parent
            onClicked: (slider.value >= 0) ? (slider.value = slider.value - slider.stepSize) : (slider.value = slider.value + slider.stepSize)
        }
        layer.enabled: Style.pressureTest.buttonShadowEnable
        layer.effect: DropShadow { radius: Style.pressureTest.buttonShadowRadius; color: Style.pressureTest.buttonShadowColor }
    }

    Rectangle{
        id: horizontalDivision
        width: parent.width - verticalDivision.x
        height: divisionLineWidth
        x: verticalDivision.x
        color: Style.pressureTest.lineColor
        anchors.bottom: infoArea.top
        anchors.bottomMargin: generalSideMargin * 0.5
        opacity: hLineDivisionOpacity
    }

    Rectangle{
        id: infoArea
        width: buttonSize * 1.2
        height: width
        color: "transparent"
        radius: buttonRadius
        anchors.bottom: parent.bottom
        anchors.bottomMargin: generalSideMargin * 0.5
        anchors.right: sliderPositioner.right

        Behavior on opacity {
            SmoothedAnimation { velocity: 150 }
        }

        Image{
            id: infoAreaAnimatedImage
            height: parent.height * 0.75
            width: parent.width * 0.75
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: generalSideMargin
            source: "Images/molecula O2 h_2_small.png"
            RotationAnimator on rotation {
                id: rotationAnimator
                from: 0;
                to: 360;
                duration: 1000
                running: true
                loops: Animation.Infinite;
                alwaysRunToEnd: true
            }
            Rectangle {border.color: "tomato"; color: "transparent"; anchors.fill: parent; visible: viewGrid}
        }

        Image{
            id: infoAreaImage
            height: infoAreaAnimatedImage.height
            width: infoAreaAnimatedImage.width
            anchors.centerIn: parent
            source: ""
            Rectangle {border.color: "olive"; color: "transparent"; anchors.fill: parent; visible: viewGrid}
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                if(pt.state === "overpressure"){
                    pt.state = "none"
                    pt.resetError()
                }
            }
            Rectangle {border.color: "gold"; color: "transparent"; anchors.fill: parent; visible: viewGrid}
        }
    }

    Rectangle{
        id: playButton
        width: buttonSize * 1.2
        height: width
        color: "transparent"
        radius: buttonRadius
        anchors.bottom: infoArea.bottom
        anchors.right: sliderPositioner.horizontalCenter
        anchors.rightMargin: generalSideMargin * 0.3
        Rectangle {border.color: "pink"; color: "transparent"; anchors.fill: parent; visible: viewGrid}
        Image{
            anchors.fill: parent
            source: "Images/outline_play_circle_white_48.png"
            opacity: enabled ? 1 : onPressButtonOpacity
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                progressLine.value = 0
                start(flowValue)
            }
        }
    }

    Rectangle{
        id: stopButton
        width: playButton.width
        height: width
        color: "transparent"
        radius: buttonRadius
        anchors.bottom: infoArea.bottom
        anchors.left: sliderPositioner.horizontalCenter
        anchors.leftMargin: generalSideMargin * 0.3
        Rectangle {border.color: "pink"; color: "transparent"; anchors.fill: parent; visible: viewGrid}

        Image{
            anchors.fill: parent
            source: "Images/outline_stop_circle_white_48.png"
            opacity: enabled ? 1 : onPressButtonOpacity
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                stop()
            }
        }
    }

    ProgressBar {
        id: progressLine
        height: 4
        visible: false
        value: 0
        from: testTime * 60  // @disable-check M16
        to: 0                // @disable-check M16
        anchors.left: infoArea.left
        anchors.right: infoArea.right
        anchors.bottom: infoArea.bottom
        anchors.bottomMargin: generalSideMargin * 0.5
        rotation: 180
        opacity: 0.75
    }

    SwipeArea{
        z: 2
        anchors.fill: parent
        enabled: visible & enableControls
        onSwipeUp: closeTest()
    }

    Heartbeat{
        id: infoAreaHearbit
        target: infoArea
        quickStart: true
    }

}
