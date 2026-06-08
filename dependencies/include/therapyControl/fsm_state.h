/*!
 * \file        fsm_state.h
 *
 * \author      Fernando Alcojor & Roberto Sanchez.
 * \version
 * \htmlonly
 *              <A HREF="path-to-tag">TAG</A>
 * \endhtmlonly
 * \date        08/05/2014.
 * \remarks
 * \attention
 * \warning
 * \copyright   SEDECAL S.A.
 * \defgroup    fsm_state
 * @{
 * \brief       This module defines a state in the Finite State Machine
 *              for the Ozonette Main application.
 *              This is not intended to be a generic state module for generic
 *              Finite state machines.
 */
#ifndef FSM_STATE_H_
#define FSM_STATE_H_

/**
 * @brief FSM states identifiers
 **/
typedef enum STATE_ID_E
{
  STATE_INIT=0,
  /* Common states */
  STATE_ERROR,
  STATE_INIT_CHECK_1,
  STATE_INIT_CHECK_2,
  STATE_INIT_CHECK_3,
  STATE_MAIN_MENU,
  STATE_O3_SELECTION,
  STATE_FLOW_SELECTION,
  STATE_TIME_SELECTION,
  STATE_DOSE_SELECTION,
  STATE_THERAPY_TIME_SELECTION,
  STATE_VACUUM_SELECTION,
  STATE_VOLUME_SELECTION,
  STATE_VACUUM_GENERATING,
  STATE_VACUUM_COMPLETED,
  STATE_VACUUM_PAUSED,
  STATE_VACUUM_CANCELLED,
  STATE_ADJUSTING,
  STATE_O3_GENERATING,
  STATE_USER_CANCELLED,
  STATE_COMPLETED,
  STATE_MANUAL_COMPLETED,
  STATE_WAITING_THERAPY_TIME,
  STATE_WAITING_AUTOHEMO_RESTART,
  STATE_OVERPRESSURE,
  STATE_MANUAL_OVERPRESSURE_1,
  STATE_MANUAL_OVERPRESSURE_2,
  STATE_SERVICE_MENU,
  STATE_SHOW_SW_VERSIONS,
  STATE_SHOW_TEMP_PRESS,
  STATE_CONTRAST_ADJUST,
  STATE_BRIGHTNESS_ADJUST,
  STATE_LANGUAGE_MENU,
  STATE_PASSWORD_FIRST,
  STATE_PASSWORD_SECOND,
  STATE_PASSWORD_THIRD,
  STATE_PASSWORD_FOURTH,
  STATE_PASSWORD_FIFTH,
  STATE_PASSWORD_SIXTH,
  STATE_CALIBRATION_MENU,
  STATE_SELECT_REF_PRESS_1,
  STATE_SELECT_REF_PRESS_2,
  STATE_SELECT_FLOW_REFS_1,
  STATE_SELECT_FLOW_REFS_1B,
  STATE_SELECT_FLOW_REFS_2,
  STATE_SELECT_FLOW_REFS_2B,
  STATE_SELECT_FLOW_REFS_3,
  STATE_SELECT_FLOW_REFS_3B,
  STATE_SELECT_O3_REFS_1,
  STATE_SELECT_O3_REFS_2,
  STATE_SELECT_O3_REFS_3,
  STATE_SELECT_O3_REFS_4,
  STATE_SELECT_PRESS_COMP_FACTOR,
  STATE_SELECT_BASE_WIDTH,
  STATE_SELECT_FLOW_COMP_FOR_PULSES,
  STATE_CALIBRATE_PERIOD,
  STATE_SAVING_PARAMETERS,
  STATE_LOADING_PARAMETERS,
  STATE_SHOWING_PARAMETERS,
  STATE_WARNING,
  STATE_WASHING,
  STATE_MANUAL_MODE_TIMEOUT,
  STATE_KEY_MODE_TRANSITION,
  STATE_ADJUST_ZERO_O3_SENSOR_1,
  STATE_ADJUST_ZERO_O3_SENSOR_2,
  STATE_ADJUST_ZERO_O3_SENSOR_3,
  STATE_DEPRESSURING_SYRINGE,
  STATE_GENERATING_FLOW,
  STATE_WAITING_AFTER_START_UP,
  STATE_WARMING_O3_SENSOR,
  STATE_MAX
}STATE_ID_E;

/**
 * @brief Return values for state methods.
 **/
typedef enum
{
  FSM_STATE_RETVAL_SUCCESS       =  0,
  FSM_STATE_RETVAL_ERROR         = -1,
  FSM_STATE_RETVAL_BAD_PARAMETER = -2,
  FSM_STATE_RETVAL_MAX           = -3
}FSM_STATE_RETVAL_E;

#include "therapyControl/Errors.h"
/**
 * @brief State object model structure
 **/
typedef struct
{
    void (* Entry)(void);
    void (* Enter)(void);
    void (* Cancel)(void);
    void (* Animate)(void);
    void (* Error)(OZONETTE_APP_ERRORS);
    void (* Slider)(void);
    void (* Exit)(void);
    void (* SpecialKey)(void);
    void (* Enter_Release)(void);
    void (* Cancel_Release)(void);
    STATE_ID_E State_ID;
    void *Owner;
}FSM_STATE_T;

///**
// * @brief FSM_STATE_Init
// *
// * @param Ctxt State context
// * @param StateID State Identifier for the state object
// * @param Entry Function to be called on State entry
// * @param Enter Transition function for Enter event
// * @param Cancel Transition function for Cancel event
// * @param Animate Transition function for Animate event
// * @param Error Transition function for Error event
// * @param Slider Transition function for Slider event
// * @param Exit Function to be called on state exit
// *
// * @return \li FSM_STATE_RETVAL_SUCCESS
// *         \li FSM_STATE_RETVAL_ERROR
// **/
//int8 FSM_STATE_Init(FSM_STATE_T * Ctxt, void *fsm_owner, STATE_ID_E StateID, void (* Entry)(void *fsm), void (* Enter)(void *fsm),
//                                        void (* Cancel)(void *fsm), void (* Animate)(void *fsm), void (* Error)(void *fsm),
//                                        void (* Slider)(void *fsm), void (* Exit)(void *fsm), void (* SpecialKey)(void *fsm),
//                                        void (* Enter_Release)(void *fsm), void (* Cancel_Release)(void *fsm));

#endif /* FSM_STATE_H_ */



