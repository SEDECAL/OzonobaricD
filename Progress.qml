// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright (C) 2024 Sedecal S.A.
// This file is part of OzonobaricD.
// See LICENSE file for details.

import QtQuick 2.12
import QtQuick.Window 2.12

Item{
    id: pb
    implicitWidth: 50
    implicitHeight: 200

//    height: implicitHeight
//    width: implicitWidth

    property bool gridView: false

    property color mainColor: "darkgrey"
    property color backColor: "lightgrey"
    property double from: 0
    property double to: 100
    property double range: to - from
    property double value: 45
    property string units: "_units_"
    property string type: ""
    property string altValue: ""

    readonly property double textMargin: pb.height * 0.05
    readonly property double textHeight: pb.height * 0.125
    readonly property double textWidth:  pb.textHeight * 5
    readonly property double unitsPixelSize: pb.height * 0.075
    readonly property double valuePixelSize: pb.height * 0.100
    readonly property double itemRadius: pb.height * 0.008

    readonly property double wholeHeihgt: height
    readonly property double barHeihgt: height - (textMargin * 2) - (textHeight * 2)
    readonly property double barY: textMargin + textHeight

    readonly property double indicator: pbMain.y

    function resolveValue(){
        if(pb.value >= pb.to) {
            return pb.barHeihgt
        }else if(pb.value <= pb.from) {
            return 0
        }else{
            return ( (pb.barHeihgt * (pb.value - pb.from)) / pb.range )
        }
    }

    Rectangle{
        id: pbBack
//      anchors.fill: parent
        width: parent.width
        height: pb.barHeihgt
        y: pb.barY
        color: pb.backColor
        radius: itemRadius
    }
    Rectangle{
        id: pbMain
        anchors.left: pbBack.left
        anchors.bottom: pbBack.bottom
        color: pb.mainColor
        width: parent.width
        radius: itemRadius
//      height: (parent.height * pb.value) / pb.to
        height: resolveValue()
    }
    Text{
        id: unitsTxt
        height: pb.textHeight
        width: pb.textWidth
        anchors.top: parent.top
//      anchors.topMargin: - pb.textMargin - height
        anchors.horizontalCenter: parent.horizontalCenter
        verticalAlignment: Text.AlignBottom//.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        text: pb.units
        font.family: "Helvetica"
        font.pointSize: pb.unitsPixelSize ? pb.unitsPixelSize : 1  // avoid system warning at start up (Point size <= 0 (0.000000), must be greater than 0)
        color: pb.mainColor
        Rectangle {border.color: "tomato"; color: "transparent"; anchors.fill: parent; visible: gridView}
    }
    Text{
        id: valueTxt
        height: pb.textHeight
        width: pb.textWidth
        anchors.bottom: parent.bottom
//      anchors.bottomMargin: - pb.textMargin - height
        anchors.horizontalCenter: parent.horizontalCenter
        verticalAlignment: Text.AlignTop//.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        text: (pb.altValue === "") ? pb.value : ""
        font.family: "Helvetica"
        font.pointSize: pb.valuePixelSize ? pb.valuePixelSize : 1  // avoid system warning at start up (Point size <= 0 (0.000000), must be greater than 0)
        color: pb.backColor
        Rectangle {border.color: "tomato"; color: "transparent"; anchors.fill: parent; visible: gridView}
    }
    Text{
        id: altValueTxt
        x: valueTxt.x
        y: valueTxt.y
        height: valueTxt.height
        width: valueTxt.width
        verticalAlignment: valueTxt.verticalAlignment
        horizontalAlignment: valueTxt.horizontalAlignment
        font.family: valueTxt.font.family
        font.pointSize: valueTxt.font.pointSize
        color: valueTxt.color
        text: pb.altValue
        Rectangle {border.color: "pink"; color: "transparent"; anchors.fill: parent; visible: gridView}
    }

}


