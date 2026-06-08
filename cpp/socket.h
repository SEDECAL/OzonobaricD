// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright (C) 2024 Sedecal S.A.
// This file is part of OzonobaricD.
// See LICENSE file for details.

#ifndef SOCKET_H
#define SOCKET_H

#include <QObject>
#include <QDebug>
#include <QTcpSocket>
#include <QAbstractSocket>
#include <QString>
#include <QtQml>
#include "iSocket.h"

class Socket : public QObject, public iSocket
{
    Q_OBJECT
	static constexpr int default_port{65530};

public:
    explicit Socket(QObject *parent = 0);
    ~Socket();
    void Manage();

    // platform reflectors for the QML side in charge to monitor/process the socket reactions
signals:
    void busActivity( QString busPayload );

    void onWrite(QString data);
    void onWritten(qint64 bytes);

    void disconnected    ( QString sockFailure  );
    void failure         ( QString sockFailure  );
    void connected       ( QString auditory     );
    void completed       ( QString peerID       );
    void hbeat           ( bool targetState     );
    void signature       ( QStringList firmwareData );

public slots:
    void bytesWritten(qint64 bytes);
    void startConnection( int serverPort = default_port );
    void syncState();
    void hbeatSettings( int window );

public slots:
    void sendData(QString data) override;
    void subscribe(QVector<QString>topics, iSocketSubscriptor *subscriber ) override;

private:
    QTcpSocket *socket;
    QString dataReceived, serverName;
    int serverPort;
    static std::atomic<bool> alive, hbeatState;
    using QSubscription = std::tuple<QVector<QString>,iSocketSubscriptor*>;
    QMap<QString,QSubscription> notifiers;

};

#endif // SOCKET_H
