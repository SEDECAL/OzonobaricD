// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright (C) 2024 Sedecal S.A.
// This file is part of OzonobaricD.
// See LICENSE file for details.

import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.5

RadioButton {
    id: control
    text: qsTr("RadioButton")
    checked: true

    property color color: "white"
    property color textColor: "#AAAAAA"
    property color checkedColor: "steelblue"

    indicator: Rectangle {
        implicitWidth: 20
        implicitHeight: implicitWidth
        x: control.leftPadding
        y: (parent.height - height) * 0.5
        radius: implicitWidth * 0.5
        border.color: control.color
        border.width: 3
        color:"transparent"

        Rectangle {
            width: parent.width - parent.border.width - 3
            height: width
            anchors.centerIn: parent
            radius: width * 0.5
            color: control.checked ? control.checkedColor: "transparent"
            visible: control.checked
        }
    }

    contentItem: Text {
        text: control.text
        font: control.font
        opacity: enabled ? 1.0 : 0.3
        color: control.checked ? control.color : control.textColor
        verticalAlignment: Text.AlignVCenter
        leftPadding: control.indicator.width + control.spacing

    }
}

