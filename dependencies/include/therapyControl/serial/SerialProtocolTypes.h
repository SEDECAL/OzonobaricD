#pragma once
/**
 * Table constants
 * @{
 */
#define TABLE_INITIALIZATION_STATE                   0
#define BASE_PERIOD_MAX_VALUE_TABLE_POSITION         3
#define BASE_PERIOD_MIN_VALUE_TABLE_POSITION         4
#define BASE_WIDTH_INI_TABLE_POSITION                5
#define BASE_PERIOD_INI_VALUE_TABLE_POSITION         6
#define WIDTH_INI_VALUE_TABLE_POSITION               7
#define PERIOD_INI_VALUE_TABLE_POSITION              8
#define PRESS_0_GAIN_SEC1_TABLE_POSITION             66
#define PRESS_0_GAIN_SEC2_TABLE_POSITION             67
#define PRESS_0_GAIN_SEC3_TABLE_POSITION             68
#define PRESS_1_GAIN_SEC1_TABLE_POSITION             69
#define PRESS_1_GAIN_SEC2_TABLE_POSITION             70
#define PRESS_1_GAIN_SEC3_TABLE_POSITION             71
#define PRESS_0_OFFSET_SEC1_TABLE_POSITION           90 /* 87 */
#define PRESS_0_OFFSET_SEC2_TABLE_POSITION           91 /* 88 */
#define PRESS_0_OFFSET_SEC3_TABLE_POSITION           92 /* 89 */
#define PRESS_1_OFFSET_SEC1_TABLE_POSITION           93 /* 90 */
#define PRESS_1_OFFSET_SEC2_TABLE_POSITION           94 /* 91 */
#define PRESS_1_OFFSET_SEC3_TABLE_POSITION           95 /* 92 */

#define FLOW_GAIN_SEC1_TABLE_POSITION                72
#define FLOW_GAIN_SEC2_TABLE_POSITION                73
#define FLOW_GAIN_SEC3_TABLE_POSITION                74
#define FLOW_OFFSET_SEC1_TABLE_POSITION              96  /* 93  */
#define FLOW_OFFSET_SEC2_TABLE_POSITION              97  /* 94  */
#define FLOW_OFFSET_SEC3_TABLE_POSITION              98  /* 95  */
#define FLOW_LIMIT_SEC1_TABLE_POSITION               120 /* 114 */
#define FLOW_LIMIT_SEC2_TABLE_POSITION               121 /* 115 */
#define FLOW_LIMIT_SEC3_TABLE_POSITION               122 /* 116 */

#define O3_SENSOR_GAIN_SEC1_TABLE_POSITION           78

#define OZONE_GAIN_SEC1_TABLE_POSITION               180 /* 171 */
#define OZONE_GAIN_SEC2_TABLE_POSITION               181 /* 172 */
#define OZONE_GAIN_SEC3_TABLE_POSITION               182 /* 173 */
#define OZONE_OFFSET_SEC1_TABLE_POSITION             183 /* 174 */
#define OZONE_OFFSET_SEC2_TABLE_POSITION             184 /* 175 */
#define OZONE_OFFSET_SEC3_TABLE_POSITION             185 /* 176 */
#define OZONE_LIMIT_SEC1_TABLE_POSITION              186 /* 177 */
#define OZONE_LIMIT_SEC2_TABLE_POSITION              187 /* 178 */
#define OZONE_LIMIT_SEC3_TABLE_POSITION              188 /* 179 */
#define START_UP_TEST_CURRENT_TABLE_POSITION         189 /* 180 */

#define PULSES_FOR_O3_CALIBRATION_SEC_1_POSITION     190 /* 181 */
#define PULSES_FOR_O3_CALIBRATION_SEC_2_POSITION     191 /* 182 */
#define PULSES_FOR_O3_CALIBRATION_SEC_3_POSITION     192 /* 183 */

#define PRESSURE_COMPENSATION_FACTOR_POSITION        193
#define CALIBRATION_PRESSURE_POSITION                194
#define FLOW_COMP_FOR_PULSES_POSITION                195

#define PULSES_FOR_1_MG_POSITION                     196 /* 183 */
#define O3_GENERATION_MODE_POSITION                  197 /* 183 */
/**@}*/

/**
 *
 * Command strings
 */
#define STRING_CMD_HEADER               "{"
#define STRING_CMD_SEPARATOR             ","
#define STRING_CMD_TAIL                 "\r"

#define STRING_CMD_TEST_COM             "*"
/**
 * Valve commands
 * @{
 */
#define STRING_CMD_SET_VALVE            "EVS"
#define STRING_CMD_GET_VALVE            "EVG"
/**@}*/
/**
 * Fan commands
 * @{
 */
#define STRING_CMD_SET_FAN              "AFS"
#define STRING_CMD_GET_FAN              "AFG"
/**@}*/

/**
 * Vacuum commands
 * @{
 */
#define STRING_CMD_SET_VACUUM           "VS"
#define STRING_CMD_GET_VACUUM           "VG"
/**@}*/

/**
 * Proportional ElectroValve commands
 * @{
 */
#define STRING_CMD_SET_PROP_VALVE       "EPS"
#define STRING_CMD_GET_PROP_VALVE       "EPG"
/**@}*/

/**
 * SENSOR commands
 * @{
 */
#define STRING_CMD_SET_SENSOR_SLOPE     "SSS"
#define STRING_CMD_GET_SENSOR_SLOPE     "SGS"
#define STRING_CMD_SET_SENSOR_OFFSET    "SSO"
#define STRING_CMD_GET_SENSOR_OFFSET    "SGO"
#define STRING_CMD_GET_SENSOR           "SG"
#define STRING_CMD_GET_ALL_SENSORS      "SGA"
/**@}*/

/**
 * Modulator commands
 * @{
 */
#define STRING_CMD_SET_MODULATOR_BASE_WIDTH    "MSBW"
#define STRING_CMD_SET_MODULATOR_BASE_PERIOD   "MSBP"
#define STRING_CMD_SET_MODULATOR_WIDTH         "MSW"
#define STRING_CMD_SET_MODULATOR_PERIOD        "MSP"
#define STRING_CMD_SET_MODULATOR_DEADTIME      "MSDT"
#define STRING_CMD_GET_MODULATOR_BASE_WIDTH    "MGBW"
#define STRING_CMD_GET_MODULATOR_BASE_PERIOD   "MGBP"
#define STRING_CMD_GET_MODULATOR_WIDTH         "MGW"
#define STRING_CMD_GET_MODULATOR_PERIOD        "MGP"
#define STRING_CMD_MODULATOR_BASE_START        "MBSTR"
#define STRING_CMD_MODULATOR_BASE_STOP         "MBSTP"
#define STRING_CMD_MODULATOR_START             "MSTR"
#define STRING_CMD_MODULATOR_STOP              "MSTP"
/**@}*/

/**
 * Ozone commands
 * @{
 */
#define STRING_CMD_SET_OZONE_TARGET            "O3S"
#define STRING_CMD_GET_OZONE_TARGET            "O3G"
#define STRING_CMD_GET_OZONE_STATE             "O3STT"
#define STRING_CMD_START_OZONE                 "O3STR"
#define STRING_CMD_STOP_OZONE                  "O3STP"
/**@}*/

/**
 * Ozone sensor calibration commands
 * @{
 */
#define STRING_CMD_START_O3_SENSOR_CAL         "O3SSTR"
#define STRING_CMD_STATE_O3_SENSOR_CAL         "O3SSTT"
#define STRING_CMD_STOP_O3_SENSOR_CAL          "O3SSTP"
/**@}*/

/**
 * Flow commands
 * @{
 */
#define STRING_CMD_SET_FLOW_TARGET             "FS"
#define STRING_CMD_GET_FLOW_TARGET             "FG"
#define STRING_CMD_GET_FLOW_STATE              "FSTT"
#define STRING_CMD_START_FLOW                  "FSTR"
#define STRING_CMD_STOP_FLOW                   "FSTP"
/**@}*/

/**
 * PID commands
 * @{
 */
#define STRING_CMD_SET_PID_P_PARAM             "PSPP"
#define STRING_CMD_SET_PID_P_GAIN              "PSPG"
#define STRING_CMD_SET_PID_I_PARAM             "PSIP"
#define STRING_CMD_SET_PID_I_GAIN              "PSIG"
#define STRING_CMD_SET_PID_D_PARAM             "PSDP"
#define STRING_CMD_SET_PID_D_GAIN              "PSDG"
#define STRING_CMD_GET_PID_P_PARAM             "PGPP"
#define STRING_CMD_GET_PID_P_GAIN              "PGPG"
#define STRING_CMD_GET_PID_I_PARAM             "PGIP"
#define STRING_CMD_GET_PID_I_GAIN              "PGIG"
#define STRING_CMD_GET_PID_D_PARAM             "PGDP"
#define STRING_CMD_GET_PID_D_GAIN              "PGDG"

#define STRING_CMD_SET_PID_INTEGRAL_MAX        "PSIMAX"
#define STRING_CMD_SET_PID_INTEGRAL_MIN        "PSIMIN"
#define STRING_CMD_GET_PID_INTEGRAL_MAX        "PGIMAX"
#define STRING_CMD_GET_PID_INTEGRAL_MIN        "PGIMIN"

#define STRING_CMD_RESET_PID                   "PRST"

#define STRING_CMD_RESET                       "RST"
/**@}*/

/**
 * Table commands
 * @{
 */
#define STRING_CMD_SET_TABLE_POSITION          "TS"
#define STRING_CMD_GET_TABLE_POSITION          "TG"
#define STRING_CMD_CHECK_TABLE_CRC             "TCRC"
/**@}*/

/**
 * Key simulation commands
 * @{
*/
#define STRING_CMD_REMOTE_CONTROL_KEY_CANCEL            "RCCNL"
#define STRING_CMD_REMOTE_CONTROL_KEY_ENTER             "RCENT"
#define STRING_CMD_REMOTE_CONTROL_KEY_ENTER_RELASED     "RCENTR"
#define STRING_CMD_REMOTE_CONTROL_SLIDER                "RCSLD"
#define STRING_CMD_REMOTE_CONTROL_GET_STATE             "RCGET"
#define STRING_CMD_REMOTE_CONTROL_RET_STATE             "RCRET"
/**@}*/
/**
 * CRC commands
 */
#define STRING_CMD_CRC_SET                     "CRC"

/**
 * Watchdog management commands
 */
#define STRING_CMD_SET_WATCHDOG                "WS"
/**
 * Error management commands
 * @{
 */
#define STRING_CMD_CLEAR_FIRST_ERROR_QUEUE     "ERCLRF"
#define STRING_CMD_CLEAR_ALL_ERROR             "ERCLR"
#define STRING_CMD_ERROR_SKIP                  "ERSKIP"
/**@}*/
/**
 * LED STRIP management commands
 */
#define STRING_CMD_LED_STRIP_SET_COLOR          "LSC"
#define STRING_CMD_LED_STRIP_SET_DIMER          "LSD"
#define STRING_CMD_LED_STRIP_SET_BLINK          "LSB"
#define STRING_CMD_LED_STRIP_SET_WAVE           "LSW"
/**
 * \enum PROTOCOL_CONTROL_BOARD_WARNINGS_E
 * Protocol Slave board possible warning status.
 */
typedef enum
{
  CTRL_BOARD_WARNING_NO = 0x80,
  CTRL_BOARD_WARNING_NO_STANDBY_CURRENT= 0x81
}PROTOCOL_CONTROL_BOARD_WARNINGS_E;

/**
 * Software version command
 */
#define STRING_CMD_GET_SW_VERSION              "VER"
/**
 * ACK/NAK commands
 * @{
 */
#define STRING_CMD_RESPONSE_ACK                "@"
#define STRING_CMD_RESPONSE_NAK                "#"

/**
 * \enum PROTOCOL_COMMANDS_E
 * Protocol Command identifiers
 */
typedef enum serialCommandEnum
{
    CMD_NULL = 0,
  CMD_TEST_COM=1,
  CMD_SET_VALVE,
  CMD_GET_VALVE,                 /* Not implemented */
  CMD_SET_FAN,
  CMD_GET_FAN,                   /* Not implemented */
  CMD_SET_VACCUM,                /* Not implemented */
  CMD_GET_VACCUM,                /* Not implemented */
  CMD_SET_SENSOR_SLOPE,
  CMD_GET_SENSOR_SLOPE,          /* Not implemented */
  CMD_SET_SENSOR_OFFSET,
  CMD_GET_SENSOR_OFFSET,         /* Not implemented */
  CMD_GET_SENSOR,
  CMD_GET_ALL_SENSORS,
  CMD_SET_MODULATOR_BASE_WIDTH,
  CMD_SET_MODULATOR_BASE_PERIOD,
  CMD_SET_MODULATOR_WIDTH,
  CMD_SET_MODULATOR_PERIOD,
  CMD_SET_MODULATOR_DEADTIME,
  CMD_GET_MODULATOR_BASE_WIDTH,
  CMD_GET_MODULATOR_BASE_PERIOD,
  CMD_GET_MODULATOR_WIDTH,
  CMD_GET_MODULATOR_PERIOD,
  CMD_MODULATOR_BASE_START,
  CMD_MODULATOR_BASE_STOP,
  CMD_MODULATOR_START,
  CMD_MODULATOR_STOP,
  CMD_SET_OZONE_TARGET,
  CMD_GET_OZONE_TARGET,          /* Not implemented */
  CMD_START_OZONE,
  CMD_STOP_OZONE,
  CMD_STATE_OZONE,               /* Not implemented */
  CMD_SET_FLOW_TARGET,
  CMD_GET_FLOW_TARGET,           /* Not implemented */
  CMD_START_FLOW,
  CMD_STOP_FLOW,
  CMD_STATE_FLOW,                /* Not implemented */
  CMD_SET_PID_P_PARAM,           /* Not implemented */
  CMD_SET_PID_I_PARAM,           /* Not implemented */
  CMD_SET_PID_D_PARAM,           /* Not implemented */
  CMD_GET_PID_P_PARAM,           /* Not implemented */
  CMD_GET_PID_I_PARAM,           /* Not implemented */
  CMD_GET_PID_D_PARAM,           /* Not implemented */
  CMD_SET_PID_P_GAIN,            /* Not implemented */
  CMD_SET_PID_I_GAIN,            /* Not implemented */
  CMD_SET_PID_D_GAIN,            /* Not implemented */
  CMD_GET_PID_P_GAIN,            /* Not implemented */
  CMD_GET_PID_I_GAIN,            /* Not implemented */
  CMD_GET_PID_D_GAIN,            /* Not implemented */
  CMD_SET_PID_I_MAX,             /* Not implemented */
  CMD_SET_PID_I_MIN,             /* Not implemented */
  CMD_GET_PID_I_MAX,             /* Not implemented */
  CMD_GET_PID_I_MIN,             /* Not implemented */
  CMD_RESET_PID,                 /* Not implemented */
  CMD_SET_TABLE_POSITION,
  CMD_GET_TABLE_POSITION,
  CMD_CHECK_TABLE_CRC,           /* Not implemented */
  CMD_CRC_SET,
  CMD_WATCHDOG_SET,              /* Not implemented */
  CMD_CLEAR_FIRST_ERROR,
  CMD_CLEAR_ALL_ERROR,
  CMD_ERROR_SKIP,
  CMD_RESET,
  CMD_GET_SW_VERSION,
  CMD_REMOTE_CONTROL_KEY_CANCEL,
  CMD_REMOTE_CONTROL_KEY_ENTER,
  CMD_REMOTE_CONTROL_KEY_ENTER_RELEASED,
  CMD_REMOTE_CONTROL_SLIDER,
  CMD_REMOTE_CONTROL_GET_STATE,
  CMD_REMOTE_CONTROL_RET_STATE,
  CMD_SET_PROPORTIONAL_VALVE,
  CMD_GET_PROPORTIONAL_VALVE,
  CMD_START_O3_SENSOR_CAL,
  CMD_STATE_O3_SENSOR_CAL,
  CMD_STOP_O3_SENSOR_CAL,
  CMD_LED_STRIP_SET_COLOR,
  CMD_LED_STRIP_SET_DIMER,
  CMD_LED_STRIP_SET_BLINK,
  CMD_LED_STRIP_SET_WAVE,
  CMD_MAX

}serialCommandEnum;

#include "therapyControl/myTypes.h"
typedef struct {
    serialCommandEnum Command;
    uint8_t  Identifier[2];
    int16_t  Value;
    uint16_t Position[2];
}PROTOCOL_COMMAND_T;

/**
 * \struct PROTOCOL_COMMAND_T
 * Structure that represent a protocol command.
 */

typedef enum
{
    PROTOCOL_RET_SUCCESS             =  0,
    PROTOCOL_RET_ERROR_BAD_PARAMETER = -1,
    PROTOCOL_RET_BAD_COMMAND         = -2,
    PROTOCOL_RET_COMMAND_NOT_SENT    = -3,
    PROTOCOL_RET_TIMEOUT             = -4
} SPStatus;

typedef enum ControlBoardStatusEnum
{
  CTRL_BOARD_STATUS_OK         =  0,
  CTRL_BOARD_TEMP_ERROR        =  1,
  CTRL_BOARD_CURRENT_ERROR     =  2,
  CTRL_BOARD_OZONE_ERROR       =  3,
  CTRL_BOARD_FLOW_ERROR        =  4,
  CTRL_BOARD_PRESS_ERROR       =  5,
  CTRL_BOARD_LEAKAGE_ERROR     =  6,
  CTRL_BOARD_PIN_ERROR         =  7,
  CTRL_BOARD_COMS_ERROR        =  8,
  CTRL_BOARD_CAL_ERROR         =  9,
  CTRL_BOARD_TRANSFORMER_ERROR = 10,
  CTRL_BOARD_CTRL_BOARD_STATUS_MAX
}ControlBoardStatusEnum;

/** \struct PROTOCOL_RESPONSE_T Protocol response structure. */
/**
 * \union ACK_NAK_INFO_T
 * Union for managing NAK code.
 */
typedef union ACK_NAK_INFO_T
{
    uint8_t Command;
    uint8_t NakCode;
}AcKNAckInfo;

/**
 * \enum PROTOCOL_CMD_RESPONSE_E
 * Protocol command response types.
 */
typedef enum
{
    CMD_RESPONSE_ACK = 0,
    CMD_RESPONSE_NAK,
    CMD_RESPONSE_KEY_SIMULATION,
    CMD_RESPONSE_NONE,
    CMD_RESPONSE_MAX,
    CMD_RESPONSE_TIMEOUT,
    CMD_XMITT_FAILURE
}PROTOCOL_CMD_RESPONSE_E;

#define MAX_RESPONSE_DATA_FIELDS        50/*7 * 3*/
typedef struct
{
    uint8_t                 Ack_Nak;
    AcKNAckInfo             Ack_Nak_Info;
    ControlBoardStatusEnum  Status;
    int16_t                 Data[MAX_RESPONSE_DATA_FIELDS];
}PROTOCOL_RESPONSE_T;

/**
 * SENSOR Section definitions
 * @{
 */
#define SECTION_0                            0
#define SECTION_1                            1
#define SECTION_2                            2
/**@}*/
#define WARNING_MASK    0x80


#ifdef __cplusplus
namespace SerialProtocolNameSpace {

/**
 * valve and fan states.
 */
typedef enum spinValue {
    ON  = 1,
    OFF = 0
} spinValue;


/**
 * \enum PROTOCOL_CONTROL_BOARD_STATUS_E
 * Protocol Slave board possible status.
 */


using SPCommand  = PROTOCOL_COMMAND_T;
using SPStatus   = SPStatus;
using SPResponse = PROTOCOL_RESPONSE_T;


};
#endif

