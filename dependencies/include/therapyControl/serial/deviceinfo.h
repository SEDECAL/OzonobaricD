#pragma once
#include <QString>
#include <QObject>
#include <QBluetoothDeviceInfo>

class DeviceInfo: public QObject
{
    Q_OBJECT
    Q_PROPERTY( QString deviceName READ getName NOTIFY deviceChanged)
    Q_PROPERTY( QString deviceAddress READ getAddress NOTIFY deviceChanged)
    Q_PROPERTY( qint16 rssi READ valueOfRSSI )
    Q_PROPERTY( int major READ valueOfMajor )
    Q_PROPERTY( quint8  minor READ valueOfMinor )

public:
    DeviceInfo(const QBluetoothDeviceInfo &device);
    void setDevice(const QBluetoothDeviceInfo &device);

    QString getName() const;
    QString getAddress() const;
    qint16 valueOfRSSI() const;
    int valueOfMajor() const;
    quint8 valueOfMinor() const;

    QBluetoothDeviceInfo getBTView() const;

signals:
    void deviceChanged();

private:
    QBluetoothDeviceInfo m_device;
};
