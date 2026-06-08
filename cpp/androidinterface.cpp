// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright (C) 2024 Sedecal S.A.
// This file is part of OzonobaricD.
// See LICENSE file for details.


#include <QtAndroidExtras>
#include "androidinterface.h"

#include <QtAndroid>
#include <QAndroidJniObject>
#include <QDebug>

AndroidInterface::AndroidInterface()
{
}

bool AndroidInterface::setScreenOrientation(int orientation)
{
	QAndroidJniObject activity = QtAndroid::androidActivity();

	if(activity.isValid())
	{
		activity.callMethod<void>("setRequestedOrientation", "(I)V", orientation);
		return true;
	}
	
	return false;
}

int AndroidInterface::getScreenOrientation()
{
    QAndroidJniObject activity = QtAndroid::androidActivity();
    if (!activity.isValid()) return -1;

    QAndroidJniObject resources = activity.callObjectMethod("getResources", "()Landroid/content/res/Resources;");
    QAndroidJniObject configuration = resources.callObjectMethod("getConfiguration", "()Landroid/content/res/Configuration;");

    int orientation = configuration.getField<jint>("orientation");

    return orientation; // 1 = Portrait, 2 = Landscape
}

void AndroidInterface::setScreenOnStatus(bool state){
    if(m_screenOnStatus == state)
        return;

    m_screenOnStatus = state;
    emit screenOnStatusChanged();
}

bool AndroidInterface::screenOnStatus(){
    return m_screenOnStatus;
}

void AndroidInterface::keepScreenOn(bool on) {

    QtAndroid::runOnAndroidThread([on]{
        QAndroidJniObject activity = QtAndroid::androidActivity();
        if (activity.isValid()) {
            QAndroidJniObject window = activity.callObjectMethod("getWindow", "()Landroid/view/Window;");

            if (window.isValid()) {
                const int FLAG_KEEP_SCREEN_ON = 128;
                if (on) {
                    qDebug() << __PRETTY_FUNCTION__ << "keep screen on forever...";
                    window.callMethod<void>("addFlags", "(I)V", FLAG_KEEP_SCREEN_ON);
                } else {
                    qDebug() << __PRETTY_FUNCTION__ << "allow to switch off the screen when appropriate...";
                    window.callMethod<void>("clearFlags", "(I)V", FLAG_KEEP_SCREEN_ON);
                }
            }
        }
        QAndroidJniEnvironment env;
        if (env->ExceptionCheck()) {
            env->ExceptionClear();
        }
    });
   setScreenOnStatus(on);
}


void AndroidInterface::restarApp() {
//  https://www.kdab.com/qt-on-android-how-to-restart-your-application/
    auto activity = QtAndroid::androidActivity();

    auto packageManager = activity.callObjectMethod("getPackageManager",
                                                    "()Landroid/content/pm/PackageManager;");

    auto activityIntent = packageManager.callObjectMethod("getLaunchIntentForPackage",
                                                          "(Ljava/lang/String;)Landroid/content/Intent;",
                                                          activity.callObjectMethod("getPackageName",
                                                                                    "()Ljava/lang/String;").object());

    auto pendingIntent = QAndroidJniObject::callStaticObjectMethod("android/app/PendingIntent", "getActivity",
                                                                   "(Landroid/content/Context;ILandroid/content/Intent;I)Landroid/app/PendingIntent;",
                                                                   activity.object(), jint(0), activityIntent.object(),
                                                                   QAndroidJniObject::getStaticField<jint>("android/content/Intent",
                                                                                                           "FLAG_ACTIVITY_CLEAR_TOP"));
    //                                                                                                           "FLAG_ONE_SHOT"));

    auto alarmManager = activity.callObjectMethod("getSystemService",
                                                  "(Ljava/lang/String;)Ljava/lang/Object;",
                                                  QAndroidJniObject::getStaticObjectField("android/content/Context",
                                                                                          "ALARM_SERVICE",
                                                                                          "Ljava/lang/String;").object());

    alarmManager.callMethod<void>("set",
                                  "(IJLandroid/app/PendingIntent;)V",
                                  QAndroidJniObject::getStaticField<jint>("android/app/AlarmManager", "RTC"),
                                  jlong(QDateTime::currentMSecsSinceEpoch() + 100), pendingIntent.object());
    qApp->quit();
}
