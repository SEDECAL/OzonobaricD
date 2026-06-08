// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright (C) 2024 Sedecal S.A.
// This file is part of OzonobaricD.
// See LICENSE file for details.

import QtQuick 2.0

Rectangle{
    id: pinPad

    property bool gridView: false

    property var layout: [7, 8, 9, 4, 5, 6, 1, 2, 3, "back", 0, "enter"]
    property string pin: ""
    property bool pinVisible: false
    property int buttonSize: 60
    property color buttonColor: "sienna"
    property int spacing: 25


    signal enterKey(string pinValue)

    function manageKey(key){

        switch(key){
        case "back": pin = pin.slice(0, pin.length - 1)
            break
        case "enter": enterKey(pin)
                      reset()
            break
        default:  pin =  (pin.length < 4) ? pin += key : pin
        }

        resolveDisplay()
        console.log("pinPad key:", key, "pinPad display:", pinPadDisplay.text, "pin:", pin)
    }

    function resolveDisplay(){
        pinPadDisplay.text = ' ' + ( pinVisible ? pin : '*'.repeat(pin.length) )
    }

    function reset(){
        pin = ""
        resolveDisplay()
        pinVisible = false
        visible = false
    }

    height: (6 * spacing) + (4 * buttonSize) + pinPadDisplay.height
    width: (4 * spacing) + (3 * buttonSize)
    color: "orange"
    radius: height * 0.01

    Text{
        id: pinPadDisplay
        height: pinPad.buttonSize * 0.8
        width: (pinPad.buttonSize * 2) + pinPad.spacing
        anchors.top: parent.top
        anchors.topMargin: pinPad.spacing
        anchors.left: parent.left
        anchors.leftMargin: pinPad.spacing

        text: ""
        color: "white"
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment:  Text.AlignLeft
        font.pixelSize: height * 0.8
        MouseArea{
            anchors.fill: parent
            onClicked: {
                pinPad.pinVisible = !pinPad.pinVisible
                pinPad.resolveDisplay()
            }
            Rectangle {border.color: "olive"; color: "transparent"; anchors.fill: parent; visible: gridView}
        }
        Image{
            height: parent.height * 0.5
            width: height
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: height * 0.3
            source: pinPad.pinVisible ? "Images/outline_visibility_off_white_24.png" : "Images/outline_visibility_white_24.png"
        }
        Rectangle {border.color: pinPad.buttonColor; color: "transparent"; anchors.fill: parent; radius: height * 0.09}
    }

    Rectangle{
        id: closeControl
        height: pinPadDisplay.height
        width: pinPad.buttonSize
        color: "transparent" // pinPad.buttonColor
        radius: height * 0.05
//      border.color: pinPad.buttonColor

        anchors.top: parent.top
        anchors.topMargin: pinPad.spacing
        anchors.right: parent.right
        anchors.rightMargin: pinPad.spacing

        MouseArea{
            anchors.fill: parent
            onClicked: {
                pin = "invalid pin"
                pinPad.manageKey("enter")
            }
        }
        Image{
            anchors.centerIn: parent
            height: parent.height
            width: height
            source: "Images/baseline_clear_white_48.png" // "Images/ic_back_white_48dp_02.png"
        }
    }

    Grid{
        id: pinPadGrid
        anchors.top: pinPadDisplay.bottom
        anchors.topMargin: spacing
        anchors.left: parent.left
        anchors.leftMargin: spacing
        spacing: pinPad.spacing
        columns: 3
        rows: 4
        Repeater {
            model: 12
            delegate: Rectangle{
                height: pinPad.buttonSize
                width: height
                color: pinPad.buttonColor
                radius: height * 0.05
                Text{
                    anchors.fill: parent
                    color: "white"
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment:  Text.AlignHCenter
                    font.pixelSize: height * 0.8

                    text: {
                        switch( pinPad.layout[index] ){
                        case "back":
                        case "enter": ""; break
                        default: pinPad.layout[index]
                        }
                    }
                }
                MouseArea{
                    anchors.fill: parent
                    onClicked: pinPad.manageKey(pinPad.layout[index])
                }
                Image{
                    anchors.fill: parent
                    source:{
                        switch( pinPad.layout[index] ){
                        case "back": "Images/ic_del_white_48dp_00.png"; break
                        case "enter": "Images/ic_done_white_48dp.png"; break
                        default: ""
                        }

                    }
                }
            }
        }
    }
    Rectangle {border.color: "tomato"; color: "transparent"; anchors.fill: parent; visible: gridView}
}
