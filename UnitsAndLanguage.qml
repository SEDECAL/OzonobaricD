// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright (C) 2024 Sedecal S.A.
// This file is part of OzonobaricD.
// See LICENSE file for details.

import QtQuick 2.12
import QtQuick.Controls 2.5

Item {
    property bool gridView: false

    property variant unitList:{
        'international': "ºC - mbar",
        'imperial'     : "ºF - Psi"
    }
    property variant languageList:{
        'spanish':   "Español",
        'english':   "English",
        'chinesse':  "中国人",
        'portugese': "Português",
        'german':    "Deutsch",
        'french':    "Français",
        'italian':   "Italiano",
        'russian':   "Pусский"
    }

    /// TODO
    /// TODO
    /// TODO refer to style

    property color radioButtonColor: "#DDDDDD"
    property color radioButtonCheckedColor: "#008B9E"

    signal unitsChange(string unitsId)
    signal languageChange(string languageId)

    function setUnitsCheckedPosition(value) {
        for(var ret=0; ret<unitsRepeater.count; ret++) {
            if(unitsRepeater.itemAt(ret).unitsId === value) {
                unitsRepeater.itemAt(ret).checked = true
                return ret;
            }
        }
        return 0
    }

    function getUnitsCheckedPosition() {
        for(var ret=0; ret<unitsRepeater.count; ret++) {
            if(unitsRepeater.itemAt(ret).checked) {
                return unitsRepeater.itemAt(ret).unitsId;
            }
        }
        return ""
    }

    function gotoLanguageChecked() {
        var position = getLanguageCheckedPositionIndex()
        var scrollBarVertStep = (1.0 - language.scrollView.ScrollBar.vertical.size) / languageRepeater.count
        language.scrollView.ScrollBar.vertical.position = (scrollBarVertStep + (scrollBarVertStep / languageRepeater.count)) * position
    }

    function getLanguageCheckedPositionIndex() {
        for(var ret=0; ret<languageRepeater.count; ret++) {
            if(languageRepeater.itemAt(ret).checked) {
                return ret;
            }
        }
        return 0
    }

    function setLanguageCheckedPosition(value) {
        for(var ret=0; ret<languageRepeater.count; ret++) {
            if(languageRepeater.itemAt(ret).languageId === value) {
                languageRepeater.itemAt(ret).checked = true
                return ret;
            }
        }
        return 0
    }

    function getLanguageCheckedPosition() {
        for(var ret=0; ret<languageRepeater.count; ret++) {
            if(languageRepeater.itemAt(ret).checked) {
                return languageRepeater.itemAt(ret).languageId
            }
        }
        return ""
    }

    Item {
        id: units
        height: parent.height
        width: parent.width * 0.48

        ButtonGroup {
            id: radioUnitsGroup
            onClicked: {
                unitsChange(getUnitsCheckedPosition())
                console.log("units clicked:", button.text)
            }
        }

        ListModel { id: unitsModel }
        Column {
            width: parent.width
            Repeater {
                id: unitsRepeater
                model: unitsModel
                delegate: MyRadioButtom {
                    property string unitsId: mId
                    text: mtext
                    ButtonGroup.group: radioUnitsGroup
                    width: parent.width
                    color: radioButtonColor
                    checkedColor: radioButtonCheckedColor
                    font.pixelSize: 19   ///  TODO  style
                }
            }
        }
        Component.onCompleted: {
            for(var item in unitList){
                unitsModel.append( { mtext: unitList[item], mId: item } )
            }
            unitsRepeater.itemAt(0).checked = true
        }
        Rectangle {border.color: "tomato"; color: "transparent"; anchors.fill: parent; visible: gridView}
    }

    Item {
        id: language
        height: parent.height
        width: units.width
        anchors.right: parent.right
        property alias scrollView: scrollView

        ButtonGroup {
            id: radioLanguageGroup
            onClicked: {
                languageChange(getLanguageCheckedPosition())
                console.log("language clicked:", button.text)
            }
        }

        ListModel {
            id: languageModel
//          ListElement { mtext: "Spanish" }
        }
        Component {
            id: languageDelegate
            MyRadioButtom{
                property string languageId: mId
                text: mtext
                ButtonGroup.group: radioLanguageGroup
                width: parent.width
                color: radioButtonColor
                checkedColor: radioButtonCheckedColor
                font.pixelSize: 19   ///  TODO  style
            }
        }
        ScrollView{
            id: scrollView
            anchors.fill: parent
            ScrollBar.vertical.interactive: true
            clip:true

            Column{
                id: languageColumn
                anchors.fill: parent

                Repeater {
                    id: languageRepeater
                    model: languageModel
                    delegate: languageDelegate
                }
            }
            Component.onCompleted: {
                for(var lang in languageList){
                    languageModel.append( { mtext: languageList[lang], mId: lang } )
                }
                ScrollBar.vertical.policy = (languageRepeater.itemAt(0).height * languageRepeater.count) > scrollView.height ? ScrollBar.AlwaysOn : ScrollBar.AlwaysOff

//                TODO REMOVE whe interted
                languageRepeater.itemAt(3).checked = true
                ttest.running = true
            }
            Timer{
                id: ttest
                interval: 2500
                onTriggered:  gotoLanguageChecked(  )

            }
        }

        Rectangle {border.color: "olive"; color: "transparent"; anchors.fill: parent; visible: gridView}
}

    Rectangle {border.color: "green"; color: "transparent"; anchors.fill: parent; visible: gridView}
}


