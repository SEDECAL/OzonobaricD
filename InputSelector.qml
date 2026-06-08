// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright (C) 2024 Sedecal S.A.
// This file is part of OzonobaricD.
// See LICENSE file for details.

import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.15
import QtQuick.Controls 1.4  as QQC1
import QtQuick.Controls.Styles 1.4
import QtGraphicalEffects 1.12
import QtQuick.LocalStorage 2.0
import "Database.js" as DB
import AppStyle 1.0
import AppConstants 1.0

Item {
    id: inputSelectorItem

    property bool   gridView: false
    property double factor: 1
    property double expandedWidth: inputSelectorItem.width * 0.98 * factor //740
    property double expandedHeight: inputSelectorItem.height * 0.6579 * factor
    property double expandedX: (inputSelectorItem.width - expandedWidth) * 0.5 * factor //10
    property double expandedY: inputSelectorItem.width * 0.29 * factor //230

    property string  shiftProtocol: "" // protocol to be loaded by means of visual shift effect
    property int     shiftProtocolDuration: 200
    property int     shiftDirection: shiftType["left"]
    property variant shiftType: { 'left': -1, 'right': 1 }

    property int maxAvailableFlow: 50
//    property int maxFlowBack: 0
    property int maxFlow: 0
    property int maxTime: 0


    Screen.orientationUpdateMask: Qt.PortraitOrientation | Qt.LandscapeOrientation | Qt.InvertedPortraitOrientation | Qt.InvertedLandscapeOrientation //15
    property bool isIsPortrait: (Screen.orientation === Qt.PortraitOrientation  || Screen.orientation === Qt.InvertedPortraitOrientation)
    property bool isIsLandScape: (Screen.orientation === Qt.LandscapeOrientation || Screen.orientation === Qt.InvertedLandscapeOrientation)

    function reduceAndRestoreItems(){
        for(var i=0; i<inputRepeater.count; i++)
        {
            if(inputRepeater.itemAt(i).state === "big")
            {
                inputRepeater.itemAt(i).restoreBackState()
                inputRepeater.itemAt(i).state = "small"
            }
        }
    }

    function reduceItems(){
        for(var i=0; i<inputRepeater.count; i++)
        {
            inputRepeater.itemAt(i).state = "small"
        }
    }

    function enableItems(index){
        for(var i=0; i<inputRepeater.count; i++)
        {
            inputRepeater.itemAt(i).enabled = true
        }
    }

    function disableNoSelectecItems(index){
        for(var i=0; i<inputRepeater.count; i++)
        {
            if(i !== index) inputRepeater.itemAt(i).enabled = false
        }
    }

    function disableReducedItems(){
        for(var i=0; i<inputRepeater.count; i++)
        {
            if(inputRepeater.itemAt(i).state === "small"){
                inputRepeater.itemAt(i).enabled = false
            }
        }
    }

    function load(protocol){
        inputModel.clear()

        if(arguments.length) {
            var db = DB.dbConfig_Get(protocol)

            for (var i = 0; i < db.length; i++) {
                inputModel.append({ protocol_name_:  db.item(i).protocol_name,
                                    parameter_name_: db.item(i).param_name,
                                    units:           db.item(i).param_units,
                                    maxVal:          db.item(i).param_max_value_0,
                                    minVal:          db.item(i).param_min_value_0,
                                    value:           db.item(i).param_def_value,
                                    unitsColor:      db.item(i).param_units_color,
                                    valueColor:      db.item(i).param_color,
                                    icon_:           db.item(i).param_icon,
                                    memoryButons:    db.item(i).param_fix_values,
                                    stepSize_0_:     db.item(i).param_step_value_0,
                                    stepSize_1_:     db.item(i).param_step_value_1,
                                    stepSize_2_:     db.item(i).param_step_value_2,
                                    sliderMax_0_:    setMaxValue(db.item(i).param_name, db.item(i).param_max_value_0),
                                    sliderMax_1_:    db.item(i).param_max_value_1,
                                    sliderMax_2_:    db.item(i).param_max_value_2,
                                    sliderMin_0_:    setMinValue(db.item(i).param_name, db.item(i).param_min_value_0),
                                    sliderMin_1_:    db.item(i).param_min_value_1,
                                    sliderMin_2_:    db.item(i).param_min_value_2 })
            }
        }
    }

    function setMaxValue(param_name, max_val){
        if(param_name === Const.param.edition.time){
            maxTime = max_val
        }
        if(param_name === Const.param.edition.flow){
            maxFlow = max_val

            if(maxAvailableFlow < max_val){
                maxFlow = maxAvailableFlow
                return maxAvailableFlow.toString()
            }
        }
        return max_val
    }

    function setMinValue(param_name, min_val){
        if(param_name === Const.param.edition.flow){
            if(maxAvailableFlow < min_val)
                return 1
        }
        return min_val
    }

    function shiftLoad(protocol, direction){
        shiftProtocol = protocol
        shiftDirection = shiftType[direction]  // paid attention: frist shiftDirection update, then inputRowItem.state
        inputRowItem.state = ( (direction === "left") || (direction === "right") ) ? "shift" : "repose"
    }

    function values(){
        var ret = ""

        for(var i=0; i<inputRepeater.count; i++)
            ret += inputRepeater.itemAt(i).slider.value + ","

        return ret.substring(0, ret.length - 1)
    }

    function maxValues(){
        var ret = ""

        for(var i=0; i<inputRepeater.count; i++)
            ret += inputRepeater.itemAt(i).slider.maximumValue + ","

        return ret.substring(0, ret.length - 1)
    }

    function minValues(){
        var ret = ""

        for(var i=0; i<inputRepeater.count; i++)
            ret += inputRepeater.itemAt(i).slider.minimumValue + ","

        return ret.substring(0, ret.length - 1)
    }

    function isEditingO3(){
        for(var i=0; i<inputRepeater.count; i++){
            if(inputRepeater.itemAt(i).parameter_name === Const.param.edition.concentration){
                return (inputRepeater.itemAt(i).state === "big")
            }
        }
    }

    function flashSelector(selectorName){
        for(var i=0; i<inputRepeater.count; i++){
            if(inputRepeater.itemAt(i).parameter_name === selectorName){
                inputRepeater.itemAt(i).enabled = true
                flashFlowTimer.restart()
            }
        }
    }

    function reviewFlowLimits(value){
        for(var i=0; i<inputRepeater.count; i++){
            if(inputRepeater.itemAt(i).parameter_name === Const.param.edition.flow){
                // only if flow is edditable
                if(getMaxAllowedFlow(value) < maxFlow){
                    inputRepeater.itemAt(i).slider.maximumValue = getMaxAllowedFlow(value)
                }
                else{
                    inputRepeater.itemAt(i).slider.maximumValue = maxFlow
                }
            }
        }
    }

    function reviewTimeLimits(value){
        for(var i=0; i<inputRepeater.count; i++){
            if(inputRepeater.itemAt(i).parameter_name === Const.param.edition.time){
                // only if time is edditable
                if( (getMaxAllowedTime(value) >= 0) && (getMaxAllowedTime(value) < maxTime) ) {
                    inputRepeater.itemAt(i).slider.maximumValue = getMaxAllowedTime(value)
                }
                else{
                    inputRepeater.itemAt(i).slider.maximumValue = maxTime
                }
            }
        }
    }

    function getMaxAllowedFlow(O3)
    {
        /* Set max allowed flow according to next rule
       *
       *   (F)
       *    |      .
       * 50 +* * * *
       *    |      .  *
       *    |      .     *
       *    |      .        *
       *    |      .           *
       *    |      .              *
       * 30 +........................*..
       *    |      .                 .
       *    |______._________________.____ (C)
       *          60                80
       */
       return 110 - O3
    }

    function getMaxAllowedTime(O3)
    {
        /* Set max allowed time according to next rule
       *
       *   (T)
       *    |      .
       * 30 +* * * *
       *    |      .  *
       *    |      .     *
       *    |      .        *
       *    |      .           *
       *    |      .              *
       * 10 +........................*..
       *    |      .                 .
       *    |______._________________.____ (C)
       *          30                80
       */

        var tmp

        if(O3 > 30)
        {
            tmp  = (80 - O3) * 20
            tmp  = tmp / 50
            tmp += 10
            return Math.round(tmp)
        }
        return -1
    }

    signal editing()
    signal editionEnd()

    ListModel {
        id: inputModel
//        ListElement { units: "l/h",    maxVal: "100", minVal: "1", value: "80",  unitsColor: "forestgreen", valueColor: "limegreen",   icon_: "Images/baseline_nights_stay_white_48.png", memoryButons: "10, 20, 30, 40, 50", changeScale_: false }
//        ListElement { units: "l/h",    sliderMax_0: "100", sliderMin_0: "1", sliderMax_1: "200", sliderMin_1: "1", sliderMax_2: "300", sliderMin_2: "1", value: "80",  unitsColor: "forestgreen", valueColor: "limegreen",   icon_: "Images/baseline_nights_stay_white_48.png", memoryButons: "10, 20, 30, 40, 50"}
    }

    Component {
        id: inputDelegate
        Input {
            width: 140 * factor
            height: 172 * factor
            width_b: expandedWidth //inputSelectorItem.width * 0.98 * factor //740
            height_b: expandedHeight //500 * factor
            x_b: expandedX //(inputSelectorItem.width - width_b) * 0.5 * factor //10
            y_b: expandedY //inputSelectorItem.width * 0.29 * factor //230
            radius: 5
            color: Style.input.backColor//"#444444"
            protocol_name: protocol_name_
            parameter_name: parameter_name_
            icon.source: icon_
            unitsLabel.text: units
            slider.value: value
            defautSliderValue: value
            slider.maximumValue: sliderMax_0_
            slider.minimumValue: sliderMin_0_
            slider.stepSize: stepSize_0_
            unitsLabel.color: unitsColor
            valueLabel.color: valueColor
            xOrigin: inputRow.x
            yOrigin: inputRowItem.y
            elementSep: inputRow.spacing
            elementIndex: index
            stepSize_0:  stepSize_0_
            stepSize_1:  stepSize_1_
            stepSize_2:  stepSize_2_
            sliderMax_0: sliderMax_0_
            sliderMax_1: sliderMax_1_
            sliderMax_2: sliderMax_2_
            sliderMin_0: sliderMin_0_
            sliderMin_1: sliderMin_1_
            sliderMin_2: sliderMin_2_
            scaleId: 0

            layer.enabled: Style.input.shadowEnable
            layer.effect: DropShadow { radius: Style.input.shadowRadius }

            Component.onCompleted:{
                var memoryValuesArray = memoryButons.split(" ").join("").split(",") // split(" ").join("") to remove whitespaces, then split(",") to generate an array
                for(var i = 0; i < 5; i++) {
                        memoryButtonModel.append({ "value": (memoryValuesArray[i]) ? (memoryValuesArray[i]) : "" })
                }
            }

            onInputSelected: {
                disableNoSelectecItems(selection)
                editing()
                console.log("input selected: ", selection)
            }
            onInputDeselected: {
                enableItems()
                editionEnd()
                console.log("input deselected: ", selection, save_pending, protocol_name, parameter_name, defValue, fixButtons)

                if(save_pending){
                    DB.dbConfig_Update("param_def_value", defValue, protocol_name, parameter_name)
                    DB.dbConfig_Update("param_fix_values", fixButtons, protocol_name, parameter_name)
                }
                if(parameter_name === Const.param.edition.concentration){
                  reviewFlowLimits(slider.value)
                }
            }
            onSliderValueChanged: {
                console.log("slider changed, (element index: ", index, ") ,(parameter name: ", parameter_name, "), (value: ", value, ")")

                if(parameter_name === Const.param.edition.concentration){
                    reviewFlowLimits(value)
                    reviewTimeLimits(value)
                }
                if(parameter_name === Const.param.edition.flow) {
                    if(isEditingO3()){
                        flashSelector(Const.param.edition.flow)
                    }
                }
                if(parameter_name === Const.param.edition.time) {
                    if(isEditingO3()){
                        flashSelector(Const.param.edition.time)
                    }
                }
            }
        }
    }

    Item {
        id: inputRowItem
        z: 2
        width: parent.width
        height: inputRow.height * factor

        RowLayout {
            id: inputRow
            anchors.centerIn: parent  // @disable-check M16 @disable-check M31
            spacing: 10// parent.height * 0.055
            Repeater {
                id: inputRepeater
                model: inputModel
                delegate: inputDelegate
            }
        }

        states: [
            State { name: "shift" },
            State { name: "repose" }
        ]

        transitions: [
            Transition {
                to: "shift"
                SequentialAnimation {
                    SmoothedAnimation { target: inputRowItem; property: "x"; to: inputRowItem.width * shiftDirection; duration: shiftProtocolDuration } //; easing.type: Easing.InCubic }
                    ScriptAction { script: inputRowItem.x =  -inputRowItem.width * shiftDirection}
                    ScriptAction { script: load(shiftProtocol) }
                    SmoothedAnimation { target: inputRowItem; property: "x"; to: 0; duration: shiftProtocolDuration } //; easing.type: Easing.OutCubic }
                    ScriptAction { script: inputRowItem.state = "repose"}
                }
            }
        ]
        Rectangle {border.color: "lightblue"; color: "transparent"; anchors.fill: parent; visible: gridView }
    }

    Rectangle {
        id: leftCover
        z: inputRowItem.z + 1
        width: parent.width * 0.5
        height: inputRowItem.height * 1.2
        anchors.top: inputSelectorItem.top
        anchors.right: inputSelectorItem.left
        border.color: gridView ? "olive" : "transparent"
 //     color: Style.main.backColor
        gradient: Gradient {
             orientation: Gradient.Horizontal
             GradientStop { position: 0;    color: Style.main.backColor }
             GradientStop { position: 0.87; color: Style.main.backColor }
             GradientStop { position: 1;    color: "transparent" }
        }
    }

    Rectangle {
        id: rightCover
        z: inputRowItem.z + 1
        width: parent.width * 0.5
        height: inputRowItem.height * 1.2
        anchors.top: inputSelectorItem.top
        anchors.left: inputSelectorItem.right
        border.color: gridView ? "olive" : "transparent"
//      color: Style.main.backColor
        gradient: Gradient {
             orientation: Gradient.Horizontal
             GradientStop { position: 0;    color: "transparent" }
             GradientStop { position: 0.13; color: Style.main.backColor }
             GradientStop { position: 1;    color: Style.main.backColor }
        }
    }

    MouseArea {
        id: minimizedRowCover
        x: inputRowItem.x
        y: inputRowItem.y
        height: inputRowItem.height
        width: inputRowItem.width
        z: inputRowItem.z + 1
        enabled: false
        Rectangle {opacity: 0.2; color: "green"; anchors.fill: parent; visible: (gridView && parent.enabled)}
    }

    Timer{
        id: flashFlowTimer
        interval: 600
        running: false
        onRunningChanged: minimizedRowCover.enabled = running
        onTriggered: if(isEditingO3()) disableReducedItems()
    }


}
