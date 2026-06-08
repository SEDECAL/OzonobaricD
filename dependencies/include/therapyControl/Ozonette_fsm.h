/*
 * fsm.h
 *
 *  Created on: 08/05/2014
 *      Author: Fernando.Alcojor
 */

#ifndef FSM_H_
#define FSM_H_

#include "therapyControl/Errors.h"

#include <stdio.h>
#include <stdarg.h>
#include <math.h>

/* Compilation date */
#define DATE_STAMP  __DATE__                                  /*!< Compilation date. */
#define TIME_STAMP  __TIME__                                  /*!< Compilation time. */

/* Version */
/*#define SW_VERSION      "V3.R0.P0_c"                          !< First version with new hardware.                                      */
/*#define SW_VERSION      "V3.R0.P0_d"                          !< Some modifications suggested by CFY in relation with service menu.    */
/*#define SW_VERSION      "V3.R0.P0_e"                          !< Dose information removed when syringe ends.                           */
/*#define SW_VERSION      "V3.R0.P0_f"                          !< If overpressure during vacuum in bagging therapy program flow goes to */
                                                              /*!< adjusting state.                                                      */
                                                              /*!< Service menu PIN code changed to 8517.                                */
/*#define SW_VERSION      "V3.R0.P0_g"                          !< Bug 1409. O3 dose showed after syringe filing.                        */
                                                              /*!< Bug 1410. Vacuum time fails when it's configured higher than 66 secs. */
                                                              /*!< Flow calibration slider range increased @ 0..150.                     */
                                                              /*!< Parameters shown in show parameters menu option modified.             */
/*#define SW_VERSION      "V3.R0.P0_h"                          !< 27/09/2017                                                            */
                                                              /*!< Pressure compensation in error 9 calculation.                         */
                                                              /*!< Error 9 limits modified to abs(100).                                  */
                                                              /*!< Modifications in 'show parameters menu option.                        */
/*#define SW_VERSION      "V3.R0.P0_i"                          !< 29/09/2017                                                            */
                                                              /*!< Syringe detection algorithm modified.                                 */
/*#define SW_VERSION      "V3.R0.P0_j"                          !< 13/10/2017                                                            */
                                                              /*!< Flow calibration process changed.                                     */
/*#define SW_VERSION      "V3.R0.P0_k"                          !< 16/10/2017                                                            */
                                                              /*!< ClearErrors() function eliminated in DetectHighVoltageDisconnection() */
                                                              /*!< because SW temporally hangs.                                          */
/*#define SW_VERSION      "V3.R0.P0_k"                          !< 17/10/2017                                                            */
                                                              /*!< To levels of tolerance in O3 concentration detection implemented (one */
                                                              /*!< for syringe and other one for the rest of therapies).                 */
/*#define SW_VERSION      "V4.R0.P0_a"                          !< 24/10/2017                                                            */
                                                              /*!< First attempt to include resonance system.                            */
                                                              /*!< Show start up settings when cancel is pressed during start up.        */
/*#define SW_VERSION      "V4.R0.P0_b"                          !< 09/11/2017                                                            */
                                                              /*!< Return from 'show start up settings' when enter key is depressed.     */
/*#define SW_VERSION      "V4.R0.P0_c"                          !< 09/11/2017                                                            */
                                                              /*!< Error recognition during InitialCheck_Step2.                          */
/*#define SW_VERSION      "V4.R0.P0_d"                          !< 10/11/2017                                                            */
                                                              /*!< Patch to avoid hang up when communication error in 'TuneSensorLED()'  */
/*#define SW_VERSION      "V4.R0.P0_e"                          !< 13/11/2017                                                            */
                                                              /*!< Adjust lateral scroll bar in calibration menu.                        */
/*#define SW_VERSION      "V4.R0.P0_f"                          !< 16/11/2017                                                            */
                                                              /*!< Move "periods" and "load parameters" to service menu.                 */
/*#define SW_VERSION      "V4.R0.P0_g"                          !< 17/11/2017                                                            */
                                                              /*!< Calibrate minimum pulses for 1 mg/l. Modify 'Show parameters' option. */
/*#define SW_VERSION      "V4.R0.P0_h"                          !< 20/11/2017                                                            */
                                                              /*!< Include possibility to generate with and without O3 sensor (not used).*/
/*#define SW_VERSION      "V4.R0.P0_i"                          !< 21/11/2017                                                            */
                                                              /*!< Initialize display each time program goes to main menu to avoid       */
                                                              /*!< accidental cursor blinking due to glitches.                           */
/*#define SW_VERSION      "V4.R0.P0_j"                          !< 29/11/2017                                                            */
                                                              /*!< Add LCD_Init() to Initialize display routine.                         */
/*#define SW_VERSION      "V4.R0.P0_k"                          !< 19/12/2017                                                            */
                                                              /*!< Modify texts to avoid accent marks in Spanish messages.               */
/*#define SW_VERSION      "V4.R0.P0_l"                          !< 02/02/2018                                                            */
                                                              /*!< Add LCD_Init() previous to all display accesses.                      */
/*#define SW_VERSION      "V4.R0.P1_a"                        //   First SDV attempt bugs corrections:                                   */
                                                              //   Bug 10380: (SDV) End of automatic syringe. Call before state change to ensure depresure process visibility on GUI (11/09/2024)
                                                              //   Bug 10434: (SDV) Pressure and temperature not updated.
/*#define SW_VERSION      "V4.R0.P2_b"                        //   Second SDV attempt bugs corrections 14/10/2024 */
/*#define SW_VERSION      "V4.R0.P2_c"                        //   Third SDV attempt bugs corrections 23/10/2024  */
/*#define SW_VERSION      "V4.R0.P3_a"                        //   Just rename after all findings resolution 05/03/2025.*/
/*#define SW_VERSION      "V4.R0.P4_a"                        //   Azure task 13979: Include error 10 (transformer disconnect error) as part of the startup test (09/04/2025).*/
/*#define SW_VERSION      "V4.R0.P5_a"                        //   Azure task 14932: Change calibration method. Use two reference points. (10/07/2025). */
                                                              //   Azure task 14934: Reduce the calculation time of the work period (10/07/2025)
                                                              //   Azure task 14931: Analyze long wait times during O3 calibration (17/07/2025)
                                                              //   Azure task 14990: Repeat Error 9 start up test evaluation. (17/07/2025)
                                                              //   Azure Task 15012: Show interface and control software version during quick start (27/08/2025)
                                                              //   Azure Bug 14988:  Cancel pressure calibration error (27/08/2025)
                                                              //   Azure Task 15141: Modify Skip error supervision functionality implementation (05/09/2025)
                                                              //   Azure Task 15173: Avoid second generation shortcut to reduce therapy start up time (09/09/2025)
  #define SW_VERSION      "V4.R0.P6_a"                        //   Azure Task 15540: Modify second reference pressure calibration point from 1000 to 500. (06/11/2025).


/**
 * \enum Dose scale Ids.
 */
typedef enum
{
  DOSE_SCALE_0 = 0,
  DOSE_SCALE_1,
  DOSE_SCALE_2,
  DOSE_SCALE_3
}DOSE_SCALE_E;

/**
 * \enum Ozone sensor calibration states.
 */
typedef enum
{
  O3_SENSOR_CAL_ST_STOP = 0,
  O3_SENSOR_CAL_ST_RUNING,
  O3_SENSOR_CAL_ST_MAX
}O3_SENSOR_CAL_ST_E;

/**
 * \enum Syringe type enumeration.
 */
typedef enum
{
   SYRINGE_ID_5ML = 0,
   SYRINGE_ID_10ML,
   SYRINGE_ID_20ML,
   SYRINGE_ID_50ML,
   SYRINGE_ID_100ML,
   SYRINGE_ID_MAX
}SYRINGE_ID_E;

/**
 * \enum Sensor identifier enumeration.
 */
typedef enum
{
  ID_SENSOR_TEMPERATURE_0 = 0,
  ID_SENSOR_PRESSURE_0,
  ID_SENSOR_PRESSURE_1,
  ID_SENSOR_FLOW,
  ID_SENSOR_CURRENT,
  ID_SENSOR_OZONE,
  ID_SENSOR_VOLUME,
  ID_SENSOR_OZONE_DIRECT,
  ID_SENSOR_MAX
}ID_SENSOR_E;

/**
 * \enum Ozonette FSM Main screen option selected.
 */
typedef enum
{
  SYRINGE_SELECTED_SCREEN = 0,
  CONTINUOUS_OZONE_SELECTED_SCREEN = 1,
  MANUAL_SELECTED_SCREEN = 2
}OZONETTE_APP_SCREEN_E;

/**
 * \enum Ozonette FSM Operation modes.
 */
typedef enum
{
    SYRINGE_MODE        = 0,
    CONTINUOUS_MODE     = 1,
    DOSE_MODE           = 2,
    BAGGING_MODE        = 3,
    INSUFFLATION_MODE   = 4,
    VACUUM_MODE         = 5,
    SERVICE_MODE        = 6,
    MANUAL_MODE         = 7,
    AUTOHEMO_MODE       = 8,
    MANUAL_SYRINGE_MODE = 9,
    SALINE_HEMO_MODE    = 10,
    PASS_THROUGH_MODE   = -1,
    No_MODE             =-1
}OPERATION_MODE_E;

/**
 * \enum Parameter enumeration.
 */
typedef enum
{
  OZONE = 0,
  FLOW  = 1,
  TIME  = 2
}PARAMETER_E;

/**
 * \enum Proportional valves enumeration.
 */
typedef enum
{
  PROP_VALVE_INPUT= 0
}PROP_VALVE_ID_E;

/**
 * \enum Output valves enumeration.
 */
typedef enum
{
  VALVE_CATALYSER = '1',
  VALVE_OUTPUT_0  = '0',
  VALVE_OUTPUT_1  = '2',
  VALVE_VACUUM    = '3'
}VALVE_ID_E;

/**
 * \enum Output valves possible configurations
 */
typedef enum
{
  OUTPUT_TO_EXTERIOR_0 = 0,
  OUTPUT_TO_EXTERIOR_1 = 1,
  OUTPUT_TO_CATALYSER = 2,
  OUTPUT_TO_BOTH  = 3,
  OUTPUT_TO_MAX
}OUTPUT_POSITION_E;
/*
typedef enum
{
  OUTPUT_TO_CATALYSER = 0,
  OUTPUT_TO_EXTERIOR_0  = 1,
  OUTPUT_TO_BOTH  = 2,
  OUTPUT_TO_EXTERIOR_1  = 2,
  OUTPUT_TO_MAX
}OUTPUT_POSITION_E;
*/
/**
 * \enum Valves position
 */
typedef enum
{
  VALVE_CLOSE = 0,
  VALVE_OPEN  = 1
}VALVE_STATE_E;

/**
 * \enum Fan enumeration
 * */
typedef enum
{
  FAN_0 = '0',
  FAN_1 = '1'
}FAN_ID_E;

/**
 * \enum Fan possible states.
 * */
typedef enum
{
  FAN_OFF = 0,
  FAN_ON  = 1
}FAN_STATE_E;

/**
 * \enum Vacuum device enumeration
 * */
typedef enum
{
  VACUUM_0 = '0',
  VACUUM_1 = '1'
}VACUUM_ID_E;

/**
 * \enum Vacuum possible states.
 * */
typedef enum
{
  VACUUM_OFF = 0,
  VACUUM_ON  = 1
}VACUUM_STATE_E;

/**
 * \enum Beep state.
 * */
typedef enum
{
  BEEP_DISABLED = 1,
  BEEP_ENABLED  = 0
}BEEP_STATE_E;

/**
 * \enum Bagging vacuum type.
 * */
typedef enum
{
  INITIAL_BAGGING_VACCUM  = 0,
  CLEANING_BAGGING_VACCUM = 1
}BAGGING_VACUUM_TYPE_E;

/**
 * \enum autohemotherapy types.
 * */
typedef enum
{
  NORMOBARIC_AUTOHEMO = 'N',
  HYPERBARIC_AUTOHEMO = 'H'
}AUTOHEMO_TYPE_E;

/**
 * \enum wait or not wait.
 * */
typedef enum
{
  WAIT = 1,
  NO_WAIT = 0
}WAIT_TYPE_E;

/**
 * \enum insufflation types.
 * */
typedef enum
{
  V_INSUFFLATION = 'V',
  R_INSUFFLATION = 'R'
}INSUFFLATION_TYPE_E;

/**
 * \enum skip error configuration
 * */
typedef enum
{
  NO_SKIP_ERROR = 0,
  SKIP_ERROR = 1
}SKIP_ERROR_E;



#include "therapyControl/myTypes.h"
typedef struct config_t
{
    uint8  Contrast;
    uint8  Luminosity;
    uint8  Language;
    uint8  IsDemoMode;
}CONFIG_T;

typedef struct nextSyringeParams_t
{
    int16  ModulatorBasePeriod;
    int16  ModulatorBaseWidth;
    int16  ModulatorPeriod;
    int16  ModulatorWidth;
}NEXT_SYRINGE_PARAMS_T;

typedef struct
{
    uint32 Accumulator;
    int16  Counter;
    uint16 LastSamples[3];
    int8   LastSamplesCounter;
}MODULATOR_WIDTH_MEDIA_T;


#define LED_STRIP_COLOR_STARTING      0xFFFFFF
#define LED_STRIP_COLOR_ERROR         0xFF0000
#define LED_STRIP_COLOR_STANDBY       0x00FFFF
#define LED_STRIP_COLOR_ADJUSTING     0xFF00FF
#define LED_STRIP_COLOR_GENERATING    0xFF00FF
#define LED_STRIP_COLOR_CANCEL        0xFF1000
#define LED_STRIP_COLOR_COMPLETED     0x008000
#define LED_STRIP_COLOR_OVERPRESSURE  0xFF7000

/* orange ffa500 */

#define LED_STRIP_DIME_100       255
#define LED_STRIP_DIME_75        192
#define LED_STRIP_DIME_50        128
#define LED_STRIP_DIME_25        64


#define OZONETTE_APP_MAX_FSM_STATES 64 + 6

#include "therapyControl/fsm_state.h"
#include "therapyControl/RomValues.h"
#include "therapyControl/Syringe.h"
/**
 * @brief Ozonette FSM context structure.
 * It has all the context and variables involved in the
 * implementation of the Ozonette Application Finite State Machine.
 */
// Review Asap fields order: var is hardcoded on C at boot time
#include "therapyControl/Timer.h"
#if 0  // 01072021 old code (JB)
typedef struct
{

    FSM_STATE_T            *LastState;
    FSM_STATE_T            *CurrentState;
    FSM_STATE_T             States[OZONETTE_APP_MAX_FSM_STATES];
    OPERATION_MODE_E        Option;
	TIMER_CTX_T             AnimationTimer;
	TIMER_CTX_T             ProcessEventTimer;
	TIMER_CTX_T             DataReadTimer;
	TIMER_CTX_T             AdjustTimeout;
	TIMER_CTX_T             GeneralPurposeTimeout;
	TIMER_CTX_T             WaitForServiceKeyTimer;
	TIMER_CTX_T             ManualModeIdleTimeout;
	TIMER_CTX_T             ManualModeTimeout;
	TIMER_CTX_T             HihgVoltDisconectTimeout;
	TIMER_CTX_T             CleanGeneratorTimeout;
	TIMER_CTX_T             AutoHemoPressureCompensationTimeout;
	TIMER_CTX_T             PeriodicSocketSupervisor;
	TIMER_CTX_T             PeriodicSocketInformation;
	SYRINGE_CTX_T           SyringeCtrl;

    uint8                   SamplePosition;
    uint8                   ConfiguredO3Concentration;
    uint8                   ConfiguredFlow;
    uint16                  ConfiguredTime;
    uint16                  ConfiguredTherapyTime;
    uint16                  ConfiguredDose;
    uint8                   ConfiguredVacuumTime;
    uint8                   ConfiguredVacuumTimeBackUp;
    uint32                  ConfiguredVolume;
    uint8                   RemainingHours;
    uint8                   RemainingMinutes;
    uint8                   RemainingSeconds;
    uint8                   FreezeRemainingTime;
    uint8                   StableFlow;
    uint8                   StableOzone;
    uint16                  SensorData[ID_SENSOR_MAX][NUM_SENSOR_SAMPLES];
    OZONETTE_APP_ERRORS     ErrorState;
    uint16                  SliderValue;
    int16                   CurrentMeanTemperature;
    uint16                  CurrentMeanPressure;
    uint16                  CurrentMeanOzone;
    uint16                  CurrentMeanFlow;
    uint32                  CurrentTotalDose;
    uint32                  CumulatedDose;
    uint32                  CurrentOutputVolume;
    uint32                  ReferenceOutputVolume;
    uint32                  CumulatedOutputVolume;
    uint8                   ManualModeEnterPushed;
    uint8                   InitVolumeGathering;

    uint8                   EnteredPassword[PASSWORD_SIZE];
    uint8                   CalibrationPassword[PASSWORD_SIZE];
    uint16                  PressAtm;
    uint16                  PressAdjust;                         /* Pressure during adjust process */
    uint8                   MaxAllowedFlow;                      /* Maximum allowed flow depending on O3 concentration selected */
    uint8                   MaxAllowedTime;
    uint8                   SyringeFillStaus;
    uint8                   TemperatureMonitoring;
    int8                    ManageCommandError;                  /* Due to optimize flash space */
    uint8                   MaxAvailableFlow;                    /* Maximum available flow depending on O3 input pressure applied */
    uint8                   ContinuousModeForOpenedBag;
    uint16                  WashingConfiguredTime;
    uint16                  WashingSeconds;
    uint8                   WashingReturnState;
    uint8                   SyringeDetected;                     /* Syringe already detected */
    uint8                   AnimationCounter;                    /* Animation iteration counter */
    uint8                   Testing_O3;
    uint8                   FirstManualModeIteraion;
    uint8                   InsufflationState;
    uint8                   InsufflationMode;
    uint8                   MediaInit;
    uint8                   DoseScale;
    uint8                   ChangeDoseScaleCounter;
    int16                   ChangeDoseScaleSliderValue;
    uint8                   BaggingVacuumType;
    uint8                   GeneratorCleaned;
    uint8                   SyringeEmergencyStop;
    uint8                   CalibrationErrorDuringStartUp;
    uint8                   Starting;
    int16                   MaxCurrent;                          /* Used in resonance frequency search process. */
    int16                   LastModBasePeriod;                   /* Used in resonance frequency search process. */
    int16                   TargetModBasePeriod;                 /* Used in resonance frequency search process. */
    uint8                   ShowStartUpSettings;
    uint16                  RemainingVacuumTime;
    uint16                  RemainingTherapyTime;
    uint8                   AutoHemoType;
    uint16                  AutoHemoCycles;
    uint8                   AutoHemoConcentrationSet[AUTOHEMO_CONCENTRATION_SET_LON];
    char                    ControlBoardVersion[CONTROL_BOARD_VERSION_LENGTH];
    int16                   ParametersValues[PARAMETERS_VALUES_LENGTH];
    uint8                   ManualSyringeState;
    uint16                  OverpressureDuringTherapy;
    uint8                   PressureControlledVacuum;
    int16                   MaxPressureControlledVacuum;
    int16                   PressThreshold;
    uint8                   StopAfterStartUp;
	int16                   MaxPressureOnBloodPush;
    uint8                   FirstSyringe;
    NEXT_SYRINGE_PARAMS_T   NextSyringe;
    MODULATOR_WIDTH_MEDIA_T ModulatorWidthMedia;
    uint32                  GenerationTime;
    uint8                   SkipMessageResponse;
    int16                   PeriodicInfoDelay;
	int16					MaxPressureOnReinfusion;
	int8					KeyPressedCode;
	uint8					SliderOperated;
}OZONETTE_FSM_T;
#endif

// 01072021 new code
typedef struct
{
	FSM_STATE_T            *LastState;
	FSM_STATE_T            *CurrentState;
	FSM_STATE_T             States[OZONETTE_APP_MAX_FSM_STATES];
	OPERATION_MODE_E        Option;
	TIMER_CTX_T             AnimationTimer;
	TIMER_CTX_T             ProcessEventTimer;
	TIMER_CTX_T             DataReadTimer;
	TIMER_CTX_T             AdjustTimeout;
	TIMER_CTX_T             GeneralPurposeTimeout;
	TIMER_CTX_T             WaitForServiceKeyTimer;
	TIMER_CTX_T             ManualModeIdleTimeout;
	TIMER_CTX_T             ManualModeTimeout;
	TIMER_CTX_T             HihgVoltDisconectTimeout;
	TIMER_CTX_T             CleanGeneratorTimeout;
	TIMER_CTX_T             AutoHemoPressureCompensationTimeout;
	TIMER_CTX_T             PeriodicSocketSupervisor;
	TIMER_CTX_T             PeriodicSocketInformation;
	SYRINGE_CTX_T           SyringeCtrl;
	uint8                   SamplePosition;
	uint8                   ConfiguredO3Concentration;
	uint8                   ConfiguredFlow;
	uint16                  ConfiguredTime;
	uint16                  ConfiguredTherapyTime;
	uint16                  ConfiguredDose;
	uint16                  ConfiguredVacuumTime;
	uint16                  ConfiguredVacuumTimeBackUp;
	uint32                  ConfiguredVolume;
	uint8                   RemainingHours;
	uint8                   RemainingMinutes;
	uint8                   RemainingSeconds;
	uint8                   FreezeRemainingTime;
	uint8                   StableFlow;
	uint8                   StableOzone;
	uint16                  SensorData[ID_SENSOR_MAX][NUM_SENSOR_SAMPLES];
	OZONETTE_APP_ERRORS     ErrorState;
	uint16                  SliderValue;
	uint8                   SliderOperated;
	int16                   CurrentMeanTemperature;
	uint16                  CurrentMeanPressure;
	uint16                  CurrentMeanOzone;
	uint16                  CurrentMeanFlow;
	uint32                  CurrentTotalDose;
	uint32                  CumulatedDose;
	uint32                  CurrentOutputVolume;
	uint32                  ReferenceOutputVolume;
	uint32                  CumulatedOutputVolume;
	uint8                   ManualModeEnterPushed;
	uint8                   InitVolumeGathering;
	uint16                  PressAtm;
	uint16                  PressAdjust;                         /* Pressure during adjust process */
	uint8                   MaxAllowedFlow;                      /* Maximum allowed flow depending on O3 concentration selected */
	uint8                   MaxAllowedTime;
	uint8                   TemperatureMonitoring;
	int8                    ManageCommandError;                  /* Due to optimize flash space */
	uint8                   MaxAvailableFlow;                    /* Maximum available flow depending on O3 input pressure applied */
	uint8                   ContinuousModeForOpenedBag;
	uint16                  WashingConfiguredTime;
	uint16                  WashingSeconds;
	uint8                   WashingReturnState;
	uint8                   SyringeDetected;                     /* Syringe already detected */
	uint8                   FirstManualModeIteraion;
	uint8                   InsufflationState;
	uint8                   InsufflationMode;
	uint8                   MediaInit;
	uint8                   BaggingVacuumType;
	uint8                   GeneratorCleaned;
	uint8                   SyringeEmergencyStop;
	uint8                   CalibrationErrorDuringStartUp;
	uint8                   Starting;
	int16                   MaxCurrent;                          /* Used in resonance frequency search process. */
	int16                   LastModBasePeriod;                   /* Used in resonance frequency search process. */
    int16                   MaxModBasePeriod;                 /* Used in resonance frequency search process. */
	uint16                  RemainingVacuumTime;
	uint16                  RemainingTherapyTime;
	uint8                   AutoHemoType;
	uint8                   AutoHemoCycles;
	uint8                   AutoHemoConcentrationSet[AUTOHEMO_CONCENTRATION_SET_LON];
    char                    ControlBoardVersion[CONTROL_BOARD_VERSION_LENGTH];
	int16                   ParametersValues[PARAMETERS_VALUES_LENGTH];
	uint8                   ManualSyringeState;
	uint8                   OverpressureDuringTherapy;
	uint8                   PressureControlledVacuum;
	int16                   MaxPressureControlledVacuum;
	int16                   PressThreshold;
	uint8                   StopAfterStartUp;
	int16                   MaxPressureOnReinfusion; /*MaxPressureOnBloodPush;*/
	uint8                   FirstSyringe;
	NEXT_SYRINGE_PARAMS_T   NextSyringe;
	MODULATOR_WIDTH_MEDIA_T ModulatorWidthMedia;
	uint32                  GenerationTime;
	uint8                   SkipMessageResponse;
	int16                   PeriodicInfoDelay;
    uint8                   KeyPressedCode;
    uint8                   TuningO3SensorCount;
    uint8                   AppActive;
    uint8                   CalibratingO3; // Azure Bug 10862: (SDV 2) Preventive led tunning incompatibility with calibration procedures
}OZONETTE_FSM_T;

typedef struct
{
  uint8 KeySimulationPending;
  uint8 SliderSimulationPending;
  uint8 SendStatePending;
  int8  KeyVal;
  int16 SliderVal;
  uint8 ShiftUp;
  uint8 ShiftDown;
}REMOTE_CONTROL_T;

typedef struct
{
    int16 X1;
    int16 X2;
    int16 Y1;
    int16 Y2;
}SOLVE_LINE_T;

/**
 * \enum Key codes
 */
typedef enum
{
  KEY_NONE            = 0x00,
  KEY_CANCEL          = 0x01,
  KEY_ENTER           = 0x02,
  KEY_ENTER_RELEASED  = 0x04,
  KEY_CANCEL_RELEASED = 0x08
}KEY_TYPES;


#define INI_BASE_PERIOD_CALCULATION_EQUATION(period, pressure, factor)   (period + (uint16)((uint32)(((uint32)factor * (uint32)pressure) >> 6)))
#define PERIOD_PRESSURE_COMPENSATION_EQUATION(period, pressure, factor)  (period - (uint16)((uint32)(((uint32)factor * (uint32)pressure) >> 6)))

#ifdef __cplusplus
extern "C" {
#endif
/**
 * Dummy function for those events not supported in the FSM states.
 * When am event is not possible in a given state, it's function pointer is configured with this function that does nothing.
 */
void DelegateDummy(void);


/**
 * Return valve output code depending on selected therapy.
 */
int8 ReturnValveOutput(void);

/**
 * Writes total generation time to a file.
 */
void WriteGenerationTimeToFile(void);

/**
 * Generates welcome message.
 */
void WelcomeMessage(void);
/**
 * Generates beep sound.
 */
void Beep(void);

/**
 * Generates beep sound for key press.
 */
void BeepKey(void);

/**
 * Present menu on screen.
 */
void MangeMenu(uint8 SelectedOption, uint8 *Titles, uint16 Image);

/**
 * Update reamining time depending on supplied dose for dose therapy
 */
void UpdateDoseRemainingTime(void);

/**
 * Print on screen generation data when cancelled.
 */
void DisplayCancelledTotals(void);
/**
 * Print on screen generation data when error condition.
 */
void DisplayOnErrorTotals(void);

/**
 * Print on screen generation data when therapy finished.
 */
void DisplayCompletedTotals(void);

/**
 * Read parameter from generator board.
 */
uint16 GetExternalParameter(uint16 ParamPosition);

/**
 * Set slider value on state transition .
 */
void InitSliderOnEntry(void);

/**
 * Reads from flash per-state image and writes it on the LCD display.
 */
void DisplayScreen(void);

/**
 * Reset accumulators.
 */
void ResetCumulativeValues(void);

/**
 * Send the specified command and process the answer.
 */

/**
 * Clear all errors.
 */
void ClearErrors(void);
/**
 * Send command group to stop generation.
 */
void SendStopCommand(void);

/**
 * Send command group to start the generator.
 */
void SendGeneratorStartSecuence(uint16 ModBasePeriod, uint16 ModWith, uint16 DeadTime);
/**
 * Send command group to start generation.
 */
void SendGenerationCommands(int16 GenerationMode);

/**
 * Switch valves following the correct secuence.
 */
void SwitchOutputValves(OUTPUT_POSITION_E OutputPosition);

/**
 * Compensate overpressure after bottle filling.
 */
void AutoHemoPressureCompensation(uint8 WaitForDepressure);

/**
 * Prepare valves for measure during therapy time on hiperbaric autohemo.
 */
void HiperbaricAutoHemoPressureMeasurementValvePositionig(void);

/**
 * Compensate overpressure after syringe filling.
 */
void SyringePressureCompensation(void);

/**
 * Enable show start up settings after start up.
 */
void EnableShowStartUpSettings(void);
/**
 * Manages step 1 of initial checking.
 */
void InitialCheck_Step1(void);
/**
 * Manages step 15 of initial checking.
 */
void InitialCheck_Step15(void);
/**
 * Manages step 2 of initial checking.
 */
void InitialCheck_Step2(void);
/**
 * Manages step 3 of initial checking.
 */
void InitialCheck_Step3(void);
/**
 * Pressure compensation for start up test.
 */
void PressureCompensationForStartUpTest(void);
/**
 * Wait until O3 sensor calibration is done.
 */
void WaitForO3SensorCalibration(void);
/**
 * Transition to the initial check process.
 */
void GotoInitialCheck(void);

/**
 * Transition to the Service menu State.
 */
void GotoServiceMenu(void);

/**
 * Transition to the Main menu State.
 */
void GotoMainMenu(void);

/**
 * Transition to the Ozone concentration selection state.
 */
void GotoO3Selection(void);

/**
 * Transition to the Brightness adjusting state.
 */
void GotoBrightnessSelection(void);

/**
 * Transition to the Contrast adjusting state.
 */
void GotoContrastSelection(void);

/**
 * Transition to the Flow selection state.
 */
void GotoFlowSelection(void);

/**
 * Transition to the time selection state.
 */
void GotoTimeSelection(void);

/**
 * Transition to the vacuum selection state.
 */
void GotoVacuumSelection(void);

/**
 * Transition to the volume selection state.
 */
void GotoVolumeSelection(void);

/**
 * Transition to the vacuum generation state.
 */
void GotoVacuumGeneration(void);
/**
 * Starts vacuum generation process.
 */
void StartVacuumGeneration();
/**
 * Starts resonance frequency search process.
 */
void StartResonanceFrequencySearch(void);
/**
 * Starts generator clean up process.
 */
void GeneratorCleanStart(int16 CleanFlow, uint32 CleanTime);
/**
 * Stops generator clean up process.
 */
void GeneratorCleanStop(void);
/**
 * Transition to the vacuum generation state from cancel vacuum state.
 */
void ReturnVacuumGeneration(void);
/**
 * Transition to the vacuum completed state.
 */
void GoToVacuumCompleted(void);
/**
 * Transition to the vacuum cancelled state.
 */
void GoToVacuumCancelled(void);
/**
 * Transition to the vacuum paused state.
 */
void GoToVacuumPaused(void);

/**
 * Repeat vacuum generation.
 */
void RepeatVacuumGeneration(void);

/**
 * Transition to the Ozone adjusting state.
 */
void GoToAdjusting(void);

/**
 * Transition to the Ozone sensor zero adjusting state.
 */
void GoToZeroAdjust(void);

/**
 * Transition to the Ozone generation state.
 */
void GotoGenerating(void);

/**
 * Transition to the Calibration state.
 */
void GotoCalibration(void);

/**
 * Transition to the show version state.
 */
void GotoShowVersions(void);

/**
 * Transition enter o cancel key waiting state after overpressure condition in manual mode.
 */
void GotoReturnFromOverPressure(void);

/**
 * Transition to the pressure and temperature state.
 */
void GotoShowPressureAndTemp(void);

/**
 * Transition to the language adjust state.
 */
void GotoLanguageAdjust(void);

/**
 * Transition to the User canceled state.
 */
void GotoUserCanceled(void);

/**
 * Transition to completed operation state.
 */
void GotoEndOperation(void);

/**
 * Transition to manual mode time out state.
 */
void GotoManualModeTimeOut(void);

/**
 * Transition to overpressure operation state.
 */
void GotoOverPressure(const char *backtrace);

/**
 * exit from overpressure state.
 */
void GotoOverPressureCancel(void);

/**
 * Transition to the Calibration menu state.
 */
void GotoCalibrationMenu(void);

/**
 * Transition to the Pressure Calibration state.
 */
void GotoCalibratePress(void);
/**
 * Transition to the Flow Calibration state.
 */
void GotoCalibrateFlow(void);
/**
 * Transition to the Ozone Calibration state.
 */
void GotoCalibrateO3(void);

/**
 * Transition to the Period Calibration state.
 */
void GotoCalibratePeriod(void);

/**
 * Transition to the pressure compensation factor state.
 */
void GotoAdjustPressCompFactor(void);

/**
 * Transition adjust base width state.
 */
/*void GotoAdjustBaseWidth(void);*/

/**
 * Transition adjust flow compensation for pulses.
 */
void GotoAdjustFlowCompForPulses(void);

/**
 * Transition to test pressure compensation factor.
 */
void GotoTestO3(void);

/**
 * Change to save parameters state
 *  */
void GotoSaveParameters(void);
/**
 * Change to load parameters state
 *  */
void GotoLoadParameters(void);
/**
 * Change to show parameters state
 *  */
void GotoShowParameters(void);

/**
 * Transition to the Error State.
 */
void GotoError(const OZONETTE_APP_ERRORS error );
void GotoErrorDummy( const OZONETTE_APP_ERRORS p);

/**
 * Send error (translated code).
 */
void SendErrorCode(uint16 ErrorState);

/**
 * Exit from Error State.
 */
void ExitError(void);

/**
 * Exit from Error State an execute initial check.
 */
void ExitErrorAndRestart(void);

/**
 * Transition to completed washing state.
 */
void GotoWashing(void);

/**
 * Extend washing time.
 */
void WashingExtesion(void);

/**
 * End of key mode transition.
 */
void EndOfKeyModeTransition(void);

/**
 * Start flow for blood push.
 */
void StartBloodPush(void);

/**
 * Stop flow for blood push.
 */
void StopBloodPush(void);

/**
 * Release pressure while blood push.
 */
void ReleasePressureOnBloodPush(void);

/**
 * Slider to O3 concentration conversion
 */
uint16 Slider2Ozone(uint16 Value);

/**
 * Slider to flow conversion
 */
int16  Slider2Flow(int16 Value);

/**
 * Slider to time conversion
 */
int16  Slider2Time(int16 Value);

/**
 * Slider to pin number conversion
 */
int16  Slider2Pin(int16 Value);

/**
 * Get volume sensor information.
 */
uint32 GetCumulatedVolume(void);

/**
 * Restart any therapy.
 */
void RestartGeneration(void);
/**
 * Restart autohemo therapy.
 */
void RestartAutohemo(void);
/**
 * Send all the configuration commands to perform the ozone generation.
 */
void InitGeneration(void);
void cancelGeneration(void);
void resumeGeneration( uint32_t delay );
/**
 * Change state when enterkey is released.
 */
void WaitEnterRelease(void);

/**
 * Start fan if temperature is bigger than parameter, stop it if not.
 */
void SetFanDependingOnTemperature(uint16 Temperature);

/**
 * Start stop vacuum.
 */
void SetVacuum(int8 State);

/**
 * Block previous vacuum pump valve.
 */
void BlockVaccumPump(void);

/**
 * Unblock previous vacuum pump valve.
 */
void UnblockVaccumPump(void);

uint8 MaxAllowedFlow(void);
uint8 MaxAllowedTime(void);


/**
 * Update the display information according to the state.
 */
void UpdateDisplay(void);

/**
 * Function that performs the adjusting animation screen sequence.
 */
void UpdateAdjusting(void);

/**
 * FunctionS that update zero adjusting progress.
 */
void UpdateZeroAdjusting_1(void);
void UpdateZeroAdjusting_2(void);
void UpdateZeroAdjusting_3(void);

/**
 * Function that checks vacuum generation process.
 */
void UpdateVacuum(void);

/**
 * Function that controls therapy time.
 */
void UpdateWaitingTherapyTime(void);

/**
 * Function that controls end of therapy time.
 */
void SkipTherapyTime(void);
/**
 * Change dose scale if necessary.
 */
void UpdateDoseScale(void);

/**
 * Function that starts O3 generation with stared parameters.
 */
void StartSyringeWithStoredParameters(void);

/**
 * Function that calculates modulator width for next syringe.
 */
void CalculateModulatorWithForNextSyringe(void);

/**
 * Function that resets O3 generation parameters.
 */
void ResetO3ParametersForNextSyringe(void);

/**
 * Function that stores O3 generation parameters.
 */
void StoreO3ParametersForNextSyringe(void);

/**
 * Function that updates pushing blood supervision process.
 */
void UpdatePushingBlood(void);

/**
 * Function that performs the generation screen information update.
 */
void UpdateGenerating(void);

/**
 * Function that performs the control of washing process.
 */
void UpdateWashing(void);

/**
 * Function that performs the cancel of washing process.
 */
void CancelWashing(void);

/**
 * Enter Pushing event handling function for manual mode operation.
 */
void ManualOnPush(void);

/**
 * Enter release event handling function for manual mode operation.
 */
void ManualOnRelease(void);

/**
 * Writes the error image and the error code according to the failure detected.
 */
void DisplayError(void);

/**
 * Function that performs the blinking of the Error state screen.
 */
void UpdateError(void);

/**
 * Select the reference value in the various calibration states using the slider.
 */
void SelectReferenceValue(void);

/**
 * Calculate line for flow calibration.
 */
void ResolveFlowCalibrationLine(int16 *Slope, int16 *Offset);
/**
 * Calculate line for O3 concentration calibration.
 */
void ResolveO3CalibrationLine(int16 *Slope, int16 *Offset);
/**
 * Look for two lines intersection point .
 */
int16 ResolveLineIntersection(int16 Slope1, int16 Offset1, int16 Slope2, int16 Offset2);
/**
 * Extract some iterative processes form next function (ValidateReferenceValue) due to FLASH optimization.
 */
void CreateFlowCalibrationSector(int16 FlowCalibrationPoint, uint16 GainTablePosition, uint16 OffsetTablePosition, uint16 LimitTablePosition);

void CancelPressCalibration(void);
/**
 * Validate the reference value selected when enter is issued.
 */
void ValidateReferenceValue(void);

/**
 * Transition over the different states of the password validation sequence.
 */
void ValidatePassword(void);

/*
 * Shows a "Done" string when a configuration value is validated.
 * */
void ValidateValue(uint16 MsDelay);

/**
 * Store the configured values in memory (Contrast and Brightness)
 */
void ValidateConfigValues(void);

/**
 * Restore the configuration display values in memory (Contrast and Brightness)
 */
void RestoreDisplayConfig(void);

/**
 * Highlight the selected calibration menu option when slider is operated.
 */
void SelectCalibrateOption(void);

/**
 * Update the highlighted option in the operation selection screen.
 */
void SelectServiceOption(void);

/**
 * Update the highlighted option in the operation selection screen.
 */
void SelectOption(void);

/**
 * Read and show the Software versions of the boards.
 */
void ShowSWVersions(void);

/**
 * Read the Software versions of the control boards.
 */
void GetControlBoardSWVersion(void);
/**
 * Read and show the temperature and pressure.
 */
void ShowPressureAndTemp(void);

/**
 * Start slider mask layer setting slider maximun and minimum values.
 */
void StartSliderMask(uint16 MaxVal, uint16 MinVal);

/**
 * Generator start for initial test current.
 */
void TestCurrentStart(void);

/**
 * Calibrate current value for start up test (step 2).
 */
void CalibrationTestCurrent(void);

/**
 * Update resonance frequency search process.
 */
void UpdateResonanceFrequencySearch(void);

/**
 * Read calibration parameters from the control board and store them in flash memory for part replacement operations.
 */
void SaveParameters(void);

/**
 * Read calibration parameters from flash memory and send them to the control board.
 */
void LoadParameters(void);

/**
 * Recover parameters from memory
 */
void PrepareParameters(void);
/**
 * Show calibration parameters on screen
 */
void ShowParameters(void);

/**
 * Set generation mode
 */
void SetGenerationMode(uint16 mode);

/**
 * Set skip error value
 */
void SetSkipErrorValue(uint16 value);

/**
 * Check for flow and concentration stability
 */
uint8 MeasurementIsStable(ID_SENSOR_E Sensor);

/**
 * Prepare interface for remote control action
 */
void RemoteControlProgramAction(size_t Key, int16 SliderValue);

/**
 * Return remote control key value
 */
void RemotecontrolCheckKey(int8 *Key);

/**
 * Return remote control slider value
 */
void RemoteControlCheckSlider(int16 *SliderValue);

/**
 * Return remote control state
 */
void RemoteControlReturnState(void);

/**
 * Ozonette FSM initialization function.
 * It's called when entering the Init State and is responsible for initializing and configuring all the peripherals and global data variables for
 * the FSM correct operation.
 */
void fsmBoot(void);

/**
 * Return absolute pressure using last pressure sample and atmospheric pressure.
 */
uint16 GetInstantAbsolutePressure(uint16 PressAtm);


/**
 * Detect false flow.
 */
void DetectFalseFlowSituation(void);

/**
 * Detect high voltage disconnection
 */
void DetectHighVoltageDisconnection(void);




/**
 * Compute data sensor media.
 */
void SensorMeanComputation(void);

/**
 * Reset sensor information.
 */
void SensorMeasureReset(void);

/**
 * Check flow stability.
 */
void CheckFlowStability(void);

/**
 * Check ozone stability.
 */
void CheckOzoneStability(void);

/**
 * Distort adjusting process.
 */
void SkipAdjusting(void);


void SetAppMode(uint8 Mode);
/**
 * Ozonette FSM process event function.
 * It's called iteratively to check for keyboard, Timer and serial protocol asynchronous events and call the current state event handling function.
 */
void OZONETTE_FSM_ProcessEvents(void);

/**
 * General menu management.
 */

/**
 *  Main menu management.
 */
void ManageMainMenu(void);

/**
 *  Service menu management.
 */
void ManageServiceMenu(void);

/**
 *  Language menu management.
 */
void ManageLanguageMenu(void);

/**
 *  Calibration menu management.
 */
void ManageCalibrationMenu(void);

/**
 *  Main menu start.
 */
void MainMenuEnter(void);

/**
 *  Service menu start.
 */
void ServiceMenuEnter(void);

/**
 *  Calibration menu start.
 */
void CalibrationMenuEnter(void);

/**
 *  Language menu start.
 */
void LanguageMenuEnter(void);

/**
 *  Manage Socket.
 */
int8 ManageSocket(void);

/*
 *  Initialize mean temperature buffer
 */
void KeepCurrentMeanTemperature(void);

/*
 *  Reset some timers
 */
void ResetTimers(void);
void ExitFromWaitingAfterStartUp(void);

void SensorProcess  ( void );
void SyncPeriodicInfo( uint16_t period );
//void SendPeriodicInfo();

void SendPeriodicInfoDelegate();
#ifdef __cplusplus
}
#endif






void InitWarmingO3Sensor(void);
void WarmingO3Sensor(void);
void CompletedLedIndication(void);
void AdjustingLedIndication(void);
void ChangeCurrentState (FSM_STATE_T* NewState);
void UpdatePressureAndTemperature(void);
#endif /* FSM_H_ */





/*
  NOTAS DE INTERES
  ================

 * (10/11/2017) Baggin.
 ----------------------
 In bagging therapy output is connected to the bag, and output valve is open while vaccum process in order to measure pressure. If
 therapy parameters are introduced so quickly, it could happen that O2 that provides the cleaning process of the sensor goes to the
 bag for a few seconds. That situation is not considered dangerous.

 * (10/11/2017) Error 1, 2, 3, 5, 8 during start up.
 ---------------------------------------------------
 If this errors happen during start up, reset is the best option. It should be very complex return the execution to the state just
 before the error. In other way, go to main menu is not the best option because parameters and permissions enabled during star up
 could be set in wrong way (max allowed flow, syringe enable ...).

 */
