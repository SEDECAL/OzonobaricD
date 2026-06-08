// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright (C) 2024 Sedecal S.A.
// This file is part of OzonobaricD.
// See LICENSE file for details.

import QtQuick 2.12
import QtQuick.Controls 2.15
import AppImages 1.0

Item {
    height: 100
    width: height * 3.7
    property bool gridView: false
    property bool active: false
    property int  stopSpeed: 20
    property double logoOpacity: 0.7
    property alias pressure: pText.text
    property alias temperature: tText.text

    onActiveChanged: {
        if(active){
            dcGif.playing = true
            standardizationGif.playing = true
        }
    }

    AnimatedImage {
        id: standardizationGif
        height: parent.height
        width: height
        z: 2
        source: Img.advertising.halo
        onVisibleChanged: currentFrame = 0
        onCurrentFrameChanged: {
            if((!active) && (currentFrame == 0)){
                standardizationGif.playing = false
                standardizationGif.speed = 1
            }
            if((!active) && (currentFrame)){
                standardizationGif.speed = stopSpeed
            }
        }
    }

    Image {
        id: standardizationImg
        height: standardizationGif.height
        width: standardizationGif.width
         source: Img.advertising.normalization
        x:standardizationGif.x
        y:standardizationGif.y
        opacity: logoOpacity
    }

    AnimatedImage {
        id: dcGif
        height: parent.height
        width: height
        z: 2
        source: Img.advertising.halo
        anchors.right: parent.right
        onVisibleChanged: currentFrame = 0
        onCurrentFrameChanged: {
            if((!active) && (currentFrame == 0)){
                dcGif.playing = false
                dcGif.speed = 1
            }
            if((!active) && (currentFrame)){
                dcGif.speed = stopSpeed
            }
        }
    }

    Image {
        id: dcImg
        height: dcGif.height
        width: dcGif.width
        source: Img.advertising.dc
        x: dcGif.x
        y: dcGif.y
        opacity: logoOpacity
    }

    Text {
        id: pText
        height: parent.height * 0.4
        width: parent.width //- (2 * parent.height)
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        text: "P: 948 mbar"
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment:  Text.AlignHCenter
        font.family: "Helvetica"
        font.pixelSize: parent.height * 0.3
//      fontSizeMode: Text.Fit
        color: "white"
        Rectangle {border.color: "green"; color: "transparent"; anchors.fill: parent; visible: gridView}
    }

    Text {
        id: tText
        height: pText.height
        width: pText.width
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: pText.top
        text: "T: 25 ºC"
        verticalAlignment: pText.verticalAlignment
        horizontalAlignment:  pText.horizontalAlignment
        font.family: pText.font.family
        font.pixelSize: pText.font.pixelSize
        color: pText.color
        Rectangle {border.color: "green"; color: "transparent"; anchors.fill: parent; visible: gridView}
    }

    Rectangle {border.color: "olive"; color: "transparent"; anchors.fill: parent; visible: gridView}
}


