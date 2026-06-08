// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright (C) 2024 Sedecal S.A.
// This file is part of OzonobaricD.
// See LICENSE file for details.

#include "batteryinfo.h"

batteryinfo::batteryinfo(QObject *parent) : QObject(parent) {}

int batteryinfo::getBatteryLevel() {
    QAndroidJniObject activity = QtAndroid::androidActivity();
    QAndroidJniObject context = activity.callObjectMethod(
        "getApplicationContext", "()Landroid/content/Context;");

    QAndroidJniObject batteryService = context.callObjectMethod(
        "getSystemService",
        "(Ljava/lang/String;)Ljava/lang/Object;",
        QAndroidJniObject::fromString("batterymanager").object<jstring>());

    if (batteryService.isValid()) {
        int level = batteryService.callMethod<jint>("getIntProperty", "(I)I",
            4 /* BatteryManager.BATTERY_PROPERTY_CAPACITY */);

        return level;
    }
    return -1; // Error
}

bool batteryinfo::isCharging() {
    QAndroidJniObject activity = QtAndroid::androidActivity();

    // Crear un IntentFilter para "android.intent.action.BATTERY_CHANGED"
    QAndroidJniObject intentFilter("android/content/IntentFilter");
    intentFilter.callMethod<void>("addAction",
                                  "(Ljava/lang/String;)V",
                                  QAndroidJniObject::fromString("android.intent.action.BATTERY_CHANGED").object());

    // Registrar el receptor de la batería con el IntentFilter
    QAndroidJniObject intent = activity.callObjectMethod(
                "registerReceiver",
                "(Landroid/content/BroadcastReceiver;Landroid/content/IntentFilter;)Landroid/content/Intent;",
                nullptr, intentFilter.object());

    if (intent.isValid()) {
        int status = intent.callMethod<jint>("getIntExtra", "(Ljava/lang/String;I)I",
                                             QAndroidJniObject::fromString("status").object<jstring>(), -1);
        int plugged = intent.callMethod<jint>("getIntExtra", "(Ljava/lang/String;I)I",
                                              QAndroidJniObject::fromString("plugged").object<jstring>(), -1);

        return (status == 2 || plugged > 0); // 2 = BATTERY_STATUS_CHARGING
    }

    return false; // No se pudo determinar
}

