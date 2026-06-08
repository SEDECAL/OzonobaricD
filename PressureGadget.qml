// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright (C) 2024 Sedecal S.A.
// This file is part of OzonobaricD.
// See LICENSE file for details.

import QtQuick 2.15
import QtGraphicalEffects 1.12
import AppStyle 1.0
import AppConstants 1.0
import AppImages 1.0

ExpandArea{
    id: pressureGadget

    property var visibility: [
//      ["syringe_auto",                      false],
        [Const.protocol.syringe_auto,         false],
        [Const.protocol.manual_syringe,       false],
        [Const.protocol.continuous,           true],
        [Const.protocol.open_bag,             true],
        [Const.protocol.closed_bag,           true],
        [Const.protocol.vaginal_insufflation, true],
        [Const.protocol.rectal_insufflation,  true],
        [Const.protocol.dose,                 true],
        [Const.protocol.vacuum_time,          false],
        [Const.protocol.vacuum_pressure,      false]
    ]
    property var enableSelection: [
//      ["syringe_auto",                      false],
        [Const.protocol.syringe_auto,         false],
        [Const.protocol.manual_syringe,       false],
        [Const.protocol.continuous,           true],
        [Const.protocol.open_bag,             true],
        [Const.protocol.closed_bag,           false],
        [Const.protocol.vaginal_insufflation, true],
        [Const.protocol.rectal_insufflation,  true],
        [Const.protocol.dose,                 false],
        [Const.protocol.vacuum_time,          false],
        [Const.protocol.vacuum_pressure,      false]
    ]

    property alias pressureTest: pressureTest
    property alias pressureTestState: pressureTest.state
    property alias pressure: pressureTest.pressureValue
    property alias toFlow: pressureTest.toFlow
    property alias fromFlow: pressureTest.fromFlow
    property alias flowValue: pressureTest.flowValue
    property alias testTime: pressureTest.testTime

    signal editing(string gadgetId)
    signal editionEnd(string gadgetId)
    signal start(int flow)
    signal stop()
    signal resetError()

    function load(protocol){
        var result = false

        for (var i in visibility){
            if(visibility[i][0] === protocol){
                result = visibility[i][1]
            }
        }
        pressureGadget.visible = result

        for (i in enableSelection){
            if(enableSelection[i][0] === protocol){
                result = enableSelection[i][1]
            }
        }
        pressureTest.enableSelection = result
    }

    function configure(from, to, current){
        pressureTest.fromPressure = from
        pressureTest.toPressure = to
        pressureTest.reset(current)
        pressureTest.pressureValue = current
    }

    function closePressureGadget(){
        pressureTest.visible = false
        pressureTest.opacity = 0
        pressureGadget.retract()
        editionEnd("pressureGadget")
    }

    function updatePressureUnits(unitsType){
        pressureTest.pressureUnits = (unitsType === "international") ? "mbar" : (unitsType === "imperial") ? "Psi" : "--"
    }

    function upadateProgress(value){
        pressureTest.progressLine.value = value
    }


    radius: parent.height * 0.006
    color: Style.pressureGadget.backColor
    animationTime: 300
    expandOnClicked: true
    imgSource: Img.pressureGadget.mainButton

    x_s: (parent.width - parent.height * 0.12) * 0.5
    y_s: parent.height * 0.55

    height: parent.height * 0.14
    width: parent.height * 0.14
    visible: false

    layer.enabled: Style.pressureGadget.shadowEnable
    layer.effect: DropShadow { radius: Style.pressureGadget.shadowRadius }

    onStateChanged: if(state === "big") editing("pressureGadget")

    onExpansionEnd: {
        pressureTest.visible = true
        pressureTestOpacityAnimantor.running = true
    }

    OpacityAnimator {
        id: pressureTestOpacityAnimantor
        target: pressureTest
        from: 0
        to: 1
        duration: 200
        running: false
    }

    PressureTest{
        id: pressureTest
        anchors.fill: parent
        visible: false
        opacity: 0

        onStop: pressureGadget.stop()
        onStart: pressureGadget.start(flow)
        onResetError: pressureGadget.resetError()
        onClose: closePressureGadget()
    }
}


