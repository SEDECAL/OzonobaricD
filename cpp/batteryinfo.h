// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright (C) 2024 Sedecal S.A.
// This file is part of OzonobaricD.
// See LICENSE file for details.

#ifndef BATTERYINFO_H
#define BATTERYINFO_H

#include <QObject>
#include <QtAndroidExtras/QAndroidJniObject>
#include <QtAndroidExtras/QAndroidJniEnvironment>
#include <QtAndroid>

class batteryinfo : public QObject {
    Q_OBJECT
public:
    explicit batteryinfo(QObject *parent = nullptr);
    Q_INVOKABLE int getBatteryLevel();
    Q_INVOKABLE bool isCharging();
};

#endif // BATTERYINFO_H

