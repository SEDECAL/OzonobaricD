// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright (C) 2024 Sedecal S.A.
// This file is part of OzonobaricD.
// See LICENSE file for details.

#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "debtools.h"
#include "socket.h"
#include "main.private.h"
#include "sharefile.h"
#include "androidinterface.h"
#include "batteryinfo.h"



/*constexpr const char* appDomain{"org.protocolsDemo.example"};*/
constexpr const char* appDomain{"com.sedecal.ozonobaricd"};

int main(int argc, char *argv[])
{
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif
    QGuiApplication app(argc, argv);

//// Verificar y solicitar permisos en tiempo de ejecución para Android (en caso de necesitarse)
//  #include <QtAndroidExtras>
//  if (QtAndroid::checkPermission("android.permission.READ_EXTERNAL_STORAGE") != QtAndroid::PermissionResult::Granted) {
//      QtAndroid::requestPermissionsSync({"android.permission.READ_EXTERNAL_STORAGE"});
//  }
//  if (QtAndroid::checkPermission("android.permission.WRITE_EXTERNAL_STORAGE") != QtAndroid::PermissionResult::Granted) {
//      QtAndroid::requestPermissionsSync({"android.permission.WRITE_EXTERNAL_STORAGE"});
//  }

    QQmlApplicationEngine engine;
    AndroidInterface android;
//  android.setScreenOrientation(android_SCREEN_ORIENTATION_SENSOR);

    app.setOrganizationName("Sedecal");
    app.setOrganizationDomain("Sedecal.com");
    app.setApplicationName(appDomain);

    qmlRegisterSingletonType(QUrl("qrc:///Styles/Style2.qml"), "AppStyle", 1, 0, "Style");
    qmlRegisterSingletonType(QUrl("qrc:///Constants/Const0.qml"), "AppConstants", 1, 0, "Const");
    qmlRegisterSingletonType(QUrl("qrc:///Imgs/Img0.qml"), "AppImages", 1, 0, "Img");

    qmlRegisterType<sock2BSPP, 1>("Sock2BSPP", 1, 0, "Sock2BSPP");
    sock2BSPP sock2BSPP_;
    Socket consoleSocket;
    consoleSocket.Manage();
    auto offlineStoragePath = QUrl::fromLocalFile(engine.offlineStoragePath());
    debTools dbtools;
    ShareFile sharefile;
    batteryinfo batteryinfo;

    engine.rootContext()->setContextProperty("socket2BSPP", &sock2BSPP_);
    engine.rootContext()->setContextProperty("consoleSocket", &consoleSocket);
    engine.rootContext()->setContextProperty("offlineStoragePath", offlineStoragePath);
    engine.rootContext()->setContextProperty("dbtools", &dbtools);
    engine.rootContext()->setContextProperty("sharefile", &sharefile);
    engine.rootContext()->setContextProperty("android", &android);
    engine.rootContext()->setContextProperty("batteryInfo", &batteryinfo);

    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}



