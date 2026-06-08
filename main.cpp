// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright (C) 2024 Sedecal S.A.
// This file is part of OzonobaricD.
// See LICENSE file for details.

#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <debtools.h>
#include "cpp/socket.h"
#include "cpp/main.private.h"

int main(int argc, char *argv[])
{
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif
    debTools dbtools;

    QGuiApplication app(argc, argv);
    qmlRegisterSingletonType(QUrl("qrc:///Styles/Style1.qml"), "AppStyle", 1, 0, "Style");
    qmlRegisterSingletonType(QUrl("qrc:///Constants/Const0.qml"), "AppConstants", 1, 0, "Const");
    qmlRegisterSingletonType(QUrl("qrc:///Imgs/Img0.qml"), "AppImages", 1, 0, "Img");

    QQmlApplicationEngine engine;


    qmlRegisterType<sock2BSPP, 1>("Sock2BSPP", 1, 0, "Sock2BSPP");
    sock2BSPP tmp;
    engine.rootContext()->setContextProperty("socket2BSPP", & tmp);
    Socket consoleSocket;
    consoleSocket.Manage();
    engine.rootContext()->setContextProperty("consoleSocket", &consoleSocket);




    auto offlineStoragePath = QUrl::fromLocalFile(engine.offlineStoragePath());
    engine.rootContext()->setContextProperty("offlineStoragePath", offlineStoragePath);
    engine.rootContext()->setContextProperty("dbtools", &dbtools);

    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}

