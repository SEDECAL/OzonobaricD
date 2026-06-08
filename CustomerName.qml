// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright (C) 2024 Sedecal S.A.
// This file is part of OzonobaricD.
// See LICENSE file for details.

import QtQuick 2.12
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.12
import AppStyle 1.0

Item{
    property alias text: cnText.text

    Text {
        id: cnText
        anchors.fill: parent
        text: "---"
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment:  Text.AlignHCenter
        font.family: "Helvetica"
        font.pixelSize: height
        fontSizeMode: Text.Fit
        color: Style.customerName.fontColor

        layer.enabled: Style.customerName.shadowEnable
        layer.effect: DropShadow { radius: Style.customerName.shadowRadius }
    }
}


