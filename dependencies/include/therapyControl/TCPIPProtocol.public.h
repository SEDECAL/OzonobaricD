#pragma once

#ifdef __cplusplus

#include "therapyControl/iAppSock.h"
#include "therapyControl/serial/iBLE.h"

class cTCPIPProtocol {

public:
    cTCPIPProtocol ( iTCPIPPort & tcpIface, iError & error, iBLEManage & bleManage );
    void process   ( const char *payload );
    int  send      ( const char *text, int16_t value = -1 );
    virtual ~cTCPIPProtocol(); // smart pointers boiler plate

private:
    class Impl;
    std::unique_ptr<Impl> impl;

};
#endif


#ifdef __cplusplus
extern "C" {
#endif

int SPROT_GetGenerationData   ( const char* );
int SPROT_SendText            ( const char *Text);
int SPROT_SendTextAndValue    ( const char *Text, int16_t Value );
int SPROT_SyncSoftwareVersion ( const char *);
int SPROT_GetParameters       ( const char* ); /* #4332 */
int SPROT_SendError           ( const char *Text );

#ifdef __cplusplus
}
#endif
