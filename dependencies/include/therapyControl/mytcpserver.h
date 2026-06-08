#ifndef MYTCPSERVER_H
#define MYTCPSERVER_H

#include <QObject>
#include <QTcpServer>
#include <QTcpSocket>
#include <QDebug>
#include "inc/iAppSock.h"


class MyTcpServer : public QObject, public iTCPIPPort
{
    Q_OBJECT
public:
    explicit MyTcpServer(QObject *parent = 0);

signals:

public slots:
    void newConnection();
    void readyRead();
    void write(const QByteArray &data);

private:
    QTcpServer *server;
    QTcpSocket *socket;

private:
    // iAppSock.h interface
    void xmitt ( const char *device, const char *payload) override;
    void busActivity ( const char* device, const char *payload ) override;
    void Subscribe( Notifier notifier ) override;
};

#endif // MYTCPSERVER_H
