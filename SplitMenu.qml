// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright (C) 2024 Sedecal S.A.
// This file is part of OzonobaricD.
// See LICENSE file for details.

import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Layouts 1.3

Item {
    id: mainArea

    property bool   gridView: false
    property bool   opacityEffect: true
    property bool   smIsPortrait: true
    property bool   smIsLandScape: !smIsPortrait
    property int    smViewTime: 1000
    property double smSize: 100
    property double splitVelocity: 800
    property double smReducedPercent: 15
    property double smReducedSice: (splitMenuModel.count * smSize * smReducedPercent / 100)

    property alias splitMenuModel: splitMenuModel

    signal smClicked(string smId, string smIcon)
//  signal smTimeOut()

    function clamp(number, min, max) {
      return Math.max(min, Math.min(number, max));
    }

    function opacityFactory(index) {
        return 0.6 - (0.2 * index)
    }

    function applyOpacity() {
        for(var i = 0; i < myRep.count ; i++) myRep.itemAt(i).opacity = opacityFactory(i)
    }

    function removeOpacity() {
        for(var i = 0; i < myRep.count ; i++) myRep.itemAt(i).opacity = 1
    }

    function split(){
        // transparent color is asigned to simulated items
        // simulated items are only created to occupy physical space
        if(myRep.itemAt(0).color !== "transparent")
        {
            removeOpacity()

            if(smIsLandScape)
                mainArea.width = splitMenuModel.count * smSize
            else
                mainArea.height = splitMenuModel.count * smSize
        }

        viewTimer.restart()
//        if(myRep.count > 1){
//            viewTimer.restart()
//        }
//        else{
//            viewTimer.stop()
//        }
    }

    function retract(){
        applyOpacity()

        if(smIsLandScape)
            mainArea.width = smReducedSice
        else
            mainArea.height = smReducedSice

        viewTimer.stop()
    }

    function resize(){
        var tmp = splitVelocity
        splitVelocity = -1
        smReducedSice = splitMenuModel.count * smSize * smReducedPercent / 100
        mainArea.height = (smIsLandScape) ? smSize : smReducedSice
        mainArea.width = (smIsLandScape) ? smReducedSice : smSize
        splitVelocity = tmp
        applyOpacity()
    }

    function count(){
        return myRep.count
    }

    height: (smIsLandScape) ? smSize : smReducedSice
    width: (smIsLandScape) ? smReducedSice : smSize

    onWidthChanged: smGrid.columnSpacing = clamp(mainArea.width * 0.05, 2, 5)
    onHeightChanged: smGrid.rowSpacing = clamp(mainArea.height * 0.05, 2, 5)

    Behavior on width  { SmoothedAnimation{ velocity: splitVelocity } }
    Behavior on height { SmoothedAnimation{ velocity: splitVelocity } }

    onSmSizeChanged: resize()
    onSmIsLandScapeChanged: resize()

    ListModel {
        id: splitMenuModel
//        ListElement { smColor: "lightblue"; smId: "myId"; smIcon: "Images/round_flow_black_48.png" }
    }

    Component{
        id: splitMenuDelegate
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: smColor
            radius: (smSize * 0.04)
            opacity: opacityFactory(index)
            //border.color: "#111111"
//          avoid round corners on left/up side of button when retracted
//            Rectangle{
//                width: (smIsLandScape) ? (smSize * 0.03) : parent.width
//                height: (smIsLandScape) ? parent.height : (smSize * 0.03)
//                color: smColor
//                visible: {
//                    if (smIsLandScape) (parent.width < (smSize * 0.9)) ? true : false
//                    else (parent.height < (smSize * 0.9)) ? true : false
//                }
//            }
            Image{
                anchors.fill: parent
                source: smIcon
                visible: {
                    if (smIsLandScape) (parent.width > (smSize * smReducedPercent * 2 / 100)) ? true : false
                    else (parent.height > (smSize * smReducedPercent * 2 / 100)) ? true : false
                }
            }
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    console.log("split menu element clicked:", index, "-->", smId)
                    smClicked(smId, smIcon)
                    retract()
                }
            }
        }
    }

    GridLayout {
        id: smGrid
        anchors.fill: parent
        flow: (smIsLandScape) ? GridLayout.LeftToRight : GridLayout.TopToBottom
        columnSpacing: clamp(smSize * 0.05, 2, 5)
        rowSpacing: columnSpacing
        Repeater {
            id: myRep
            model: splitMenuModel
            delegate: splitMenuDelegate
        }
    }

    Timer{
        id: viewTimer
        interval: smViewTime//closeSubmenuTimerInterval
        onTriggered: {
            retract()
//          smTimeOut()
        }
    }

    Rectangle {border.color: "green"; color: "transparent"; anchors.fill: parent; visible: gridView}
}



/*

import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Layouts 1.3


Item {
    id: mainArea

    property bool   gridView: true
    property bool   opacityEffect: true
    property bool   smIsPortrait: true
    property bool   smIsLandScape: !smIsPortrait
    property double smSize: 100
    property double splitVelocity: 800
    property double smReducedPercent: 15
    property double smReducedSice: (splitMenuModel.count * smSize * smReducedPercent / 100)

    property alias splitMenuModel: splitMenuModel

    signal smClicked(string smId, string smIcon)

    function clamp(number, min, max) {
      return Math.max(min, Math.min(number, max));
    }

    function opacityFactory(index) {
        return 0.6 - (0.2 * index)
    }

    function applyOpacity() {
        for(var i = 0; i < myRep.count ; i++) myRep.itemAt(i).opacity = opacityFactory(i)
    }

    function removeOpacity() {
        for(var i = 0; i < myRep.count ; i++) myRep.itemAt(i).opacity = 1
    }

    function split(){
        // transparent color is asigned to simulated items
        // simulated items are only created to occupy physical space
        if(myRep.itemAt(0).color !== "transparent")
        {
            removeOpacity()

            if(smIsLandScape)
                mainArea.width = splitMenuModel.count * smSize
            else
                mainArea.height = splitMenuModel.count * smSize
        }
    }

    function retract(){
        applyOpacity()

        if(smIsLandScape)
            mainArea.width = smReducedSice
        else
            mainArea.height = smReducedSice
    }

    height: (smIsLandScape) ? smSize : smReducedSice
    width: (smIsLandScape) ? smReducedSice : smSize

    onWidthChanged: smGrid.columnSpacing = clamp(mainArea.width * 0.05, 2, 5)
    onHeightChanged: smGrid.rowSpacing = clamp(mainArea.height * 0.05, 2, 5)

    Behavior on width  { SmoothedAnimation{ velocity: splitVelocity } }
    Behavior on height { SmoothedAnimation{ velocity: splitVelocity } }

    onSmIsLandScapeChanged: {
        var tmp = splitVelocity
        splitVelocity = -1
        mainArea.height = (smIsLandScape) ? smSize : smReducedSice
        mainArea.width = (smIsLandScape) ? smReducedSice : smSize
        splitVelocity = tmp
        applyOpacity()
    }
//    onSmSizeChanged:
//    {
//        console.log("-- smSize: ", smSize, "mainArea.height: ", mainArea.height, "mainArea.width: ", mainArea.width)
//        var tmp = splitVelocity
//        splitVelocity = -1
//        splitVelocity = tmp
//    }

    ListModel {
        id: splitMenuModel
//        ListElement { smColor: "lightblue"; smId: "myId"; smIcon: "Images/round_flow_black_48.png" }
    }

    Component{
        id: splitMenuDelegate
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: smColor
            radius: (smSize * 0.04)
            opacity: opacityFactory(index)
//          avoid round corners on left/up side of button when retracted
//          Rectangle{
//              width: (smIsLandScape) ? (smSize * 0.06) : parent.width
//              height: (smIsLandScape) ? parent.height : (smSize * 0.06)
//              color: smColor
//              visible: {
//                  if (smIsLandScape) (parent.width < (smSize * 0.9)) ? true : false
//                  else (parent.height < (smSize * 0.9)) ? true : false
//              }
//          }
            Image{
                anchors.fill: parent
                source: smIcon
                visible: {
                    if (smIsLandScape) (parent.width > (smSize * smReducedPercent * 2 / 100)) ? true : false
                    else (parent.height > (smSize * smReducedPercent * 2 / 100)) ? true : false
                }
            }
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    console.log("split menu element clicked:", index, "-->", smId)
                    smClicked(smId, smIcon)
                }
            }
        }
    }

    GridLayout {
        id: smGrid
        anchors.fill: parent
        flow: (smIsLandScape) ? GridLayout.LeftToRight : GridLayout.TopToBottom
        columnSpacing: clamp(smSize * 0.05, 2, 5)
        rowSpacing: columnSpacing
        Repeater {
            id: myRep
            model: splitMenuModel
            delegate: splitMenuDelegate
        }
    }

    Rectangle {border.color: "green"; color: "transparent"; anchors.fill: parent; visible: gridView}
}

*/
