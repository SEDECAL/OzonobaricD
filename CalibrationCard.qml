// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright (C) 2024 Sedecal S.A.
// This file is part of OzonobaricD.
// See LICENSE file for details.

import QtQuick 2.15
import QtQuick.Controls 2.5
import QtQuick.Controls 1.4  as QQC1
import QtQuick.Controls.Styles 1.4

ExpandArea{
    id: calibrationCard
    property bool gridView: false

    property double vMargin: 0.27   // %
    property double hMargin: 0.025  // %
    property double generalSideMargin: height * 0.06
    property double buttonSize: height * 0.20
    property double onPressButtonOpacity: 0.4
    property double buttonRadius: height * 0.01
    property color  buttonColor: "#003333"// "#5F6367"
    property color  controlsColor: "steelblue"
    property color  activeControlsColor: "red"
    property color  stepsColor: "red"
    property color  descriptionColor: "red"
    property int    calibrationSteps: 1
    property int    currentStep: 0
    property var    calibrationSettings: ({})
    property string stepDescription: "Step"
    property bool   waitingMode: false
    property string tittleAnimationState: "hide"
    property bool   sliderView: true

    property alias  slider: slider
    property alias  decriptionText: decriptionText
    property alias  tittle: tittle

    signal okButtonPressed()
    signal backButtonPressed()
    signal sliderValueChanged(int value)

    function closeCard(){
        currentStep = 0
        controls.visible = false
        retract()
    }

    function updateSliderValue(value){
        slider.value = value
    }

    function nextStep(){
        console.log("Calibration card ok button simulation pressed...")
        if(++currentStep === calibrationSteps)
            closeCard()
    }

    radius: 5
    color: "#00ff11" //Style.configurationArea.cardColor
    animationTime: 350
    expandOnClicked: true

    onExpansionEnd: controls.visible = true
    onStateChanged: tittleLine.visible = (state === "big") ? false : true

    Item{
        id: alwaysVisibleControls
        Label{
            id: tittle
            color: calibrationCard.controlsColor
            height: calibrationCard.height_s - (2 * calibrationCard.vMargin  * calibrationCard.height_s)
            width: calibrationCard.width_s * (1 - (2 * calibrationCard.hMargin))
            text: ""//calibrationCard.tittle
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.topMargin: calibrationCard.height_s * calibrationCard.vMargin
            anchors.leftMargin: calibrationCard.width_s * calibrationCard.hMargin
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment:  Text.AlignLeft
            font.pixelSize: height
        }

        Image{
            id: extensioButton
            height: tittle.height
            width: height
            anchors.right: tittle.right
            anchors.bottom: tittle.bottom
            visible: tittleLine.visible
            source: "Images/outline_expand_more_white_24.png"
        }

        Rectangle {
            id: tittleLine
            border.color: calibrationCard.controlsColor
            color: "transparent"
            width: tittle.width
            anchors.left: tittle.left
            anchors.top: tittle.bottom
            anchors.topMargin: 5
            height: 1
            Behavior on visible {PropertyAnimation { duration: (tittleLine.visible) ? 0 : 700 } }
        }

        Rectangle {
            id: tittleLineAnimation
            state: tittleAnimationState
            width: tittleLine.width
            height: tittleLine.height + 2
            anchors.verticalCenter: tittleLine.verticalCenter
            anchors.right: tittleLine.right
            visible: false
            color: calibrationCard.color
            onStateChanged: {
                width = (state == "show") ? 0 : tittleLine.width
                visible = (state == "show") ? true : false
                calibrationCard.expandOnClicked = (state == "show") ? false : true
            }
            Behavior on width {
                SmoothedAnimation { duration: 2000 }
            }
        }
    }

    Item{
        id: controls
        visible: false
        anchors.fill: parent

        Text {
            id: valueLabel
            height: parent.height * 0.4
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: buttonsCol.bottom
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            text: slider.value.toString()
            font.family: "Helvetica"
            font.pointSize: (parent.height * 0.30) ? (parent.height * 0.30) : 1  // avoid system warning at start up (Point size <= 0 (0.000000), must be greater than 0)
            color: calibrationCard.controlsColor
            fontSizeMode: Text.Fit
            visible: !waitingMode

            Rectangle {border.color: "blue"; color: "transparent"; anchors.fill: parent; visible: gridView}
        }

        Column {
            id: buttonsCol
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.topMargin: generalSideMargin
            anchors.rightMargin: generalSideMargin
            spacing: generalSideMargin * 0.5

            Rectangle {
                id: okButton
                height: buttonSize
                width: buttonSize
                color: buttonColor
                radius: buttonRadius
                enabled: !waitingMode
                opacity: waitingMode ? onPressButtonOpacity : 1

                Image{
                    anchors.fill: parent
                    source: "Images/ic_done_white_48dp.png"
                    opacity: okButtonButton.pressed ? onPressButtonOpacity : 1
                }
                MouseArea {
                    id: okButtonButton
                    anchors.fill: parent
                    onClicked: {
                    //  NOTE: Two events generated when clicked:
                    //  - currentStep change
                    //  - okButtonPressed()
                    //  The first one is linked width next card settings steps, then the new slider value
                    //  will be used during ok button signal events (lossing the slider value selected before).
                    //  Change the precedence of the signal is not a solution.

                    //  (++currentStep === calibrationSteps) ? closeCard() : null
//                        okButtonPressedResponse()
                        delayCurrentStepUpdate.running = true
                        okButtonPressed()

                    }
                }
                Timer{
                    id: delayCurrentStepUpdate
                    interval: 100
                    onTriggered: (++currentStep === calibrationSteps) ? closeCard() : null
                }
            }
            Rectangle {
                id: backButton
                height: buttonSize
                width: buttonSize
                color: buttonColor
                radius: buttonRadius

                Image{
                    anchors.fill: parent
                    source: "Images/ic_back_white_48dp_02.png"
                    opacity: backButtonButton.pressed ? onPressButtonOpacity : 1
                }
                MouseArea {
                    id: backButtonButton
                    anchors.fill: parent
                    onClicked: {
                        closeCard()
                        backButtonPressed()
                    }
                }
            }
        }

        Rectangle {
            id: plusButton
            height: buttonSize
            width: buttonSize
            color: buttonColor
            radius: buttonRadius
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            anchors.bottomMargin: generalSideMargin
            anchors.rightMargin: generalSideMargin
            visible: (sliderView) ? !waitingMode : false

            Label{
                color: controlsColor
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
//              onClicked: (slider.value >= 0) ? (slider.value = slider.value + slider.stepSize) : (slider.value = slider.value - slider.stepSize)
                onClicked: (slider.value >= 0) ? slider.value++ : slider.value--
            }
        }

        Rectangle {
            id: minusButton
            height: buttonSize
            width: buttonSize
            color: buttonColor
            radius: buttonRadius
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.bottomMargin: generalSideMargin
            anchors.leftMargin: generalSideMargin
            visible: (sliderView) ? !waitingMode : false

            Label{
                color: controlsColor
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
//              onClicked: (slider.value >= 0) ? (slider.value = slider.value - slider.stepSize) : (slider.value = slider.value + slider.stepSize)
                onClicked: (slider.value >= 0) ? slider.value-- : slider.value++
            }
        }

        Item {
            id: sliderPositioner
            anchors.left: parent.left
            anchors.leftMargin: generalSideMargin
            anchors.right: parent.right
            anchors.rightMargin: generalSideMargin
            anchors.bottom: minusButton.top
            anchors.top: buttonsCol.bottom
            visible: (sliderView) ? !waitingMode : false

            QQC1.Slider {
                id: slider
                width: parent.width
                anchors.centerIn: parent
                stepSize: 1

                style: SliderStyle {
                    groove: Rectangle {
                        color: (slider.value >= 0) ? "white" : controlsColor
                        implicitHeight: height_b * 0.02
                        radius: implicitHeight * 0.5
                        width: parent.width
                        Rectangle {
                            color: (slider.value >= 0) ? controlsColor : "white"
                            radius: parent.radius
                            implicitHeight: parent.height
                            implicitWidth: styleData.handlePosition
                        }
                    }
                    handle: Rectangle {
                        id: handleId
                        anchors.centerIn: parent
                        color: control.pressed ? activeControlsColor : controlsColor
                        implicitWidth: height_b * 0.1
                        implicitHeight: implicitWidth
                        radius: implicitWidth * 0.7
                    }
                }

                onValueChanged: sliderValueChanged(value)
            }
            Rectangle {border.color: "khaki"; color: "transparent"; anchors.fill: parent; visible: gridView}
        }

        Text{
            id: stepsText
            height: tittle.height
            width: tittle.width * 0.5
            anchors.left: valueLabel.left
            anchors.top: valueLabel.top
            anchors.margins: generalSideMargin
            color: stepsColor//"#BBBBBB"
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignLeft
            font.family: "Helvetica"
            font.pointSize: (height * 0.7) ? (height * 0.7) : 1
            text: stepDescription + " " + (currentStep + 1) + " / " + calibrationSteps
            Rectangle {border.color: "tomato"; color: "transparent"; anchors.fill: parent; visible: gridView}
        }

        TextArea{
            id: decriptionText
            height: plusButton.height
            anchors.left: minusButton.right
            anchors.right: plusButton.left
            anchors.margins: generalSideMargin
            anchors.top: plusButton.top
            anchors.topMargin: 0
            enabled: false
            color: descriptionColor//"#DDDDDD"  // @disable-check M16
            wrapMode: TextEdit.Wrap
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            font.family: "Helvetica"
            font.pointSize: height * 0.21 // 0.21 three text lines (0.23 for two text lines)
            text: ""
            Rectangle {border.color: "tomato"; color: "transparent"; anchors.fill: parent; visible: gridView}
        }

        Image {
            id: waitingIdicator
            height: parent.height / 2
            width: height
            anchors.centerIn: parent
            source: "Images/molecula O2 h_2.png"
            visible: waitingMode
            RotationAnimator on rotation {
                id: rotationEffect
                from: 0
                to: 360
                duration: 1000
                running: parent.visible
                onFinished: rotationDelay.restart()
            }
            Timer{
                id: rotationDelay
                interval: 3000
                running: false
                onTriggered: rotationEffect.restart()
            }
            Rectangle {border.color: "lightGreen"; color: "transparent"; anchors.fill: parent; visible: gridView}
        }
    }

    Rectangle {border.color: "plum"; color: "transparent"; anchors.fill: parent; visible: gridView}
}
