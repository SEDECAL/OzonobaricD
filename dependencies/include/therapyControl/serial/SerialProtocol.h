/*!
 * \file        Protocol.h
 * \brief       This module implements the Master side of the communication protocol between control
 * and interface boards for Ozone systems.
 *
 * \author      Fernando Alcojor & Roberto Sanchez.
 * \version
 * \htmlonly
 *              <A HREF="path-to-tag">TAG</A>
 * \endhtmlonly
 * \date        20/03/2014.
 * \remarks
 * \attention
 * \warning
 * \copyright   SEDECAL S.A.
 * \defgroup    Protocol
 * @{
 * @brief       This module implements the Serial communication protocol master side for communicating
 *              with the slave side.
 *              It let's you send and receive commands, get the last response to a command and Enable/Disable the CRC check in the protocol.
 *              It also implements some internal functions.
 */


#ifndef SERIALPROTOCOL_H_
#define SERIALPROTOCOL_H_

#include "inc/myTypes.h"
/** * Maximum size for command messages. */
#define PROTOCOL_MAX_MESSAGE_SIZE       30/*20*/
/** Size of buffer for CRC compound */
#define PROTOCOL_CRC_SIZE               3
/** Maximum size for integer to hexadecimal conversion buffer. */
#define MAX_HEX_VALUE_SIZE              5
/** Maximum for number field of command structure. */
#define MAX_NUMBER_IN_COMMAND           0x5A
/**
 * Identifier length
 */
#define IDENTIFIER_LENGTH               2
/**
 * Maximum number of bytes in command response.
 */
#define MAX_RESPONSE_LENGTH             50
/**
 * Maximum number of fields command response.
 */
/**
 * Maximum number of retries for a command.
 */
#define NUM_MAX_RETRIES                 3
/**
 * Response string offset for command code
 */
#define RESPONSE_CMD_OFFSET             3
/**
 * Command string offset for CRC status.
 */
#define CRC_STATE_OFFSET                5
/**
 * Response string offset for system error code
 */
#define FROMTAIL_ERRORCODE_OFFSET       4
/**
 * Response string offset for data information
 */
#define FROMTAIL_DATA_OFFSET
/**
 * Response string offset for ACK or NAK
 */
#define RESPONSE_ACK_NAK_OFFSET         1




/**
 * ACK/NAK codes
 * @{
 */
#define CODE_ACK                               '@'
#define CODE_NAK                               '#'
/**
 * Warning mask to distinguish error and warning indications
 * @{
 */
#define WARNING_MASK    0x80
/**@}*/

/**
 * \enum CRC_STATE_E
 * CRC status constants
 */
typedef enum
{
  CRC_DEACTIVATED = 1, /* CRC_DEACTIVATED */
  CRC_ACTIVATED   = 2  /* CRC_ACTIVATED   */
}CRC_STATE_E;

/**
 * \enum PROTOCOL_RETURN_E
 * Return values for Protocol functions
 */


/**
 * \enum PROTOCOL_NAK_ERROR_E
 * Protocol NAK Causes
 */
typedef enum
{
  PROTOCOL_NAK_NO_ERROR = '0',
  PROTOCOL_NAK_ERROR_NO_COMMAND,
  PROTOCOL_NAK_ERROR_UNKNOWN_COMMAND,
  PROTOCOL_NAK_ERROR_KNOWN_COMMAND,
  PROTOCOL_NAK_ERROR_CRC,
  PROTOCOL_NAK_ERROR_START_BYTE,
  PROTOCOL_NAK_ERROR_NO_DELIMITER,
  PROTOCOL_NAK_ERROR_WRONG_PARAMETER_VALUE,
  PROTOCOL_NAK_ERROR_REPORTED_FROM_LOWER_LAYER,
  PROTOCOL_NAK_ERROR_SENSOR_NOT_CALIBRATED,
  PROTOCOL_NAK_PARSE_ERROR_MAX
} PROTOCOL_NAK_ERROR_E;





#include "therapyControl/myTypes.h"
/*! \brief Protocol command type. */
typedef struct protocol_command_list_t
{
  int   Id;             /*!< Number identifier for each protocol command.  */
  char  String[8];      /*!< Literal identifier for each protocol command. */
}PROTOCOL_COMMAND_LIST_T;

/**
 * @brief Protocol_GetCRCStatus
 * @return \b [in] Status CRC_ACTIVATE or CRC_DEACTIVATE
 */
CRC_STATE_E Protocol_GetCRCStatus(void);

/**
 * @}
 */
#endif /* SERIALPROTOCOL_H_ */
