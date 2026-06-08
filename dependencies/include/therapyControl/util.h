#pragma once
#include <stdint.h>
enum  Numerology {
    RET_ERROR_BAD_PARAMETERS = -1,
    RET_SUCCESS = 0
};

#ifdef __cplusplus
template<typename T = void>
constexpr uint8_t CRCcalc( const char *Message )
{
    int i = 0;
    uint8_t binCRC = 0;
    do { binCRC ^= Message[i]; } while( Message[i++] != 0 );
    return binCRC;
}

#include <string>
std::string commandSerializer( const char *str_command );

#include <sys/time.h>
#include "therapyControl/fsm_state.h"
#include "therapyControl/serial/SerialProtocolTypes.h"

extern "C" {
#endif


uint8_t UTILS_Hex2Uint8(char *Data);
int16_t UTILS_Hex2Int16(char *Data);

enum typeOfPadding {
    PAD = 0,
    WITH_PADDING,
    NO_PADDING,
};

int8_t  UTILS_uint8ToHexString(uint8_t Value, char *String , enum typeOfPadding Padding);
int8_t  UTILS_int16ToHexString(int16_t Value, char *String, enum typeOfPadding Padding);
void    CyDelay(uint16_t mseconds);
int elapsed( const struct timespec* previous );
const char* stateDescriptor( STATE_ID_E state_id );
const char* SPCommandDescriptor( serialCommandEnum command_id );

#ifdef __cplusplus
}
#endif
