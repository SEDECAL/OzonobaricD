#pragma once

//// JB#January 2021 helper to representate 1970 seconds in a decent way
//#include <string>
//#include <ctime>
//#include <iostream>
//#include <iomanip>
//#include <sys/time.h>

//typedef struct {} signaturedTime;
//template <typename T=void>
//std::string snapshot( unsigned int now_ = 0 )
//{
//    using namespace std;
//    ostringstream oss;
//    if constexpr ( std::is_same_v<T, signaturedTime> )
//    {
//        time_t t; time( & t );
//        struct tm * tm = localtime( & t );
//        struct timeval tv; gettimeofday( & tv, 0);

//        oss << tm->tm_year + 1900;
//    for( auto i : { tm->tm_mon +1, tm->tm_mday, tm->tm_hour, tm->tm_min, tm->tm_sec } )
//            oss << setfill ('0') << setw (2) << i;
//        return oss.str();
//    }
//    time_t now = now_ == 0 ? time(0) : static_cast<time_t>( now_ );
//    string tmp = string( ctime( & now ) );
//    struct timespec msec;
//    clock_gettime( CLOCK_REALTIME, & msec);
//    oss << tmp.substr(0, tmp.length() -6 ) << "." << std::setfill('0') << setw(3) << (int) (msec.tv_nsec / 1000000 );
//    return oss.str();
//}

#include <QObject>
class BluetoothBaseClass : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString error READ error WRITE setError NOTIFY errorChanged)
    Q_PROPERTY(QString info READ info WRITE setInfo NOTIFY infoChanged)
    Q_PROPERTY(bool busy  READ busy WRITE setBusy NOTIFY busyChanged )

public:
    explicit BluetoothBaseClass(QObject *parent = nullptr);

    QString error() const;
    void setError(const QString& error);
    void clearError();

    QString info() const;
    void setInfo(const QString& info);

    void setBusy(bool);
    bool busy() const;

    void clearMessages();

signals:
    void errorChanged(const QString&);
    void infoChanged(const QString&);
    void busyChanged();

private:
    QString m_error;
    QString m_info;
    bool m_busy;
};


