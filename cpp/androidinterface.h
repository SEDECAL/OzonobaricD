// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright (C) 2024 Sedecal S.A.
// This file is part of OzonobaricD.
// See LICENSE file for details.

#pragma once

#include <QObject>


#define android_SCREEN_ORIENTATION_LANDSCAPE 0
#define android_SCREEN_ORIENTATION_PORTRAIT 1
#define android_SCREEN_ORIENTATION_SENSOR 4
#define android_SCREEN_ORIENTATION_SENSOR_LANDSCAPE 6
#define android_SCREEN_ORIENTATION_SENSOR_PORTRAIT 7

class AndroidInterface : public QObject
{
    Q_OBJECT
//    Q_PROPERTY(bool screenOnStatus READ screenOnStatus WRITE setScreenOnStatus NOTIFY screenOnStatusChanged)
    Q_PROPERTY(bool screenOnStatus READ screenOnStatus WRITE setScreenOnStatus NOTIFY screenOnStatusChanged)
public:
    AndroidInterface();
    void setScreenOnStatus(bool status);
    bool screenOnStatus();

    Q_INVOKABLE bool setScreenOrientation(int orientation);
    Q_INVOKABLE void keepScreenOn(bool on);
    Q_INVOKABLE void restarApp();
    Q_INVOKABLE int getScreenOrientation();

signals:
    void screenOnStatusChanged();

private:
    bool m_screenOnStatus = false;
};
