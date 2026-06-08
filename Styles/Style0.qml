// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright (C) 2024 Sedecal S.A.
// This file is part of OzonobaricD.
// See LICENSE file for details.

pragma Singleton
import QtQuick 2.0

QtObject {
//  readonly property color xxx: "yyy"

    property QtObject main: QtObject {
//      readonly property color backColor: "#121212"
        readonly property color backColor: "#151515"
    }

    property QtObject protocolSelector: QtObject {
        readonly property string btn0Color: "#96D647" // keep string type instead of color
        readonly property string btn1Color: "#48C869" // due some problem on list elements
        readonly property string btn2Color: "#00B686"
        readonly property string btn3Color: "#00A199"
        readonly property string btn4Color: "#008B9E"
        readonly property string btn5Color: "#007395"
    }

    property QtObject param: QtObject {
        property QtObject edition: QtObject {
            property QtObject unitsColor: QtObject {
                 readonly property color concentration:   "deepskyblue"
                 readonly property color flow:            "forestgreen"
                 readonly property color time:            "darkgoldenrod"
                 readonly property color c_bag_volume:    "darkorchid"
                 readonly property color waiting_time:    "darkgoldenrod"
                 readonly property color i_rectal_volume: "darkorchid"
                 readonly property color dose:            "saddlebrown"
                 readonly property color vacuum_time:     "darkgoldenrod"
                 readonly property color vacuum_press:    "indianred"
            }
            property QtObject mainColor: QtObject {
                 readonly property color concentration:   "lightskyblue"
                 readonly property color flow:            "limegreen"
                 readonly property color time:            "gold"
                 readonly property color c_bag_volume:    "orchid"
                 readonly property color waiting_time:    "gold"
                 readonly property color i_rectal_volume: "orchid"
                 readonly property color dose:            "sandybrown"
                 readonly property color vacuum_time:     "gold"
                 readonly property color vacuum_press:    "pink"
            }
        }
        property QtObject view: QtObject {
            property QtObject mainColor: QtObject {
                readonly property string dose:     "deepskyblue"
                readonly property string volume:   "forestgreen"
                readonly property string time_m:   "darkgoldenrod"
                readonly property string time_s:   "darkgoldenrod"
                readonly property string pressure: "indianred"
                readonly property string gosth_0:  "transparent"
                readonly property string gosth_1:  "transparent"
            }
            property QtObject backColor: QtObject {
                readonly property string dose:     "lightskyblue"
                readonly property string volume:   "limegreen"
                readonly property string time_m:   "gold"
                readonly property string time_s:   "gold"
                readonly property string pressure: "pink"
                readonly property string gosth_0:  "transparent"
                readonly property string gosth_1:  "transparent"
            }
        }
    }

    property QtObject customerName: QtObject {
        readonly property bool  shadowEnable: false
        readonly property int   shadowRadius: 10
        readonly property color fontColor:   "#555555"
    }

    property QtObject gradientProgress: QtObject {
        readonly property color upColor:  "firebrick"
        readonly property color midColor: "forestgreen"  // "darkGreen"
        readonly property color lowColor: "gold"
    }

    property QtObject helpMenu: QtObject {
        readonly property color backColor:   "#555"
        readonly property color selectColor: "#777"
    }

    property QtObject input: QtObject {
        readonly property bool  shadowEnable: true
        readonly property int   shadowRadius: 10
        readonly property color backColor:   "#444444"  // white & 0.2 opacity
        readonly property color buttonColor: "#1A1A1A"
        readonly property bool  buttonShadowEnable: false
        readonly property int   buttonShadowRadius: 7
        readonly property color buttonShadowColor: "#2A2A2A"
    }

    property QtObject pressureGadget: QtObject {
        readonly property bool  shadowEnable: true
        readonly property int   shadowRadius: 10
        readonly property color backColor:   "#444444"
    }

    property QtObject pressureTest: QtObject {
        readonly property bool  buttonShadowEnable: true
        readonly property int   buttonShadowRadius: 7
        readonly property color buttonShadowColor: "#2A2A2A"
        readonly property color backColor:         "transparent"
        readonly property color buttonColor:       "#1A1A1A"
        readonly property color lineColor:         main.backColor
        readonly property color overpressure:      "orange"
        readonly property color unitsColor:        "forestgreen"
        readonly property color valueColor:        "limegreen"
        readonly property color metterUnitsColor:  "gold"
        readonly property color metterValueColor:  "transparent"
    }

    property QtObject pageIndicator: QtObject {
        readonly property color color: "#666666"
    }

    property QtObject resultView: QtObject {
        readonly property color backColor: "#444444"
    }

    property QtObject tabBar: QtObject {
        readonly property color indicatorColor: "white"
        readonly property color indicatorBorderColor: "#AAAAAA"
        readonly property color indicatorAuraColor: "#CCCCCC"
        readonly property color indicatorAuraBorderColor: "#CCCCCC"
    }

    property QtObject toolBar: QtObject {
        readonly property color buttonBackColor: "transparent"
        readonly property color timeDateColor: "#BBBBBB"
    }

    property QtObject configurationArea: QtObject {
        readonly property color backColor:   "#2B2F34"
        readonly property color cardColor:   "#383C42"
        readonly property color backButtonShadowColor: "#222222"
        readonly property int   backButtonShadowRadius: 15
        readonly property color tabViewColor: configurationArea.backColor//"#2B2F34"
        readonly property color tabViewDisabledColor: "#212427"
    }

    property QtObject deviceInfo: QtObject {
        readonly property color cardColor:   "#383C42"
        readonly property color tittleColor: "#008B9E"
        readonly property color textColor:   "#AAAAAA"
        readonly property color buttonColor: "#616161"
        readonly property bool  buttonShadowEnable: true
        readonly property int   buttonShadowRadius: 5
        readonly property color buttonShadowColor: "#2A2A2A"
    }

    property QtObject deviceCalibration: QtObject {
        readonly property color cardColor:           "#383C42"
        readonly property color tittleColor:         "#008B9E"
        readonly property color controlsColor:       "#008B9E"
        readonly property color activeControlsColor: "#00E1FF"
        readonly property color textColor:           "#AAAAAA"
        readonly property color buttonColor:         "#5F6367"
        readonly property color stepsColor:          "#DDDDDD"
        readonly property color descriptionColor:    "#BBBBBB"
        readonly property color lockColor:           "#424242"
        readonly property bool  lockShadowEnable:    true
        readonly property int   lockShadowRadius:    8
        readonly property color lockShadowColor:     "#151515"
        readonly property color pinPadColor:         "#3A3A3A"
        readonly property color pinPadButtonColor:   "#525252"
        readonly property bool  pinPadShadowEnable:  true
        readonly property int   pinPadShadowRadius:  15
        readonly property color pinPadShadowColor:   "#151515"
    }
}



