#pragma once

#include <memory>
#include "inc/iAppSock.h"
#include "inc/serial/iSPP.h"
#include "inc/serial/iBLE.h"

class cTherapyControl {

public:
    cTherapyControl(iTCPIPPort & tcpipPort, iSPPPort & sppPort , iBLEManage &bleManage );

private:
    class Impl;
    std::shared_ptr<Impl> impl;

public:
    virtual ~cTherapyControl(); // smart pointers boiler plate
};
