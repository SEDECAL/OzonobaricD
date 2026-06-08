// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright (C) 2024 Sedecal S.A.
// This file is part of OzonobaricD.
// See LICENSE file for details.

#include "socket.h"
#include "therapyControl/TCPIPDictionary.h"
#include <QTimer>

constexpr const char *hbeat_           { SPROT_KEEP_ALIVE"\r" };
constexpr const char *hbeatACK_        { SPROT_ACK_RESP"\r" };
constexpr const char *signatureACK_    { SPROT_GET_SW_VER };
constexpr const bool debug{ false };


std::atomic<bool> watchDogEnable{true};
std::atomic<bool> Socket::hbeatState;
static QTimer *watchdog;

std::atomic<bool> Socket::alive;

Socket::Socket( QObject *parent ) : QObject( parent )
{

    ( watchdog = new QTimer() )->setParent(this);
    watchdog->setInterval( 1000 );
    connect( watchdog, & QTimer::timeout, [&](){
        if( hbeatState == false )
            emit hbeat( hbeatState );
        hbeatState = false;
        if( watchDogEnable )
            sendData( hbeat_ );
    }
    );
}

Socket::~Socket()
{
    socket->close();
    alive = false;
}

void Socket::Manage()
{
    socket = new QTcpSocket(this);

    // socket->setSocketOption(QAbstractSocket::LowDelayOption, 1);
    alive = true;
    connect( socket, &QTcpSocket::connected, [&]()
    {
		emit connected(QString("%1:%2 connected").arg(serverName).arg(serverPort));
        watchdog->start();
    });

    connect( socket, &QTcpSocket::disconnected, [&](){
        if( alive )
        {
            emit disconnected( QString("Sock(%1:%2) : %3")
                               .arg(serverName)
                               .arg(serverPort)
                               .arg(socket->errorString()));
            watchdog->stop();
        }
    });

    connect(socket, &QTcpSocket::readyRead, [&](){

        auto tmp{ socket->readAll() };
        QRegExp rx;

        ( rx = QRegExp("*Completed*") ).setPatternSyntax(QRegExp::Wildcard);
        if( rx.exactMatch( tmp ) )
            return emit completed( tmp );

        ( rx = QRegExp( QString("*%1").arg( hbeatACK_ ))).setPatternSyntax( QRegExp::Wildcard );
        if( rx.exactMatch( tmp ) )
            return emit hbeat( hbeatState = true );

        auto aux = QString(tmp).split("\r");
        for( auto token : aux )
        {
            rx = QRegExp("*orange*");
            rx.setPatternSyntax(QRegExp::Wildcard);
            if( rx.exactMatch(token) )
            {
                emit failure( token );
                continue;
            }

            ( rx = QRegExp( QString("*%1*").arg( signatureACK_ ))).setPatternSyntax( QRegExp::Wildcard );
            if( rx.exactMatch( token ) )
            {
                auto aux = QString(token).split(',');
                emit signature( { aux[1], aux[2] } );
            }

            bool processing{false};
            if( token.isEmpty() == false )
            {
                if( token.split(SPROT_ACK_RESP).size() > 1 )
                {

                    auto payload = token.split(SPROT_ACK_RESP)[1];
                    QString topic_name = payload.split(",")[0];

                    // Low Level Serial Protocol format i.e: "{@,SG,0,2504,1C"
                    if( topic_name.isEmpty() )
                        if( token.split(",").size() > 2 )
                            topic_name = QString("{%0").arg( token.split(",")[1] );

                    if( topic_name.length() )
                    {
                        for( auto & [ topics, notifier ] : notifiers )
                        {
                            //  qDebug() << topic_name << " vs " << topics;
                            if( topics.contains( topic_name ) )
                            {
                                notifier->topicUpdate( topic_name, payload );
                                processing = true;
                            }
                        }
                    }
                }
            }

            if ( processing == false )
                if( token.isEmpty() == false )
                    emit busActivity( token );
        }

    } );

    connect(socket, SIGNAL(bytesWritten(qint64)), this, SLOT(bytesWritten(qint64)));

    connect(socket, QOverload<QAbstractSocket::SocketError>::of(&QAbstractSocket::error),
            [=]( QAbstractSocket::SocketError ){
        qDebug() << "Socket Handler: " << socket->errorString();
        emit failure( QString("<font color=\"orange\">WARNING TCPIP.server(%1:%2) : <b>%3</b></font>")
                      .arg(serverName)
                      .arg(serverPort)
                      .arg(socket->errorString()));
    }
    );
}

void Socket::bytesWritten(qint64 bytes)
{
/*  qDebug() << "Socket written: " << bytes << "btyes"; */
    emit onWritten(bytes);
}

void Socket::sendData( QString data )
{    
/*  qDebug() << "Socket written: ----->" << data; */
	if( socket->isValid() )
	{
        socket->write(data.toLatin1());
        emit onWrite(data);
    }
}

void Socket::subscribe(QVector<QString> topics, iSocketSubscriptor* subscriber)
{
    notifiers[ subscriber->whoAmI() ] = { topics, subscriber };
}

void Socket::startConnection( int serverPort ) { socket->connectToHost( serverName= "localhost", this->serverPort = serverPort); }
void Socket::syncState(){ sendData( QString("%1\r%2\r").arg(SPROT_GET_SW_VER).arg(SPROT_GET_STATE) ); }
void Socket::hbeatSettings( int window )
{
    qDebug() << QString("%1 %2").arg(__PRETTY_FUNCTION__ ).arg(window);
    watchDogEnable = window ? true : false;
    watchdog->setInterval( watchDogEnable ? window : watchdog->interval() );
}
