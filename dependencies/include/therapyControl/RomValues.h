#pragma once

/* Default slider values for data selection*/
#define DEFAULT_SLIDER_O3_VALUE                       15      /* ug/Nml */
#define DEFAULT_SLIDER_BAGGIN_O3_VALUE                25      /* ug/Nml */
#define DEFAULT_SLIDER_FLOW_VALUE                     20      /* l/h    */
#define DEFAULT_SLIDER_TIME_VALUE                     15      /* min    */
#define DEFAULT_SLIDER_DOSE_VALUE                     2750    /* ug     */
#define DEFAULT_SLIDER_THERAPY_TIME_VALUE             20      /* min    */
#define DEFAULT_SLIDER_BAGGING_VACUUM_VALUE           50      /* sec    */
#define DEFAULT_SLIDER_BAGGIN_VOLUME_VALUE            1       /* l      */
#define DEFAULT_SLIDER_INSUFFLATION_VOLUME_VALUE      200     /* ml     */
#define DEFAULT_SLIDER_VACUUM_VALUE                   40      /* sec    */
#define DEFAULT_SLIDER_BAGGIN_VACUUM_VALUE            50      /* sec    */
#define DEFAULT_SLIDER_INSUFFLATION_FLOW_VALUE        10      /* l/h    */
#define DEFAULT_SLIDER_FLOW_CALIBRATION_STEP_1        900     /* dimensionless */
#define DEFAULT_SLIDER_FLOW_CALIBRATION_STEP_2        30      /* dimensionless */
#define DEFAULT_SLIDER_FLOW_CALIBRATION_STEP_3        36      /* dimensionless */
#define DEFAULT_SLIDER_FLOW_CALIBRATION_STEP_1B       180     /* dimensionless */
#define DEFAULT_SLIDER_FLOW_CALIBRATION_STEP_2B       350     /* dimensionless */
#define DEFAULT_SLIDER_FLOW_CALIBRATION_STEP_3B       660     /* dimensionless */
#define DEFAULT_SLIDER_O3_CALIBRATION_STEP_1          200     /* dimensionless */
#define DEFAULT_SLIDER_O3_CALIBRATION_STEP_2          100     /* dimensionless */
#define DEFAULT_SLIDER_O3_CALIBRATION_STEP_3          50      /* dimensionless */
#define DEFAULT_SLIDER_O3_CALIBRATION_STEP_4          10      /* dimensionless */

/* Overpressure limits for different therapies*/
#define OVERPRESSURE_THRESHOLD_SYRINGE                650/*950*/     /* mBar */
#define OVERPRESSURE_THRESHOLD_CONTINUOUS             500     /* mBar */
#define OVERPRESSURE_THRESHOLD_MANUAL                 500     /* mBar */
#define OVERPRESSURE_THRESHOLD_DOSE                   700     /* mBar */ /* 19/01/2016 marketing meeting */
#define OVERPRESSURE_THRESHOLD_BAGGING                200     /* mBar */
#define OVERPRESSURE_THRESHOLD_INSUFFLATION           200     /* mBar */
#define OVERPRESSURE_THRESHOLD_AUTOHEMO               200/*500*/     /* mBar */
#define LOWPRESSURE_THRESHOLD_VACUUM                 -200     /* mBar */

#define PISTON_PRESSURE_INITIAL_PEAK                  30/*40*/      /* mBar */
#define FILL_PRESSURE_DEVIATION                       20      /* mBar */

/* Maximum and minimum values where needed */
#define MAX_SLIDER_VALUE                              100
#define MIN_SLIDER_VALUE                              0
#define MIN_OZONE_VALUE                               1
#define MAX_OZONE_VALUE                               80
#define MAX_FLOW_VALUE                                50
#define MIN_FLOW_VALUE                                10
#define MAX_DOSE_VALUE                                40000
#define MIN_DOSE_VALUE                                500
#define MAX_TIME_VALUE                                30      /* Ozonobaric P *//*20 Ozonette */
#define MIN_TIME_VALUE                                1
#define MAX_THERAPY_TIME_VALUE                        30
#define MIN_THERAPY_TIME_VALUE                        5
#define MAX_VACUUM_VALUE                              120
#define MIN_VACUUM_VALUE                              10
#define MAX_VACUUM_VALUE_FOR_BAGGIN                   180
#define MIN_VACUUM_VALUE_FOR_BAGGIN                   15
#define MAX_VOLUME_VALUE                              10      /* l  */
#define MIN_VOLUME_VALUE                              1       /* l  */
#define MAX_VOLUME_VALUE_INSUFFLATION                 6000    /* ml */
#define MIN_VOLUME_VALUE_INSUFFLATION                 1       /* ml */
#define MAX_PRESS_VALUE                               1040
#define MIN_PRESS_VALUE                               640
#define MAX_FLOW_DEVIATION                            7*8
#define MAX_OZONE_DEVIATION                           10*8
#define MAX_PULSES_VALUE                              500/*400*/
#define MIN_PULSES_VALUE                              1
#define MAX_PIN_VALUE                                 9
#define MIN_PIN_VALUE                                 0
#define MAX_CONFIG_FLOW_SLIDER_VALUE                  100
#define MIN_CONFIG_FLOW_SLIDER_VALUE                  0
#define MAX_ERROR_IN_CURRENT_START_UP_TEST_BY_SENSOR  8*8
#define MAX_ERROR_IN_CURRENT_START_UP_TEST_BY_PULSES  150
#define MAX_PERIOD_FOR_PERIOD_CALIBRATION             1800
#define MIN_PERIOD_FOR_PERIOD_CALIBRATION             1000
#define MAX_VALUE_FOR_PRESS_COMP_FACTOR               20/*64*/
#define MIN_VALUE_FOR_PRESS_COMP_FACTOR               0/*1*/
#define MAX_VALUE_FOR_BASE_WIDTH                      850
#define MIN_VALUE_FOR_BASE_WIDTH                      400
#define MAX_VALUE_FOR_FLOW_COMP_FOR_PULSES            800
#define MIN_VALUE_FOR_FLOW_COMP_FOR_PULSES            0
#define MAX_VALUE_FOR_WASHING_TIME                    1200     /* seconds */
#define MAX_SLIDER_FLOW_CALIBRATION_STEP_X            60
#define MIN_SLIDER_FLOW_CALIBRATION_STEP_X            10
#define MAX_SLIDER_FLOW_CALIBRATION_STEP_XB           900
#define MIN_SLIDER_FLOW_CALIBRATION_STEP_XB           100

/* Time parameters */
#define COMMUNICATION_TEST_PERIOD_MS                  1500    /* ms */
#define FIRST_COMMUNICATION_TEST_PERIOD_MS            1500    /* ms */  /* force delay to get stabilized atmospheric pressure values after a therapy */
#define ANIMATION_PERIOD_MS                           1000    /* ms */
#define ANIMATION_PERIOD_DURING_VACUM_MS              1       /* ms */
#define ANIMATION_PERIOD_DURING_DOSE_SELECTION_MS     500     /* ms */
#define SERVICE_ENTRY_TIME_WINDOW                     2000    /* ms */
#define PERIODIC_SOCKET_SUPERVISOR_TOUT               6000    /* ms */

#define HI_SPEED_DATA_READ_PERIOD_MS                  1000    /* ms */
#define LOW_SPEED_DATA_READ_PERIOD_MS                 2000    /* ms */
#define WASHING_FLOW_STABILIZATION_TIME               6000    /* ms */
#define GENERATOR_CLEAN_TIME                          5000    /* ms */

/*Time outs */
#define ADJUST_TIMEOUT_MS                             20000   /* ms */
#define MANUAL_MODE_IDLE_TIMEOUT                      60000   /* ms */
#define HIGH_VOLT_DETECTION_TIMEOUT                   3000    /* ms */
#define O3_SENSOR_CALIBRATION_TIME_OUT                5       /* seg */

/* Some default flow and time values */
#define DEFAULT_WHASHING_TIME                         10      /* seconds */
#define INCREMENT_FOR_WASHING_TIME                    30      /* seconds */
#define DEFAULT_FLOW_VALUE                            30      /* l/h */
#define DEFAULT_SYRINGE_FLOW_VALUE                    30      /* l/h */
#define DEFAULT_BAGGIN_FLOW_VALUE                     50      /* l/h */
#define DEFAULT_AUTOHEMO_FLOW_VALUE                   30      /* l/h */
#define WASHING_FLOW                                  40      /* l/h */
#define BLOOD_PUSH_FLOW                               10      /* l/h */
#define AUTOHEMO_WAITING_TIME                         10/*120*/     /* seconds */
#define AUTOHEMO_DEPRESSURIG_TIME                     2000    /* ms */
#define AUTOHEMO_MAX_VACUUM_TIME                      20      /* seconds */

/* Temperature limit to start fan
 * when therapy is selected */
#define FAN_ON_TEMPERATURE                            35*127  /* �C * sensor factor */
#define FAN_HYSTERESIS                                2*127   /* �C * sensor factor */

/* Start up flow for test current */
#define FLOW_START_UP_TEST_CURRENT                    20*8

/* O3 calibration flow */
#define FLOW_O3_CALIBRATION                           20*8

/* Start up flow for test flow*/
#define FLOW_START_UP_TEST_FLOW                       800     /* Set proportional valve completely opened */

/* Flow calibration points */
#define FLOW_CALIBRATION_POINT_1                      11*8
#define FLOW_CALIBRATION_POINT_2                      21*8
#define FLOW_CALIBRATION_POINT_3                      40*8

/* Ozone calibration points */
#define O3_CALIBRATION_POINT_0                         1*8
#define O3_CALIBRATION_POINT_1                        22*8
#define O3_CALIBRATION_POINT_2                        15*8
#define O3_CALIBRATION_POINT_3                        60*8

/* Save restore parameters */
#define MAX_PARAMETER_WORDS                           197
#define INI_PARAM_SPI_PAGE                            MAX_SPI_IMAGES + 1
#define PARAM_CALIBRATED_VALUES                       0x0CA0  /*!< Table contents calibrated values. */

/* Slider mask behavior control */
#define RESET_SLIDER_OFFSET                           0
#define RESET_SLIDER_MULTIPLIER                       1

/* Pushed state for manual mode */
#define PUSHED                                        1
#define NOT_PUSHED                                    0

/* Password */
#define PASSWORD_SIZE                                 4

/* Some syringe data */
#define SYRINGE_PATTERN_NUM                           5
#define SYRINGE_STOP_5ML                              4000
#define SYRINGE_STOP_10ML                             6150
#define SYRINGE_STOP_20ML                             10828
#define SYRINGE_STOP_50ML                             23404
#define SYRINGE_STOP_100ML                            45000

/* Dose selection slider scale */
#define DOSE_SCALE_0_MIN                              0
#define DOSE_SCALE_0_MAX                              90
#define DOSE_SCALE_0_OFFSET                           500
#define DOSE_SCALE_0_MULTIPLIER                       50
#define DOSE_SCALE_1_MIN                              0
#define DOSE_SCALE_1_MAX                              150
#define DOSE_SCALE_1_OFFSET                           5000
#define DOSE_SCALE_1_MULTIPLIER                       100
#define DOSE_SCALE_2_MIN                              0
#define DOSE_SCALE_2_MAX                              200
#define DOSE_SCALE_2_OFFSET                           20000
#define DOSE_SCALE_2_MULTIPLIER                       100
#define DOSE_SCALE_3_MIN                              0
#define DOSE_SCALE_3_MAX                              0
#define DOSE_SCALE_3_OFFSET                           0
#define DOSE_SCALE_3_MULTIPLIER                       1

/* Insufflation slider behavior for volume selection */
#define INSUFFLATION_SCALE_MULTIPLIER_1               10
#define INSUFFLATION_SCALE_MULTIPLIER_2               50
#define INSUFFLATION_SCALE_STEP                       2000

/* Others */
#define O3_FLOW_REACHED                               2
#define O3_CONCENTRATION_REACHED                      2
#define O3_CONCENTRATION_REACHED_ACCURATE             3
#define O3_ERROR_DETECTION_ITERATIONS                 7    /* @ 10l/h - 1ug/Nml */
#define INSUFFLATION_STATE_ON                         1
#define INSUFFLATION_STATE_PAUSED                     0
#define MANUAL_SYRINGE_STATE_ON                       1
#define MANUAL_SYRINGE_STATE_PAUSED                   0
#define IRRATIONAL_SLIDER_VALUE                      -2
#define DOSE_SCALE_COUNTER_DELAY                      5
#define BAGGING_FINAL_VACUUM_TIME_FACTOR              20   /* seconds/liter */
#define PERIOD_INCREMENT_FOR_CURRENT_START_UP_TEST    250
#define PERIOD_FOR_START_UP_TEST_CURRENT              1280 + 500
#define INITIAL_PERIOD_FOR_O3_CALIBRATION             1400
#define INITIAL_PULSES_FOR_O3_CALIBRATION             300
#define INITIAL_PRESSURE_COMPENSATION_FACTOR          32
#define DEFAULT_PRESSURE_GAIN                         115
#define NUM_SENSOR_SAMPLES                            16 /* Chose multiple of 2 value and review each constant use to adjust '>>' operator */
#define PROP_VALVE_CLOSED_VALUE                       5
#define TUNE_O3_SENSOR_LED                            0
#define TUNE_O3_SENSOR_LED_AND_START_LED_PID          1
#define RESONANCE_FREQ_SEARCH_WIDTH_VALUE             240
#define RESONANCE_FREQ_SEARCH_PERIOD_START_VALUE      1000
#define RESONANCE_FREQ_SEARCH_PERIOD_STOP_VALUE       700
#define RESONANCE_FREQ_SEARCH_PERIOD_STEP_VALUE       6
#define SLIDER_DEBIATION_FOR_PRESS_COMP_FACTOR        10
#define O3_GENERATION_BASED_ON_O3_PHOTOSENSOR         1
#define O3_GENERATION_BASED_ON_TUBE_CALIBRATION       0
#define CONTROL_BOARD_VERSION_LENGTH                  50
#define PARAMETERS_VALUES_LENGTH                      25
#define AUTOHEMO_CONCENTRATION_SET_LON                5
