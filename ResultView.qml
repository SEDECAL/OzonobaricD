// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright (C) 2024 Sedecal S.A.
// This file is part of OzonobaricD.
// See LICENSE file for details.

import QtQuick 2.15
import QtQuick.Controls 2.15
import AppStyle 1.0

ExpandArea{
    id: rv

    property bool gridView: false

    property int rvMaxLineChars:  15
    property int rvDefaultHeight: 0 // height on creation
    property int rvDefaultY:      0 // position on creation
    property int rvButtonSize:    rvDefaultHeight * 0.7
    property int rvInterline:     rvDefaultHeight * 0.01
    property int rvRadius:        rvDefaultHeight * 0.02
    property int rvSpacing:       rvDefaultHeight * 0.1
    property int rvMargin:        rvSpacing * 2

    property alias buttonImage: rvButtonImage.source
    property alias buttonColor: rvButton.color
    property alias buttonText:  rvErrorCode.text

    signal done()

    color: Style.resultView.backColor
    radius: rvRadius
    height: 0
    width: 0
    animationTime: 300
    x_s: parent.width * 0.5
    y_s: parent.height * 0.5

    function getMaxNumbersInfoWidth() {
        var maxWidth = 0

        for(var i = 0; i < resultNumbersRepeater.count; i++) {
            maxWidth = (resultNumbersRepeater.itemAt(i).width > maxWidth) ? resultNumbersRepeater.itemAt(i).width : maxWidth
        }
        return maxWidth
    }

    function getMaxUnitsInfoWidth() {
        var maxWidth = 0

        for(var i = 0; i < resultUnitsRepeater.count; i++) {
            maxWidth = (resultUnitsRepeater.itemAt(i).width > maxWidth) ? resultUnitsRepeater.itemAt(i).width : maxWidth
        }
        return maxWidth
    }

    // Clear list model, resize window and positioning window
    function clearResults(){
        resultsModel.clear()
        rvErrorCode.text = ""
        resizeMainFrameWidth()
        rv.y_b = rvDefaultY
        rv.height_b = rvDefaultHeight
      //console.log("clearResults -> resultNumbersRepeater.count:", resultNumbersRepeater.count)
    }

    // Add elemnet to list model, resize window and positioning window
    function addResult(numbers, units, color){
        resultsModel.append({ rvNumbers: numbers, rvUnits: units, rvColor: color })
        resizeMainFrameWidth()
        resizeMainFrameHeight()
      //console.log("addResult -> resultNumbersRepeater.count:", resultNumbersRepeater.count)
    }

    // Resize window width and recalculate x window position depending on the text width
    function resizeMainFrameWidth(){
        // hide text element when no information supplied
        if((resultNumbersRepeater.count))
            rv.width_b = rvMargin + rvButtonSize + rvSpacing + getMaxNumbersInfoWidth() + rvSpacing + getMaxUnitsInfoWidth() + rvMargin
        else
            rv.width_b = rvButtonSize + (rvMargin * 3)

        // correct window position
        rv.x_b = (parent.width - rv.width_b) * 0.5
    }

    // Resize window height and recalculate y window position depending on the number of lines presented
    function resizeMainFrameHeight(){
        // modify back frame height depending on the amount of information lines
        var currentTextHeight = (resultNumbersRepeater.itemAt(0).height * resultNumbersRepeater.count) + (rvInterline * (resultNumbersRepeater.count - 1))

        if( currentTextHeight >= rvDefaultHeight ){
            rv.height_b = currentTextHeight * 1.08
            rv.y_b = rvDefaultY - ((rv.height_b - rvDefaultHeight) * 0.5)
        }
        else{
            rv.y_b = rvDefaultY
            rv.height_b = rvDefaultHeight
        }
    }

//    function resizeMainFrame(){
//        resizeMainFrameWidth()
//        resizeMainFrameHeight()
//    }

    function close(){
        rv.retract()
        done()
    }

    Component.onCompleted: {
        rvDefaultY = rv.y_b
        rvDefaultHeight = rv.height_b
    }

    onExpansionEnd: controls.visible = true

    onRetractionStart: controls.visible = false // @disable-check (M16)

    Item{
        id: controls
        anchors.fill: parent
        visible: false


        SwipeArea{
            z: 2
            anchors.fill: parent
            onSwipeUp: close()
        }

        ListModel {
            id: resultsModel
          //ListElement{ rvColor: "gold"; rvNumbers: "01:55"; rvUnits: "min" }
        }

        Component {
            id: resultNumbersDelegate
            Text {
                height: rvDefaultHeight * 0.4
                text: rvNumbers.substring(0, rvMaxLineChars - rvUnits.length)
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment:  Text.AlignRight
                font.family: "Helvetica"
                font.pixelSize: height * 0.8
                color: rvColor
                Rectangle {border.color: "green"; color: "transparent"; anchors.fill: parent; visible: gridView}
            }
        }

        Component {
            id: resultUnitsDelegate
            Text {
                height: rvDefaultHeight * 0.4
                text: rvUnits.substring(0, rvMaxLineChars)
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment:  Text.AlignLeft
                font.family: "Helvetica"
                font.pixelSize: height * 0.8
                color: rvColor
                Rectangle {border.color: "olive"; color: "transparent"; anchors.fill: parent; visible: gridView}
            }
        }

        Row {
            spacing: rvSpacing
            height: parent.height
            anchors.centerIn: parent

            Rectangle {
                id: rvButton
                height: rvButtonSize
                width: height
                anchors.verticalCenter: parent.verticalCenter
                color: "transparent"
                radius: rvRadius
                Image {
                    id: rvButtonImage
                    anchors.fill: parent
                    source: ""
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: close()
                }
                Text {
                    id: rvErrorCode
                    height: rvButton.height * 0.2
                    text: ""
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment:  Text.AlignRight
                    font.family: "Helvetica"
                    font.pixelSize: height * 0.8
                    color: "white"
                    anchors.bottom: parent.bottom
                    anchors.right: parent.right
                    anchors.rightMargin: parent.height * 0.02
                    Rectangle {border.color: "black"; color: "transparent"; anchors.fill: parent; visible: gridView}
                }
            }

            Item {
                id: resultNumbers
                height: parent.height
                width:  (resultNumbersRepeater.count) ? getMaxNumbersInfoWidth() : 0
                Grid {
                    id: resultNumbersColumn
                    width: parent.width
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: rvInterline
                    columns: 1
                    horizontalItemAlignment: Grid.AlignRight
                    Repeater {
                        id: resultNumbersRepeater
                        model: resultsModel
                        delegate: resultNumbersDelegate
                    }
                }

                Rectangle {border.color: "lightblue"; color: "transparent"; anchors.fill: parent; visible: gridView }
            }
            Item {
                id: resultUnits
                height: parent.height
                width:  (resultUnitsRepeater.count) ? getMaxUnitsInfoWidth() : 0
                Grid {
                    id: resultUnitsColumn
                    width: parent.width
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: rvInterline
                    columns: 1
                    horizontalItemAlignment: Grid.AlignLeft
                    Repeater {
                        id: resultUnitsRepeater
                        model: resultsModel
                        delegate: resultUnitsDelegate
                    }
                }

                Rectangle {border.color: "plum"; color: "transparent"; anchors.fill: parent; visible: gridView }
            }
        }

        Heartbeat{
            target: rvButton
            quickStart: true
            running: false// controls.visible
        }

        //    Image {
        //        id: infoImage
        //        height: parent.height * 0.5 * 0.35
        //        width: height
        //        anchors.top: parent.top
        //        anchors.topMargin: rvMargin * 0.2
        //        anchors.right: parent.right
        //        anchors.rightMargin: rvMargin * 0.2
        //        source: "Images/outline_info_white_24.png"
        //    }

    }
    Rectangle {border.color: "sienna"; color: "transparent"; anchors.fill: parent; visible: gridView }
}


