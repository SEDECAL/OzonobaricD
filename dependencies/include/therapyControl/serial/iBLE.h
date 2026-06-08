#pragma once

#include <QObject>

#ifdef __cplusplus
class iBLEManage {
public:
    virtual void startSearch() = 0;
    virtual void startDiscovering() = 0;
    virtual void stopSearch() = 0;
    virtual void stopDiscovering() = 0;
    virtual void setName(const QString &name) = 0;
    virtual void setAddress(const QString &add) = 0;
    virtual bool serialStatus() = 0;
    virtual QString getName() = 0;
    virtual QString getAddress() = 0;
    virtual QString getDiscovered() = 0;
    virtual ~iBLEManage(){};
};
#endif
