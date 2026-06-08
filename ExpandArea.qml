// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright (C) 2024 Sedecal S.A.
// This file is part of OzonobaricD.
// See LICENSE file for details.

import QtQuick 2.12

Rectangle{
    id: expandArea

    // Properties, to be on element declaration
    property int    animationTime: 300

    // Use this properties to define movement and size of the button
    // naming convention: _s (as small) _b (as big)
    property int    x_s: 0
    property int    y_s: 0
    property int    x_b: 0
    property int    y_b: 0
    property int    z_b: 1 // used to allow buton to pass over other elements if needed
    property double width_s:  0
    property double width_b:  0
    property double height_s: 0
    property double height_b: 0

    // Use these properties when button is defined inside an element and has to be expanded to a external coordinates.
    // Initialize with the coordinates of element where the button is included in.
    property double xOrigin: 0
    property double yOrigin: 0

    // Use this property to allow expand on expand on clicked action
    property bool expandOnClicked: true

    // Use this property to assign a image when in "small" state if needed
    property alias imgSource: image.source

    // Internal properties, do not init on element declaration
    property int    relativeX_b: x_b - xOrigin
    property int    relativeY_b: y_b - yOrigin
    property int    privateAnimationTime: 0

    signal expansionStart()
    signal expansionEnd()
    signal retractionStart()
    signal retractionEnd()

    states: [
        State { name: "small" },
        State { name: "big"   }
    ]

    transitions: [
        Transition {
            to: "big";
            SequentialAnimation {
                ScriptAction { script: expansionStart() }
                NumberAnimation { target: expandArea; property: "z";  to: 1 }  // float over other elements
                NumberAnimation { target: image; property: "opacity"; to: 0; duration: (image.source == "") ? 0 : privateAnimationTime * 0.2 }
                ParallelAnimation {
                    SmoothedAnimation { target: expandArea; property: "width";  to: width_b;     duration: privateAnimationTime }
                    SmoothedAnimation { target: expandArea; property: "height"; to: height_b;    duration: privateAnimationTime }
                    SmoothedAnimation { target: expandArea; property: "x";      to: relativeX_b; duration: privateAnimationTime }
                    SmoothedAnimation { target: expandArea; property: "y";      to: relativeY_b; duration: privateAnimationTime }
                }
                ScriptAction { script: expansionEnd() }
            }
        },
        Transition {
            to: "small";
            SequentialAnimation {
                ScriptAction { script: retractionStart() }
                ParallelAnimation {
                    SmoothedAnimation { target: expandArea; property: "width";  to: width_s;  duration: privateAnimationTime }
                    SmoothedAnimation { target: expandArea; property: "height"; to: height_s; duration: privateAnimationTime }
                    SmoothedAnimation { target: expandArea; property: "x";      to: x_s;      duration: privateAnimationTime }
                    SmoothedAnimation { target: expandArea; property: "y";      to: y_s;      duration: privateAnimationTime }
                }
                NumberAnimation { target: image; property: "opacity"; to: 1; duration: (image.source == "") ? 0 : privateAnimationTime * 0.25 }
                NumberAnimation { target: expandArea; property: "z";  to: 0 }  // allow others to float over it
                ScriptAction { script: retractionEnd() }
            }
        }
    ]

    function expand(){
        z = z_b // allows expand view over other elelments if z_b is bigger enought
        expandArea.state = "big"
    }

    function retract(){
        expandArea.state = "small"
    }

    onWidthChanged: if(width === width_s) z = 1

    Component.onCompleted: {
        width_s = width
        height_s = height
        state = "small"
        privateAnimationTime = animationTime // keep this line at the end of the block (avoid transition during component creation)
    }

    Image{
        id: image
        anchors.fill: parent
        source: ""
    }

    MouseArea{
        anchors.fill: parent
        onClicked: {
            if((expandOnClicked) && (parent.state === "small"))
            {
                expand()
            }
        }
    }
}

