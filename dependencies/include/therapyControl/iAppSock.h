#pragma once

#include <memory>
template<class T, class... Args>
auto s_factory( Args&&... args ){ return [ args... ]{ return std::make_shared<T>(args...); }(); }

template<class T, class... Args>
auto factory_unique( Args&&... args ){ return std::move( [ args... ]{ return std::make_unique<T>(args...); }()); }

#include <string>
class iNotifier
{
public:
    virtual void uiNotify( const char *payload ) = 0;
    virtual void busNotify( const char *device, const std::string &payload ) = 0;
    virtual ~iNotifier(){}
};

class iTCPIPPort {
public:
    virtual void xmitt       ( const char *device, const char *payload ) = 0;
    virtual void busActivity ( const char* device, const char *payload ) = 0;

    using Notifier = std::weak_ptr<iNotifier> ;
    virtual void Subscribe( Notifier notifier ) = 0;
    virtual ~iTCPIPPort(){};
};

#include "therapyControl/Errors.h"
class iError {
public:
    virtual std::string error( OZONETTE_APP_ERRORS error_id ) = 0;
};
