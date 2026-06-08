// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright (C) 2024 Sedecal S.A.
// This file is part of OzonobaricD.
// See LICENSE file for details.

import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Layouts 1.3
import AppStyle 1.0
import AppConstants 1.0
import AppImages 1.0

Item {
    height: parent.height
    width: parent.width
    opacity: enabled ? 1 : 0.3

    property bool   gridView: false
    property bool   psIsPortrait: true
    property bool   psIsLandScape: !psIsPortrait
    property bool   isExecutableProtocol: false
    property int    selectedTab: -1
    property string currentProtocol: ""
//  property int    closeSubmenuTimerInterval: 3000
    property double subMenuSize: ( ( ((height < width) ? height : width) - (tabBar.separatorSize * (tabBar.tabBarModel.count -1)) ) / tabBar.tabBarModel.count).toFixed(10)
//                  subMenuSize:        -------> screen size <--------       ---------------> separators size <---------------        ---> menu elements <---

//  Fill the protocol item with "pause" string when pause be needed during generation
//    property var pn: { 'protocol': 0, 'pauseStatus': 1 }
//    property var pauseNeeded: [
////      ["syringe_auto",                      ""],
//        [Const.protocol.syringe_auto,         ""],
//        [Const.protocol.manual_syringe,       ""],
//        [Const.protocol.continuous,           ""],
//        [Const.protocol.open_bag,             Const.controls.pause],
//        [Const.protocol.closed_bag,           ""],
//        [Const.protocol.vaginal_insufflation, Const.controls.pause],
//        [Const.protocol.rectal_insufflation,  Const.controls.pause],
//        [Const.protocol.dose,                 ""],
//        [Const.protocol.vacuum_time,          Const.controls.pause],
//        [Const.protocol.vacuum_pressure,      Const.controls.pause]
//    ]

    property var pauseNeeded: [
//      { prot: "syringe_auto",                      pause: ""},
        { prot: Const.protocol.syringe_auto,         pause: ""},
        { prot: Const.protocol.manual_syringe,       pause: ""},
        { prot: Const.protocol.continuous,           pause: ""},
        { prot: Const.protocol.open_bag,             pause: ""},
        { prot: Const.protocol.closed_bag,           pause: ""},
        { prot: Const.protocol.vaginal_insufflation, pause: Const.controls.pause},
        { prot: Const.protocol.rectal_insufflation,  pause: Const.controls.pause},
        { prot: Const.protocol.dose,                 pause: ""},
        { prot: Const.protocol.vacuum_time,          pause: Const.controls.pause},
        { prot: Const.protocol.vacuum_pressure,      pause: Const.controls.pause}
    ]

    property var playNeeded: [
//      { prot: "syringe_auto",                      play: ""},
        { prot: Const.protocol.syringe_auto,         play: ""},
        { prot: Const.protocol.manual_syringe,       play: ""},
        { prot: Const.protocol.continuous,           play: ""},
        { prot: Const.protocol.open_bag,             play: Const.controls.play},
        { prot: Const.protocol.closed_bag,           play: ""},
        { prot: Const.protocol.vaginal_insufflation, play: ""},
        { prot: Const.protocol.rectal_insufflation,  play: ""},
        { prot: Const.protocol.dose,                 play: ""},
        { prot: Const.protocol.vacuum_time,          play: ""},
        { prot: Const.protocol.vacuum_pressure,      play: ""}
    ]

    property var generatingControlsList: [
//      { prot: "syringe_auto",                      controls: "play, pause, stop"},
        { prot: Const.protocol.syringe_auto,         controls: [""                 , ""                  , Const.controls.stop]},
        { prot: Const.protocol.manual_syringe,       controls: [Const.controls.play, ""                  , Const.controls.stop]},
        { prot: Const.protocol.continuous,           controls: [""                 , ""                  , Const.controls.stop]},
        { prot: Const.protocol.open_bag,             controls: [Const.controls.play, ""                  , Const.controls.stop]},
        { prot: Const.protocol.closed_bag,           controls: [Const.controls.play, ""                  , Const.controls.stop]},
        { prot: Const.protocol.vaginal_insufflation, controls: [""                 , Const.controls.pause, Const.controls.stop]},
        { prot: Const.protocol.rectal_insufflation,  controls: [""                 , Const.controls.pause, Const.controls.stop]},
        { prot: Const.protocol.dose,                 controls: [""                 , ""                  , Const.controls.stop]},
        { prot: Const.protocol.vacuum_time,          controls: [""                 , Const.controls.pause, Const.controls.stop]},
        { prot: Const.protocol.vacuum_pressure,      controls: [""                 , Const.controls.pause, Const.controls.stop]}
    ]

//  Swipe selection variables
    property int swipeIndex: -1
    property int swipeIndexCorrection: 0
    property var swipeContext: [
//      { protocol: "syringe_auto",                      position: 0, icon: "Images/outline_syringe_white_48.png"},
        { protocol: Const.protocol.syringe_auto,         position: 0, icon: Img.protocol.syringe_auto },
        { protocol: Const.protocol.manual_syringe,       position: 0, icon: Img.protocol.manual_syringe },
        { protocol: Const.protocol.continuous,           position: 1, icon: Img.protocol.continuous },
        { protocol: Const.protocol.open_bag,             position: 2, icon: Img.protocol.open_bag },
        { protocol: Const.protocol.closed_bag,           position: 2, icon: Img.protocol.closed_bag },
        { protocol: Const.protocol.vaginal_insufflation, position: 3, icon: Img.protocol.vaginal_insufflation },
        { protocol: Const.protocol.rectal_insufflation,  position: 3, icon: Img.protocol.rectal_insufflation },
        { protocol: Const.protocol.dose,                 position: 4, icon: Img.protocol.dose },
        { protocol: Const.protocol.vacuum_time,          position: 5, icon: Img.protocol.vacuum_time },
        { protocol: Const.protocol.vacuum_pressure,      position: 5, icon: Img.protocol.vacuum_pressure },
    ]

    signal protocolSelected(string protocolId, string selectionMethod)
    signal protocolDeselected()

    function clamp(number, min, max) {
      return Math.max(min, Math.min(number, max));
    }

    function closeTabs(){
        for(var i = 0; i < subMenusRepeater.count; i++)
            subMenusRepeater.itemAt(i).retract()
    }

    function needPause(protocol){
//        var result = false

//        for (var i in pauseNeeded){
//            if(pauseNeeded[i][pn.protocol] === protocol){
//                result = pauseNeeded[i][pn.pauseStatus]
//            }
//        }
//        return result

        var pauseSt = ""
        pauseNeeded.forEach( item => { if(item.prot === protocol) pauseSt = item.pause } )
        return pauseSt
    }

    function needPlay(protocol){
        var playSt = ""
        playNeeded.forEach( item => { if(item.prot === protocol) playSt = item.play } )
        return playSt
    }

    function generatingControls(protocol){
        var controls = "stop"
        generatingControlsList.forEach( item => { if(item.prot === protocol) controls = item.controls } )
        return controls
    }

    function submenuClicked(protocol, icon, selectionMethod){
        // closeTabs()
        tabBar.tbChangeIcon(selectedTab, icon)
        currentProtocol = protocol
        protocolSelected(currentProtocol, selectionMethod)
        isExecutableProtocol = true
    }

    function swipeProtocol(direction){
        var selectionMethod = ""

        if(direction === "right"){
            selectionMethod = "swipeRight"
            swipeIndex = swipeIndex + swipeIndexCorrection
            swipeIndex = ((swipeIndex + 1) > (swipeContext.length - 1)) ? 0 : (swipeIndex + 1)
        }
        else{ // "left"
            selectionMethod = "swipeLeft"
            swipeIndex = ((swipeIndex - 1) < 0) ? (swipeContext.length - 1) : (swipeIndex - 1)
        }

        closeTabs()
        tabBar.tbRestoreIcon()
        selectedTab = swipeContext[swipeIndex].position
        submenuClicked(swipeContext[swipeIndex].protocol, swipeContext[swipeIndex].icon, selectionMethod)

//      tabBar.indexArea.position = swipeContext[swipeIndex].position

        // Above lines generates the necessary events to simulate a tabBar click by means of swipe gesture.
        // This sistuation generates (betwen others) two processes: inputSelector.load with the new protocol
        // configuration and tabBar.indexArea new positioning animation.
        // It happens that smooth movement for the tabBar.indexArea is sligthly interruped by the load process
        // (included in inputSelector information animation) which is quite heavy due to DB access and the
        // appends to list models. As a walk around tabBar.indexArea positioning is sligthly delayed to avoid
        // a complex sinchronization system between transitions (inputSelector information and tabBar.indexArea).
        updateTabBarIndexAreaDelay.start()

        console.log("protocolselected by swipe:", swipeContext[swipeIndex].protocol, swipeContext[swipeIndex].icon, selectedTab)
    }

    // Keep swipe index updated when protocol is selected by clicking on tab bar
    function updateSwipeIndex(){
        swipeIndexCorrection = 0

        for(var i in swipeContext){
            if(swipeContext[i].protocol === currentProtocol){
                swipeIndex = i
                return
            }
        }
        // in the case submenu opened but no therapy selected
        for(var j in swipeContext){
            if(swipeContext[j].position === selectedTab){
                swipeIndex = j //- 1
                swipeIndexCorrection = -1
                return
            }
        }
    }

    Timer{
        id: updateTabBarIndexAreaDelay
        interval: 200
        onTriggered: tabBar.indexArea.position = swipeContext[swipeIndex].position
    }

    onCurrentProtocolChanged: updateSwipeIndex()

    TabBar{
        id: tabBar
        tbScreenFraction: 6
        tbIsPortrait: psIsPortrait
        Component.onCompleted:{
//          Create tab bar elements
//          tabBarModel.append( {tbProtocol: "syringe",                   tbColor: "#96D647",                        tbIcon:"Images/outline_syringe_white_48.png"} )
            tabBarModel.append( {tbProtocol: Const.protocol.syringe,      tbColor: Style.protocolSelector.btn0Color, tbIcon: Img.protocol.syringe } )
            tabBarModel.append( {tbProtocol: Const.protocol.continuous,   tbColor: Style.protocolSelector.btn1Color, tbIcon: Img.protocol.continuous } )
            tabBarModel.append( {tbProtocol: Const.protocol.bag,          tbColor: Style.protocolSelector.btn2Color, tbIcon: Img.protocol.bag } )
            tabBarModel.append( {tbProtocol: Const.protocol.insuffaltion, tbColor: Style.protocolSelector.btn3Color, tbIcon: Img.protocol.insuffaltion } )
            tabBarModel.append( {tbProtocol: Const.protocol.dose,         tbColor: Style.protocolSelector.btn4Color, tbIcon: Img.protocol.dose } )
            tabBarModel.append( {tbProtocol: Const.protocol.vacuum,       tbColor: Style.protocolSelector.btn5Color, tbIcon: Img.protocol.vacuum } )
        }
        onTabClicked:{
            console.log("signal from tab bar element clicked received:", tabIndex)

            selectedTab = tabIndex
            closeTabs()
            subMenusRepeater.itemAt(tabIndex).split()
            currentProtocol = protocolName

            // TODO: try to move to StateMachine
            if(subMenusRepeater.itemAt(tabIndex).count() > 1){
                protocolDeselected()
                isExecutableProtocol = false
            }
            else{
                protocolSelected(currentProtocol, "click")
                isExecutableProtocol = true
            }
        }
    }

//  TEST this
//  fruitModel.append(..., "attributes": [{"name":"spikes","value":"7mm"}, {"name":"color","value":"green"}]);
//  fruitModel.get(0).attributes.get(1).value; // == "green"
    ListModel {
        id: subMenusModel
        // elements: number of submenu buttons
        // color: color of buttons
        // ids: identifier of each button (separated by ',' (necessary) and whitespaces (optional) )
        // icons: path to each button (separated by ',' (necessary) and whitespaces (optional) )

        // void submenu must be declared in order to occupy physical space in the submenus structure
        // void submenu is declared by setting 'elements' to 0
        // 'color' and 'icons' must be declared (their value doesn't matter)

//        ListElement { elements: 2; color: "#96D647"; ids:"syringe_auto, manual_syringe";              icons: "Images/outline_syringe_white_48.png, Images/outline_manual_syringe_bis_white_48.png" }
//        ListElement { elements: 0; color: "";        ids:"continuous";                                icons: "" }
    }

    Component {
        id: subMenusDelegate
        SplitMenu{
            opacity: 1
            smIsPortrait: psIsPortrait
            splitVelocity: 1000
            smSize: subMenuSize
            smReducedPercent: 7
            smViewTime: 3000
            Component.onCompleted:{
                var idArray = ids.split(" ").join("").split(",") // split(" ").join("") to remove whitespaces, then split(",") to generate an array
                var iconArray = icons.split(" ").join("").split(",")
                if(elements)
                    for(var i = 0; i < elements; i++) splitMenuModel.append({"smColor": color, "smId": idArray[i], "smIcon": iconArray[i]})
                else
                    splitMenuModel.append({"smColor": "transparent", "smIcon": ""})
            }
            onSmClicked: {
//               // closeTabs()
//                tabBar.tbChangeIcon(selectedTab, smIcon)
//                currentProtocol = smId
//                protocolSelected(currentProtocol)
//                isExecutableProtocol = true
//                console.log("signal from split menu element clicked received:", smId, smIcon, selectedTab)
                submenuClicked(smId, smIcon, "click")
                console.log("signal from split menu element clicked received:", smId, smIcon, selectedTab)
            }
//            onSmTimeOut: {
//                timeOut()
//            }
        }
    }


    Grid{
        id: subMenusGrid
        height: (psIsLandScape) ? tabBar.height : tabBar.height * 0.5
        width: (psIsLandScape) ? tabBar.width * 0.5 : tabBar.width
        anchors.top: (psIsLandScape) ?  tabBar.top : tabBar.bottom
        anchors.left: (psIsLandScape) ? tabBar.right : tabBar.left
        anchors.topMargin: (psIsLandScape) ? 0 : height * 0.04
        anchors.leftMargin: (psIsLandScape) ? width * 0.04 : 0
        columns: (psIsLandScape) ? 0 : tabBar.tabBarModel.count
        rows: (psIsLandScape) ? tabBar.tabBarModel.count : 0
        spacing: Math.round(tabBar.separatorSize)

        Repeater {
            id: subMenusRepeater
            model: subMenusModel
            delegate: subMenusDelegate
        }

        Component.onCompleted:{
//          Create submenu elements
//          subMenusModel.append( {elements: 2, color: "#96D647",                        ids: "syringe_auto, manual_syringe",                                                 icons: "Images/outline_syringe_white_48.png, Images/outline_manual_syringe_bis_white_48.png"} )
            subMenusModel.append( {elements: 2, color: Style.protocolSelector.btn0Color, ids: Const.protocol.syringe_auto + "," + Const.protocol.manual_syringe,              icons: Img.protocol.syringe_auto + "," + Img.protocol.manual_syringe } )
            subMenusModel.append( {elements: 0, color: "",                               ids: Const.protocol.continuous,                                                      icons: "" } )
            subMenusModel.append( {elements: 2, color: Style.protocolSelector.btn2Color, ids: Const.protocol.open_bag + "," + Const.protocol.closed_bag,                      icons: Img.protocol.open_bag + "," + Img.protocol.closed_bag } )
            subMenusModel.append( {elements: 2, color: Style.protocolSelector.btn3Color, ids: Const.protocol.vaginal_insufflation + "," + Const.protocol.rectal_insufflation, icons: Img.protocol.vaginal_insufflation + "," + Img.protocol.rectal_insufflation } )
            subMenusModel.append( {elements: 0, color: "",                               ids: Const.protocol.dose,                                                            icons: "" } )
            subMenusModel.append( {elements: 2, color: Style.protocolSelector.btn5Color, ids: Const.protocol.vacuum_time + "," + Const.protocol.vacuum_pressure,              icons: Img.protocol.vacuum_time + "," + Img.protocol.vacuum_pressure } )
        }

    }

//    Timer{
//        id: closeSubmenuTimer
//        interval: closeSubmenuTimerInterval
//        onTriggered: closeTabs()
//    }

    Rectangle {border.color: "burlywood"; color: "transparent"; anchors.fill: parent; visible: gridView }

// DEBUG
    function log1(){
        console.log("ProtocolSelector - psIsPortrait", psIsPortrait)
        console.log("ProtocolSelector - height", height)
        console.log("ProtocolSelector - width", width)
        console.log("ProtocolSelector - subMenuSize", subMenuSize)
        console.log("ProtocolSelector - tabBar.separatorSize", tabBar.separatorSize)
        console.log("ProtocolSelector - tabBar.tabBarModel.count", tabBar.tabBarModel.count)
    }
    onHeightChanged: log1()
    Component.onCompleted: log1()
}
