// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright (C) 2024 Sedecal S.A.
// This file is part of OzonobaricD.
// See LICENSE file for details.

import QtQuick 2.2
import QtQuick.Window 2.15
import QtQuick.Extras 1.4
import QtQuick.Controls 1.1
import QtLocation 5.6
import QtGraphicalEffects 1.0
import QtQuick.Controls.Styles 1.4
import AppImages 1.0
import AppStyle 1.0


//  Note: problems reconfiguring pie menu depending on screen position (portrait or landscape) solved.
//        Changing 'startAngle' and 'endAngle' on PieMenuStyle depending on 'pmIsLandScape' value generates
//        pie menu appearance distorsion (in shpae and opacity).
//        The problem has been solved using a walk around by means of rotation property on 'pieMenu' and
//        rotated images on pie MenuItem icons.


Item {
    property int pieMenuWidth: 0
    property int hmViewTime: 1000
    property bool isVisible: pieMenu.visible
    property bool pmIsPortrait: true
    readonly property bool pmIsLandScape: !pmIsPortrait

    width: 0
    height: width

    function popUp(){
        pieMenu.popup()
        hmViewTimer.restart()
    }

    function disableItems(itemList){

        if(!arguments.length) {
            itemList = ["manual", "tutorial_video", "diagram", "protocol_video"]
        }

        for(var i = 0; i < itemList.length ; i++) {
            switch(itemList[i]){
            case "manual": manualOpt.enabled = false
                break
            case "tutorial_video": tutorialOpt.enabled = false
                break
            case "diagram": diagramOpt.enabled = false
                break
            case "protocol_video": protocolOpt.enabled = false
                break
            }
        }
    }

    function enableItems(itemList){

        if(!arguments.length) {
            itemList = ["manual", "tutorial_video", "diagram", "protocol_video"]
        }

        for(var i = 0; i < itemList.length ; i++) {
            switch(itemList[i]){
            case "manual": manualOpt.enabled = true
                break
            case "tutorial_video": tutorialOpt.enabled = true
                break
            case "diagram": diagramOpt.enabled = true
                break
            case "protocol_video": protocolOpt.enabled = true
                break
            }
        }
    }

    signal cliked(string helpType)

    Component.onCompleted: {pieMenuWidth = width; width = 10}

    PieMenu {
        id: pieMenu
        width: parent.width
        height: width
        anchors.centerIn: parent

        rotation: pmIsLandScape ? 0 : 90

        Behavior on width {SmoothedAnimation{velocity:  2000}}

        style: PieMenuStyle {
            id: pieStyle
            backgroundColor: Style.helpMenu.backColor
            selectionColor : Style.helpMenu.selectColor
            startAngle: 30
            endAngle: -210
//          startAngle: (pmIsLandScape ? 30 : 120)      // force repainting to avoid disagreements when orientation changes
//          endAngle:   (pmIsLandScape ? -210 : -120)   // force repainting to avoid disagreements when orientation changes
            shadowColor: Qt.rgba(0, 0, 0, 0.8)
        }

        MenuItem {
            id: manualOpt
            onTriggered: cliked("manual")
            iconSource: enabled ? (pmIsLandScape ? Img.helpMenu.manual : Img.helpMenu.manual_Rotation_90) : (pmIsLandScape ? Img.helpMenu.manual_disabled : Img.helpMenu.manual_Rotation_90_disabled)
        }
        MenuItem {
            id: tutorialOpt
            onTriggered: cliked("tutorial_video")
            iconSource: enabled ? (pmIsLandScape ? Img.helpMenu.tutorial : Img.helpMenu.tutorial_Rotation_90) : (pmIsLandScape ? Img.helpMenu.tutorial_disabled : Img.helpMenu.tutorial_Rotation_90_disabled)
        }
        MenuItem {
            id: diagramOpt
            onTriggered: cliked("diagram")
            iconSource: enabled ? (pmIsLandScape ? Img.helpMenu.connection : Img.helpMenu.connection_Rotation_90) : (pmIsLandScape ? Img.helpMenu.connection_disabled : Img.helpMenu.connection_Rotation_90_disabled)
        }
        MenuItem {
            id: protocolOpt
            onTriggered: cliked("protocol_video")
            iconSource: enabled ? (pmIsLandScape ? Img.helpMenu.video : Img.helpMenu.video_Rotation_90) : (pmIsLandScape ? Img.helpMenu.video_disabled : Img.helpMenu.video_Rotation_90_disabled)
        }
        onVisibleChanged: parent.width = visible ? pieMenuWidth : 10 // force repainting to avoid disagreements when orientation changes
    }

    Timer{
        id: hmViewTimer
        interval: hmViewTime
        onTriggered: pieMenu.visible = false
    }
}
