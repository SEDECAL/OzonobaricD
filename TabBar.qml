// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright (C) 2024 Sedecal S.A.
// This file is part of OzonobaricD.
// See LICENSE file for details.

import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Layouts 1.12
import AppStyle 1.0

Item {
    id: tabBarContainer

    property bool gridView: false
    property bool tbIsPortrait: true
    property bool indicatorItemAuraVisible: false
    readonly property bool tbIsLandScape: !tbIsPortrait
    property string backIcon: ""
    property int backIndex: -1
    property double tbScreenFraction: 6
    readonly property double separatorSize: (tbIsLandScape) ? tbGrid.rowSpacing : tbGrid.columnSpacing

    property alias tabBarModel: tabBarModel
                                                      property alias indexArea: indexArea
    signal tabClicked(int tabIndex, string protocolName)

    function clamp(number, min, max) {
      return Math.max(min, Math.min(number, max));
    }

    function tbChangeIcon(index, icon){
        backIndex = index
        backIcon = tabBarModel.get(index).tbIcon
        tabBarModel.setProperty(index, "tbIcon", icon)
        console.log("stored back values: ", backIndex, backIcon)
    }

    function tbRestoreIcon(){
        if(backIndex !== -1){
            tabBarModel.setProperty(backIndex, "tbIcon", backIcon)
            console.log("restored back values: ", backIndex, backIcon)
            backIndex = -1
        }
        else
            console.log("no icon restore needed")
    }


//    function clickSimulation(index, protcol){
//        console.log("tab bar element clicked SIMULATION:")
//        indexArea.position = index
////      tabClicked(index, protcol)
//        tbRestoreIcon()
//    }
    function clickSimulation(index, protcol){
        console.log("tab bar element clicked SIMULATION:", index, protcol)
        indexArea.position = index
        tabClicked(index, protcol)
        tbRestoreIcon()
    }

    height: (tbIsLandScape) ? parent.height : parent.height / tbScreenFraction
    width:  (tbIsLandScape) ? parent.width / tbScreenFraction : parent.width

   onTbIsLandScapeChanged: tbRestoreIcon()

    ListModel {
        id: tabBarModel
//      ListElement { tbColor: "red";   tbIcon: "Images/round_flow_black_48.png" }
    }

    Component {
        id: tabBarDelegate
        Rectangle {
            id: tbButton
            property string protocolName: tbProtocol
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: tbColor
            radius: ((parent.height > parent.width) ? parent.width : parent.height) * 0.03
            Image{
                anchors.centerIn: parent
                source: tbIcon
                height: (parent.height > parent.width) ? parent.width : parent.height
                width: height
            }
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    console.log("tab bar element clicked:", index, tbIcon)
                    indexArea.position = index
                    tabClicked(index, tbProtocol)
                    tbRestoreIcon()
                }
            }
        }
    }
    GridLayout {
        id: tbGrid
        width: (tbIsLandScape) ? parent.width - indexArea.width : parent.width
        height: (tbIsLandScape) ? parent.height : parent.height - indexArea.height
        anchors.left: (tbIsLandScape) ? indexArea.right : parent.left
        anchors.top: (tbIsLandScape) ? parent.top : indexArea.bottom

        flow: (tbIsLandScape) ? GridLayout.TopToBottom : GridLayout.LeftToRight
        rowSpacing: (tbIsLandScape) ? clamp(height * 0.01, 2, 5) : 0
        columnSpacing: (tbIsLandScape) ? 0: clamp(width * 0.01, 2, 5)

        z:3
        Repeater {
            id: tabBarRepeater
            model: tabBarModel
            delegate: tabBarDelegate
        }
    }

    Item {
        id: indexArea
        property int velocity: 0
        property int position: 0
        property int lastPosition: 0

        z:1
        width: (tbIsLandScape) ? parent.width * 0.15 : parent.width
        height: (tbIsLandScape) ? parent.height : parent.height * 0.20

        onPositionChanged: {
            velocity = 200 * Math.abs(lastPosition - position)
            lastPosition = position
        }

        Item {
            id: indicatorArea
            x: (tbIsLandScape) ? 0 : indexArea.position * (width + tbGrid.columnSpacing)
            y: (tbIsLandScape) ? indexArea.position * (height + tbGrid.rowSpacing) : 0
            width: (tbIsLandScape) ? parent.width : ((parent.width - ((tabBarModel.count - 1) * tbGrid.columnSpacing)) / tabBarModel.count)
            height: (tbIsLandScape) ? ((parent.height - ((tabBarModel.count - 1) * tbGrid.rowSpacing)) / tabBarModel.count) : parent.height

            Behavior on x { SmoothedAnimation { velocity: (tbIsLandScape) ? -1 : indexArea.velocity }}
            Behavior on y { SmoothedAnimation { velocity: (tbIsLandScape) ? indexArea.velocity : -1 }}

            Rectangle{
                id: indicatorItem
                height: (tbIsLandScape) ? parent.height * 0.9 : parent.height * 0.5
                width: (tbIsLandScape) ? parent.width * 0.5 : parent.width * 0.9
                anchors.centerIn: parent
                color: Style.tabBar.indicatorColor
                z:2
                radius: ((parent.height > parent.width) ? parent.width : parent.height) * 0.15
                border.color: Style.tabBar.indicatorBorderColor
            }
            Rectangle{
                id: indicatorItemAura
                height: (tbIsLandScape) ? parent.height + (tbGrid.rowSpacing * 2) : tabBarContainer.height * 1.02
                width: (tbIsLandScape) ? tabBarContainer.width * 1.02 : parent.width + (tbGrid.columnSpacing * 2)
                y: (tbIsLandScape) ? -tbGrid.rowSpacing : 0
                x: (tbIsLandScape) ? 0 : -tbGrid.columnSpacing
                color: Style.tabBar.indicatorAuraColor
                radius: ((parent.height > parent.width) ? parent.width : parent.height) * 0.25
                border.color: Style.tabBar.indicatorAuraBorderColor
                visible: indicatorItemAuraVisible
            }
        }
        Rectangle {border.color: "pink"; color: "transparent"; anchors.fill: parent; visible: gridView}
    }
    Rectangle {border.color: "red"; color: "transparent"; anchors.fill: parent; visible: gridView}
}
