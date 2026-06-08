// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright (C) 2024 Sedecal S.A.
// This file is part of OzonobaricD.
// See LICENSE file for details.

import QtQuick 2.12

Item {
    signal error()
    signal generating()
    signal endGeneration()
    signal vacuum()
    signal adjusting()
    signal waiting()
    signal pause()
    signal play()
    signal pauseVac()
    signal returnToActive()

    signal bluetoothLinked()
    signal bluetoothUnlinked()

    signal loadParamEnd(bool loadError)
    signal saveParamEnd(bool saveError)

    signal gadgetOverpressure()

    signal configO3end()
}
