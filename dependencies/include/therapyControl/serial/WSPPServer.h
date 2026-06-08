#pragma once

#include <QtCore/qobject.h>
#include <QSerialPort>
#include <QTimer>
#include "therapyControl/iAppSock.h"
#include "therapyControl/serial/iSPP.h"
#include <QFuture>

QT_USE_NAMESPACE

class cWSPPServer : public QObject, public iSPPPort {
    Q_OBJECT
    static constexpr const char* whoAmI{ "<font color=\"green\">cWSPPServer</font> " };
    static constexpr const int   watchDogWindow{1000};
    static constexpr auto defaultRate{QSerialPort::Baud57600};
    QFuture<void> f;

public:
    explicit cWSPPServer( iTCPIPPort & sock, QObject *parent = nullptr);
    ~cWSPPServer();

public slots:
    qint64 busXmitt(const QString &message);

signals:
    void received ( const QString & sender, const QString &message);

private:
    iTCPIPPort & appPort;
    QSerialPort *sp{nullptr};
    QString latch;
    int sniffer{3};
    bool emulationEnabled{false}, startUp{true};
    void auditory(const std::string &uiMessage, int deferred = 200 );

private:
    // iSPPort interface
    bool busXmitt( const char *payload, const char *device = nullptr ) override;
    bool emulation( bool enabled = false ) override;
    void boot( int acceptPort ) override;
    void shutdown() override;
};

