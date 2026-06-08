// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright (C) 2024 Sedecal S.A.
// This file is part of OzonobaricD.
// See LICENSE file for details.

import QtQuick 2.15
import QtQuick.Controls 2.5
import AppStyle 1.0
import QtGraphicalEffects 1.0
import "Database.js" as DB

Item {
    id: deviceCalibration
    property bool gridView: false

    property alias saveParamInfo: saveParamInfo
    property alias periodCalibrationInfo: periodCalibrationInfo
    property alias resetTimeInfo: resetTimeInfo
    property alias linkGeneratorInfo: linkGeneratorInfo
    property alias generationMode: generationMode

    property bool enableMasck: false // used over enable/disable cards algorithm to allow only allowed cards when no serial connection available
    property bool blocked: false
    property bool locked: false
    property int  verticalSpacing: 20
    property int  horizontalSpacing: 7
    property int  widthWhenExpanded: 0
    property double cardOpacityLevel: 0.5

//    property var gostCalibratrionSettings: {
//        "calibType": "gost",
//        "steps": 1,
//        "stepDesc": "gost",
//        "tittle": "gost",
//        "step_1":{
//            "maxSlider": 10,
//            "minSlider": 0,
//            "defValue": 5,
//            "description": "gost",
//        }
//    }
    property var pressureCalibratrionSettings: {
        "calibType": "pressure",
        "steps": 2,
        "stepDesc": "Step",                                       // this value will be overwritten by the translation system
        "tittle": "Pressure calibration",                         // this value will be overwritten by the translation system
        "step_1":{
            "maxSlider": 1100,
            "minSlider": 800,
            "defValue": 1080,
            "waitingMode": false,
            "description": "this is pressure description step 1", // this value will be overwritten by the translation system
            "sliderView": true,
        },
        "step_2":{
            "maxSlider": 1100,
            "minSlider": 500,
            "defValue": 500,
            "waitingMode": false,
            "description": "this is pressure description step 2", // this value will be overwritten by the translation system
            "sliderView": false,
        }
    }
    property var flowCalibratrionSettings: {
        "calibType": "flow",
        "steps": 2,
        "stepDesc": "Step",
        "tittle": "Flow calibration",                             // this value will be overwritten by the translation system
        "step_1":{
            "maxSlider": 2400,/*201,*/
            "minSlider": 200,/*21,*/
            "defValue": 725,
            "waitingMode": false,
            "description": "this is flow description step 1",     // this value will be overwritten by the translation system
            "sliderView": true,
        },
        "step_2":{
            "maxSlider": 1000,
            "minSlider": 10,
            "defValue": 500,
            "waitingMode": false,
            "description": "this is flow description step 2",     // this value will be overwritten by the translation system
            "sliderView": true,
        }
    }
    property var o3CalibratrionSettings: {
        "calibType": "O3",
        "steps": 4,
        "stepDesc": "Step",
        "tittle": "O3 calibration",                               // this value will be overwritten by the translation system
        "step_1":{
            "maxSlider": 0,
            "minSlider": 0,
            "defValue": 0,
            "waitingMode": true,
            "description": "this is O3 description step 1",       // this value will be overwritten by the translation system
            "sliderView": true,
        },
        "step_2":{
            "maxSlider": 1024,
            "minSlider": 0,
            "defValue": 330,
            "waitingMode": false,
            "description": "this is O3 description step 2",       // this value will be overwritten by the translation system
            "sliderView": true,
        },
        "step_3":{
            "maxSlider": 1024,
            "minSlider": 0,
            "defValue": 50,
            "waitingMode": true,////////////////////false,
            "description": "this is O3 description step 3",       // this value will be overwritten by the translation system
            "sliderView": true,
        },
        "step_4":{
            "maxSlider": 1024,
            "minSlider": 0,
            "defValue": 5,
            "waitingMode": false,
            "description": "this is O3 description step 4",       // this value will be overwritten by the translation system
            "sliderView": true,
        }
    }

/*
    property var o3CalibratrionSettings: {
        "calibType": "O3",
        "steps": 4,
        "stepDesc": "Step",
        "tittle": "O3 calibration",                               // this value will be overwritten by the translation system
        "step_1":{
            "maxSlider": 301,
            "minSlider": 31,
            "defValue": 91,
            "description": "this is O3 description step 1",       // this value will be overwritten by the translation system
        },
        "step_2":{
            "maxSlider": 302,
            "minSlider": 32,
            "defValue": 92,
            "description": "this is O3 description step 2",       // this value will be overwritten by the translation system
        },
        "step_3":{
            "maxSlider": 303,
            "minSlider": 33,
            "defValue": 93,
            "description": "this is O3 description step 3",       // this value will be overwritten by the translation system
        },
        "step_4":{
            "maxSlider": 304,
            "minSlider": 34,
            "defValue": 94,
            "description": "this is O3 description step 4",       // this value will be overwritten by the translation system
        }
    }

*/

    property variant leftCalibrationOpt: { 'linkGenerator': 0,
                                           'resetTime': 1,
                                           'saveParam': 2,
                                           'generationMode': 3 }

    property variant rightCalibrationInfoOpt: { 'periodCalibration': 0,
                                                '__': 1 }

    signal calibrationStart(string calibType)
    signal calibrationEnd()
    signal calibrationChanged(int calValue)
    signal calibrationNotChanged()
//    signal calibrationError()


    function closeAllCards(){
        console.log("closeAllCards()")
        for(var i = 0; i < rightRepeater.count; i++){
            rightRepeater.itemAt(i).closeCard()
        }
    }

    function appendCalibrationSettings(descriptor, step){
        rightModel.append( { mTittle:      descriptor.tittle,
                             mSteps:       descriptor.steps,
                             mStepDesc:    descriptor.stepDesc,
                             mMaxSlider:   descriptor["step_" + step.toString()].maxSlider,
                             mMinSlider:   descriptor["step_" + step.toString()].minSlider,
                             mDefValue:    descriptor["step_" + step.toString()].defValue,
                             mDescription: descriptor["step_" + step.toString()].description,
                             mWaitingMode: descriptor["step_" + step.toString()].waitingMode,
                             mSliderView:  descriptor["step_" + step.toString()].sliderView,
                             mCalibrationSettings : descriptor
                          } )
    }

    function refreshCalibrationSettings(index, descriptor, step){
        if(step <= descriptor.steps){
//          console.log("------------------------> refreshCalibrationSettings <------------------------------------")
//          console.log("mMaxSlider:", descriptor["step_" + step.toString()].maxSlider)
//          console.log("mMinSlider:", descriptor["step_" + step.toString()].minSlider)
//          console.log("mDefValue:", descriptor["step_" + step.toString()].defValue)
//          console.log("mDescription:", descriptor["step_" + step.toString()].description)
//          console.log("mWaitingMode:", descriptor["step_" + step.toString()].waitingMode)
//          console.log("mSliderView:", descriptor["step_" + step.toString()].sliderView)
            rightModel.setProperty(index, "mMaxSlider", descriptor["step_" + step.toString()].maxSlider)
            rightModel.setProperty(index, "mMinSlider", descriptor["step_" + step.toString()].minSlider)

            if( (descriptor.calibType === "pressure") && (step === 1) ){ // Azure Bug 10860: (SDV 2) Review whole calibration process
                rightModel.setProperty(index, "mDefValue", configArea.deviceCalibration.pressureCalibratrionSettings["step_1"].defValue) // Azure Bug 10431: (SDV) Pressure calibration menu improvement.
            }
            else{
                rightModel.setProperty(index, "mDefValue", descriptor["step_" + step.toString()].defValue)
            }

            rightModel.setProperty(index, "mDescription", descriptor["step_" + step.toString()].description)
            rightModel.setProperty(index, "mWaitingMode", descriptor["step_" + step.toString()].waitingMode)
            rightModel.setProperty(index, "mSliderView", descriptor["step_" + step.toString()].sliderView)
        }
    }

    function refreshAttachedElements(){

        generationMode.x =       leftRepeater.itemAt(leftCalibrationOpt.generationMode).dataAreaX
        generationMode.y =       leftRepeater.itemAt(leftCalibrationOpt.generationMode).dataAreaY + leftRepeater.itemAt(leftCalibrationOpt.generationMode).y
        generationMode.width =   leftRepeater.itemAt(leftCalibrationOpt.generationMode).dataAreaW
        generationMode.height =  leftRepeater.itemAt(leftCalibrationOpt.generationMode).dataAreaH
        generationMode.visible = leftRepeater.itemAt(leftCalibrationOpt.generationMode).extended

        resetTimeInfo.x =       leftRepeater.itemAt(leftCalibrationOpt.resetTime).dataAreaX
        resetTimeInfo.y =       leftRepeater.itemAt(leftCalibrationOpt.resetTime).dataAreaY + leftRepeater.itemAt(leftCalibrationOpt.resetTime).y
        resetTimeInfo.width =   leftRepeater.itemAt(leftCalibrationOpt.resetTime).dataAreaW
        resetTimeInfo.height =  leftRepeater.itemAt(leftCalibrationOpt.resetTime).dataAreaH
        resetTimeInfo.visible = leftRepeater.itemAt(leftCalibrationOpt.resetTime).extended

        saveParamInfo.x =       leftRepeater.itemAt(leftCalibrationOpt.saveParam).dataAreaX
        saveParamInfo.y =       leftRepeater.itemAt(leftCalibrationOpt.saveParam).dataAreaY + leftRepeater.itemAt(leftCalibrationOpt.saveParam).y
        saveParamInfo.width =   leftRepeater.itemAt(leftCalibrationOpt.saveParam).dataAreaW
        saveParamInfo.height =  leftRepeater.itemAt(leftCalibrationOpt.saveParam).dataAreaH
        saveParamInfo.visible = leftRepeater.itemAt(leftCalibrationOpt.saveParam).extended

        linkGeneratorInfo.x =       leftRepeater.itemAt(leftCalibrationOpt.linkGenerator).dataAreaX
        linkGeneratorInfo.y =       leftRepeater.itemAt(leftCalibrationOpt.linkGenerator).dataAreaY + leftRepeater.itemAt(leftCalibrationOpt.linkGenerator).y
        linkGeneratorInfo.width =   leftRepeater.itemAt(leftCalibrationOpt.linkGenerator).dataAreaW
        linkGeneratorInfo.height =  leftRepeater.itemAt(leftCalibrationOpt.linkGenerator).dataAreaH
        linkGeneratorInfo.visible = leftRepeater.itemAt(leftCalibrationOpt.linkGenerator).extended

        periodCalibrationInfo.x =       rightInfoCardRepeater.itemAt(rightCalibrationInfoOpt.periodCalibration).dataAreaX + rightColumn.x
        periodCalibrationInfo.y =       rightInfoCardRepeater.itemAt(rightCalibrationInfoOpt.periodCalibration).dataAreaY + rightInfoCardRepeater.itemAt(rightCalibrationInfoOpt.periodCalibration).y
        periodCalibrationInfo.width =   rightInfoCardRepeater.itemAt(rightCalibrationInfoOpt.periodCalibration).dataAreaW
        periodCalibrationInfo.height =  rightInfoCardRepeater.itemAt(rightCalibrationInfoOpt.periodCalibration).dataAreaH
        periodCalibrationInfo.visible = rightInfoCardRepeater.itemAt(rightCalibrationInfoOpt.periodCalibration).extended
    }

    function enableAttachedElements(){
        // ?? --> avoid warnings when no items are still created
        if(leftRepeater.itemAt(0) ?? false){
            linkGeneratorInfo.enabled = leftRepeater.itemAt(leftCalibrationOpt.linkGenerator).enabled
            resetTimeInfo.enabled = leftRepeater.itemAt(leftCalibrationOpt.resetTime).enabled & enableMasck
            saveParamInfo.enabled = leftRepeater.itemAt(leftCalibrationOpt.saveParam).enabled & enableMasck
            periodCalibrationInfo.enabled = rightInfoCardRepeater.itemAt(rightCalibrationInfoOpt.periodCalibration).enabled & enableMasck
        }
    }

    function focusOnCalibrationCard(cardId){
        leftColumn.enabled = false
        for(var i = 0; i < rightRepeater.count; i++){
            rightRepeater.itemAt(i).enabled = ((i === cardId) ? true : false) & enableMasck
        }
        for(i = 0; i < rightInfoCardRepeater.count; i++){
            rightInfoCardRepeater.itemAt(i).enabled = false
        }
        deviceCalibration.blocked = true
    }

    function focusOnRightInfoCard(cardId){
        leftColumn.enabled = false
        for(var i = 0; i < rightRepeater.count; i++){
            rightRepeater.itemAt(i).enabled = false  & enableMasck
        }
        for(i = 0; i < rightInfoCardRepeater.count; i++){
            rightInfoCardRepeater.itemAt(i).enabled = ((i === cardId) ? true : false) & enableMasck
            rightInfoCardRepeater.itemAt(i).blocked = rightInfoCardRepeater.itemAt(i).enabled
        }
        deviceCalibration.blocked = true
        enableAttachedElements()
    }

    function focusOnLeftInfoCard(cardId){
        rightColumn.enabled = false
        for(var i = 0; i < leftRepeater.count; i++){
            leftRepeater.itemAt(i).enabled = ((i === cardId) ? true : false) //& enableMasck
            leftRepeater.itemAt(i).blocked = leftRepeater.itemAt(i).enabled
        }
        deviceCalibration.blocked = true
        enableAttachedElements()
    }

    function focusAllCard(){
        leftColumn.enabled = true
        rightColumn.enabled = true
        for(var i = 0; i < rightRepeater.count; i++){
            rightRepeater.itemAt(i).enabled = true & enableMasck
        }
        for(i = 0; i < leftRepeater.count; i++){
            leftRepeater.itemAt(i).enabled = true & ( (i === leftCalibrationOpt.linkGenerator) ? true : enableMasck )
            leftRepeater.itemAt(i).blocked = false
        }
        for(i = 0; i < rightInfoCardRepeater.count; i++){
            rightInfoCardRepeater.itemAt(i).enabled = true & enableMasck
            rightInfoCardRepeater.itemAt(i).blocked = false
        }
        deviceCalibration.blocked = false

        enableAttachedElements()
    }

    function retractAllInfoCard(){
        console.log("retractAllInfoCard")
        for(var i = 0; i < leftRepeater.count; i++){
            leftRepeater.itemAt(i).extended = false
        }
        for(i = 0; i < rightInfoCardRepeater.count; i++){
            rightInfoCardRepeater.itemAt(i).extended = false
        }
        refreshAttachedElements()
    }

    function lockControls(){
        console.log("lockControls")
        leftColumn.enabled = false
        rightColumn.enabled = false
        locked = true
    }

    function unlockControls(){
        console.log("unlockControls")
        leftColumn.enabled = true ////& enableMasck
        rightColumn.enabled = true & enableMasck
        locked = false
    }

    function loadLeftElements(){
        leftModel.clear()

        // populate and translate models
        leftModel.append( { mMaxHeight: 300, mExtensible: true,  mExtended: false,  mEditEnabled: false, mScrollEnabled: false, mTittle: DB.dbLang_Get("link_generator"),  mText: "" } )
        leftModel.append( { mMaxHeight: 150, mExtensible: true,  mExtended: false,  mEditEnabled: false, mScrollEnabled: false, mTittle: DB.dbLang_Get("reset_gen_time"),  mText: "" } )
        leftModel.append( { mMaxHeight: 180, mExtensible: true,  mExtended: false,  mEditEnabled: false, mScrollEnabled: false, mTittle: DB.dbLang_Get("save_param"),      mText: "" } )
        leftModel.append( { mMaxHeight: 150, mExtensible: true,  mExtended: true,   mEditEnabled: false, mScrollEnabled: false, mTittle: DB.dbLang_Get("generation_mode"), mText: "" } )

        // Walk around
        // Last element on leftModel have problems to position auxiliar frame (saveParamInfo) over datArea
        // for the first time that the card is expanded. (Don't know why by the moment).
        // Creating last element with extended property as true an then changing it to false, forces the system
        // to positioning auxiliar frame on the right coodinates.
        leftRepeater.itemAt(3).extended = false
    }

    function loadRightElements(){
        var i
        // walk around
        // avoid this error (TypeError: Cannot read property 'y' of null)
        // during execution time when language is changed. It not happens
        // dureing component creation
        for(i = 0; i < rightRepeater.count; i++){
            rightRepeater.itemAt(i).y_s = 0
        }
        // end of walk around

        // reset models
        rightModel.clear()
        rightInfoCardModel.clear()

        // translate texts
        pressureCalibratrionSettings.tittle = DB.dbLang_Get("pressure_cal")
        pressureCalibratrionSettings.stepDesc = DB.dbLang_Get("step_desc")

        for(i = 1; i <= pressureCalibratrionSettings.steps; i++){
            pressureCalibratrionSettings["step_" + i.toString()].description = DB.dbLang_Get("press_cal_desc_" + i.toString())
        }

        flowCalibratrionSettings.tittle = DB.dbLang_Get("flow_cal")
        flowCalibratrionSettings.stepDesc = DB.dbLang_Get("step_desc")

        for(i = 1; i <= flowCalibratrionSettings.steps; i++){
            flowCalibratrionSettings["step_" + i.toString()].description = DB.dbLang_Get("flow_cal_desc_" + i.toString())
        }

        o3CalibratrionSettings.tittle = DB.dbLang_Get("o3_cal")
        o3CalibratrionSettings.stepDesc = DB.dbLang_Get("step_desc")

        for(i = 1; i <= o3CalibratrionSettings.steps; i++){
            o3CalibratrionSettings["step_" + i.toString()].description = DB.dbLang_Get("o3_cal_desc_" + i.toString())
        }

        // populate models
        appendCalibrationSettings(pressureCalibratrionSettings, 1)
        appendCalibrationSettings(flowCalibratrionSettings, 1)
        appendCalibrationSettings(o3CalibratrionSettings, 1)

        rightInfoCardModel.append( { mMaxHeight: 180, mExtensible: true,  mExtended: true,  mEditEnabled: false, mScrollEnabled: false, mTittle: DB.dbLang_Get("period_cal"), mText: "" } )
        rightInfoCardRepeater.itemAt(0).extended = false
    }

    function changeLanguage(){
        loadRightElements()
        loadLeftElements()
        languageChangeWalkaroundTimer.start()
    }


    function o3SensorReady(){
        rightRepeater.itemAt(2).nextStep()
    }

    function hideCalibrationCardAnimator(){
        for(var i = 0; i < rightRepeater.count; i++){
            rightRepeater.itemAt(i).tittleAnimationState = "hide"
        }
    }

    function showActiveCalibrationCardAnimation(){
        for(var i = 0; i < rightRepeater.count; i++){
            if(rightRepeater.itemAt(i).enabled){
                rightRepeater.itemAt(i).tittleAnimationState = "show"
            }
        }
    }

    function changeActiveCalibrationCardWaitingMode(state){
        for(var i = 0; i < rightRepeater.count; i++){
            if(rightRepeater.itemAt(i).enabled){
                rightModel.setProperty(i, "mWaitingMode", state)
            }
        }
    }
    onVisibleChanged: {
        if(visible){
            retractAllInfoCard()
            lockControls()
            pinPad.reset()
        }
    }

    onEnableMasckChanged: {
        console.log("device calibration enabled mask changed: ", enableMasck)
        if(stateMachine.currentState != "configSearching"){
            focusAllCard()
            retractAllInfoCard()
            if (!enableMasck) {
                lockControls()
            }
            pinPad.reset()
        }
    }

    Timer{
        id: languageChangeWalkaroundTimer
        interval: 300
        onTriggered: locked ? lockControls() : unlockControls()
    }

    DeviceLink{
        id: linkGeneratorInfo
        z:2
        buttonSize: 90 * 0.8
        buttonColor: "#5F6367"
        listAlternativeColor: "#2B2F34"
        textColor: "#DDDDDD"
        onButtonClicked: console.log("button clicked during:", state)
        onStateChanged: (state === "showStatus") ? focusAllCard() : focusOnLeftInfoCard(leftCalibrationOpt.linkGenerator)
    }

    Selection{
        id: generationMode
        z:2
        onSelectionChanged: {
            consoleSocket.sendData("{GEN_MODE," + (value ? "1" : "0") + "\r")
            generationMode.enabled = false
            temporalDisableControl.start()
        }
        Timer{
            id: temporalDisableControl
            interval: 1000
            running: false
            onTriggered: generationMode.enabled = true
        }
    }

    Confirmation{
        id: resetTimeInfo
        z:2
        includeProgress: false
        btnEndVisible: false
        btnStartImgSource: "Images/baseline_play_arrow_white_24.png"
        onStateChanged: {
            if(state === "progress"){
                configArea.deviceInfo.workingTime = 0

                // Azure Bug 10429: (SDV) Uncontrolled enabled resources (hang)
                deviceCalibration.blocked = true
                focusOnLeftInfoCard(leftCalibrationOpt.resetTime)

                resetTimeInfo.btnStartImgSource = "Images/ic_done_white_48dp.png"
                visulaDelay.start()
            }
        }
        Timer{
            id: visulaDelay
            interval: 500
            running: false
            onTriggered: {
                resetTimeInfo.state = "waiting";
                resetTimeInfo.btnStartImgSource = "Images/baseline_play_arrow_white_24.png"

                // Azure Bug 10429: (SDV) Uncontrolled enabled resources (hang)
                resetTimeInfo.no()
                deviceCalibration.blocked = false
                focusAllCard()
            }
        }
    }

    Confirmation{
        id: saveParamInfo
        z:2
        includeProgress: true
        btnStartImgSource: "Images/baseline_play_arrow_white_24.png"
        btnEndVisible: false
        onStateChanged: (state === "waiting") ? focusAllCard() : focusOnLeftInfoCard(leftCalibrationOpt.saveParam)
        onYes: deviceCalibration.blocked = true
    }

    Confirmation{
        id: periodCalibrationInfo
        z:2
        includeProgress: true
        btnStartImgSource: "Images/baseline_play_arrow_white_24.png"
        btnEndImgSource: "Images/baseline_stop_white_24.png"
        onStateChanged: (state === "waiting") ? focusAllCard() : focusOnRightInfoCard(rightCalibrationInfoOpt.periodCalibration)
        onYes: calibrationChanged(0)
        onNo: consoleSocket.sendData("{CNL_SIM\r")
        delayedCancelConfirmation: true
    }

    Item{
        id: leftColumn
        height: parent.height
        width: (parent.width * 0.5) - (verticalSpacing * 0.5)
        opacity: enabled ? 1 : cardOpacityLevel

        ListModel {
            id: leftModel
//          ListElement { mMaxHeight: 150; mExtensible: false; mExtended: false; mTittle: "Information"; mText: "text demo" }
        }

        Component {
            id: leftDelegate

            InfoCard{
                opacity: enabled ? 1 : cardOpacityLevel
                extensible: mExtensible
                extended: mExtended
                maxHeight: mMaxHeight
                minHeight: 55
                tittle: mTittle
                tittleColor: Style.deviceCalibration.tittleColor
                color: Style.deviceCalibration.cardColor
                text: mText
                textColor: Style.deviceCalibration.textColor
                width: parent.width
                vMargin: 0.27
                imgExtended: "Images/outline_expand_less_white_24.png"
                imgRetracted: "Images/outline_expand_more_white_24.png"
                editEnabled: mEditEnabled
                scrollEnabled: mScrollEnabled

                onYChanged:       refreshAttachedElements()
//              onUserExtension:  updatteLeftOnUserExtension(index)
//              onUserRetraction: updatteLeftOnUserRetraction(index)
                onUserExtension:  {refreshAttachedElements()}//; focusOnInfoCard(index)}
                onUserRetraction: {refreshAttachedElements()}//;focusAllCard()}
            }
        }

        Column{
            spacing: horizontalSpacing
            anchors.fill: parent

            Repeater {
                id: leftRepeater
                model: leftModel
                delegate: leftDelegate
            }
            Component.onCompleted: loadLeftElements()
        }
        Rectangle {border.color: "green"; color: "transparent"; anchors.fill: parent; visible: gridView}
    }

    Item{
        id: rightColumn
        height: parent.height
        width: leftColumn.width
        anchors.right: parent.right
        z: leftColumn.z
        opacity: enabled ? 1 : cardOpacityLevel

        Column{
            id: gostColumn
            spacing: horizontalSpacing
            anchors.fill: parent

            Repeater {
                id: rightGostRepeater
                model: 2
                delegate: Rectangle{ height: 55; width: 25; color:  gridView ? "gold" : "transparent"}
            }

            ListModel {
                id: rightInfoCardModel
            }

            Repeater {
                id: rightInfoCardRepeater
                model: rightInfoCardModel
                delegate: leftDelegate
            }

            Rectangle{
                id: rightGostRepeaterB
                height: 55; width: 25; color:  gridView ? "tomato" : "transparent"
                onYChanged: if (rightRepeater.itemAt(2) !== null){
                                rightRepeater.itemAt(2).y = rightGostRepeaterB.y
                            }
            }
        }

        ListModel {
            id: rightModel
//          ListElement { mTittle: "Information"; mMaxSlider: 100; mMinSlider: 0; mDefValue: 50; mSteps}
        }

        Component {
            id: rightDelegate

            CalibrationCard {
                opacity: enabled ? 1 : cardOpacityLevel
                x_s: 0
                y_s: (index === 2 ) ? rightGostRepeaterB.y : rightGostRepeater.itemAt(index).y
                height: 55
                width: (widthWhenExpanded  * 0.5) - (verticalSpacing * 0.5) - deviceCalibration.anchors.margins
                x_b: -(verticalSpacing + leftColumn.width)
                y_b: parent.height - height_b
                height_b: 370
                width_b: verticalSpacing + (leftColumn.width * 2)
                tittle.text: mTittle
                slider.maximumValue: mMaxSlider
                slider.minimumValue: mMinSlider
                slider.value: mDefValue
                calibrationSteps: mSteps
                stepDescription: mStepDesc
                decriptionText.text: mDescription
                calibrationSettings: mCalibrationSettings
                waitingMode: mWaitingMode
                sliderView: mSliderView
                color:               Style.deviceCalibration.cardColor
                stepsColor:          Style.deviceCalibration.stepsColor
                buttonColor:         Style.deviceCalibration.buttonColor
                controlsColor:       Style.deviceCalibration.controlsColor
                descriptionColor:    Style.deviceCalibration.descriptionColor
                activeControlsColor: Style.deviceCalibration.activeControlsColor

                onWidthChanged: if(state === "big") {width = verticalSpacing + (leftColumn.width * 2)} // patch to solve Azure bug 13607: Fail on calibration card width

                onCurrentStepChanged: {
                    deviceCalibration.refreshCalibrationSettings(index, calibrationSettings, currentStep + 1)
                    updateSliderValue(mDefValue)  // althoug 'refreshCalibrationSettings' refreshes 'mDefValue' slider value doesn't go to default value (force it)
                }
                onExpansionStart: {
                    deviceCalibration.retractAllInfoCard()
                    focusOnCalibrationCard(index)
                    calibrationStart(calibrationSettings.calibType)
                    consoleSocket.sendData("{SLD_SIM," + slider.value + "\r")
                }
                onRetractionEnd: {
//                  focusAllCard()
                    delayedFocusAllCard.start()
                    calibrationEnd()
                    showActiveCalibrationCardAnimation()
                }
//              onOkButtonPressed: calibrationChanged(slider.value)
//              onBackButtonPressed: calibrationNotChanged()
//              onSliderValueChanged: consoleSocket.sendData("{SLD_SIM," + slider.value + "\r")
                onOkButtonPressed: {
                    consoleSocket.sendData("{ENT_SIM\r")
                }
                onBackButtonPressed: consoleSocket.sendData("{CNL_SIM\r")
                onSliderValueChanged: {
//                  console.log("Slider value changed to:", slider.value)
                    consoleSocket.sendData("{SLD_SIM," + slider.value + "\r")
                }
                onExpansionEnd: {
                    deviceCalibration.refreshCalibrationSettings(index, calibrationSettings, currentStep + 1) // Azure Bug 10431: (SDV) Pressure calibration menu improvement.
                }
            }
        }

        Repeater {
            id: rightRepeater
            model: rightModel
            delegate: rightDelegate
        }
        Component.onCompleted: loadRightElements()
        Rectangle {border.color: "tomato"; color: "transparent"; anchors.fill: parent; visible: gridView}
    }


    Rectangle{
        id: lock
        height: 120
        width: height
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 100
        color: Style.deviceCalibration.lockColor
        radius: 6
        visible: locked
        layer.enabled: Style.deviceCalibration.lockShadowEnable
        layer.effect: DropShadow { radius: Style.deviceCalibration.lockShadowRadius; color: Style.deviceCalibration.lockShadowColor }
        MouseArea{
            anchors.fill: parent
            onClicked: pinPad.visible = true
        }
        Image{
            id: lockImage
            anchors.fill: parent
            anchors.margins: parent.height * 0.05
            source: "Images/outline_lock_white_48.png"
        }
    }

    PinPad{
        id: pinPad
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 100
        visible: false
        buttonSize: 85
        buttonColor: Style.deviceCalibration.pinPadButtonColor
        spacing: 20
        color: Style.deviceCalibration.pinPadColor
        onEnterKey: pinValue === "8517" ? unlockControls() : null
        onVisibleChanged: deviceCalibration.blocked = visible
        layer.enabled: Style.deviceCalibration.pinPadShadowEnable
        layer.effect: DropShadow { radius: Style.deviceCalibration.pinPadShadowRadius; color: Style.deviceCalibration.pinPadShadowColor }
    }

    Timer{
        id: delayedFocusAllCard
        interval: 2000
        running: false
        onTriggered: {
            focusAllCard()
            hideCalibrationCardAnimator()
        }

    }

}
