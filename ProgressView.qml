// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright (C) 2024 Sedecal S.A.
// This file is part of OzonobaricD.
// See LICENSE file for details.

import QtQuick 2.12
import QtQuick.Window 2.12
import AppConstants 1.0
import AppStyle 1.0

Item{
    id: pv

    implicitWidth: 580
    implicitHeight: 400

    property bool gridView: false

    property double itemSpacing: 2
    property double itemWidth: 10

    property double gosth_0_w: itemWidth
    property double gosth_0_h: (progressRepeater.count) ? progressRepeater.itemAt(0).barHeihgt : 0
    property double gosth_0_H: (progressRepeater.count) ? progressRepeater.itemAt(0).wholeHeihgt : 0
    property double gosth_0_y: (progressRepeater.count) ? progressRepeater.itemAt(0).barY : 0
    property double gosth_0_x: (progressRepeater.count) ? progressRow.x + progressRepeater.itemAt(pvRegister[Const.param.view.gosth_0]).x : 0

    property double gosth_1_w: itemWidth
    property double gosth_1_h: (progressRepeater.count) ? progressRepeater.itemAt(0).barHeihgt : 0
    property double gosth_1_H: (progressRepeater.count) ? progressRepeater.itemAt(0).wholeHeihgt : 0
    property double gosth_1_y: (progressRepeater.count) ? progressRepeater.itemAt(0).barY : 0
    property double gosth_1_x: (progressRepeater.count) ? progressRow.x + progressRepeater.itemAt(pvRegister[Const.param.view.gosth_1]).x : 0

    property string pressureUnits: "mbar"


    property variant pvRegister: {'': 0} // param - value pairs presented on each moment (i.e: 'dose': 4). Used to conrol parameter position on progress view.

    function showProgress(paramType, from, to){
        pvRegister[paramType] = progressRepeater.count

        switch(paramType){
//      case "dose":                    progressModel.append({typeVal: paramType, mColor: "deepskyblue",                       bColor: "lightskyblue",                      unitTxt: "ug",          fromVal: from, toVal: to, val: from}); break;
        case Const.param.view.dose:     progressModel.append({typeVal: paramType, mColor: Style.param.view.mainColor.dose,     bColor: Style.param.view.backColor.dose,     unitTxt: "ug",          fromVal: from, toVal: to, val: from}); break;
        case Const.param.view.volume:   progressModel.append({typeVal: paramType, mColor: Style.param.view.mainColor.volume,   bColor: Style.param.view.backColor.volume,   unitTxt: "ml",          fromVal: from, toVal: to, val: from}); break;
        case Const.param.view.time_m:   progressModel.append({typeVal: paramType, mColor: Style.param.view.mainColor.time_m,   bColor: Style.param.view.backColor.time_m,   unitTxt: "min",         fromVal: from, toVal: to, val: from}); break;
        case Const.param.view.time_s:   progressModel.append({typeVal: paramType, mColor: Style.param.view.mainColor.time_s,   bColor: Style.param.view.backColor.time_s,   unitTxt: "sec",         fromVal: from, toVal: to, val: from}); break;
        case Const.param.view.pressure: progressModel.append({typeVal: paramType, mColor: Style.param.view.mainColor.pressure, bColor: Style.param.view.backColor.pressure, unitTxt: pressureUnits, fromVal: from, toVal: to, val: from}); break;
        case Const.param.view.gosth_0:  progressModel.append({typeVal: paramType, mColor: Style.param.view.mainColor.gosth_0,  bColor: Style.param.view.backColor.gosth_0,  unitTxt: "",            fromVal: 0,    toVal: 0,  val: 0   }); break;
        case Const.param.view.gosth_1:  progressModel.append({typeVal: paramType, mColor: Style.param.view.mainColor.gosth_1,  bColor: Style.param.view.backColor.gosth_1,  unitTxt: "",            fromVal: 0,    toVal: 0,  val: 0   }); break;
        }
    }

    function updatePressureUnits(unitsType){
        pressureUnits = (unitsType === "international") ? "mbar" : (unitsType === "imperial") ? "Psi" : "--"
    }

    function updateProgress(paramType, value){
        if(pvRegister[paramType] !== undefined)
            progressRepeater.itemAt(pvRegister[paramType]).value = value
//      console.log("map['dose']:", map['dose']) // keep line as example of usage
    }

    function updateAltProgress(paramType, value){
        if(pvRegister[paramType] !== undefined)
            progressRepeater.itemAt(pvRegister[paramType]).altValue = value
//      console.log("map['dose']:", map['dose']) // keep line as example of usage
    }

    function clearProgress(){
        progressModel.clear()
        pvRegister = {'': 0}
    }

    function show(){
        opacityAnimator.running = true
    }

    function hide(){
        opacityAnimator.running = false
        opacity = 0
    }

    function exists(element){
        return (pvRegister[element] !== undefined)
    }

    opacity: 0

    OpacityAnimator {
        id: opacityAnimator
        target: pv
        from: 0
        to: 1
        duration: 300
        running: false
    }

    ListModel {
        id: progressModel
//        ListElement{typeVal: "dose"; mColor: "deepskyblue"; bColor: "lightskyblue";       unitTxt: "ug";  fromVal: "0"; toVal:"80"; val: "5"}
//        ListElement{typeVal: "dose"; mColor: "deepskyblue"; bColor: "lightskyblue";       unitTxt: "ug";  fromVal: "0"; toVal:"80"; val: "5"}
    }

    Component {
        id: progressDelegate
        Progress{
            height: progressRowItem.height
            width: itemWidth
            mainColor: mColor
            backColor: bColor
            units: unitTxt
            from: fromVal
            to: toVal
            value: val
            altValue: ""
            type: typeVal
        }
    }

    Item {
        id: progressRowItem
        height: parent.height
        width: parent.width
        Row {
            id: progressRow
            anchors.centerIn: parent
            spacing: itemSpacing
            Repeater {
                id: progressRepeater
                model: progressModel
                delegate: progressDelegate
            }
        }

        Rectangle {border.color: "lightblue"; color: "transparent"; anchors.fill: parent; visible: gridView }
    }
}
