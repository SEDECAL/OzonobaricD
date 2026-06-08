// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright (C) 2024 Sedecal S.A.
// This file is part of OzonobaricD.
// See LICENSE file for details.

import QtQuick 2.12

//AnimatedImage {
//    property bool gridView: false

//    height: 100
//    width: 100
//    source: "Images/sedecal-OM302-2-3-seg_Modified_B01.gif"
//    visible: false
//    playing: visible
//    onVisibleChanged: currentFrame = 0

//    Rectangle {border.color: "tomato"; color: "transparent"; anchors.fill: parent; visible: gridView}
//}

Molecule {
    property bool gridView: false

    height: parent.height
    width: height
    visible: false
    playing: visible

    Rectangle {border.color: "tomato"; color: "transparent"; anchors.fill: parent; visible: gridView}
}
