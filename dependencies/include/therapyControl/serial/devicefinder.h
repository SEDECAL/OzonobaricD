#ifndef DEVICEFINDER_H
#define DEVICEFINDER_H

#include "therapyControl/serial/bluetoothbaseclass.h"

#include <QTimer>
#include <QVariant>
#include <QBluetoothDeviceDiscoveryAgent>
#include <QBluetoothDeviceInfo>


class DeviceInfo;
class DeviceHandler;

class DeviceFinder: public BluetoothBaseClass
{
    Q_OBJECT

    static constexpr const char *LBEServerName{"RN4870-EDA3"};
    static constexpr const char *LBEServerMAC{"D8:80:39:F3:ED:A3"};
    bool discovered{false};
    Q_PROPERTY(bool scanning READ scanning NOTIFY scanningChanged)
    Q_PROPERTY(QVariant devices READ devices NOTIFY devicesChanged)

public:
    DeviceFinder(DeviceHandler *handler, QObject *parent = nullptr);
    ~DeviceFinder();

    bool scanning() const;
    QVariant devices();

public slots:
    void startSearch();
    void startDiscovering();
    void stopSearch();
    void connectToService(const QString &address);
    void setBleServerName(const QString &name);
    void setBleServerMac(const QString &mac);
    QString getBleServerName();
    QString getBleServerMac();
    QString getDiscovered();

private slots:
    void peripheralDiscovered(const QBluetoothDeviceInfo&);
    void scanError(QBluetoothDeviceDiscoveryAgent::Error error);
    void scanFinished();
    void launchSearch();

signals:
    void scanningChanged();
    void devicesChanged();

private:
    DeviceHandler *peripheral{nullptr};
    QBluetoothDeviceDiscoveryAgent *m_deviceDiscoveryAgent;
    QList<QObject*> peripherals;
    void cleanup();
    QString auditory;

    QString mBleServerName = "RNXXXX-YYYY"; //"RN4870-EDA3"
    QString mBleServerMac = "XX:XX:XX:XX:XX:XX"; //"D8:80:39:F3:ED:A3";
    QList<QString> deviceList; // = {"RN4870-1111_,_11:80:11:F3:11:11", "RN4870-2222_,_22:80:22:F3:22:22"};
    int deviceListIndex = 0;
    bool justDiscover = false;
};

#endif // DEVICEFINDER_H
