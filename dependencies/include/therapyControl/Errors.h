/*
 * Errors.h
 *
 *  Created on: 06/05/2014
 *      Author: Fernando.Alcojor
 */

#ifndef ERRORS_H_
#define ERRORS_H_ 1

/**
 * \enum Error codes enumeration
 * */
/*
typedef enum
{
  NO_ERROR                = 0,
  TEMP_ERROR              = 1,
  CURRENT_ERROR           = 2,
  OZONE_ERROR             = 3,
  FLOW_ERROR              = 4,
  PRESS_ERROR             = 5,
  LEAKAGE_ERROR           = 6,
  PIN_ERROR               = 7,
  COMS_ERROR              = 8,
  CAL_ERROR               = 9,
  VALVE_0_ERROR           = 10,
  VALVE_1_ERROR           = 11,
  PASSWORD_ERROR          = 12,
  PRESS_SENSOR_ERROR      = 13,
  PROPORIONAL_VALVE_ERROR = 14,
  PERIOD_ERROR            = 15,
  SAVE_PARAMETERS_ERROR   = 16,
  LOAD_PARAMETERS_ERROR   = 17,
  MAX_ERROR
}OZONETTE_APP_ERRORS;
*/
typedef enum
{
    PASS_THROUGH = -1 ,
    NO_ERROR                = 0,
    TEMP_ERROR              = 1,
    CURRENT_ERROR           = 2,
    OZONE_ERROR             = 3,
    FLOW_ERROR              = 4,
    PRESS_ERROR             = 5,
    LEAKAGE_ERROR           = 6,
    PIN_ERROR               = 7,
    COMS_ERROR              = 8,
    CAL_ERROR               = 9,
    TRANSFORMER_ERROR       = 10,
    PROPORIONAL_VALVE_ERROR = 11,
    PASSWORD_ERROR          = 12,
    PRESS_SENSOR_ERROR      = 13,
    VALVE_0_ERROR           = 14,
    VALVE_1_ERROR           = 15,
    SAVE_PARAMETERS_ERROR   = 16,
    LOAD_PARAMETERS_ERROR   = 17,
    PERIOD_ERROR            = 18,
    SIMULATION_ERROR        = 19,
    MAX_ERROR
}OZONETTE_APP_ERRORS;

typedef enum
{
  NO_WARNING  = NO_ERROR,
  MAX_WARNING = -1
}OZONETTE_APP_WARNINGS;

#endif /* ERRORS_H_ */
