#pragma once

#include "therapyControl/serial/SerialProtocolTypes.h"
using namespace SerialProtocolNameSpace;
enum class Activity {
   RemoteContolKeyEnter = CMD_REMOTE_CONTROL_KEY_ENTER,
   RemoteControlKeyEnterRelease = CMD_REMOTE_CONTROL_KEY_ENTER_RELEASED,
   RemoteControlKeyCancel  = CMD_REMOTE_CONTROL_KEY_CANCEL,
   RemoteControlKeySlider  = CMD_REMOTE_CONTROL_SLIDER,
};

#include <string>
#include "therapyControl/fsm_state.h"
#include "therapyControl/TCPIPProtocol.h"
#include "therapyControl/util.h"
#include "therapyControl/fsm_state.h"
#include "therapyControl/iAppSock.h"
#include "therapyControl/therapyParams.h"

class iFSMView {
public:
    virtual STATE_ID_E currentState() = 0;
    virtual std::string currentError( ) = 0;
    virtual std::string currentOperation() = 0;
    virtual std::string firmwareID() = 0;
    virtual std::string parameter     (size_t index) = 0;
    virtual std::string syncBloodPush ( const char *maxPressure = nullptr )  = 0;
    virtual std::string startVacuum   ( VaccumParameters & vp ) = 0;
    virtual std::string manual        ( ManualParams & p ) = 0;
    virtual std::string dose          ( DoseParams & p ) = 0;
    virtual std::string autoHemo      ( salineHemoParams & p ) = 0;
    virtual std::string salineHemo    ( salineHemoParams & p ) = 0;
    virtual std::string Insuflation   ( INSUFFLATION_TYPE_E i_type, const InsuflattionParams & p ) = 0;
    virtual std::string BaggingRenamePlease       ( const OPERATION_MODE_E b_mode, const BaggingParams & p, const int washing_time = -1 ) = 0;
    virtual uint32_t generationTime() = 0;
    virtual void activity( Activity now, int payload = 0) = 0;
    virtual void resumeOperation( uint32_t delay) = 0;
    virtual void periodicInfo( uint16_t period ) = 0;
    virtual void resetParams( const OPERATION_MODE_E mode = PASS_THROUGH_MODE ) = 0;
    virtual void resetGenerator( ) = 0;
    virtual void emergencyStop( ) = 0; // Azure Bug 10863: (SDV 2) Problems due bluetooth connection lost during generation

    virtual ~iFSMView(){}

};

std::unique_ptr<iFSMView> fsmViewFactory( iError &error);


template <class T>
static const std::string view( const T & var ) {

    if constexpr ( std::is_same_v<T, uint8> || std::is_same_v<T,int8> || std::is_same_v<T,STATE_ID_E>)
    {
        std::string State{"  "};
//      UTILS_uint8ToHexString( var, State.data(), WITH_PADDING);
	sprintf((char *)State.data(), "%02X", var & 0xFF);
        return State;
    }

    if constexpr ( std::is_same_v<T, int16> || std::is_same_v<T, uint16> ||  std::is_same_v<T, OZONETTE_APP_ERRORS>)
    {
	std::string State{"    "};
//      UTILS_int16ToHexString( var, State.data(), WITH_PADDING);
	sprintf((char *)State.data(), "%04X", var & 0xFFFF);
	return State;
    }

    if constexpr ( std::is_same_v<T, int32> || std::is_same_v<T, uint32> )
    {
	std::string State{"        "};
	sprintf((char *)State.data(), "%08X", var & 0xFFFFFFFF);
	return State;
    }
    static_assert( 1, "Not type encoded");
}

template <class T = void>
static std::string responseAck(){ return std::string(SPROT_ACK_RESP).append(SPROT_END_COMMAND_STRING); }
