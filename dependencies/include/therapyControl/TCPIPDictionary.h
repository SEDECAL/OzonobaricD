/*
 * SocketProtocol.h
 *
 *  Created on: 29/01/2018
 *      Author: Roberto.Sanchez
 */

#pragma once

/* Socket protocol responses */
#define SPROT_ACK_RESP                "{@"
#define SPROT_NACK_RESP               "{#"

/* Socket protocol commands */
#define SPROT_END_LIST                 ""
#define SPROT_KEEP_ALIVE               "{ALIVE"
#define SPROT_SYRINGE_START            "{SYRSTR"
#define SPROT_O3CONT_START             "{O3STR"
#define SPROT_CLOSED_BAGGING_START     "{CBAGSTR"
#define SPROT_OPENED_BAGGING_START     "{OBAGSTR"
#define SPROT_DOSE_START               "{DOSESTR"
#define SPROT_AUTOHEMO_START           "{AUTOSTR"
#define SPROT_SALINE_HEMOTHERAPY_START "{SALINESTR"
#define SPROT_V_INSUFFLATION_START     "{INSSTR_V"
#define SPROT_R_INSUFFLATION_START     "{INSSTR_R"
#define SPROT_TIME_VACUUM_START        "{TVACSTR"
#define SPROT_PRESSURE_VACUUM_START    "{PVACSTR"
#define SPROT_MANUAL_START             "{MANSTR"
#define SPROT_THERAPY_STOP             "{STOP"
#define SPROT_GET_STATE                "{GETST"
#define SPROT_GET_SW_VER               "{GETVER"
#define SPROT_GET_PARAMETERS           "{GETPAR"
#define SPROT_GET_CURRENT_VALUES       "{GETDAT"
#define SPROT_GET_INFO                 "{GETINFO"
#define SPROT_SET_P_INFO               "{SET_P_INFO"
#define SPROT_SERVICE_MENU             "{SERVICE"
#define SPROT_CALIBRATE_PRESSURE       "{CALPRESS"
#define SPROT_CALIBRATE_FLOW           "{CALFLOW"
#define SPROT_CALIBRATE_O3             "{CALO3"
#define SPROT_CALIBRATE_P_FACTOR       "{CALPFACT"
#define SPROT_CALIBRATE_PERIOD         "{CALPER"
#define SPROT_SAVE_PARAMETERS          "{SAVEPAR"
#define SPROT_LOAD_PARAMETERS          "{LOADPAR"

#define SPROT_SIMULATE_ENTER           "{ENT_SIM"
#define SPROT_SIMULATE_ENTER_RELEASED  "{ENTREL_SIM"
#define SPROT_SIMULATE_CANCEL          "{CNL_SIM"
#define SPROT_SIMULATE_SLIDER          "{SLD_SIM"

#define SPROT_STOP_AFTER_START_UP      "{ST_UP_STOP"
#define SPROT_START_BLOOD_PUSH         "{STR_PUSH"
#define SPROT_STOP_BLOOD_PUSH          "{STP_PUSH"
#define SPROT_TEXT                     "{TEXT"
#define SPROT_RESET_GENERATOR_TIME     "{RSTGENTIME"
#define SPROT_SIMULATE_ERROR_DEBUG     "{SIM_ERROR"
#define SPROT_SERIAL_PROTOCOL          "{SERIAL_PRO"

#define SPROT_SERIAL_BOOT              "{SERIAL_BOOT"
#define SPROT_SERIAL_STOP_BOOT         "{SERIAL_STOP_BOOT"
#define SPROT_SERIAL_SET_NAME          "{SERIAL_SET_NAME"
#define SPROT_SERIAL_GET_NAME          "{SERIAL_GET_NAME"
#define SPROT_SERIAL_SET_ADD           "{SERIAL_SET_ADD"
#define SPROT_SERIAL_GET_ADD           "{SERIAL_GET_ADD"
#define SPROT_SERIAL_STATUS            "{SERIAL_ST"
#define SPROT_FSM_BOOT                 "{FSM_BOOT"
#define SPROT_INIT                     "{INIT"
#define SPROT_SET_GEN_MODE             "{GEN_MODE"
#define SPROT_SERIAL_GET_DISCOVERED    "{SERIAL_GET_DISC"
#define SPROT_SERIAL_START_DISC        "{SERIAL_DISC"
#define SPROT_SERIAL_STOP_DISC         "{SERIAL_STOP_DISC"

#define SPROT_APP_MODE                 "{APP_MODE"

#define SPROT_SET_SKIP_ERROR           "{SET_SKIP_ERROR"

