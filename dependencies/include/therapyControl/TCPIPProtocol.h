/*
 * SocketProtocol.h
 *
 *  Created on: 29/01/2018
 *      Author: Roberto.Sanchez
 */

#pragma once
#include <string.h>
#include <stdlib.h>

/*#define SPROT_VERSION   "V0.R0.P0"     31/01/2018. First version with test and draft commands. */
/*#define SPROT_VERSION   "V0.R0.P1"     27/06/2018. First version with test and draft commands. Is the same version, the other one was not correctly registered in svn*/
#define SPROT_VERSION   "V0.R0.P2"  /* 10/07/2018. Pressure information added on get generation command.*/


#define SPROT_MAX_COMMAND_LENGTH   80
#define SPROT_MAX_RESPONSE_LENGTH  100
#define SPROT_END_COMMAND_CHAR     0x0D
#define SPROT_END_COMMAND_STRING   "\x0D"
#define SPROT_START_COMMAND_CHAR   '{'
#define SPROT_SEPARATOR_CHAR       ","

/* Socket protocol commands */
#include "therapyControl/TCPIPDictionary.h"



#define SPROT_ERROR_WRONG_COMMAND_CODE   -1
#define SPROT_ERROR_NO_START_CHAR        -2

#define SocketProtocolInit SPROT_Init(GLB_SocketCommandBuffer, &GLB_SocketCommand, GLB_SocketResponseBuffer, &GLB_SocketResponse);
#include "inc/myTypes.h"

typedef struct SPROT_command{
  uint8 i;
  char *Data;
} SPROT_COMMAND;

typedef struct SPROT_response{
  uint8 i;
  char *Data;
} SPROT_RESPONSE;

typedef struct SPROT_command_item{
  char  CommandId[15];
  int8 (*DecodeFunction)(char *Data);
} SPROT_COMMAND_ITEM;



void SPROT_Init(int8 *CommandBuffer,  SPROT_COMMAND *SocketCommandStruct, int8 *ResponseBuffer, SPROT_RESPONSE *SocketResponseStruct);
int8 SPROT_ReceiveCommand(int8 *Data, SPROT_COMMAND *Command);
int8 SPROT_ExecuteCommand(SPROT_COMMAND *Command, SPROT_COMMAND_ITEM *CommandList);
int8 SPROT_StartResponse(SPROT_RESPONSE *Response, char*Data);
int8 SPROT_AppendResponse(SPROT_RESPONSE *Response, const char *Data);

void SPROT_InitResources(void);
void SPROT_ResetCumulativeValues(void);
int8 SPROT_CheckCurrentErrorStatus(void);

int8 SPROT_KeepAlive           (const char *Data);
int8 SPROT_SyringeStart        (const char *Data);
int8 SPROT_O3Start             (const char *Data);
int8 SPROT_ManualStart         (const char *Data);
int8 SPROT_ClosedBaggingStart  (const char *Data);
int8 SPROT_OpenedBaggingStart  (const char *Data);
int8 SPROT_DoseStart           (const char *Data);
int8 SPROT_AutoHemoStart       (const char *Data);
int8 SPROT_SalineHemoStart     (const char *Data);
int8 SPROT_R_InsufflationStart (const char *Data);
int8 SPROT_V_InsufflationStart (const char *Data);
int8 SPROT_TimeVacuumStart     (const char *Data);
int8 SPROT_PressureVacuumStart (const char *Data);
int8 SPROT_TheraphyCancel      (const char *Data);
int8 SPROT_DeviceInfo          (const char *Data);
int8 SPROT_PeriodicInfo        (const char *Data);
int8 SPROT_GetGeneratorState   (const char *Data);
int8 SPROT_SimulateEnterKey    (const char *Data);
int8 SPROT_SimulateCancelKey   (const char *Data);
int8 SPROT_SimulateSlider      (const char *Data);
int8 SPROT_ServiceMenu         (const char *Data);
int8 SPROT_CalibratePressure   (const char *Data);
int8 SPROT_CalibrateFlow       (const char *Data);
int8 SPROT_CalibrateO3         (const char *Data);
int8 SPROT_CalibratePFactor    (const char *Data);
int8 SPROT_CalibratePeriod     (const char *Data);
int8 SPROT_SaveParameters      (const char *Data);
int8 SPROT_LoadParameters      (const char *Data);
int8 SPROT_StopAfterStartUp    (const char *Data);
int8 SPROT_StartBloodPush      (const char *Data);
int8 SPROT_StopBloodPush       (const char *Data);
int8 SPROT_ResetGenerationTime (const char *Data);
int8 SPROT_SimulateErrorForDebugPurposes(const char *Data);
int8 SPROT_SimulateEnterReleasedKey(const char *Data);
int8 SPROT_AppMode             (const char *Data);

//int8 SPROT_SerialBoot          (const char *Data);


