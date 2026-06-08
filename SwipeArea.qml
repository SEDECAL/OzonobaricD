// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright (C) 2024 Sedecal S.A.
// This file is part of OzonobaricD.
// See LICENSE file for details.

import QtQuick 2.12

MouseArea{
    property bool gridView: false
    property bool logView: false

    property bool swipeEnabled: false

    property int x_p: 0
    property int y_p: 0
    property int x_r: 0
    property int y_r: 0
    property int swipeSize: 100

    property int exclusionArea_x: 0
    property int exclusionArea_y: 0
    property int exclusionArea_width: 0
    property int exclusionArea_height: 0

    signal swipeUp()
    signal swipeDown()
    signal swipeLeft()
    signal swipeRight()

    propagateComposedEvents:  true

    onPressed: {
        x_p = mouseX
        y_p = mouseY

//      logView ? console.log("clicked at:", x_p, y_p) : null
        swipeEnabled = true
        if( (x_p > exclusionArea_x)  &&  (x_p < (exclusionArea_x + exclusionArea_width)) ){
            if( (y_p > exclusionArea_y)  &&  (y_p < (exclusionArea_y + exclusionArea_height)) ){
                swipeEnabled = false
//              logView ? console.log("exclusion area") : null
            }
        }

    }
    onReleased: {
        var propagation = true
        x_r = mouseX
        y_r = mouseY

        if(swipeEnabled){
            if( (y_p - y_r) >= swipeSize) {
                swipeUp()
                propagation =  false
                logView ? console.log("Swipe up") : null
            }
            if( (y_r - y_p) >= swipeSize) {
                swipeDown()
                propagation =  false
                logView ? console.log("Swipe down") : null
            }
            if( (x_r - x_p) >= swipeSize) {
                swipeRight()
                propagation =  false
                logView ? console.log("Swipe right") : null
            }
            if( (x_p - x_r) >= swipeSize) {
                swipeLeft()
                propagation =  false
                logView ? console.log("Swipe left") : null
            }
        }
        if(propagation){
//          logView ? console.log("No Swipe") : null
        }
        propagateComposedEvents = propagation
        recoverPropagation.running = !propagation
//      logView ? console.log("released at:", x_r, y_r) : null
    }

    Rectangle{
        id: exclusionAreaViewer
        visible: gridView
        color: "transparent"
        border.color: "green"
        x: exclusionArea_x
        y: exclusionArea_y
        width: exclusionArea_width
        height: exclusionArea_height
    }
    Timer{
        id: recoverPropagation
        interval: 1
        onTriggered: propagateComposedEvents = true
    }
    Rectangle {border.color: "olive"; color: "transparent"; anchors.fill: parent; visible: gridView}
}
