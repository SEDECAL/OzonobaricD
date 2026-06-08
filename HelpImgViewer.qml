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
    id: helpImgViewer

    property bool gridView: false
    property string source: ""


    signal editing()

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

    onExpansionStart: {}

    Item{
        id: controls
        visible: false
        anchors.fill: parent

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
                    helpImgViewer.retract()
                }
            }
        }

        Image{
            anchors.centerIn: parent
            height: parent.height * 0.95
            width: parent.width * 0.95
            source: helpImgViewer.source
            Rectangle {border.color: "pink"; color: "transparent"; anchors.fill: parent; visible: gridView}
        }
        Rectangle {border.color: "gold"; color: "transparent"; anchors.fill: parent; visible: gridView}
    }
}
