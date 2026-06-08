// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright (C) 2024 Sedecal S.A.
// This file is part of OzonobaricD.
// See LICENSE file for details.

import QtQuick 2.0
import QtQuick.Controls 2.12


Item{
    id: deviceLink

    property bool   gridView: false

    property double buttonSize: 9
    property double buttonRadius: buttonSize * 0.055
    property color  buttonColor: "grey"
    property color  textColor: "white"
    property color  addTextColor: "#AAAAAA"
    property color  listAlternativeColor: "grey"
    property string linkedDevice: ""
    property string selectedDevice: ""

    // linkResult must be init to true. It is updated dependind on SERIAL_ST
    // command result. The transition from false to true have only sense during
    // linking process, so linkResult is set to false only at the beggining of
    // this activity, and then, updated dependig on SERIAL_ST command result.
    // If linkResult is init to false by deafult, no controlled linked device
    // name could be written to DB since changes from false to true on linkResult
    // (caused by SERIAL_ST processing) could result on uncontrolled DB wrinitng.
    property bool linkResult: true

    signal devClicked(string device, int index)
    signal buttonClicked(string state)
    signal backButtonClicked()
    signal searchEnd()
    signal unLinked()
    signal linked(string device)

//  anchors.fill: parent

    function addDevice(deviceId){
        deviceModel.append( { mDeviceName: deviceId } )
        linkStatusImg.source = ""
    }

    function clearDevices(){
        deviceModel.clear()
//      linkedDevice = ""
//      devLinked = false
    }

    function getName(devId){
        return devId.substr(0,devId.indexOf("_,_"))

    }

    function getAddress(devId){
        return devId.substr(devId.indexOf("_,_") + "_,_".length)

    }

    onLinkResultChanged: {
        linkedDevice = linkResult ? selectedDevice : linkedDevice
        if(linkResult){
            console.log("device " + selectedDevice.replace('_,_', ' - ') + " linked...")
            linked(selectedDevice)
        }
    }

    state: "showStatus"
    states: [
        State {
            name: "showStatus"
            PropertyChanges { target: controlButtonImg; source: "Images/outline_search_white_24_1.png" }
            PropertyChanges { target: searchingIcon; visible: false }
            PropertyChanges { target: linkStatus; visible: true }
            PropertyChanges { target: linkName; visible: true }
            PropertyChanges { target: linkStatusImg; source: (getName(linkedDevice) === "") ? "Images/OZD_unlink_09.png" : "Images/OZD_09.png" }
            PropertyChanges { target: connectingStatus; visible: false }
            PropertyChanges { target: deviceList; visible: false }
            PropertyChanges { target: backButton; visible: false }
            PropertyChanges { target: requestDevicesTimer; running: false }
            PropertyChanges { target: searchTout; running: false }
            PropertyChanges { target: linkingTout; running: false }
        },
        State {
            name: "searching"
            PropertyChanges { target: controlButtonImg; source: "Images/outline_clear_white_24.png" }
            PropertyChanges { target: searchingIcon; visible: true }
            PropertyChanges { target: linkStatus; visible: true }
            PropertyChanges { target: linkName; visible: false }
            PropertyChanges { target: linkStatusImg; source: "Images/outline_more_horiz_white_48.png" }
            PropertyChanges { target: connectingStatus; visible: false }
            PropertyChanges { target: deviceList; visible: true }
            PropertyChanges { target: backButton; visible: false }
            PropertyChanges { target: requestDevicesTimer; running: true }
            PropertyChanges { target: searchTout; running: true }
            PropertyChanges { target: linkingTout; running: false }
        },
        State {
            name: "searchEnd"
            PropertyChanges { target: controlButtonImg; source: "Images/outline_search_again_white_24.png" }
            PropertyChanges { target: searchingIcon; visible: false }
            PropertyChanges { target: linkStatus; visible: linkStatus.visible }
            PropertyChanges { target: linkStatusImg; source: linkStatusImg.source }
            PropertyChanges { target: connectingStatus; visible: false }
            PropertyChanges { target: deviceList; visible: true }
            PropertyChanges { target: backButton; visible: true }
            PropertyChanges { target: requestDevicesTimer; running: false }
            PropertyChanges { target: searchTout; running: false }
            PropertyChanges { target: linkingTout; running: false }
        },
        State {
            name: "linking"
            PropertyChanges { target: controlButtonImg; source: "Images/outline_clear_white_24.png" }
            PropertyChanges { target: searchingIcon; visible: false }
            PropertyChanges { target: linkStatus; visible: false }
            PropertyChanges { target: connectingStatus; visible: true }
            PropertyChanges { target: deviceList; visible: false }
            PropertyChanges { target: backButton; visible: false }
            PropertyChanges { target: requestDevicesTimer; running: false }
            PropertyChanges { target: searchTout; running: false }
            PropertyChanges { target: linkingTout; running: true }
        }
    ]

    Label{
        // debug purposes
        visible: false
        text: parent.state + " - " + linkedDevice + " - " + selectedDevice
        z:10
        y: -20
        color: "gold"
    }

    Row{
       id: controlButtonRow
        height: buttonSize
        opacity: enabled ? 1 : 0.3
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: buttonSize * 0.25

        Rectangle{
            id: controlButton
            height: parent.height
            width:  height
            color:  buttonColor
            radius: buttonRadius
            Image {
                id: controlButtonImg
                anchors.fill: parent
                source: ""
            }
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    switch (deviceLink.state){
                    case "showStatus": deviceLink.state = "searching";  break;//clearDevices(); break;
                    case "searching":  deviceLink.state = "showStatus"; break;
                    case "searchEnd":  deviceLink.state = "searching";  break;//clearDevices(); break;
                    case "linking":    deviceLink.state = "showStatus"; break;
                    }
                    clearDevices();
                    buttonClicked(deviceLink.state)
                }
            }
        }

        Rectangle{
            id: backButton
            height: parent.height
            width:  height
            color:  buttonColor
            radius: buttonRadius
            Image {
                anchors.fill: parent
                source: "Images/outline_clear_white_24.png"
            }
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    backButtonClicked()
                    deviceLink.state = "showStatus"
                }
            }
        }
    }

    Image{
        id: searchingIcon
        property int imageIndex: 0
        height: buttonSize * 0.8
        width:  height
        anchors.right: parent.right
        anchors.verticalCenter: controlButtonRow.verticalCenter
        source: imageIndex ? "Images/outline_bluetooth_searching_white_48.png" : "Images/outline_bluetooth_searching_no_waves_white_48.png"
        Timer{
            running: visible
            interval: 1000
            repeat: true
            onTriggered: parent.imageIndex = parent.imageIndex ? 0 : 1
        }
    }

    Item{
        id: linkStatus
        width: parent.width
        height: parent.height
        anchors.top: parent.top
        anchors.bottom: controlButtonRow.top
        visible: false
        Item{
            anchors.centerIn: parent
            height: linkName.height + linkAddress.height+ linkAddress.anchors.topMargin + auxPositioningItem.height + auxPositioningItem.anchors.topMargin
            width: parent.width
            Label{
                id: linkName
                color: textColor
                height: buttonSize * 0.3
                width: parent.width * 0.8
                anchors.top: parent.top
                anchors.horizontalCenter: parent.horizontalCenter
                text: getName(linkedDevice)
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment:  Text.AlignHCenter
                font.pixelSize: height
                Rectangle {border.color: "gold"; color: "transparent"; anchors.fill: parent; visible: gridView}
            }
            Label{
                id: linkAddress
                color: addTextColor
                height: linkName.height
                width: linkName.width
                visible: linkName.visible
                anchors.top: linkName.bottom
                anchors.topMargin: height * 0.3
                anchors.horizontalCenter: parent.horizontalCenter
                text: getAddress(linkedDevice)
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment:  Text.AlignHCenter
                font.pixelSize: height
                Rectangle {border.color: "plum"; color: "transparent"; anchors.fill: parent; visible: gridView}
            }
            Item{
                id: auxPositioningItem
                width: buttonSize * 1.2
                height: width
                anchors.top: linkAddress.bottom
                anchors.topMargin: height * 0.1
                anchors.horizontalCenter: parent.horizontalCenter
                Rectangle {border.color: "green"; color: "transparent"; anchors.fill: parent; visible: gridView}
           }
           Image{
               id: linkStatusImg
               width: buttonSize
               height: width
               source: ""
               anchors.centerIn: auxPositioningItem
           }
        }
        Rectangle {z:100;border.color: "tomato"; color: "transparent"; anchors.fill: parent; visible: gridView}
    }

    Item{
        id: connectingStatus
        width: parent.width
        anchors.top: parent.top
        anchors.bottom: controlButtonRow.top
        visible: false
        Item{
            anchors.centerIn: parent
            height: connectingName.height + connectingAddress.height+ connectingAddress.anchors.topMargin + connectingStatusImg.height + connectingStatusImg.anchors.topMargin
            width: parent.width
            Label{
                id: connectingName
                color: textColor
                height: buttonSize * 0.3
                width: parent.width * 0.8
                anchors.top: parent.top
                anchors.horizontalCenter: parent.horizontalCenter
                text: getName(selectedDevice)
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment:  Text.AlignHCenter
                font.pixelSize: height
                Rectangle {border.color: "plum"; color: "transparent"; anchors.fill: parent; visible: gridView}
            }
            Label{
                id: connectingAddress
                color: addTextColor
                height: connectingName.height
                width: connectingName.width
                visible: connectingName.visible
                anchors.top: connectingName.bottom
                anchors.topMargin: height * 0.3
                anchors.horizontalCenter: parent.horizontalCenter
                text: getAddress(selectedDevice)
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment:  Text.AlignHCenter
                font.pixelSize: height
                Rectangle {border.color: "plum"; color: "transparent"; anchors.fill: parent; visible: gridView}
            }
            Image{
                id: connectingStatusImg
                property int imageIndex: 0
                width: buttonSize * 1.2
                height: width
                anchors.top: connectingAddress.bottom
                anchors.topMargin: height * 0.1
                anchors.horizontalCenter: parent.horizontalCenter
                source: imageIndex ? "Images/outline_bluetooth_searching_white_48.png" : "Images/outline_bluetooth_searching_no_waves_white_48.png"
                Timer{
                    running: visible
                    interval: 1000
                    repeat: true
                    onTriggered: parent.imageIndex = parent.imageIndex ? 0 : 1
                }
                Rectangle {border.color: "sienna"; color: "transparent"; anchors.fill: parent; visible: gridView}
            }
        }
        Rectangle {border.color: "khaki"; color: "transparent"; anchors.fill: parent; visible: gridView}
    }

    Item{
        id: deviceList
        width: parent.width
        anchors.top: parent.top
        anchors.bottom: controlButtonRow.top
        anchors.bottomMargin: buttonSize * 0.1

        ListModel {
            id: deviceModel
        }

        Component {
            id: discoveredDevice
            Item{
                height: buttonSize * 0.6
                width: deviceLink.width //parent.width
                Label{
                    height: parent.height * 0.6
                    width: parent.width
                    text: "  " + getName(mDeviceName)
                    color: textColor
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment:  Text.AlignLeft
                    font.pixelSize: height * 0.8
                    background: Rectangle{
                        color: (index & 0x01) ? "transparent" : listAlternativeColor
                    }
                }
                Label{
                    height: parent.height * 0.4
                    width: parent.width
                    anchors.bottom: parent.bottom
                    text: "   " + getAddress(mDeviceName)
                    color: addTextColor
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment:  Text.AlignLeft
                    font.pixelSize: height * 0.9
                    background: Rectangle{
                        color: (index & 0x01) ? "transparent" : listAlternativeColor
                    }
                }
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        selectedDevice = mDeviceName
                        devClicked(selectedDevice, index)
                        linkResult = false
                    }
                }
            }
        }

        ScrollView{
            id: control
            anchors.fill: parent
            ScrollBar.vertical.interactive: true
            ScrollBar.vertical.policy: ScrollBar.AlwaysOn
            clip:true
            Column{
                spacing: 0
                anchors.fill: parent

                Repeater {
                    id: discoverdRepeater
                    model: deviceModel
                    delegate: discoveredDevice
                }

//                Component.onCompleted: {
//                    deviceModel.append( { mDeviceName: "BTN 7541" } )
//                    deviceModel.append( { mDeviceName: "BTN 8563" } )
//                    deviceModel.append( { mDeviceName: "BTN 2541" } )
//                }
            }
        }
        Rectangle {border.color: "orange"; color: "transparent"; anchors.fill: parent; visible: gridView}
    }

    Timer{
        id: requestDevicesTimer
        interval: 1000
        repeat: true
        onTriggered: consoleSocket.sendData("{SERIAL_GET_DISC\r")
    }

    Timer{
        id: searchTout
        interval: 90000
        onTriggered: searchEnd()
    }

    Timer{
        id: linkingTout
        interval: 30000
        onTriggered: unLinked()
    }
}



