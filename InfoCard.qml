// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright (C) 2024 Sedecal S.A.
// This file is part of OzonobaricD.
// See LICENSE file for details.

import QtQuick 2.0
import QtQuick.Controls 2.5

Rectangle{
    id: infoCard
    property bool   gridView: false

    property bool   extensible: false
    property bool   extended: false
    property bool   editEnabled: flase
    property bool   scrollEnabled: flase
    property bool   blocked: false
    property int    maxHeight: 300
    property int    minHeight: 50
    property double vMargin: 0.27   // %
    property double hMargin: 0.025  // %
    property string tittle: "Info card title"
    property color  tittleColor: "steelblue"

    property string text: ""
    property color  textColor: "white"
    property color  edtitableTextColor: "white"

    property string imgExtended: ""
    property string imgRetracted: ""

    readonly property double dataAreaX: columnId.x
    readonly property double dataAreaY: columnId.y + dataArea.y
    readonly property double dataAreaW: dataArea.width
    readonly property double dataAreaH: dataArea.height

    signal userExtension
    signal userRetraction
    signal infoTextChanged(string infoText)

    radius: 5
    color: "#333333"
    width: 350
    height: extended ? maxHeight : minHeight


    // Walk around
    // Working time information is not refresed. To get this information updated it is necessary this
    // piece of code joined to the walk around described at 'onWorkingTimeChanged' in 'deviceInfo.qml'
    onTextChanged: textArea.text = text

    Column{
        id: columnId
        y: infoCard.vMargin * infoCard.minHeight
        height: parent.height - (2 * infoCard.vMargin  * infoCard.minHeight)
        width: parent.width * (1 - (2 * infoCard.hMargin))
        anchors.centerIn: parent
        spacing: 5

        Label{
            id: tittle
            color: infoCard.tittleColor
            height: infoCard.minHeight - (2 * infoCard.vMargin  * infoCard.minHeight)
            width: parent.width
            text: infoCard.tittle
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment:  Text.AlignLeft
            font.pixelSize: height
            MouseArea{
                anchors.fill: parent
                anchors.topMargin: -infoCard.vMargin * infoCard.minHeight
                anchors.bottomMargin: -infoCard.vMargin * infoCard.minHeight
                onClicked:{
                    if(!blocked){
                        if(infoCard.extensible){
                            infoCard.extended = !infoCard.extended
                            infoCard.extended ? userExtension() : userRetraction()
                        }
                    }
                }
            }
            Image{
                id: extensioButton
                height: parent.height
                width: height
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                source: (infoCard.extensible) ? (infoCard.extended ? imgExtended : imgRetracted) : ""
            }
        }
        Rectangle {
            id: tittleLine
            border.color: infoCard.tittleColor
            color: "transparent"
            width: parent.width
            height: 1
        }

        Flickable{
            id: dataArea
            width: parent.width
            height: parent.height - tittleLine.height - tittle.height - (2 * columnId.spacing)
            visible: infoCard.extended
            enabled: editEnabled ? true : scrollEnabled
            flickableDirection: Flickable.VerticalFlick

            ScrollBar.vertical: ScrollBar {
                anchors.right: parent.right
                policy: scrollEnabled ? ScrollBar.AlwaysOn : ScrollBar.AlwaysOff
            }
            // Avoid small position sinchronization on first touch
            contentX : originX
            contentY : originY

            TextArea.flickable: TextArea {
                id: textArea
                textFormat: TextEdit.RichText
                text: infoCard.text
                color: infoCard.edtitableTextColor
                enabled: false //editEnabled
                visible: !editEnabled

                // Walk around
                // When using Flickable instead of ScrollView for TextArea scroll managment,
                // textArea.text dissapears when extended property changes from true to false
                // an then true again
                onVisibleChanged: text = infoCard.text
            }
            TextInput{
                id: textInput
                text: infoCard.text
                color: "#AAAAAA" ///  TODO  style
                font.pixelSize: 19  ///  TODO  style
                visible: editEnabled
                verticalAlignment: TextInput.AlignBottom
                enabled: true
                height: parent.height

                // Simulate automatic indentation introduced on TextArea
                anchors.left: parent.left
                anchors.leftMargin: height * 0.3
                // Avoid cursor blinking on text when keyboard is closed by enter key
                onAccepted: textArea.forceActiveFocus()
//                onActiveFocusChanged: console.log("Focus changeddddddddddddddddddddddddddddddddddd", activeFocus)

                onActiveFocusChanged: !activeFocus ? infoTextChanged(text) : null


            }
        }
    }
    Rectangle {id: debug;  border.color: "tomato"; color: "transparent"; x: columnId.x;               y: columnId.y;               width: columnId.width;  height: columnId.height;  visible: gridView}
    Rectangle {id: debug1; border.color: "olive";  color: "transparent"; x: columnId.x + tittle.x;    y: columnId.y + tittle.y;    width: tittle.width;    height: tittle.height;    visible: gridView}
    Rectangle {id: debug2; border.color: "plum";   color: "transparent"; x: columnId.x + dataArea.x;  y: columnId.y + dataArea.y;  width: dataArea.width;  height: dataArea.height;  visible: gridView}
}

/* HTML text formatting
<b>Bold</b>
<i>Italic</i>
<br> carriage return
<p1 style=\"font-size:10px\">Hello World</p1>
*/

//        ScrollView {
//            id: dataArea
//            width: parent.width
//            height: parent.height - tittleLine.height - tittle.height - (2 * columnId.spacing)
//            visible: infoCard.extended
//            enabled: editEnabled ? true : scrollEnabled
//            ScrollBar.vertical.interactive: true
//            ScrollBar.vertical.policy: scrollEnabled ? ScrollBar.AlwaysOn : ScrollBar.AlwaysOff
//            ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
//            contentWidth: availableWidth

//            TextArea {
//                id: textArea
//                textFormat: TextEdit.RichText
//                text: infoCard.text
//                color: infoCard.textColor
//                enabled: editEnabled
//            }
//        }
