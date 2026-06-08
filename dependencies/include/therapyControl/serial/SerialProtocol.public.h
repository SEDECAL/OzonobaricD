#pragma once

#include "therapyControl/serial/SerialProtocolTypes.h"

#ifdef __cplusplus
#include <string>
using namespace SerialProtocolNameSpace;

#include "therapyControl/serial/iSPP.h"
#include "therapyControl/serial/iBLE.h"

#include <memory>
class cSerialProtocol {
public:
    cSerialProtocol(iSPPPort& phy , iBLEManage& ble_manager);

    ~cSerialProtocol();
    SPStatus   xmitt       ( const SPCommand & spCommand, size_t deadline = 1000 );
    SPResponse response    ();
    void       busActivity ( const char *device, const std::string & payload );

private:
    class Private;
    std::unique_ptr<Private> priv;
};

extern "C" {

#endif

void COM_PutString( const char *payload);
int  SerialProtocolXmitt( const PROTOCOL_COMMAND_T *command, int deadline );
int  SerialStatus(void);
PROTOCOL_RESPONSE_T SerialProtocolResponse();

#ifdef __cplusplus
}
#endif
