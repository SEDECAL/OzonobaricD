// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright (C) 2024 Sedecal S.A.
// This file is part of OzonobaricD.
// See LICENSE file for details.

import QtQuick 2.15
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtGraphicalEffects 1.0
import QtQuick.Controls 1.4  as QQC1
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.3
import AppStyle 1.0
import AppImages 1.0

Rectangle{
    id: inputItem

    property bool gridView: false

    property alias icon: icon
    property alias unitsLabel: unitsLabel
    property alias valueLabel: valueLabel
    property alias slider: slider
    property alias memoryButtonModel: memoryButtonModel

    // change scale magement variables
    property int scaleId: 0
    property int stepSize_0: 0
    property int stepSize_1: 0
    property int stepSize_2: 0
    property int sliderMax_0: 0
    property int sliderMax_1: 0
    property int sliderMax_2: 0
    property int sliderMin_0: 0
    property int sliderMin_1: 0
    property int sliderMin_2: 0

    // back state and memory management variables
    property string  protocol_name: ""
    property string  parameter_name: ""
    property bool    saveStatePending: false
    property int     defautSliderValue: 0
    property variant backState: { 'backDefaultSlider': 9,
                                  'backMemory': { 'button_0': 10,
                                  'button_1': 11,
                                  'button_2': 12,
                                  'button_3': 13,
                                  'button_4': 14 }}

    // appearance management variables -> naming convention: _s (as small) _b (as big)
    property double xOrigin: -1
    property double yOrigin: -1
    property double elementSep: -1
    property int    elementIndex: -1
    property int    animationTime: 0

    property int    x_s: -1
    property int    y_s: -1
    property int    x_b: -1
    property int    y_b: -1
    property double width_s:  -1
    property double width_b:  -1
    property double height_s: -1
    property double height_b: -1
    property int    relativeX_b: -1
    property int    relativeY_b: -1

    property double generalSideMargin: height * 0.05

    property double unitsLabelFontSize_s: height_s * 0.14
    property double unitsLabelFontSize_b: height_b * 0.07

    //  property double unitsLabelRightMargin_s: height_s * 0.05 - unitsLabel.width // (keep eye!) break binding on component completed
    property double unitsLabelRightMargin_s: height_s * 0.00 - unitsLabel.width // (keep eye!) break binding on component completed
    property double unitsLabelRightMargin_b: height_b * 0.27

    property double valueLabelSideMargin_s: height_s * 0.06
    property double valueLabelRightMargin_b: height_b * 0.27
    property double valueLabelLeftMargin_b: height_b * 0.45

    property double valueLabelBottomMargin_s: valueLabelSideMargin_s * 0.25
    property double valueLabelBottomMargin_b: height_b * 0.4

    property double buttonSize: height * 0.17
    property double buttonRadius: height * 0.01
    property double buttonOpacity: 0
    property color  buttonColor: Style.input.buttonColor
    property double onPressButtonOpacity: 0.4
    property bool   buttonSahdow: false

    signal inputSelected(int selection)
    signal inputDeselected(int selection, bool save_pending, string protocol_name, string parameter_name, int defValue, string fixButtons)
    signal sliderValueChanged(int value)

    states: [
        State { name: "small" },
        State { name: "big"   }
    ]

    transitions: [
        Transition {
            to: "big";
            SequentialAnimation{
                ParallelAnimation {
                    SmoothedAnimation { target: inputItem; property: "width";  to: width_b;     duration: animationTime }
                    SmoothedAnimation { target: inputItem; property: "height"; to: height_b;    duration: animationTime }
                    SmoothedAnimation { target: inputItem; property: "x";      to: relativeX_b; duration: animationTime }
                    SmoothedAnimation { target: inputItem; property: "y";      to: relativeY_b; duration: animationTime }

                    SmoothedAnimation { target: valueLabel; property: "anchors.leftMargin";   to: valueLabelLeftMargin_b;   duration: animationTime }
                    SmoothedAnimation { target: valueLabel; property: "anchors.rightMargin";  to: valueLabelRightMargin_b;  duration: animationTime }
                    SmoothedAnimation { target: valueLabel; property: "anchors.bottomMargin"; to: valueLabelBottomMargin_b; duration: animationTime }

                    SmoothedAnimation { target: unitsLabel; property: "rotation";            to: 0;                       duration: animationTime }
                    SmoothedAnimation { target: unitsLabel; property: "anchors.rightMargin"; to: unitsLabelRightMargin_b; duration: animationTime }
                    SmoothedAnimation { target: unitsLabel; property: "font.pointSize";      to: unitsLabelFontSize_b;    duration: animationTime }

                    PropertyAnimation { target: buttonsCol; property: "opacity"; to: 1; duration: animationTime; easing.type: Easing.InQuad}
                }
                ScriptAction { script: buttonSahdow = Style.input.buttonShadowEnable }
            }
        },
        Transition {
            to: "small";
            SequentialAnimation{
                ScriptAction { script: buttonSahdow = false }
                ParallelAnimation {
                    SmoothedAnimation { target: inputItem; property: "width";  to: width_s;  duration: animationTime }
                    SmoothedAnimation { target: inputItem; property: "height"; to: height_s; duration: animationTime }
                    SmoothedAnimation { target: inputItem; property: "x";      to: x_s;      duration: animationTime }
                    SmoothedAnimation { target: inputItem; property: "y";      to: y_s;      duration: animationTime }

                    SmoothedAnimation { target: valueLabel; property: "anchors.leftMargin";   to: valueLabelSideMargin_s;   duration: animationTime }
                    SmoothedAnimation { target: valueLabel; property: "anchors.rightMargin";  to: valueLabelSideMargin_s;   duration: animationTime }
                    SmoothedAnimation { target: valueLabel; property: "anchors.bottomMargin"; to: valueLabelBottomMargin_s; duration: animationTime }

                    SmoothedAnimation { target: unitsLabel; property: "rotation";            to: 90;                      duration: animationTime }
                    SmoothedAnimation { target: unitsLabel; property: "anchors.rightMargin"; to: unitsLabelRightMargin_s; duration: animationTime }
                    SmoothedAnimation { target: unitsLabel; property: "font.pointSize";      to: unitsLabelFontSize_s;    duration: animationTime }

                    PropertyAnimation { target: buttonsCol; property: "opacity"; to: 0; duration: animationTime; easing.type: Easing.OutQuad}
                }
            }
        }
    ]

    function expand(){
        z = 10 // allows expand view over other input elelments
        relativeX_b = x_b - xOrigin
        relativeY_b = y_b - yOrigin
        inputItem.state = "big"
        inputSelected(elementIndex)

        saveStatePending = false
        registerBackState()
    }

    function retract(){
        inputItem.state = "small"
//      debugBackState()
        inputDeselected( elementIndex,
                         saveStatePending,
                         protocol_name,
                         parameter_name,
                         defautSliderValue,
                         memoryButtonsToString() )
    }

    function scaleButtonView(){
        var tmp = 0

        tmp += sliderMax_1
        tmp += sliderMax_2
        tmp += sliderMin_1
        tmp += sliderMin_2

        return !!tmp // the same as Boolean(tmp)
    }

    function changeScale(scale, value){

        switch(scale){
        case 0:
            slider.stepSize = stepSize_0
            slider.maximumValue = sliderMax_0
            slider.minimumValue = sliderMin_0
            break
        case 1:
            slider.stepSize = stepSize_1
            slider.maximumValue = sliderMax_1
            slider.minimumValue = sliderMin_1
            break
        case 2:
            slider.stepSize = stepSize_2
            slider.maximumValue = sliderMax_2
            slider.minimumValue = sliderMin_2
            break
        }

        if(arguments.length === 2){
            slider.value = value
        }else{
            slider.value = slider.minimumValue + ( (slider.maximumValue - slider.minimumValue) * 0.5 )
        }
    }

    function adjustScale(value){
        var scale = 0

        if(value > sliderMax_0){
            scale++
        }
        if(value > sliderMax_1){
            scale++
        }
        scaleId = scale
        changeScale(scale, value)
    }

    function registerBackState(){
        var i = 0
        console.log("registering back state...")

        backState['backDefaultSlider'] = slider.value

        for (var key in backState['backMemory']){
            backState['backMemory'][key] = memoryButtonsRepeater.itemAt(i++).text
        }
    }

    function restoreBackState(){
        var i = 0
        console.log("restoring back state...")

        slider.value = backState['backDefaultSlider']

        for (var key in backState['backMemory']){
            memoryButtonsRepeater.itemAt(i++).text = backState['backMemory'][key]
        }
        saveStatePending = false
    }

    function memoryButtonsToString(){
        var ret = ""

        for(var i = 0; i < memoryButtonsRepeater.count; i++){
            ret += memoryButtonsRepeater.itemAt(i).text
            ret += (i < memoryButtonsRepeater.count - 1) ? "," : ""
        }
        return ret
    }

    function debugBackState(){
        for (var i in backState){
            console.log("i:", i, backState[i])
        }
        for (var j in backState['backMemory']){
            console.log("j:", j, backState['backMemory'][j])
        }
    }

    width: 15
    height: 20
    radius: 5
    color: "#999999"
    opacity: enabled ? 1 : 0.5

    Component.onCompleted: {
        width_s = width
        height_s = height
        x_s = (width_s + elementSep) * elementIndex
        y_s = 0
        state = "small"
        unitsLabelRightMargin_s = unitsLabelRightMargin_s // break property binding
        animationTime = 500 // keep this line at the end of the block (avoid transition during component creation)

    }

    onWidthChanged: if(width === width_s) z = 1

    MouseArea{
        anchors.fill: parent
        onClicked: if(parent.state === "small") expand()
    }

    Image {
        id: icon
        width: parent.height * 0.4
        height: parent.height * 0.4
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.topMargin: generalSideMargin
        anchors.leftMargin: generalSideMargin
        source: ""

        Rectangle {border.color: "plum"; color: "transparent"; anchors.fill: parent; visible: gridView}
    }

    Text {
        id: unitsLabel
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.topMargin: parent.height * 0.05 //+ width_s * 0.5 - height_s * 0.5
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignLeft
        transformOrigin: Item.TopLeft
        rotation: 90
        text: "units"
        font.family: "Helvetica"
        font.pointSize: unitsLabelFontSize_s
        color: "deepskyblue"
        Rectangle {border.color: "silver"; color: "transparent"; anchors.fill: parent; visible: gridView}
    }

    Text {
        id: valueLabel
        height: parent.height * 0.4
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.leftMargin: valueLabelSideMargin_s
        anchors.rightMargin: valueLabelSideMargin_s
        anchors.bottomMargin: valueLabelBottomMargin_s
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        text: slider.value.toString()
        font.family: "Helvetica"
        font.pointSize: parent.height * 0.30
        color: "lightskyblue"
        fontSizeMode: Text.Fit

        Rectangle {border.color: "khaki"; color: "transparent"; anchors.fill: parent; visible: gridView}
    }

    Column {
        id: buttonsCol
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.topMargin: generalSideMargin
        anchors.rightMargin: generalSideMargin
        spacing: generalSideMargin * 0.5
        enabled: (parent.state === "small") ? false : true
        opacity: 0

        Rectangle {
            id: okButton
            height: buttonSize
            width: buttonSize
            color: buttonColor
            radius: buttonRadius
            layer.enabled: buttonSahdow
            layer.effect: DropShadow { radius: Style.input.buttonShadowRadius; color: Style.input.buttonShadowColor }

            Image{
                anchors.fill: parent
                source: "Images/ic_done_white_48dp.png"
                opacity: okButtonButton.pressed ? onPressButtonOpacity : 1
            }
            MouseArea {
                id: okButtonButton
                anchors.fill: parent
                onClicked: retract()
            }
        }
        Rectangle {
            id: backButton
            height: buttonSize
            width: buttonSize
            color: buttonColor
            radius: buttonRadius
            layer.enabled: buttonSahdow
            layer.effect: DropShadow { radius: Style.input.buttonShadowRadius; color: Style.input.buttonShadowColor }

            Image{
                anchors.fill: parent
                source: "Images/ic_back_white_48dp_02.png"
                opacity: backButtonButton.pressed ? onPressButtonOpacity : 1
            }
            MouseArea {
                id: backButtonButton
                anchors.fill: parent
                onClicked: {
//                  debugBackState()
                    restoreBackState()
                    retract()
                }
            }
        }
        Rectangle {
            id: saveButton
            height: buttonSize
            width: buttonSize
            color: buttonColor
            radius: buttonRadius
            layer.enabled: buttonSahdow
            layer.effect: DropShadow { radius: Style.input.buttonShadowRadius; color: Style.input.buttonShadowColor }

            Image{
                anchors.fill: parent
                source: "Images/ic_save_white_48dp.png"
                opacity: saveButtonButton.pressed ? onPressButtonOpacity : 1
            }

            MouseArea {
                id: saveButtonButton
                anchors.fill: parent
                onClicked: {
                    saveStatePending = true
                    defautSliderValue = slider.value
                    valueLabelCopy.state = "moveToSave"
                }
            }
        }
    }

    Rectangle {
        id: plusButton
        z: 3 // paid atention to swipe area z value
        height: buttonSize
        width: buttonSize
        color: buttonColor
        radius: buttonRadius
        enabled: (parent.state === "small") ? false : true
        opacity: buttonsCol.opacity
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.bottomMargin: generalSideMargin
        anchors.rightMargin: generalSideMargin
        layer.enabled: buttonSahdow
        layer.effect: DropShadow { radius: Style.input.buttonShadowRadius; color: Style.input.buttonShadowColor }

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
    }

    Rectangle {
        id: minusButton
        z: 3 // paid atention to swipe area z value
        height: buttonSize
        width: buttonSize
        color: buttonColor
        radius: buttonRadius
        enabled: (parent.state === "small") ? false : true
        opacity: buttonsCol.opacity
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.bottomMargin: generalSideMargin
        anchors.leftMargin: generalSideMargin
        layer.enabled: buttonSahdow
        layer.effect: DropShadow { radius: Style.input.buttonShadowRadius; color: Style.input.buttonShadowColor }

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
    }

    Rectangle {
        id: scaleButton
        height: buttonSize
        width: buttonSize
        color: buttonColor
        radius: buttonRadius
        enabled: (parent.state === "small") ? false : true
        opacity: buttonsCol.opacity
        anchors.bottom: sliderPositioner.top
        anchors.left: parent.left
        anchors.leftMargin: generalSideMargin
        visible: scaleButtonView()
        layer.enabled: buttonSahdow
        layer.effect: DropShadow { radius: Style.input.buttonShadowRadius; color: Style.input.buttonShadowColor }

        Image{
            anchors.fill: parent;
            source: "Images/sliderRange_02.png"
            opacity: scaleButtonButton.pressed ? onPressButtonOpacity : 1
        }

        MouseArea {
            id: scaleButtonButton
            anchors.fill: parent
            onClicked: changeScale( scaleId = (++scaleId) > 2 ? 0 : scaleId )
        }
        Text {
            height: parent.height * 0.3
            text: scaleId
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment:  Text.AlignRight
            font.family: "Helvetica"
            font.pixelSize: height * 0.8
            color: "white"
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            anchors.rightMargin: parent.height * 0.06
            anchors.bottomMargin: parent.height * 0.02
            Rectangle {border.color: "red"; color: "transparent"; anchors.fill: parent; visible: false}
        }
    }

    ListModel {
        id: memoryButtonModel
        //        ListElement { value: "250" }
    }

    Component {
        id: memoryButtonDelegate
        Rectangle {
            height: buttonSize * 0.6
            width: buttonSize
            color: buttonColor
            radius: buttonRadius * 0.8
            layer.enabled: buttonSahdow
            layer.effect: DropShadow { radius: Style.input.buttonShadowRadius; color: Style.input.buttonShadowColor }

            property alias text: buttonText.text
            Text {
                id: buttonText
                height: parent.height
                width: parent.width *0.9
                anchors.centerIn: parent
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                text: value
                font.family: "Helvetica"
                font.pointSize: parent.height
                color: "white"
                fontSizeMode: Text.Fit

                opacity: memoryButtonDelegateMouseArea.pressed ? onPressButtonOpacity : 1
                Rectangle {border.color: "khaki"; color: "transparent"; anchors.fill: parent; visible: gridView}
            }
            MouseArea {
                id: memoryButtonDelegateMouseArea
                width: parent.width
                height: buttonSize
                anchors.bottom: parent.bottom

                onClicked:{
                    slider.value = buttonText.text
                    if(scaleButton.visible){
                        adjustScale(memoryButtonModel.get(index).value)
                    }
                }
                onPressAndHold: {
                    saveStatePending = true
                    memoryButtonCopy.place(index)
                    valueLabelCopy.state = "moveToMemoryButton"
                }
                Rectangle {border.color: "tomato"; color: "transparent"; anchors.fill: parent; visible: gridView}
            }
        }
    }

    Row {
        id: memoryButtonsRow
        anchors.bottom: parent.bottom
        anchors.left: minusButton.right
        anchors.right: plusButton.left
        anchors.bottomMargin: generalSideMargin
        anchors.rightMargin: generalSideMargin
        anchors.leftMargin: generalSideMargin
//      spacing: generalSideMargin * 0.5
        spacing: (width - (buttonSize * memoryButtonsRepeater.count)) / (memoryButtonsRepeater.count - 1)
        enabled: (parent.state === "small") ? false : true
        opacity: buttonsCol.opacity
        Repeater{
            id: memoryButtonsRepeater
            model: memoryButtonModel
            delegate: memoryButtonDelegate
        }
    }

    Item {
        id: sliderPositioner
        z: 3 // paid atention to swipe area z value
        anchors.left: parent.left
        anchors.leftMargin: generalSideMargin
        anchors.right: parent.right
        anchors.rightMargin: generalSideMargin
        anchors.bottom: minusButton.top
        anchors.top: buttonsCol.bottom
        enabled: (parent.state === "small") ? false : true
        opacity: buttonsCol.opacity
        rotation: (value >= 0) ? 0 : 180

        QQC1.Slider {
            id: slider
            width: parent.width
            anchors.centerIn: parent
            stepSize: 1

            style: SliderStyle {
                groove: Rectangle {
                    color: (value >= 0) ? "white" : unitsLabel.color
                    implicitHeight: height_b * 0.02
                    radius: implicitHeight * 0.5
                    width: parent.width
                    Rectangle {
                        color: (value >= 0) ? unitsLabel.color : "white"
                        radius: parent.radius
                        implicitHeight: parent.height
                        implicitWidth: styleData.handlePosition
                    }
                }
                handle: Rectangle {
                    id: handleId
                    anchors.centerIn: parent
                    color: control.pressed ? valueLabel.color : unitsLabel.color
                    implicitWidth: height_b * 0.1
                    implicitHeight: implicitWidth
                    radius: implicitWidth * 0.7
                }
            }

            onValueChanged: sliderValueChanged(value)
        }
        Rectangle {border.color: "khaki"; color: "transparent"; anchors.fill: parent; visible: gridView}
    }

    Text {
        id: valueLabelCopy

        property int animationTime: 500

        height: valueLabel.height
        width: valueLabel.width
        anchors.horizontalCenter: valueLabel.horizontalCenter;
        anchors.verticalCenter: valueLabel.verticalCenter
        verticalAlignment: valueLabel.verticalAlignment
        horizontalAlignment: valueLabel.horizontalAlignment
        text: valueLabel.text
        font.family: valueLabel.font.family
        font.pointSize: valueLabel.font.pointSize
        color: valueLabel.color
        fontSizeMode: valueLabel.fontSizeMode
        opacity: 0
        state: "moveToOrigin"

        states: [
            State {
                name: "moveToOrigin"
                AnchorChanges { target: valueLabelCopy; anchors.horizontalCenter: valueLabel.horizontalCenter; anchors.verticalCenter: valueLabel.verticalCenter }
                PropertyChanges { target: valueLabelCopy; width: valueLabel.width; height: valueLabel.height}
            },
            State {
                name: "moveToSave"
                AnchorChanges { target: valueLabelCopy; anchors.horizontalCenter: saveButtonCopy.horizontalCenter; anchors.verticalCenter: saveButtonCopy.verticalCenter }
                PropertyChanges { target: valueLabelCopy; width: 0; height: 0}
            },
            State {
                name: "moveToMemoryButton"
                AnchorChanges { target: valueLabelCopy; anchors.horizontalCenter: memoryButtonCopy.horizontalCenter; anchors.verticalCenter: memoryButtonCopy.verticalCenter }
                PropertyChanges { target: valueLabelCopy; width: 0; height: 0}
            }
        ]

        transitions: [
            Transition { to: "moveToSave";         animations: valueLabelCopyDisplacementAnimation },
            Transition { to: "moveToMemoryButton"; animations: valueLabelCopyDisplacementAnimation }
        ]

        SequentialAnimation {
            id: valueLabelCopyDisplacementAnimation
            PropertyAnimation { target: valueLabelCopy; property: "opacity"; to: 1; duration: 0 }
            ParallelAnimation {
                AnchorAnimation { duration: animationTime }
                NumberAnimation { duration: animationTime }
            }
            PropertyAnimation { target: valueLabelCopy; property: "opacity"; to: 0; duration: (valueLabelCopy.state === "moveToSave") ? animationTime : animationTime * 0.25 }
            //          ScriptAction { script: if(valueLabelCopy.state === "moveToMemoryButton") memoryButtonModel.setProperty(memoryButtonCopy.replicationIndex, "value", valueLabel.text)}
            ScriptAction { script: if(valueLabelCopy.state === "moveToMemoryButton") memoryButtonsRepeater.itemAt(memoryButtonCopy.replicationIndex).text = valueLabel.text }
            PropertyAnimation { target: valueLabelCopy; property: "state"; to: "moveToOrigin"; duration: 0 }
        }

        Rectangle {border.color: "tomato"; color: "transparent"; anchors.fill: parent; visible: gridView}
    }

    Item {
        id: saveButtonCopy
        x: buttonsCol.x
        y: buttonsCol.y + saveButton.y
        height: saveButton.height
        width: saveButton.width
        Rectangle {border.color: "orange"; color: "transparent"; anchors.fill: parent; visible: gridView}
    }

    Item {
        id: memoryButtonCopy

        property int replicationIndex: -1

        function place(index){
            console.log("Placing memoryButtonCopy...")
            memoryButtonCopy.replicationIndex = index
            memoryButtonCopy.height = memoryButtonsRepeater.itemAt(index).height
            memoryButtonCopy.width = memoryButtonsRepeater.itemAt(index).width
            memoryButtonCopy.x = memoryButtonsRepeater.itemAt(index).x + memoryButtonsRow.x
            memoryButtonCopy.y = memoryButtonsRepeater.itemAt(index).y + memoryButtonsRow.y
        }

        Rectangle {border.color: "pink"; color: "transparent"; anchors.fill: parent; visible: gridView}
    }

    SwipeArea{
        z: 2
        anchors.fill: parent
        enabled: (parent.state === "big") ? true : false
        onSwipeUp: retract()
    }
}
