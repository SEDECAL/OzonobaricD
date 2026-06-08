// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright (C) 2024 Sedecal S.A.
// This file is part of OzonobaricD.
// See LICENSE file for details.

import QtQuick 2.0
import QtQuick.Controls 2.15

Item {
    property bool gridView: false

    function update(value){
        sensorSelector.checked = !value // inverted logic to improve style
    }

    signal selectionChanged(bool value)

    Row{
        id: itemsRow
        anchors.verticalCenter: parent.verticalCenter
      //anchors.horizontalCenter: parent.horizontalCenter
        Switch{
            id: sensorSelector
            rotation: 180   // inverted logic to improve style
            Rectangle {border.color: "green"; color: "transparent"; anchors.fill: parent; visible: gridView}
        }

        Label{
            id: rightText
            Rectangle {border.color: "blue"; color: "transparent"; anchors.fill: parent; visible: gridView}
            text: qsTr("O3 sensor")
            opacity: sensorSelector.checked ? 0.2 : 1  // inverted logic to improve style
            color: "white" ///  TODO  style
            font.pixelSize: 21  ///  TODO  style
            anchors.verticalCenter: sensorSelector.verticalCenter
        }
    }
    MouseArea{
        z: 3
        width: itemsRow.width
        height: parent.height
        anchors.left: itemsRow.left
        onClicked:{
            sensorSelector.checked = !sensorSelector.checked
            selectionChanged(!sensorSelector.checked) // inverted logic to improve style
        }
        Rectangle {border.color: "tomato"; color: "transparent"; anchors.fill: parent; visible: gridView}
    }
    Rectangle {border.color: "yellow"; color: "transparent"; anchors.fill: parent; visible: gridView}
}

/*
Item {
    property bool gridView: true
    property bool updated: false

    function update(value){
        if(sensorSelector.checked !== value){
            sensorSelector.checked = value
            updated = true
        }
    }

    signal selectionChanged(bool value)

    Row{
        anchors.verticalCenter: parent.verticalCenter
//      anchors.horizontalCenter: parent.horizontalCenter
        Switch{
            id: sensorSelector
            // rotation: 180
            onCheckedChanged: {
                if(!updated){
                    selectionChanged(checked)
                }
                updated = false
            }
            Rectangle {border.color: "green"; color: "transparent"; anchors.fill: parent; visible: gridView}
        }

        Label{
            id: rightText
            Rectangle {border.color: "blue"; color: "transparent"; anchors.fill: parent; visible: gridView}
            text: qsTr("O3 sensor")
            opacity: sensorSelector.checked ? 1 : 0.2// : 1  // inverted logic to improve style
            color: "white" ///  TODO  style
            font.pixelSize: 21  ///  TODO  style
            anchors.verticalCenter: sensorSelector.verticalCenter
//            MouseArea{
//                anchors.centerIn: parent
//                width: parent.width
//                height: parent.height * 3
//                onClicked: value = !value
//            }
        }
    }
    Rectangle {border.color: "yellow"; color: "transparent"; anchors.fill: parent; visible: gridView}



}

*/
