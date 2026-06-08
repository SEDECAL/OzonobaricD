// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright (C) 2024 Sedecal S.A.
// This file is part of OzonobaricD.
// See LICENSE file for details.

pragma Singleton
import QtQuick 2.0

QtObject {
    //  readonly property color xxx: "yyy"

    property QtObject protocol: QtObject {
        readonly property string syringe:              "Images/outline_syringe_white_48.png"
        readonly property string syringe_auto:         "Images/outline_automatic_syringe_white_48_01.png"
        readonly property string manual_syringe:       "Images/outline_manual_syringe_bis_white_48.png"
        readonly property string continuous:           "Images/outline_autorenew_white_48.png"
        readonly property string bag:                  "Images/outline_bag_white_48.png"
        readonly property string open_bag:             "Images/outline_open_bag_white_1_48.png"
        readonly property string closed_bag:           "Images/outline_closed_bag_1_white_48.png"
        readonly property string insuffaltion:         "Images/outline_insuflation_white_48.png"
        readonly property string vaginal_insufflation: "Images/outline_vaginal_insufflation_white_48.png"
        readonly property string rectal_insufflation:  "Images/outline_rectal_insufflation_white_48.png"
        readonly property string dose:                 "Images/outline_local_dose_solid_3_white_48.png"
        readonly property string vacuum:               "Images/outline_vacuum_white_48.png"
        readonly property string vacuum_time:          "Images/outline_vacuum_time_white_48_b.png"
        readonly property string vacuum_pressure:      "Images/outline_vacuum_pressure_white_48_b.png"
    }

    property QtObject param: QtObject {
//      readonly property color xxx: "yyy"

        property QtObject edition: QtObject {
             readonly property string concentration:   "Images/OZONO_02.png"
             readonly property string flow:            "Images/Flow_white.png"
             readonly property string time:            "Images/ic_schedule_white_48dp.png"
             readonly property string c_bag_volume:    "Images/Volume_00.png"
             readonly property string waiting_time:    "Images/ClosedBagWaitingTime_00.png"
             readonly property string i_rectal_volume: "Images/Volume_00.png"
             readonly property string dose:            "Images/small_dose_00.png"
             readonly property string vacuum_time:     "Images/outline_vacuum_time_white_48_b.png"
             readonly property string vacuum_press:    "Images/outline_vacuum_pressure_white_48_b.png"
        }
    }

    property QtObject pressureGadget: QtObject {
        readonly property string mainButton: "Images/check_pressure_02.png"
    }

    property QtObject advertising: QtObject {
        readonly property string dc:            "Images/dc.png"
        readonly property string normalization: "Images/n.png"
        readonly property string halo:          "Images/Halo_Black_00.gif"
    }

    property QtObject helpMenu: QtObject {
        readonly property string manual:                          "Images/READ MANUAL 02.png"
        readonly property string tutorial:                        "Images/TOUCH 02.png"
        readonly property string connection:                      "Images/Connection 01 175x175.png"
        readonly property string video:                           "Images/MOVIE 02.png"
        readonly property string manual_disabled:                 "Images/READ MANUAL 02_Op_30.png"
        readonly property string tutorial_disabled:               "Images/TOUCH 02_Op_30.png"
        readonly property string connection_disabled:             "Images/Connection 01 175x175_Op_30.png"
        readonly property string video_disabled:                  "Images/MOVIE 02_Op_30.png"
        readonly property string manual_Rotation_90:              "Images/READ MANUAL 02_Rotate_90.png"
        readonly property string tutorial_Rotation_90:            "Images/TOUCH 02_Rotate_90.png"
        readonly property string connection_Rotation_90:          "Images/Connection 01 175x175_Rotate_90.png"
        readonly property string video_Rotation_90:               "Images/MOVIE 02_Rotate_90.png"
        readonly property string manual_Rotation_90_disabled:     "Images/READ MANUAL 02_Rotate_90_Op_30.png"
        readonly property string tutorial_Rotation_90_disabled:   "Images/TOUCH 02_Rotate_90_Op_30.png"
        readonly property string connection_Rotation_90_disabled: "Images/Connection 01 175x175_Rotate_90_Op_30.png"
        readonly property string video_Rotation_90_disabled:      "Images/MOVIE 02_Rotate_90_Op_30.png"
    }


}

