#pragma once

#include <QtCore/qobject.h>
#include <QTimer>
#include <QtBluetooth/qbluetoothaddress.h>
#include <QtBluetooth/qbluetoothserviceinfo.h>
#include <QtBluetooth/QBluetoothServer>
#include "therapyControl/iAppSock.h"
#include "therapyControl/serial/iSPP.h"
#include "therapyControl/serial/iBLE.h"

QT_USE_NAMESPACE

class cBLESPPClient : public QObject, public iSPPPort , public iBLEManage {
    Q_OBJECT

public:
    explicit cBLESPPClient( iTCPIPPort & sock, QObject *parent = nullptr);
    ~cBLESPPClient();

public slots: // study to be projected as private--
    qint64 busXmitt(const QString &message, const QString &Device = "");

private slots:
    void pullSock(const QByteArray &value);

signals:
    void searchRequest();
    void discoverRequest();
    void stopSearchRequest();
    void stopDiscoverRequest();

private:
    void cleanUp();
    iTCPIPPort & appPort;

private:
    // iBSSPPort interface
    bool busXmitt( const char *payload, const char *device = nullptr ) override;
    bool emulation( bool enabled = false ) override;
    void boot( int acceptPort ) override ;
    void shutdown() override;

    // iBLE interface
    void startSearch() override;
    void startDiscovering() override;
    void stopSearch() override;
    void stopDiscovering() override;
    void setName(const QString &name) override;
    void setAddress(const QString &add) override;
    bool serialStatus() override;
    QString getName() override;
    QString getAddress() override;
    QString getDiscovered() override;
};

