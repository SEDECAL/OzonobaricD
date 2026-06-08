// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright (C) 2024 Sedecal S.A.
// This file is part of OzonobaricD.
// See LICENSE file for details.

import QtQuick 2.15
import QtQuick.Controls 2.5
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtGraphicalEffects 1.12
import AppStyle 1.0

ExpandArea{
    id: configArea

    property bool gridView: false

    property alias deviceInfo: deviceInfo
    property alias deviceCalibration: deviceCalibration

    signal editing()
    signal editionEnd()
    signal startUpNeeded()

    radius: parent.height * 0.006
    color: Style.configurationArea.backColor
    animationTime: 500
    expandOnClicked: true

    x_s: parent.width * 0.5
    y_s: parent.height * 0.5

    height: 0
    width: 0
    visible: false

    onStateChanged: if(state === "big") editing()
                    else controls.visible = false

    onExpansionEnd: controls.visible = true


    onExpansionStart: {
        // Bug 9792: Calibration menu wrong initialized
        // (calibration menu elements wrong init after reset, start bug solution)
        deviceCalibration.focusAllCard()
        deviceCalibration.retractAllInfoCard()
        deviceCalibration.lockControls()
        deviceCalibration.periodCalibrationInfo.state = "waiting"
        // (calibration menu elements wrong init after reset, end bug solution)
    }

    Item{
        id: controls
        visible: false
        anchors.fill: parent

        property bool blocked: false

        onBlockedChanged: backButton.visible = !controls.blocked

        MouseArea{
            // Walk around
            // When text on a editable InfoCard gets focus, keyboard is automatically
            // opened. When the keyboard is closed by the user the focus remains on
            // text frame with the cursor blinking (extrange visual effect).
            // This invisible component solves the problem.
            // In other hand, when the keyboard is opened, it is only be closed by
            // clicking 'keyboard close button'. This mouse area allows to close it
            // just by clicking outside the key board.
            z: 10
            height: parent.height * 2
            width: parent.width * 2
            anchors.centerIn: parent
            propagateComposedEvents:  true
            onPressed: {
                mouse.accepted = false
                tabView.forceActiveFocus()
            }
        }

        Image{
            id: backButton
            z:10
            visible: true // !controls.blocked
            height: 80
            width: height
            anchors.right: parent.right
            anchors.rightMargin: 10
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 15
            source: "Images/baseline_cancel_blue_48.png"
            layer.enabled: true//Style.customerName.shadowEnable
            layer.effect: DropShadow { radius: Style.configurationArea.backButtonShadowRadius
                                       color:  Style.configurationArea.backButtonShadowColor }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    controls.visible = false
                    configArea.retract()
                    editionEnd()
                }
            }
        }

        TabView {
            id: tabView
            enabled: !controls.blocked
            width: parent.width
            height: parent.height * 0.106
            currentIndex: 0
            onCurrentIndexChanged: swipeView.currentIndex = currentIndex
            style: TabViewStyle {
                frameOverlap: 1
                tab: Rectangle {
                  color: styleData.selected ? Style.configurationArea.tabViewColor : Style.configurationArea.tabViewDisabledColor
//                    color: styleData.selected ? "#2B2F34" :"#212427"

//                    border.color: "transparent"// "#2B2F34"//Style.configurationArea.backColor
                    implicitWidth: tabView.width * 0.5
                    implicitHeight: tabView.height
                    radius:0
                    Image{
                        height: parent.height * 0.8
                        width: height
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.leftMargin: 25
                        opacity: styleData.selected ? 1 : 0.3
                        source: (styleData.index) ? ( (deviceCalibration.locked) ? "Images/outline_build_locked.png" : "Images/outline_build_unlocked_1.png" ) : "Images/outline_info_white_1.png"
                    }
                }
                frame: Rectangle { color: Style.configurationArea.backColor }
            }
            Tab { id: tab1 }
            Tab { id: tab2 }
        }

        SwipeView {
            id: swipeView
            clip: true
            height: parent.height - tabView.height
            width: parent.width
            currentIndex: 0
            interactive: !controls.blocked
            anchors.bottom: parent.bottom

            onCurrentIndexChanged: tabView.currentIndex = currentIndex


            Item {
                id: infoControls
                DeviceInfo{
                    id: deviceInfo
                    verticalSpacing: 12
                    horizontalSpacing: 8
                    anchors.fill: parent
                    anchors.margins: 18
                    onBlockedChanged: controls.blocked = blocked
                }
            }

            Item {
                id: calibrationControls
                DeviceCalibration{
                    id: deviceCalibration
                    verticalSpacing: 12
                    horizontalSpacing: 8
                    anchors.fill: parent
                    anchors.margins: 18
                    widthWhenExpanded: configArea.width_b
                    onBlockedChanged: controls.blocked = blocked
                    onCalibrationChanged: startUpNeeded()
                    onCalibrationStart: backButton.visible = false
                    onCalibrationEnd: backButton.visible = true
                    linkGeneratorInfo.onLinkedDeviceChanged: {
                        deviceInfo.bluetoothInfo.state = !linkGeneratorInfo.linkedDevice ? "noTargetDev" :
                                                          linkGeneratorInfo.linkResult ? "connected" : "disconnected"
                    }
                }
            }
        }

        Rectangle {border.color: "gold"; color: "transparent"; anchors.fill: parent; visible: gridView}
    }
}

// Just tabView version

//    Item{
//        id: controls
//        visible: false
//        anchors.fill: parent

//        Image{
//            id: backButton
//            z:10
//            height: 80
//            width: height
//            anchors.right: parent.right
//            anchors.rightMargin: 20
//            anchors.top: parent.top
//            anchors.topMargin: 30
////          anchors.bottom: parent.bottom
////          anchors.bottomMargin: 20
//            source: "Images/baseline_cancel_white_48.png"
//            layer.enabled: true//Style.customerName.shadowEnable
//            layer.effect: DropShadow { radius: 15 }//Style.customerName.shadowRadius }
//            MouseArea {
//                anchors.fill: parent
//                onClicked: {
//                    controls.visible = false
//                    configArea.retract()
//                    editionEnd()
//                }
//            }
//        }

//        TabView {
//            anchors.fill: parent
//            anchors.margins: 0

//            style: TabViewStyle {
//                frameOverlap: 1
//                tab: Rectangle {
//                    color: styleData.selected ? Style.configurationArea.backColor :"#1A1A1A"
//                    border.color:  Style.configurationArea.backColor
//                    implicitWidth: controls.width * 0.5//Math.max(text.width + 4, 80)
//                    implicitHeight: 85
//                    radius:0
//                    Image{
//                        height: parent.height * 0.8
//                        width: height
//                        anchors.verticalCenter: parent.verticalCenter
//                        anchors.left: parent.left
//                        anchors.leftMargin: 25
//                        source: (styleData.index) ? "Images/outline_build.png" : "Images/outline_info_white.png"
//                        opacity: styleData.selected ? 1 : 0.3
//                    }
//                }
//                frame: Rectangle { color: Style.configurationArea.backColor }
//            }

//            Tab {
//                id: infoControls
//                anchors.fill: parent
//                anchors.topMargin: parent.height * 0.02
//                anchors.bottomMargin: anchors.topMargin
//                anchors.leftMargin: anchors.topMargin
//                anchors.rightMargin: anchors.topMargin

//                DeviceInfo{}
//            }

//            Tab {
//                id: calibrationControls
//            }
//        }
//    }


