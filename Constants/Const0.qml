// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright (C) 2024 Sedecal S.A.
// This file is part of OzonobaricD.
// See LICENSE file for details.

pragma Singleton
import QtQuick 2.0

QtObject {
//  readonly property color xxx: "yyy"

    property QtObject protocol: QtObject {
        readonly property string syringe:              "syringe"
        readonly property string syringe_auto:         "syringe_auto"
        readonly property string manual_syringe:       "manual_syringe"
        readonly property string continuous:           "continuous"
        readonly property string bag:                  "bag"
        readonly property string open_bag:             "open_bag"
        readonly property string closed_bag:           "closed_bag"
        readonly property string insuffaltion:         "insuffaltion"
        readonly property string vaginal_insufflation: "vaginal_insufflation"
        readonly property string rectal_insufflation:  "rectal_insufflation"
        readonly property string dose:                 "dose"
        readonly property string vacuum:               "vacuum"
        readonly property string vacuum_time:          "vacuum_time"
        readonly property string vacuum_pressure:      "vacuum_pressure"
    }
    property QtObject param: QtObject {
//      readonly property color xxx: "yyy"

        property QtObject edition: QtObject {
            readonly property string concentration:   "concentration"
            readonly property string flow:            "flow"
            readonly property string time:            "time"
            readonly property string c_bag_volume:    "c_bag_volume"
            readonly property string waiting_time:    "waiting_time"
            readonly property string i_rectal_volume: "i_rectal_volume"
            readonly property string dose:            "dose_"
            readonly property string vacuum_time:     "vacuum_time"
            readonly property string vacuum_press:    "vacuum_press"
        }
        property QtObject view: QtObject {
            readonly property string dose:     "dose"
            readonly property string volume:   "volume"
            readonly property string time_m:   "time_m"
            readonly property string time_s:   "time_s"
            readonly property string pressure: "pressure"
            readonly property string gosth_0:  "gosth_0"
            readonly property string gosth_1:  "gosth_1"
        }
    }
    property QtObject controls: QtObject {
        readonly property string play:     "play"
        readonly property string pause:    "pause"
        readonly property string stop:     "stop"
        readonly property string help:     "help"
        readonly property string settings: "settings"
    }
}
