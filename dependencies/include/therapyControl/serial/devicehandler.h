#ifndef DEVICEHANDLER_H
#define DEVICEHANDLER_H

#include "therapyControl/serial/bluetoothbaseclass.h"

#include <QDateTime>
#include <QTimer>
#include <QVector>

#include <QLowEnergyController>
#include <QLowEnergyService>

class DeviceInfo;

static const QLatin1String transpUartServiceUuid("49535343-FE7D-4AE5-8FA9-9FAFD205E455");
static const QLatin1String transpUartServiceUuidTXCharacteristic("49535343-1E4D-4BD9-BA61-23C647249616");


class DeviceHandler : public BluetoothBaseClass
{
    Q_OBJECT
    Q_PROPERTY(bool alive READ alive NOTIFY aliveChanged )
    Q_PROPERTY(AddressType addressType READ addressType WRITE setAddressType)


public:
    enum class AddressType {
        PublicAddress,
        RandomAddress
    };
    Q_ENUM(AddressType)

    DeviceHandler(QObject *parent = nullptr);

    void attach(DeviceInfo *peripheral);
    void setAddressType(AddressType type);
    AddressType addressType() const;

    bool alive() const;

signals:
    void aliveChanged();
    void statsChanged();
    void received(const QByteArray &value);
    void xmittSignal( QString ) const;

public slots:
    void disconnectService();
    void sppXmitt( const QString  & m_command = "{VER,16") const;

private:
    void serviceDiscovered(const QBluetoothUuid &);
    void serviceScanDone();
    void cleanUp();
    void xmitt(QString message);

    //QLowEnergyService
    void serviceStateChanged(QLowEnergyService::ServiceState s);
    void updateCharacteristic(const QLowEnergyCharacteristic &c,
                              const QByteArray &value);
    void confirmedDescriptorWrite(const QLowEnergyDescriptor &d,
                              const QByteArray &value);

#ifdef SIMULATOR
    void updateDemoHR();
#endif
private:
    QVector<QLowEnergyService*> m_services;
    QLowEnergyController *m_central = nullptr;
    QLowEnergyService *m_service = nullptr;
    QLowEnergyDescriptor m_notificationDesc;
    DeviceInfo *m_currentPeripheral = nullptr;
    QLowEnergyCharacteristic spp;


    bool m_sspServiceEnabled{false};
    bool notifierEnabled{false};
    bool m_busy;
    int services_mask;

    // Statistics
    QDateTime m_start;
    QDateTime m_stop;

    QVector<int> m_measurements;
    QLowEnergyController::RemoteAddressType m_addressType = QLowEnergyController::PublicAddress;

    static QString HProperties(QLowEnergyCharacteristic::PropertyTypes);
    QList<QBluetoothUuid> services;
};

#endif // DEVICEHANDLER_H
