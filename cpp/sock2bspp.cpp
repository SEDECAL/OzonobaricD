// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright (C) 2024 Sedecal S.A.
// This file is part of OzonobaricD.
// See LICENSE file for details.

﻿#include <QStandardPaths>
#include "main.private.h"
#include <dlfcn.h>
#include <string>
#include <QDebug>

//////typedef void (*BleBootFunct)(void);
typedef int (*ModuleBootFunct)(void);
using ModuleShutDownFunct = ModuleBootFunct;
constexpr const char *BootFunctName{"ModuleBoot"};
constexpr const char *ShutDownFunctName{"ModuleShutdown"};
/////constexpr const char *StartBleFunctName{"BleBoot"};

namespace sock2BSPPDomain {
constexpr const char *module {"libSock2BSPP.so"};
auto enabled_{false};
ModuleBootFunct plugginShutDown{nullptr};
};

sock2BSPP::sock2BSPP(QObject *parent) : QObject(parent) {}

#include <QtQml>
sock2BSPP::~sock2BSPP()
{
    using namespace sock2BSPPDomain;
    if( plugginShutDown )
        plugginShutDown();
}

bool sock2BSPP::load()
{
    using namespace sock2BSPPDomain;
    if( enabled_ == false )
    {
       QLibrary myModule("Sock2BSPP");
//        QLibrary myModule("/home/ingenieria/O3/OzonobaricD/application/candidate-1.0.0/UI/Sock2BSPP/candidate-1.6.0/build.i686linux/libSock2BSPP.so");
//      QLibrary myModule("/home/ozono/O3/OzonobaricD/application/candidate-1.0.0/UI/Sock2BSPP/candidate-1.6.0/build.i686linux/libSock2BSPP.so");

//      QLibrary myModule("/home/ingenieria/O3/QmlPractise/Soc2BSPP/candidate-1.6.0/build.i686linux/libSock2BSPP.so");
//      QLibrary myModule("/home/ingenieria/.local/share/Sedecal/org.protocolsDemo.example/libSock2BSPP.so");
//        QLibrary myModule("/home/ingenieria/.local/share/Sedecal/org.protocolsDemo.example/assets/libs/libSock2BSPP.so");

//QLibrary myModule("/home/ingenieria/O3/OzonobaricD/fsm_integration/candidate-1.4.0/build.i686linux/libSock2BSPP.so");  //back to basics...
//QLibrary myModule("/home/ingenieria/O3/QmlPractise/Soc2BSPP/candidate-1.4.0/build.i686linux/libSock2BSPP.so");  //back to basics...

        qDebug() << __PRETTY_FUNCTION__  << ":" << ( enabled_ = myModule.load() ) << ":" << myModule.fileName();
     // qDebug() << QCoreApplication::libraryPaths();
     // qDebug() << "AppDataLocation" << QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
        bool ret_val = myModule.isLoaded();
        if( ret_val )
            if( auto f = ( ModuleBootFunct )myModule.resolve(BootFunctName) )
                f();
        qDebug() << __PRETTY_FUNCTION__  << "booted\n";
    }
    return enabled_ ;
}

QString sock2BSPP::state(){ return "" ; }
void sock2BSPP::setRole(BSPPRole role ){ qDebug() << static_cast<int>(role);}
void sock2BSPP::resync(){	qDebug() << __PRETTY_FUNCTION__ ; }


/*
NOTES
load process runs ok on Android.
Some adjustments should be made (@ 30/03/22) to run in linux:
It seems LD_LIBRARY_PATH should contains the path where the library is stored. So this variable should be
fixed in a shell terminal and launch the program from this shell.
To launch the program directly from Qt Creator full path (@ 30/03/22) should be passed to QLibrary module
*/
