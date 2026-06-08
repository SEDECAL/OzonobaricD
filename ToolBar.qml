// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright (C) 2024 Sedecal S.A.
// This file is part of OzonobaricD.
// See LICENSE file for details.

import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3
import AppStyle 1.0
import AppConstants 1.0

Item{
    id: toolBarItem

    property bool gridView: false

    property bool enableMask: connectStateImg.connected
    property bool tobIsPortrait: true
    property bool tobIsLandScape: !tobIsPortrait
    property bool isBatteryCharging: false
    property double sizeFactor: 0.5
    property double buttonSpacing: sizeFactor * 10
    property double tobScreenFraction: 6
    property double disabledOpacityLevel: 0.3
    property int batteryLevel: 0

    property variant consultMenuRegister: {'': 0} // param - value pairs presented on each moment (i.e: 'dose': 9)

    readonly property double buttonSize: ( (tobIsLandScape) ? toolBarItem.width : toolBarItem.height) * sizeFactor

    property alias connectedIcon: connectStateImg.connected

    signal tobClicked(int tobIndex, string actionName)
    signal playClicked()
    signal pauseClicked()
    signal stopClicked()
    signal helpClicked()
    signal settingsClicked()
    signal playPressAndHold()
    signal playReleased()    

    function getX(buttonName){
        return toolBarItem.x + consultRepeaterGrid.x + consultRepeater.itemAt(consultMenuRegister[buttonName]).x
    }

    function getY(buttonName){
        return toolBarItem.y + consultRepeaterGrid.y + consultRepeater.itemAt(consultMenuRegister[buttonName]).y
    }

    function getSize(buttonName){
      return ( (tobIsLandScape) ? toolBarItem.width : toolBarItem.height) * sizeFactor
    }

    function searchByName(object, name){
        for(var i = 0; i < object.count ; i++)
        {
            if(object.itemAt(i).name === name)
            {
                return i
            }
        }
        return -1
    }

//    function generateSpecificClickedSignal(name){
//        switch(name){
//            case "play":     playClicked();     break
//            case "pause":    pauseClicked();    break
//            case "stop":     stopClicked();     break
//            case "help":     helpClicked();     break
//            case "settings": settingsClicked(); break
//        }
//    }
    function generateSpecificClickedSignal(name){
        switch(name){
            case Const.controls.play:     playClicked();     break
            case Const.controls.pause:    pauseClicked();    break
            case Const.controls.stop:     stopClicked();     break
            case Const.controls.help:     helpClicked();     break
            case Const.controls.settings: settingsClicked(); break
        }
    }

    function generateSpecificPressedSignal(name){
        if(name === Const.controls.play){
            playPressAndHold()
        }
    }

    function generateSpecificReleasedSignal(name){
        if(name === Const.controls.play){
            playReleased()
        }
    }

    function disableItems(itemList){
        var i, j

        if(arguments.length) {
            for(i = 0; i < actionRepeater.count ; i++) {
                actionRepeater.itemAt(i).enabled = true & enableMask
                for(j = 0; j < itemList.length ; j++)  {
                    if(actionRepeater.itemAt(i).name === itemList[j])
                    {
                        actionRepeater.itemAt(i).enabled = false
                    }
                }
            }
            for(i = 0; i < consultRepeater.count ; i++)
            {
                consultRepeater.itemAt(i).enabled = true
                for(j = 0; j < itemList.length ; j++) {
                    if(consultRepeater.itemAt(i).name === itemList[j])
                    {
                        consultRepeater.itemAt(i).enabled = false
                    }
                }
            }
        }
        else {
            for(i = 0; i < actionRepeater.count ; i++) {
                actionRepeater.itemAt(i).enabled = false
            }
            for(i = 0; i < consultRepeater.count ; i++) {
                consultRepeater.itemAt(i).enabled = false
            }
        }
    }

    function enableItems(itemList){
        var i, j

        if(arguments.length) {
            for(i = 0; i < actionRepeater.count ; i++) {
                actionRepeater.itemAt(i).enabled = false
                for(j = 0; j < itemList.length ; j++) {
                    if(actionRepeater.itemAt(i).name === itemList[j]) {
                        actionRepeater.itemAt(i).enabled = true & enableMask
                    }
                }
            }
            for(i = 0; i < consultRepeater.count ; i++) {
                consultRepeater.itemAt(i).enabled = false
                for(j = 0; j < itemList.length ; j++) {
                    if(consultRepeater.itemAt(i).name === itemList[j]) {
                        consultRepeater.itemAt(i).enabled = true
                    }
                }
            }
        }
        else
        {
            for(i = 0; i < actionRepeater.count ; i++) {
                actionRepeater.itemAt(i).enabled = true & enableMask
            }
            for(i = 0; i < consultRepeater.count ; i++) {
                consultRepeater.itemAt(i).enabled = true
            }
        }
    }


    function updateBateryInfo(level){
        if(level < 15)
            return (isBatteryCharging) ? "Images/battery_charging_h_r_0_24dp.png" : "Images/battery_h_r_0_24dp.png"
        else if (level < 25)
            return (isBatteryCharging) ? "Images/battery_charging_h_15_0_24dp" : "Images/battery_h_15_0_24dp.png"
        else if (level < 50)
            return (isBatteryCharging) ? "Images/battery_charging_h_25_0_24dp" : "Images/battery_h_25_0_24dp.png"
        else if (level < 75)
            return (isBatteryCharging) ? "Images/battery_charging_h_50_0_24dp" : "Images/battery_h_50_0_24dp.png"
        else if (level < 100)
            return (isBatteryCharging) ? "Images/battery_charging_h_75_0_24dp" : "Images/battery_h_75_0_24dp.png"
        else
            return (isBatteryCharging) ? "Images/battery_charging_h_100_0_24dp" : "Images/battery_h_100_0_24dp.png"
    }

    Component.onCompleted: {
        connectStateImg.visible = true     // avoid visual effects during start up
        timeDatePortrait.visible = true    // avoid visual effects during start up
        timeDateLandScape. visible = true  // avoid visual effects during start up
    }

    height: (tobIsLandScape) ? parent.height : parent.height / tobScreenFraction
    width:  (tobIsLandScape) ? parent.width / tobScreenFraction : parent.width
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    opacity: enabled ? 1 : 0.3

//  Rectangle {border.color: "transparent"; color: "#222222"; anchors.fill: parent; visible: true}
//  Rectangle {anchors.fill: parent; visible: true; color: "#000000"; border.color: "#CCCCCC"; radius: tobScreenFraction * 0.9 }

    ListModel {
        id: actionModel
//        ListElement { actColor: "transparent"; actName: "play";  actIcon: "Images/outline_play_circle_white_48.png" }
    }

    Component{
        id: actionDelegate
        Rectangle{
            property string name: actName
            width: (tobIsLandScape) ? toolBarItem.width : toolBarItem.height * sizeFactor
            height: (tobIsLandScape) ? toolBarItem.width * sizeFactor : toolBarItem.height
            color: actColor
            opacity: enabled ? 1 : disabledOpacityLevel
            Image{
                anchors.centerIn: parent
                source: actIcon
                height: (parent.height > parent.width) ? parent.width : parent.height
                width: height
            }
            MouseArea{
                property bool pressAndHolded: false
                anchors.fill: parent
                onClicked: {
                    console.log("tool bar element clicked (action):", index, actIcon)
                    pressAndHolded = false       // Azure Bug 10489: (SDV) Simple play buton touch on manual syringe starts generating
                    tobClicked(index, actName)
                    generateSpecificClickedSignal(actName)
                }
                // Note: generate only release event in the case of previous pressAndHold
                onPressAndHold: { pressAndHolded = true ; generateSpecificPressedSignal(actName)}
                onReleased: {
                    if(pressAndHolded){
                        generateSpecificReleasedSignal(actName)
                    }
                    pressAndHolded = false       // Azure Bug 10489: (SDV) Simple play buton touch on manual syringe starts generating
                }
            }

//          onEnabledChanged: console.log("tool button name: ", name, "enabled change...")

            Rectangle {border.color: "khaki"; color: "transparent"; anchors.fill: parent; visible: gridView}
        }
    }

    Grid{
        rows:  (tobIsLandScape) ?  actionRepeater.count : 0
        columns:  (tobIsLandScape) ? 0 : actionRepeater.count
        spacing: buttonSpacing
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.leftMargin: (tobIsLandScape) ? 0 : buttonSpacing
        anchors.topMargin: (tobIsLandScape) ? buttonSpacing : 0

        Repeater {
            id: actionRepeater
            model: actionModel
            delegate: actionDelegate
        }
        Component.onCompleted:{
//        Create action elements
          actionModel.append( { actColor: "transparent", actName: Const.controls.play,  actIcon: "Images/outline_play_circle_white_48.png" } )
          actionModel.append( { actColor: "transparent", actName: Const.controls.pause, actIcon: "Images/outline_pause_circle_white_48.png" } )
          actionModel.append( { actColor: "transparent", actName: Const.controls.stop,  actIcon: "Images/outline_stop_circle_white_48.png" } )
        }
    }

    ListModel {
        id: consultModel
//      ListElement { consColor: "transparent"; consName: "help";     consIcon: "Images/outline_help_outline_white_48.png" }
    }

    Component{
        id: consultDelegate
        Rectangle{
            property string name: consName
            width: (tobIsLandScape) ? toolBarItem.width : toolBarItem.height * sizeFactor
            height: (tobIsLandScape) ? toolBarItem.width * sizeFactor : toolBarItem.height
            color: consColor
            opacity: enabled ? 1 : disabledOpacityLevel
            Image{
                anchors.centerIn: parent
                source: consIcon
                height: (parent.height > parent.width) ? parent.width : parent.height
                width: height
            }
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    console.log("tool bar element clicked (consult):", index, consIcon)
                    tobClicked(index, consName)
                    generateSpecificClickedSignal(consName)
                    //parent.border.color = "#111111"
                }
            }
            Rectangle {border.color: "khaki"; color: "transparent"; anchors.fill: parent; visible: gridView}
        }
    }

    Grid{
        id: consultRepeaterGrid
        rows:  (tobIsLandScape) ?  consultRepeater.count : 0
        columns:  (tobIsLandScape) ? 0 : consultRepeater.count
        spacing: buttonSpacing
        anchors.right: (tobIsLandScape) ? parent.right : timeDateLandScape.left
        anchors.bottom: (tobIsLandScape) ? timeDateLandScape.top : parent.bottom
        anchors.rightMargin: (tobIsLandScape) ? 0 : buttonSpacing

        Repeater {
            id: consultRepeater
            model: consultModel
            delegate: consultDelegate            
            onItemAdded: {
                consultMenuRegister[item.name] = index
            }
            Component.onCompleted:{
//            Create settings/help elements
              consultModel.append( { consColor: "transparent", consName: Const.controls.help,     consIcon: "Images/outline_help_outline_white_48.png" } )
              consultModel.append( { consColor: "transparent", consName: Const.controls.settings, consIcon: "Images/outline_settings_white_48.png" } )
            }
        }

        Component.onCompleted: {
            for(var i = 0; i < consultRepeater.count ; i++){
                console.log("consultRepeater.itemAt(", i, ").x", consultRepeater.itemAt(i).x)
                console.log("consultRepeater.itemAt(", i, ").y", consultRepeater.itemAt(i).y)

//                consultMenuRegister[consultRepeater.itemAt(i).consName] = i
            }

        }
    }

    TextArea {
        id: timeDateLandScape
//        width: (tobIsLandScape) ? toolBarItem.width * 0.8 : 0
//        height: (tobIsLandScape) ? toolBarItem.width * 0.3 : 0
        width: (tobIsLandScape) ? toolBarItem.width : 0
        height: (tobIsLandScape) ? toolBarItem.width * 0.3 : 0
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        text: Qt.formatTime(new Date(),"hh:mm") + "\n" + Qt.formatDate(new Date(), "dd/MM/yy")
        verticalAlignment: Text.AlignBottom
        horizontalAlignment: Text.AlignHCenter
        font.family: "Helvetica"
        font.pixelSize:  toolBarItem.width * 0.095//20
        color: Style.toolBar.timeDateColor
        enabled: false
        visible: false // avoid visual effects during start up
        Rectangle {border.color: "blue"; color: "transparent"; anchors.fill: parent; visible: gridView}
    }

    TextArea {
        id: timeDatePortrait
        width: (tobIsLandScape) ? 0 : (2 * toolBarItem.height * sizeFactor) + buttonSpacing
        height: (tobIsLandScape) ?  0 : toolBarItem.height * 0.2
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        text: timeDateLandScape.text.replace("\n", "  ")
        verticalAlignment: Text.AlignVCenter//Text.AlignTop
        horizontalAlignment:  Text.AlignRight//Text.AlignHCenter
        font.family: timeDateLandScape.font.family
        font.pixelSize: toolBarItem.height * 0.097//20
        color: timeDateLandScape.color
        enabled: timeDateLandScape.enabled
        visible: false // avoid visual effects during start up
        Rectangle {border.color: "green"; color: "transparent"; anchors.fill: parent; visible: gridView}
    }

    Image{
        id: connectStateImg
        property bool connected: false
        height: (tobIsLandScape) ? toolBarItem.width  * 0.17 : toolBarItem.height * 0.2
        width: height
        anchors.left: (tobIsLandScape) ? timeDateLandScape.left : timeDatePortrait.left
        anchors.leftMargin: (tobIsLandScape) ?  height * 0.4 : - height * 0.2
        anchors.verticalCenter: (tobIsLandScape) ? timeDateLandScape.verticalCenter : timeDatePortrait.verticalCenter
        source: (connected) ? "Images/outline_link_white_24.png" : "Images/outline_link_off_white_24.png"
        visible: false // avoid visual effects during start up
        opacity: 0.7
        Timer {
            repeat: true
            running: !parent.connected
            onTriggered: {
                interval = (connectStateImg.visible) ? 500 : 3000
                connectStateImg.visible = !connectStateImg.visible
            }
            onRunningChanged: connectStateImg.visible = true
        }
        Rectangle {border.color: "red"; color: "transparent"; anchors.fill: parent; visible: gridView}
    }

    Rectangle{
        id: bateryLandScapePositioner
        height: connectStateImg.height
        width: connectStateImg.width
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.rightMargin: parent.height * 0.02
        opacity: 0.3
        visible: false // true for debug purposes
    }

    Image{
        id: batteryImg
        z: 3
        height: connectStateImg.height
        width: connectStateImg.width
        anchors.left: (tobIsLandScape) ? undefined : parent.left
        anchors.verticalCenter: (tobIsLandScape) ? undefined : timeDatePortrait.verticalCenter
        anchors.horizontalCenter: (tobIsLandScape) ? bateryLandScapePositioner.horizontalCenter : undefined
        anchors.bottom: (tobIsLandScape) ? bateryLandScapePositioner.bottom : undefined
        opacity: 0.8
        source: updateBateryInfo(batteryLevel)
        Rectangle {border.color: "orange"; color: "transparent"; anchors.fill: parent; visible: gridView}
    }

    TextArea {
        id: batteryCharge
        height: (tobIsLandScape) ? timeDateLandScape.height * 0.5 : timeDatePortrait.height
        width: height * 1.6
        anchors.left: (tobIsLandScape) ? undefined :batteryImg.right
        anchors.right: (tobIsLandScape) ? parent.right : undefined
        anchors.rightMargin: (tobIsLandScape) ? parent.height * 0.01 : 0
        anchors.bottom: (tobIsLandScape) ? batteryImg.top : timeDatePortrait.anchors.bottom
        anchors.bottomMargin: (tobIsLandScape) ? - height * 0.4 : 0
        verticalAlignment: timeDatePortrait.verticalAlignment
        horizontalAlignment:  (tobIsLandScape) ? Text.AlignHCenter : Text.AlignLeft
        font.family: timeDatePortrait.font.family
        font.pixelSize:  (tobIsLandScape) ? timeDateLandScape.font.pixelSize * 0.7 : timeDatePortrait.font.pixelSize
        enabled: timeDatePortrait.enabled
        visible: timeDatePortrait.visible
        color: timeDatePortrait.color
        text: batteryLevel + "%"
        Rectangle {border.color: "pink"; color: "transparent"; anchors.fill: parent; visible: gridView}
    }

    Timer {
        id: timer
        interval: 900
        repeat: true
        running: true
        onTriggered: {
            timeDateLandScape.text = Qt.formatTime(new Date(),"hh:mm") + "\n" + Qt.formatDate(new Date(), "dd/MM/yy")
        }
    }

//    Rectangle{
//        id: batteryInfoDebugTool
//        width: parent.width
//        height: parent.height * 0.5
//        color: "pink"
//        Slider{
//            id: debugSlider
//            width: parent.width * 0.9
//            anchors.centerIn: parent
//            from: 0
//            to: 100
//            value: 0
//            onValueChanged: batteryLevel = Math.round(value)
//        }
//        Label{
//            color: "black"
//            width: parent.width
//            height: parent.height * 0.25
//            anchors.top: parent.top
//            text: batteryLevel
//            horizontalAlignment: Text.AlignHCenter
//        }
//        Switch {
//            id: toggleSwitch
//            width: parent.width * 0.2
//            height: parent.height * 0.5
//            checked: false
//            onCheckedChanged: isBatteryCharging = checked
//        }
//    }

    Rectangle {border.color: "tomato"; color: "transparent"; anchors.fill: parent; visible: gridView}
}




//TextArea {
//    id: timeDateLandScape
//    width: (tobIsLandScape) ? toolBarItem.width : 0
//    height: (tobIsLandScape) ? toolBarItem.width * 0.3 : 0
//    anchors.right: parent.right
//    anchors.bottom: parent.bottom
//    text: Qt.formatTime(new Date(),"hh:mm") + "\n" + Qt.formatDate(new Date(), "dd/MM/yy")
//    verticalAlignment: Text.AlignBottom
//    horizontalAlignment: Text.AlignHCenter
//    font.family: "Helvetica"
//    font.pixelSize:  toolBarItem.width * 0.095//20
//    color:"#BBBBBB"
//    enabled: false

//    Rectangle {border.color: "blue"; color: "transparent"; anchors.fill: parent; visible: gridView}
//}

//TextArea {
//    id: timeDatePortrait
//    width: (tobIsLandScape) ? 0 : (2 * toolBarItem.height * sizeFactor) + buttonSpacing
//    height: (tobIsLandScape) ?  0 : toolBarItem.height * 0.2
//    anchors.right: parent.right
//    anchors.bottom: parent.bottom
//    text: timeDateLandScape.text.replace("\n", "  ")
//    verticalAlignment: Text.AlignTop
//    horizontalAlignment:  Text.AlignHCenter
//    font.family: timeDateLandScape.font.family
//    font.pixelSize: toolBarItem.height * 0.097//20
//    color: timeDateLandScape.color
//    enabled: timeDateLandScape.enabled

//    Rectangle {border.color: "green"; color: "transparent"; anchors.fill: parent; visible: gridView}
//}

//Image{
//    id: connectStateImg
//    height: (tobIsLandScape) ? timeDateLandScape.width  * 0.2 : timeDatePortrait.height
//    width: height
////        anchors.right: (tobIsLandScape) ? timeDateLandScape.left : timeDatePortrait.left
//    anchors.left: (tobIsLandScape) ? timeDateLandScape.left : timeDatePortrait.left
//    anchors.verticalCenter: (tobIsLandScape) ? timeDateLandScape.verticalCenter : timeDatePortrait.verticalCenter
//    source: "Images/outline_link_off_white_48.png"
//    Rectangle {border.color: "red"; color: "transparent"; anchors.fill: parent; visible: gridView}
//}
