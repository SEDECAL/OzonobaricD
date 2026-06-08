// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright (C) 2024 Sedecal S.A.
// This file is part of OzonobaricD.
// See LICENSE file for details.

import QtQuick 2.15
import QtQuick.Controls 2.5
import AppStyle 1.0
import "Database.js" as DB

Item{
    id: deviceInfo

    property bool gridView: false

    property alias loadParamInfo: loadParamInfo
    property alias bluetoothInfo: bluetoothInfo
    property alias unitsAndLanguageInfo: unitsAndLanguageInfo

    property bool blocked: false
    property bool enableMasck: false // used over enable/disable cards algorithm to allow only allowed cards when no serial connection available
    property int  verticalSpacing: 20
    property int  horizontalSpacing: 7
    property int  workingTime: -1 // keep negative value at first init value

    signal workingTimeChange(int value)
    signal deviceNameTextChange(string value)

    property string devInfoText:    ""
    property string deviceNameText: "Media Center Clinic"
    property string pressTempText:  ""
    property string parametersText: ""
    property string statrUpText:    ""
    property string temperature: ""
    property string pressure: ""
    property string guiVersion: ""
    property string interfaceVersion: ""
    property string controlVersion: ""
    property string databaseVersion: ""

    property variant leftInfoOptions: { 'pressAndTemp': 0,
                                        'deviceInfo': 1,
                                        'unitsAndLanguage': 2,
                                        'bluetoothConnection': 3,
                                        'loadParam': 4 }

    function refreshAttachedElements(){
        console.log("refreshAttachedElements");
        bluetoothInfo.x =       leftRepeater.itemAt(leftInfoOptions.bluetoothConnection).dataAreaX
        bluetoothInfo.y =       leftRepeater.itemAt(leftInfoOptions.bluetoothConnection).dataAreaY + leftRepeater.itemAt(leftInfoOptions.bluetoothConnection).y
        bluetoothInfo.width =   leftRepeater.itemAt(leftInfoOptions.bluetoothConnection).dataAreaW
        bluetoothInfo.height =  leftRepeater.itemAt(leftInfoOptions.bluetoothConnection).dataAreaH
        bluetoothInfo.visible = leftRepeater.itemAt(leftInfoOptions.bluetoothConnection).extended

        loadParamInfo.x =       leftRepeater.itemAt(leftInfoOptions.loadParam).dataAreaX
        loadParamInfo.y =       leftRepeater.itemAt(leftInfoOptions.loadParam).dataAreaY + leftRepeater.itemAt(leftInfoOptions.loadParam).y
        loadParamInfo.width =   leftRepeater.itemAt(leftInfoOptions.loadParam).dataAreaW
        loadParamInfo.height =  leftRepeater.itemAt(leftInfoOptions.loadParam).dataAreaH
        loadParamInfo.visible = leftRepeater.itemAt(leftInfoOptions.loadParam).extended

        unitsAndLanguageInfo.x =       leftRepeater.itemAt(leftInfoOptions.unitsAndLanguage).dataAreaX
        unitsAndLanguageInfo.y =       leftRepeater.itemAt(leftInfoOptions.unitsAndLanguage).dataAreaY + leftRepeater.itemAt(leftInfoOptions.unitsAndLanguage).y
        unitsAndLanguageInfo.width =   leftRepeater.itemAt(leftInfoOptions.unitsAndLanguage).dataAreaW
        unitsAndLanguageInfo.height =  leftRepeater.itemAt(leftInfoOptions.unitsAndLanguage).dataAreaH
        unitsAndLanguageInfo.visible = leftRepeater.itemAt(leftInfoOptions.unitsAndLanguage).extended
        unitsAndLanguageInfo.gotoLanguageChecked()
    }

    function updatteLeftOnUserExtension(index){
        console.log("user extension: ", index);
        switch (index){
        case leftInfoOptions.deviceInfo:
        case leftInfoOptions.unitsAndLanguage:    leftRepeater.itemAt( leftInfoOptions.bluetoothConnection ).extended = false
                                                  leftRepeater.itemAt( leftInfoOptions.loadParam ).extended = false
                                                  break;
        case leftInfoOptions.bluetoothConnection: leftRepeater.itemAt( leftInfoOptions.deviceInfo ).extended = false
                                                  leftRepeater.itemAt( leftInfoOptions.unitsAndLanguage ).extended = false
                                                  leftRepeater.itemAt( leftInfoOptions.loadParam ).extended = false
                                                  break;
        case leftInfoOptions.loadParam:           leftRepeater.itemAt( leftInfoOptions.unitsAndLanguage ).extended = false
                                                  leftRepeater.itemAt( leftInfoOptions.bluetoothConnection ).extended = false
                                                  break;
        }
        refreshAttachedElements()
    }

    function updatteLeftOnUserRetraction(index){
        console.log("user retraction: ", index);
        switch (index){
        case leftInfoOptions.loadParam:
        case leftInfoOptions.bluetoothConnection: leftRepeater.itemAt( leftInfoOptions.deviceInfo ).extended = true
                                                  leftRepeater.itemAt( leftInfoOptions.unitsAndLanguage ).extended = true
                                                  leftRepeater.itemAt( leftInfoOptions.loadParam ).extended = false
                                                  break;
        }
        refreshAttachedElements()
    }

    function resetLeftColumn(){
        leftRepeater.itemAt( leftInfoOptions.pressAndTemp ).extended = true
        leftRepeater.itemAt( leftInfoOptions.deviceInfo ).extended = true
        leftRepeater.itemAt( leftInfoOptions.unitsAndLanguage ).extended = true
        leftRepeater.itemAt( leftInfoOptions.bluetoothConnection ).extended = false
        leftRepeater.itemAt( leftInfoOptions.loadParam ).extended = false
        refreshAttachedElements()
    }

    function focusOnInfoCard(cardId){
        for(var card in leftInfoOptions){
            console.log("cardId:", cardId, "vs card:",card)
            if(cardId !== card){
                leftRepeater.itemAt( leftInfoOptions[card] ).enabled = false
                leftRepeater.itemAt( leftInfoOptions[card] ).opacity = 0.3
            }
            else{
                leftRepeater.itemAt( leftInfoOptions[card] ).blocked = true
            }
        }

        for(var i = 0; i < rightRepeater.count; i++){
            rightRepeater.itemAt(i).enabled = false
            rightRepeater.itemAt(i).opacity = 0.3
        }

        deviceInfo.blocked = true
    }

    function focusAllInfoCard(){
        for(var card in leftInfoOptions){
            // ?? --> avoid warnings when no items are still created
            if(leftRepeater.itemAt(0) ?? false){
                leftRepeater.itemAt( leftInfoOptions[card] ).enabled = true & ( leftInfoOptions[card] === leftInfoOptions.loadParam ? enableMasck : true )
                leftRepeater.itemAt( leftInfoOptions[card] ).opacity = leftRepeater.itemAt( leftInfoOptions[card] ).enabled ? 1 : 0.3
                leftRepeater.itemAt( leftInfoOptions[card] ).blocked = false
            }
        }

        for(var i = 0; i < rightRepeater.count; i++){
            rightRepeater.itemAt(i).enabled = true
            rightRepeater.itemAt(i).opacity = 1
        }
        deviceInfo.blocked = false
    }

    function formatWorkingTime(totalSeconds){
        var hours   = Math.floor(totalSeconds / 3600)
        var minutes = Math.floor((totalSeconds - (hours * 3600)) / 60)
        var seconds = totalSeconds - (hours * 3600) - (minutes * 60)

//      console.log("hours:", hours)
//      console.log("minutes:", minutes)
//      console.log("seconds:", hours)

        if (hours   < 10) { hours   = "0" + hours }
        if (minutes < 10) { minutes = "0" + minutes }
        if (seconds < 10) { seconds = "0" + seconds }

        return hours + 'h : ' + minutes + 'm : ' + seconds + 's'
    }

    function refreshWorkingTimeInfo(){
        leftRepeater.itemAt(1).text =
                "<p1 style=\"font-size:21px\">" + DB.dbLang_Get("sw_versions") + "<br></p1>" +// "<p2 style=\"font-size:4px; color:#444444\">todo: inprove this line space...<br></p2>" +
                "<p2 style=\"font-size:19px; color:#AAAAAA\">&nbsp;&nbsp;&nbsp;" + DB.dbLang_Get("gui") + ": " + guiVersion + "<br></p2>" +
                "<p2 style=\"font-size:19px; color:#AAAAAA\">&nbsp;&nbsp;&nbsp;" + DB.dbLang_Get("interface") + ": "+ interfaceVersion + "<br></p2>" +
                "<p2 style=\"font-size:19px; color:#AAAAAA\">&nbsp;&nbsp;&nbsp;" + DB.dbLang_Get("control") + ": " + controlVersion + "<br></p2>" +
                "<p2 style=\"font-size:19px; color:#AAAAAA\">&nbsp;&nbsp;&nbsp;" + DB.dbLang_Get("database") + ": " + databaseVersion + "<br></p2>" +
                "<p2 style=\"font-size:4px; color:#444444\">todo: inprove this line space...<br></p2>" +
                "<p1 style=\"font-size:21px\">" + DB.dbLang_Get("gen_time") + "<br></p1>" +// "<p2 style=\"font-size:4px; color:#444444\">todo: inprove this line space...<br></p2>" +
                "<p2 style=\"font-size:19px; color:#AAAAAA\">&nbsp;&nbsp;&nbsp;" + formatWorkingTime(workingTime) + "<br></p2>"
    }

    function loadLeftElements(){
        leftModel.clear()
        // populate and translate models
        leftModel.append( { mMaxHeight: 100, mExtensible: false, mExtended: true,  mEditEnabled: false, mScrollEnabled: false, mTittle: DB.dbLang_Get("press_temp"),    mText: pressTempText } )
        leftModel.append( { mMaxHeight: 240, mExtensible: true,  mExtended: true,  mEditEnabled: false, mScrollEnabled: false, mTittle: DB.dbLang_Get("dev_info"),      mText: devInfoText } )
        leftModel.append( { mMaxHeight: 168, mExtensible: true,  mExtended: true,  mEditEnabled: false, mScrollEnabled: false, mTittle: DB.dbLang_Get("units_lang"),    mText: "" } )
        leftModel.append( { mMaxHeight: 300, mExtensible: true,  mExtended: false, mEditEnabled: false, mScrollEnabled: false, mTittle: DB.dbLang_Get("bt_connection"), mText: "" } )
        leftModel.append( { mMaxHeight: 180, mExtensible: true,  mExtended: false, mEditEnabled: false, mScrollEnabled: false, mTittle: DB.dbLang_Get("load_param"),    mText: "" } )
    }

    function loadRightElements(){
        rightModel.clear()
        // populate and translate models
        rightModel.append( { mMaxHeight: 100, mExtensible: false, mExtended: true,  mEditEnabled:  true, mScrollEnabled: false, mTittle: DB.dbLang_Get("dev_name"),        mText: deviceNameText } )
        rightModel.append( { mMaxHeight: 266, mExtensible: false, mExtended: true,  mEditEnabled: false, mScrollEnabled:  true, mTittle: DB.dbLang_Get("dev_parameters"),  mText: parametersText } )
        rightModel.append( { mMaxHeight: 267, mExtensible: false, mExtended: true,  mEditEnabled: false, mScrollEnabled:  true, mTittle: DB.dbLang_Get("startup_results"), mText: statrUpText } )
    }

    function changeLanguage(){
        loadRightElements()
        loadLeftElements()
        refreshWorkingTimeInfo()
    }

    function refreshPressTempInfo(temp, press){
        for(var i = 0; i < leftRepeater.count; i++){
            if( leftRepeater.itemAt(i).tittle === DB.dbLang_Get("press_temp") ){
                leftRepeater.itemAt(i).text = "<p1 style=\"font-size:20px\">T:&nbsp;</p1>" + "<p2 style=\"font-size:19px; color:#AAAAAA\">" + temp + " &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</p2>" +
                                              "<p1 style=\"font-size:20px\">P:&nbsp;</p1>" + "<p2 style=\"font-size:19px; color:#AAAAAA\">" + press + "</p2>"
            }
        }
    }

    function refreshParametersInfo(data){
        for(var i = 0; i < rightRepeater.count; i++){
            if( rightRepeater.itemAt(i).tittle === DB.dbLang_Get("dev_parameters") ){
                rightRepeater.itemAt(i).text = "<p1 style=\"font-size:19px; color:#AAAAAA\">" + data + "</p1>"
                parametersText = "<p1 style=\"font-size:19px; color:#AAAAAA\">" + data
            }
        }
    }

    function appendParametersInfo(data){
        for(var i = 0; i < rightRepeater.count; i++){
            if( rightRepeater.itemAt(i).tittle === DB.dbLang_Get("dev_parameters") ){
                rightRepeater.itemAt(i).text += "<p1 style=\"font-size:19px; color:#AAAAAA\">" + data + "</p1>"
                parametersText += data
            }
        }
    }

    function refreshStartUpInfo(data){
        for(var i = 0; i < rightRepeater.count; i++){
            if( rightRepeater.itemAt(i).tittle === DB.dbLang_Get("startup_results") ){
                rightRepeater.itemAt(i).text = "<p1 style=\"font-size:19px; color:#AAAAAA\">" + data + "</p1>"
                statrUpText = "<p1 style=\"font-size:19px; color:#AAAAAA\">" + data
            }
        }
    }

    function appendStartUpInfo(data){
        for(var i = 0; i < rightRepeater.count; i++){
            if( rightRepeater.itemAt(i).tittle === DB.dbLang_Get("startup_results") ){
                rightRepeater.itemAt(i).text += "<p1 style=\"font-size:19px; color:#AAAAAA\">" + data + "</p1>"
                statrUpText +=  "<p1 style=\"font-size:19px; color:#AAAAAA\">" + data
            }
        }
    }

    onEnableMasckChanged: {
        console.log("device info enabled mask changed: ", enableMasck)
        focusAllInfoCard()
    }

    onTemperatureChanged: refreshPressTempInfo(temperature, pressure)
    onPressureChanged: refreshPressTempInfo(temperature, pressure)
    onInterfaceVersionChanged: refreshWorkingTimeInfo()
    onControlVersionChanged: refreshWorkingTimeInfo()

    // Walk around
    // Force working time information to be refresed. This piece of code works together with
    // the walk around described at 'onTextChanged' in 'infoCard.qml' when workingTime is
    // resetted to zero form configuration menu option
    onWorkingTimeChanged: {
        workingTimeChange(workingTime)
        refreshWorkingTimeInfo()
    }
    onDeviceNameTextChanged:  {
        deviceNameTextChange(deviceNameText)
        rightRepeater.itemAt(0).text = deviceNameText
    }

    onVisibleChanged: visible ? resetLeftColumn() : null

    BluetoothConnection{
        id: bluetoothInfo
        z:2
//      onStart: focusOnInfoCard('bluetoothConnection')
//      onCancel: focusAllInfoCard()
        onStateChanged: (state === "searching") ? focusOnInfoCard('bluetoothConnection') : focusAllInfoCard()
    }

    Confirmation{
        id: loadParamInfo
        z:2
        includeProgress: true
//      onYes: focusOnInfoCard('loadParam')
//      onNo: focusAllInfoCard()
        btnStartImgSource: "Images/baseline_play_arrow_white_24.png"
        btnEndVisible: false
        onStateChanged: (state === "waiting") ? focusAllInfoCard() : focusOnInfoCard('loadParam')
        onYes: deviceInfo.blocked = true
    }

    UnitsAndLanguage{
        id: unitsAndLanguageInfo
        z:2
    }

    Item{
        id: leftColumn
        height: parent.height
        width: (parent.width * 0.5) - (verticalSpacing * 0.5)

        ListModel {
            id: leftModel
//          ListElement { mMaxHeight: 150; mExtensible: false; mExtended: false; mTittle: "Information"; mText: "text demo" }
        }

        Component {
            id: leftDelegate

            InfoCard{
                extensible: mExtensible
                extended: mExtended
                maxHeight: mMaxHeight
                minHeight: 55
                tittle: mTittle
                tittleColor: Style.deviceInfo.tittleColor
                color: Style.deviceInfo.cardColor
                text: mText
                textColor: Style.deviceInfo.textColor
                width: parent.width
                vMargin: 0.27
                imgExtended: "Images/outline_expand_less_white_24.png"
                imgRetracted: "Images/outline_expand_more_white_24.png"
                editEnabled: mEditEnabled
                scrollEnabled: mScrollEnabled

                onYChanged:       refreshAttachedElements()//updateLeftOnYChange(index)
                onUserExtension:  updatteLeftOnUserExtension(index)
                onUserRetraction: updatteLeftOnUserRetraction(index)
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

        ListModel {
            id: rightModel
//          ListElement { mMaxHeight: 150; mExtensible: false; mExtended: false; mTittle: "Information"; mText: "text demo" }
        }

        Component {
            id: rightDelegate

            InfoCard {
                extensible: mExtensible
                extended: mExtended
                maxHeight: mMaxHeight
                minHeight: 55
                tittle: mTittle
                tittleColor: Style.deviceInfo.tittleColor
                color: Style.deviceInfo.cardColor
                text: mText
                width: parent.width
                vMargin: 0.27
                imgExtended: "Images/outline_expand_less_white_24.png"
                imgRetracted: "Images/outline_expand_more_white_24.png"
                editEnabled: mEditEnabled
                scrollEnabled: mScrollEnabled
                onInfoTextChanged: {
                    if(tittle === DB.dbLang_Get("dev_name")) {
                        deviceNameText = infoText
                        console.log("deviceNameText:", deviceNameText)
                    }
                }
            }
        }

        Column{
            spacing: horizontalSpacing
            anchors.fill: parent

            Repeater {
                id: rightRepeater
                model: rightModel
                delegate: rightDelegate
            }

            Component.onCompleted: loadRightElements()
        }
        Rectangle {border.color: "tomato"; color: "transparent"; anchors.fill: parent; visible: gridView}
    }
}
