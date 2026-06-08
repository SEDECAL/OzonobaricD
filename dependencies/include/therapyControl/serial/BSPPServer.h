#pragma once

#include <QtCore/qobject.h>
#include <QTimer>
#include <QtBluetooth/qbluetoothaddress.h>
#include <QtBluetooth/qbluetoothserviceinfo.h>
#include <QtBluetooth/QBluetoothServer>
#include "therapyControl/iAppSock.h"
#include "therapyControl/serial/iSPP.h"

QT_FORWARD_DECLARE_CLASS(QBluetoothSocket)
QT_FORWARD_DECLARE_CLASS(QBluetoothLocalDevice)

QT_USE_NAMESPACE

class cBSPPServer : public QObject, public iSPPPort {
    Q_OBJECT

    static constexpr const char *laika{"D8:CE:3A:76:F9:38"};
    static constexpr const char* BSSPDomain[] = {laika};
    static constexpr const char* whoAmI{ "<font color=\"green\">cBSPPServer</font> " };
    static constexpr const char* uuid{"e8e10f95-1a70-4b27-9ccf-02010264e9c8"};
    static constexpr const int   watchDogWindow{1000};

public:
    explicit cBSPPServer( iTCPIPPort & sock, QObject *parent = nullptr);
    ~cBSPPServer();

    void cleanUp();

    enum scopeValue {
        Reachable   = -1,
        UnReachable = -2,
        UnPlugged   = -3,
        UnReachabledForEver = -4
    };
    
signals:
    void scope( const QString & target, scopeValue value );

public slots: // study to be projected as private--
    qint64 busXmitt(const QString &message, const QString &Device = "");

signals:
    void received ( const QString & sender, const QString &message);
    void accepted ( const QString & connection );

private slots:
    void acceptedConnection();
    void pullSock();

private:
    QBluetoothServer *instance( int acceptPort = serverPort );
    QBluetoothServer *rfcommServer = nullptr;
    QBluetoothServer::Error error;

    QBluetoothServiceInfo serviceInfo;
    void registerService(const QBluetoothAddress &address);

    void domainHotPlug();
    QBluetoothAddress adapterAddress;
    QBluetoothLocalDevice *localAdapter = nullptr;
    QMap<QString,QBluetoothSocket*> clientSockets;
    iTCPIPPort & appPort;
    QVector<QString> serverDomain;
    QTimer hotPlugWatchdog;
    int sniffer{0}, acceptPort{serverPort};
    bool emulationEnabled{false};

private:
    // iBSSPPort interface
    bool busXmitt( const char *payload, const char *device = nullptr ) override;
    bool emulation( bool enabled = false ) override;
    void boot( int acceptPort ) override ;
    void shutdown() override;
};

