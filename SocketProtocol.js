// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright (C) 2024 Sedecal S.A.
// This file is part of OzonobaricD.
// See LICENSE file for details.

Qt.include("UnitsConversion.js")
//function preDecodeSocket(data){}  Is it necessary?

let generationTime = 0; //  Azure Bug 10444: (SDV) Generation time always set to 01:01:01, (13/09/2024)

let last = {
    state:              "",
    error:              "",
    rem_min:            "",
    rem_sec:            "",
    flow:               "",
    o3:                 "",
    dose:               "",
    volume:             "",
    pressure:           "",
    atm_press:          "",
    temp:               "",
    rem_vac_time:       "",
    rem_prot_time:      "",
    max_available_flow: "",
    autohemo_cycles:    "",
    washing_time:       "",
    washing_sec:        "",
    overpress_st:       "",
    insuf_st:           ""
}


//function getLast(){
//    for (let x in last) {
//       console.log(x + ": "+ last[x])
//    }
//}

function updateLast(data){
    var i = 0
    const cmdArgs = data.split(",")
    for (let x in last) {
       last[x] = cmdArgs[i++]
    }
}

let commands = [
    { id: "{SERIAL_ST",       exec: function(a){ return manageSerialStatus(a) } },
    { id: "{SERIAL_GET_DISC", exec: function(a){ return manageGetDicovered(a) } },
    { id: "{GETDAT",          exec: function(a){ return manageGetData(a) } },
    { id: "{TEXT",            exec: function(a){ return manageText(a) } },
    { id: "{GETPAR",          exec: function(a){ return manageParameters(a) } },
    { id: "{GETVER",          exec: function(a){ return manageVersions(a) } }
    ]

function decodeSocket(data){
    var i
//  console.log("decodeSocket data: ", data)
    commands.forEach(command => { if( (i = data.indexOf(command.id )) >=0 ) command.exec( data.substr(i + command.id.length + 1) ) }) // (+1 due to comma separator)
}

function manageSerialStatus(data){
    var status = parseInt(data.substr(0, 1), 16)
    var tmp = !!status ? fsmSignals.bluetoothLinked() : fsmSignals.bluetoothUnlinked()
    toolBar.connectedIcon = !!status
    startUp.linkStatus =  !!status
    configArea.deviceInfo.enableMasck = !!status
    configArea.deviceInfo.bluetoothInfo.state = !configArea.deviceInfo.bluetoothInfo.configPending ? (!!status ? "connected" : "disconnected") : configArea.deviceInfo.bluetoothInfo.state
    configArea.deviceCalibration.linkGeneratorInfo.linkResult = !!status ? true : configArea.deviceCalibration.linkGeneratorInfo.linkResult
    configArea.deviceCalibration.enableMasck = !!status
}

function manageGetDicovered(data){
    if(data === "")
        return

    configArea.deviceCalibration.linkGeneratorInfo.addDevice(data)
}

const rOffset = {
   STATE:               0,
   ERROR:               1,
   REM_MIN:             2,
   REM_SEC:             3,
   FLOW:                4,
   O3:                  5,
   DOSE:                6,
   VOLUME:              7,
   PRESSURE:            8,
   ATM_PRESS:           9,
   TEMP:               10,
   REM_VAC_TIME:       11,
   REM_PROT_TIME:      12,
   MAX_AVAILABLE_FLOW: 13,
   AUTOHEMO_CYCLES:    14,
   WASHING_TIME:       15,
   WASHING_SEC:        16,
   OVERPRESS_ST:       17,
   INSUF_ST:           18,
   GENERATION_TIME:    19
}

function manageGetData(data){
    updateLast(data)
    const cmdArgs = data.split(",")

    manageFsmState(parseInt(cmdArgs[rOffset.STATE], 16), parseInt(cmdArgs[rOffset.ERROR], 16))
    manageError(parseInt(cmdArgs[rOffset.STATE], 16), parseInt(cmdArgs[rOffset.ERROR], 16))
    manageRemainigTime(parseInt(cmdArgs[rOffset.REM_MIN], 16), parseInt(cmdArgs[rOffset.REM_SEC], 16))
    manageDose(parseInt(cmdArgs[rOffset.DOSE], 16))
    manageVolume(parseInt(cmdArgs[rOffset.VOLUME], 16))
    managePressure(parseInt(cmdArgs[rOffset.PRESSURE], 16), parseInt(cmdArgs[rOffset.ATM_PRESS], 16))
    manageAtmPressure(parseInt(cmdArgs[rOffset.ATM_PRESS], 16))
    manageTemperature(parseInt(cmdArgs[rOffset.TEMP], 16))
    manageRemainigVacuumTime(parseInt(cmdArgs[rOffset.REM_VAC_TIME], 16))
    manageRemainigProtocolTime(parseInt(cmdArgs[rOffset.REM_PROT_TIME], 16))
    manageInsufflationState(parseInt(cmdArgs[rOffset.INSUF_ST], 16))
    manageGenerationTime(parseInt(cmdArgs[rOffset.GENERATION_TIME], 16)) //  Azure Bug 10444: (SDV) Generation time always set to 01:01:01, (13/09/2024)
}

function manageText(data){
    /* regarding to start up information */
    var pos = data.indexOf("#", data)

    if(pos > -1){
//      startUp.text += "<p1 style=\"font-size:19px; color:#AAAAAA\">" + data.substring(pos + 1) + "</p1>" // +
//      startUp.addInfo("<p1 style=\"font-size:19px; color:#AAAAAA\">" + data.substring(pos + 1) + "</p1>")
        startUp.addInfo(data.substring(pos + 1))
        configArea.deviceInfo.appendStartUpInfo(data.substring(pos + 1) + "<br>")
    }

    pos = data.indexOf("Direct O3", data)
    if(pos > -1){
        if(stateMachine.currentState === "startUpStarting"){ // avoid contamine start up log when generating
            configArea.deviceInfo.appendStartUpInfo(data.substring(pos).replace(" (ref 400)", "") + "<br>")
        }
    }

    lookForMaxAvailableFlow(data)

    /* regarding to calibration process information */
    if(stateMachine.currentState === "configO3"){
        pos = data.indexOf("O3 sensor OK", data)
        if(pos > -1){
            console.log("O3 sensor ready detected during calibration stage...")
            configArea.deviceCalibration.o3SensorReady()
        }
        pos = data.indexOf("O3 calibration (P1) end", data)
        if(pos > -1){
            console.log("O3 calibration point 1 done...")
            configArea.deviceCalibration.changeActiveCalibrationCardWaitingMode(false)
        }
    }
}

function manageParameters(data){
    const dataArgs = data.split(",")

    configArea.deviceInfo.refreshParametersInfo("Calibration pressure: " + parseInt(dataArgs[0],  16) + "<br>")
    configArea.deviceInfo.appendParametersInfo ("Ini period: " +           parseInt(dataArgs[2],  16) + "<br>")
    configArea.deviceInfo.appendParametersInfo ("P factor: " +             parseInt(dataArgs[3],  16) + "<br>")
    configArea.deviceInfo.appendParametersInfo ("Flow gain 1: " +          parseInt(dataArgs[4],  16) + "<br>")
    configArea.deviceInfo.appendParametersInfo ("Flow gain 2: " +          parseInt(dataArgs[5],  16) + "<br>")
    configArea.deviceInfo.appendParametersInfo ("Flow gain 3: " +          parseInt(dataArgs[6],  16) + "<br>")
    configArea.deviceInfo.appendParametersInfo ("O3 sensor gain: " +       parseInt(dataArgs[1],  16) + "<br>")
    configArea.deviceInfo.appendParametersInfo ("O3 1 pulses: " +          parseInt(dataArgs[7],  16) + "<br>")
    configArea.deviceInfo.appendParametersInfo ("O3 sec 1 pulses: " +      parseInt(dataArgs[8],  16) + "<br>")
    configArea.deviceInfo.appendParametersInfo ("O3 sec 2 pulses: " +      parseInt(dataArgs[9],  16) + "<br>")
    configArea.deviceInfo.appendParametersInfo ("O3 sec 3 pulses: " +      parseInt(dataArgs[10], 16) + "<br>")
    configArea.deviceInfo.appendParametersInfo ("O3 generation mode: " +   parseInt(dataArgs[11], 16) + "<br>")

    configArea.deviceCalibration.generationMode.update(parseInt(dataArgs[11], 16) ? true : false)
}
function manageVersions(data){
    const dataArgs = data.split(",")

    dataArgs[0] += "_" // in the case no '_x' included in version name
    dataArgs[1] += "_"
    configArea.deviceInfo.interfaceVersion = dataArgs[0].substring(dataArgs[0].indexOf(":") + 1, dataArgs[0].indexOf("_"))
    configArea.deviceInfo.controlVersion = dataArgs[1].substring(dataArgs[1].indexOf(":") + 1, dataArgs[1].indexOf("_"))
}

const fsmStates = {
    STATE_INIT:                         0,
    STATE_ERROR:                        1,
    STATE_INIT_CHECK_1:                 2,
    STATE_INIT_CHECK_2:                 3,
    STATE_INIT_CHECK_3:                 4,
    STATE_MAIN_MENU:                    5,
    STATE_O3_SELECTION:                 6,
    STATE_FLOW_SELECTION:               7,
    STATE_TIME_SELECTION:               8,
    STATE_DOSE_SELECTION:               9,
    STATE_THERAPY_TIME_SELECTION:      10,
    STATE_VACUUM_SELECTION:            11,
    STATE_VOLUME_SELECTION:            12,
    STATE_VACUUM_GENERATING:           13,
    STATE_VACUUM_COMPLETED:            14,
    STATE_VACUUM_PAUSED:               15,
    STATE_VACUUM_CANCELLED:            16,
    STATE_ADJUSTING:                   17,
    STATE_O3_GENERATING:               18,
    STATE_USER_CANCELLED:              19,
    STATE_COMPLETED:                   20,
    STATE_MANUAL_COMPLETED:            21,
    STATE_WAITING_THERAPY_TIME:        22,
    STATE_WAITING_AUTOHEMO_RESTART:    23,
    STATE_OVERPRESSURE:                24,
    STATE_MANUAL_OVERPRESSURE_1:       25,
    STATE_MANUAL_OVERPRESSURE_2:       26,
    STATE_SERVICE_MENU:                27,
    STATE_SHOW_SW_VERSIONS:            28,
    STATE_SHOW_TEMP_PRESS:             29,
    STATE_CONTRAST_ADJUST:             30,
    STATE_BRIGHTNESS_ADJUST:           31,
    STATE_LANGUAGE_MENU:               32,
    STATE_PASSWORD_FIRST:              33,
    STATE_PASSWORD_SECOND:             34,
    STATE_PASSWORD_THIRD:              35,
    STATE_PASSWORD_FOURTH:             36,
    STATE_PASSWORD_FIFTH:              37,
    STATE_PASSWORD_SIXTH:              38,
    STATE_CALIBRATION_MENU:            39,
    STATE_SELECT_REF_PRESS_1:          40,
    STATE_SELECT_REF_PRESS_2:          41,
    STATE_SELECT_FLOW_REFS_1:          42,
    STATE_SELECT_FLOW_REFS_1B:         43,
    STATE_SELECT_FLOW_REFS_2:          44,
    STATE_SELECT_FLOW_REFS_2B:         45,
    STATE_SELECT_FLOW_REFS_3:          46,
    STATE_SELECT_FLOW_REFS_3B:         47,
    STATE_SELECT_O3_REFS_1:            48,
    STATE_SELECT_O3_REFS_2:            49,
    STATE_SELECT_O3_REFS_3:            50,
    STATE_SELECT_O3_REFS_4:            51,
    STATE_SELECT_PRESS_COMP_FACTOR:    52,
    STATE_SELECT_BASE_WIDTH:           53,
    STATE_SELECT_FLOW_COMP_FOR_PULSES: 54,
    STATE_CALIBRATE_PERIOD:            55,
    STATE_SAVING_PARAMETERS:           56,
    STATE_LOADING_PARAMETERS:          57,
    STATE_SHOWING_PARAMETERS:          58,
    STATE_WARNING:                     59,
    STATE_WASHING:                     60,
    STATE_MANUAL_MODE_TIMEOUT:         61,
    STATE_KEY_MODE_TRANSITION:         62,
    STATE_ADJUST_ZERO_O3_SENSOR_1:     63,
    STATE_ADJUST_ZERO_O3_SENSOR_2:     64,
    STATE_ADJUST_ZERO_O3_SENSOR_3:     65,
    STATE_DEPRESSURING_SYRINGE:        66,
    STATE_GENERATING_FLOW:             67,
    STATE_WAITING_AFTER_START_UP:      68,
    STATE_WARMING_O3_SENSOR:           69,
    STATE_MAX:                         70
}
Object.freeze(fsmStates);
//var appMain.currentFsmState = fsmStates.STATE_MAX // Azure Bug 10432: (SDV) Temperature error persistence.

function manageFsmState(state, error){
    if(appMain.currentFsmState === state)
        return;

    switch(state){
//    case fsmStates.STATE_ERROR:
//        if(stateMachine.currentState === "startUpStarting"){
//            startUp.error()
//        }
//        else if(stateMachine.currentState === "configConnecting"){
//            console.log("Clearing communication error after ble reconecting from configuration menu...")
//            clearError()
//        }
//        else if(stateMachine.currentState === "startUpConnecting"){
//            console.log("Clearing communication error after ble connecting from start up...")
//            clearError()
//        }
//        else{
//            protocolErrorView()
//            fsmSignals.error()
//        }
//        break
    case fsmStates.STATE_ERROR:
        manageErrorState(error)
        break
    case fsmStates.STATE_MAIN_MENU:
        if(stateMachine.currentState === "startUpStarting"){
            startUp.end()
        }
        break
    case fsmStates.STATE_VACUUM_GENERATING:
        protocolVaccumView()
        fsmSignals.vacuum()
        break
    case fsmStates.STATE_VACUUM_COMPLETED:
        protocolEndView()
        fsmSignals.endGeneration()
        break
    case fsmStates.STATE_VACUUM_PAUSED:
        fsmSignals.pauseVac()
        break
    case fsmStates.STATE_VACUUM_CANCELLED:
        protocolCancelView()
        fsmSignals.endGeneration()
        break
    case fsmStates.STATE_ADJUSTING:
        if( (stateMachine.currentState === "end") ||
            (stateMachine.currentState === "gadgetEditing") ){
            fsmSignals.adjusting()
        }
        break
    case fsmStates.STATE_WAITING_THERAPY_TIME:
        protocolWaitingView()
        fsmSignals.waiting()
        break
    case fsmStates.STATE_O3_GENERATING:
        protocolGeneratingView()
        fsmSignals.generating()
        break
    case fsmStates.STATE_COMPLETED:
        protocolEndView()
        fsmSignals.endGeneration()
        break
    case fsmStates.STATE_USER_CANCELLED:
        protocolCancelView()
        fsmSignals.endGeneration()
        break
    case fsmStates.STATE_OVERPRESSURE:
        protocolOverPressureView()
        if(stateMachine.currentState === "gadgetGenerating"){
            fsmSignals.gadgetOverpressure()
        }
        else {
            fsmSignals.error()
        }
        break
    case fsmStates.STATE_ADJUST_ZERO_O3_SENSOR_1:
    case fsmStates.STATE_ADJUST_ZERO_O3_SENSOR_2: // Azure Bug 10488: (SDV) No adjusting image on Closed bag therapy
        fsmSignals.adjusting()
        break
    case fsmStates.STATE_SERVICE_MENU:
        if(stateMachine.currentState === "configPeriod"){
            if(appMain.currentFsmState === fsmStates.STATE_CALIBRATE_PERIOD){ // Bug 7600: Period calibration stops inmediatelly
                configArea.deviceCalibration.calibrationEnd()
            }
        }
        if(stateMachine.currentState === "configLoading"){
            fsmSignals.loadParamEnd(false)
        }
        break
    case fsmStates.STATE_CALIBRATION_MENU:
        if(stateMachine.currentState === "configSaving"){
            fsmSignals.saveParamEnd(false)
        }
        if(stateMachine.currentState === "configO3"){ // Bug 15010: Infinite loop cleaning for O3 calibration
            fsmSignals.configO3end()
        }
        if(stateMachine.currentState === "configLoading"){ // Azure Bug 15206: Load parameters crash
            fsmSignals.loadParamEnd(true)
        }
        break
    }

    appMain.currentFsmState = state
    appMain.fsmStateDbg = state
}

function manageError(state, error){
//  Note: Azure Bug 10477: (SDV) Error id lost during error indication.
//        Refresh error code only for the very first time to avoid error code lost
//        when the error is generated by software instead of from control board status.
//        In this cases error code 0 (no error) sended by control board overwrites the
//        error code generated by software.
    if(state === fsmStates.STATE_ERROR){
        if(startUp.errorCode === ""){
            startUp.errorCode = error
        }
    }
    else{
        startUp.errorCode = ""
    }

    if(state === fsmStates.STATE_ERROR){
//  Note: refresh error only for the very first time to avoid display communication
//        error after the actual error that generates the communication interruption
        if(resultView.buttonText == ""){
//  Note: sometimes error code 0 appears due to 'error varible' management in Soc2BSPP
//        library code during transition to error state, filter it (#7470)
            resultView.buttonText = error ? error : ""
        }
    }
    else{
        resultView.buttonText = ""
    }

}

function manageErrorState(error){
    if( (error === 0) || (error === "") ){
        // Azure Bug 10514: (SDV) Eventual error screen repetition without error code id after error validation
        console.log("Unknown error code, ignoring it...")
        appMain.currentFsmState = fsmStates.STATE_MAX  // force to analise next error notification (if it is the case)
        return
    }

//  Note: since generator's control board enters in communication error state when ble connection fails
//        it returns communication error for the very first time after reconnection. It is necessary to
//        avoid that this error enters in state machine flow.
    switch(stateMachine.currentState){
    case "configEditing":
    case "configConnecting":
    case "configLinking":
    case "startUpConnecting":
    case "startUpConnected":
    case "startUpGhostConnectingSecondAttempt":
        console.log("Clearing communication error after ble reconecting from configuration menu...")
        clearError()
        break
    case "startUpStarting":
//        startUp.skipErrorAllowed = ((error === 4) || (error === 9)) // Azure Bug 10771: (SDV 2) Manage skip error button on start up
        startUp.skipErrorAllowed = ((error === 4) || (error === 9) || (error === 10)) // Azure Bug 10771: (SDV 2) Manage skip error button on start up
        startUp.error()
        break
//    case "configPeriod":
//        configArea.deviceCalibration.calibrationError()
//        break
    default:
        if((commsErrorGuardTimer.running) && (error === 8)){
            console.log("Skipped comms error due to guard timer after returning to active mode...")
            consoleSocket.sendData("{CNL_SIM\r");
            fsmSignals.returnToActive()
        }
        else{
            protocolErrorView()
            fsmSignals.error()
        }
        break
    }
}

function manageDose(dose){
    progressView.updateProgress("dose", dose)
}

function manageVolume(volume){
    progressView.updateProgress("volume", volume)
}

function manageRemainigTime(min, sec){
    if(appMain.currentFsmState !== fsmStates.STATE_WAITING_THERAPY_TIME){
        progressView.updateAltProgress("time_m", min.toString().padStart(2, '0') + ":" + sec.toString().padStart(2, '0'))
        progressView.updateProgress("time_m", (min * 60) + sec)
        pressureGadget.upadateProgress((min * 60) + sec)
    }
}

function manageRemainigProtocolTime(sec){
    if(appMain.currentFsmState === fsmStates.STATE_WAITING_THERAPY_TIME){
        var rem_m = Math.trunc(sec / 60)
        var rem_s = sec - rem_m * 60
        progressView.updateAltProgress("time_m", rem_m.toString().padStart(2, '0') + ":" + rem_s.toString().padStart(2, '0'))
        progressView.updateProgress("time_m", sec)
    }
}

function manageGenerationTime(sec){ //  Azure Bug 10444: (SDV) Generation time always set to 01:01:01, (13/09/2024)
    generationTime = sec;
}

function manageAtmPressure(press){
}

function managePressure(press, atmPress){
    var press_psi = p2imp(press).toFixed(1)
    // update pressure metter
    pressureMetter.value = press - atmPress

    // update progress pressure
    progressView.updateAltProgress("pressure", (systemUnits === "imperial") ? p2imp(press - atmPress).toFixed(1) : press - atmPress)
    progressView.updateProgress("pressure", atmPress - press)

    // update advertising
    advertising.pressure = (systemUnits === "imperial") ? ( "P: " + press_psi + " psi" ) : ( "P: " + press + " mbar" )

    // update pressure gadget
    pressureGadget.pressure = press - atmPress

    // update pressure at configuration interface
    configArea.deviceInfo.pressure = (systemUnits === "imperial") ? ( press_psi + " psi" ) : ( press + " mbar" )

    appMain.pressAtmDbg = atmPress

    configArea.deviceCalibration.pressureCalibratrionSettings["step_1"].defValue = press // Azure Bug 10431: (SDV) Pressure calibration menu improvement.
}

function manageTemperature(temp){
    var temp_c = (temp / 128).toFixed(1)
    var temp_f = t2imp((temp / 128)).toFixed(1)
    // update advertising
    advertising.temperature = (systemUnits === "imperial") ? ( "T: " + temp_f + " ºF" ) : ( "T: " + temp_c + " ºC" )
    // update pressure at configuration interface
    configArea.deviceInfo.temperature = (systemUnits === "imperial") ? ( temp_f + " ºF" ) : ( temp_c + " ºC" )
}

function manageRemainigVacuumTime(sec){
    progressView.updateProgress("time_s", sec)
}

function manageInsufflationState(state){
    if( (protocolSelector.currentProtocol === Const.protocol.rectal_insufflation) ||
        (protocolSelector.currentProtocol === Const.protocol.vaginal_insufflation) ) {
        if (state === 0)
            fsmSignals.pause()
        else
            fsmSignals.play()
    }
}

function startConnection(device, index){
    var name = ""
    var mac = ""

    if(device.indexOf("_,_") > -1){
        name = device.substr(0, device.indexOf("_,_"))
        mac = device.substr(device.indexOf("_,_") + "_,_".length)
    }

//  Include some clues in debug traces
    name = name.length ? name : "No BLE"
    mac = mac.length ? mac : "00:00:00:00:00:00"

    console.log("name:", name)
    console.log("MAC: ", mac)

//  consoleSocket.sendData("{SERIAL_SET_NAME," + "RN4870-55C3" + "\r")
//  consoleSocket.sendData("{SERIAL_SET_ADD," + "E8:EB:1B:99:55:C3" + "\r")

//  consoleSocket.sendData("{SERIAL_SET_NAME," + "RN4870-A82B" + "\r")
//  consoleSocket.sendData("{SERIAL_SET_ADD," + "E8:EB:1B:9A:A8:2B" + "\r")

    consoleSocket.sendData("{SERIAL_SET_NAME," + name +"\r")
    consoleSocket.sendData("{SERIAL_SET_ADD," + mac + "\r")
    consoleSocket.sendData("{SERIAL_BOOT\r")
}

let protocolCmd = [
        { id: Const.protocol.syringe_auto,         cmd: "{SYRSTR",   press:  700 }, // TODO: define pressure values on external DB
        { id: Const.protocol.manual_syringe,       cmd: "{MANSTR",   press:  300 }, // Azure Bug 10490: (SDV) Error 4 during manual syringe filling (Overpressure limit 300 mbar @ 10-40 ml)
        { id: Const.protocol.continuous,           cmd: "{O3STR",    press:  700 },
        { id: Const.protocol.open_bag,             cmd: "{OBAGSTR",  press:  200 },
        { id: Const.protocol.closed_bag,           cmd: "{CBAGSTR",  press:  200 },
        { id: Const.protocol.vaginal_insufflation, cmd: "{INSSTR_V", press:  200 },
        { id: Const.protocol.rectal_insufflation,  cmd: "{INSSTR_R", press:  200 },
        { id: Const.protocol.dose,                 cmd: "{DOSESTR",  press:  700 },
        { id: Const.protocol.vacuum_time,          cmd: "{TVACSTR",  press: -800 },
        { id: Const.protocol.vacuum_pressure,      cmd: "{PVACSTR",  press: -800 },
    ]

function startClicked(){

    if(stateMachine.currentState === "protocolEditing"){
        startProtocol()
//      SP.protocolGeneratingView()

    }
    else{
        if( ! ((protocolSelector.currentProtocol === Const.protocol.manual_syringe) && (stateMachine.currentState === "generating"))){  // Azure Bug 10489: (SDV) Simple play buton touch on manual syringe starts generating
            consoleSocket.sendData("{ENT_SIM\r")
        }
    }
}

function pressAndHoldClicked(){ // Azure Bug 10489: (SDV) Simple play buton touch on manual syringe starts generating
    if( ((protocolSelector.currentProtocol === Const.protocol.manual_syringe) && (stateMachine.currentState === "generating"))){
        consoleSocket.sendData("{ENT_SIM\r")
    }
}

//function startProtocol(){
//    var cmdStr
//    var imputSplit = inputSelector.values().split(",")

//    let res = protocolCmd.find(item => item.id === Const.protocol.closed_bag)
//    console.log("chhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhn:", res.cmd)

//    if (protocolSelector.currentProtocol === Const.protocol.closed_bag){
//        cmdStr = protocolCmd[Const.protocol.closed_bag].cmd + "," + imputSplit[1] + "," + imputSplit[3] + "," + imputSplit[0] + "," + imputSplit[2]
//    }
//    else{
//        protocolCmd.forEach( item => { if( item.id === protocolSelector.currentProtocol ) cmdStr = item.cmd + "," + inputSelector.values() } )
//    }

//    if(!(!!cmdStr)){
//        console.log("Protocol command not available...")
//        return
//    }

//    switch (protocolSelector.currentProtocol){
//    case Const.protocol.continuous: cmdStr += "," +  "0" ; break // TODO: define these values on external DB
//    case Const.protocol.dose:       cmdStr += "," + "30" ; break
//    }

//    protocolCmd.forEach( item => { if( item.id === protocolSelector.currentProtocol ) cmdStr += "," + item.press + "\r" } )

//    consoleSocket.sendData(cmdStr)
//    consoleSocket.sendData("{SET_P_INFO," + "100" + "\r")

//    console.log("Starting", protocolSelector.currentProtocol, "protocol ->", cmdStr)
//}


// refactor to a big switch
function startProtocol(){
    let cmdStr
    let imputSplit = inputSelector.values().split(",")
    let elementList = protocolCmd.find(item => item.id === protocolSelector.currentProtocol)

    if(elementList === undefined){
        console.log("Protocol command not available...")
        return
    }
    cmdStr = elementList.cmd + ","

    switch (protocolSelector.currentProtocol){
    case Const.protocol.syringe_auto:    cmdStr += imputSplit[0] + "," + DB.dbStorage_Get("syringe_auto_flow"); break
    case Const.protocol.closed_bag:      cmdStr += imputSplit[1] + "," + imputSplit[3] + "," + imputSplit[0] + "," + (imputSplit[2] * 1000); break
    case Const.protocol.vacuum_pressure: cmdStr += DB.dbStorage_Get("vacuum_pressure_time") + "," + ( (systemUnits === "imperial") ? p2int(imputSplit[0]).toFixed(1) : imputSplit[0] ); break
    default: cmdStr += inputSelector.values()
    }

    switch (protocolSelector.currentProtocol){
    case Const.protocol.continuous: cmdStr += "," +  DB.dbStorage_Get("continuous_clean_time"); break
    case Const.protocol.dose:       cmdStr += "," + DB.dbStorage_Get("dose_flow"); break
    }

//  cmdStr += (elementList.id !== Const.protocol.vacuum_pressure) ? "," + elementList.press + "\r" : "\r"
    cmdStr += ((elementList.id !== Const.protocol.syringe_auto)&&(elementList.id !== Const.protocol.vacuum_pressure)) ? "," + elementList.press + "\r" : "\r"

    consoleSocket.sendData(cmdStr)
    consoleSocket.sendData("{SET_P_INFO," + "100" + "\r")

    console.log("Starting", protocolSelector.currentProtocol, "protocol ->", cmdStr)
}

function startPressureGadget(flow){
    let elementList = protocolCmd.find(item => item.id === protocolSelector.currentProtocol)

    if(elementList === undefined){
        console.log("Protocol command not available...")
        return
    }
//  consoleSocket.sendData("{O3STR,0," + flow + ",1,0,700\r")
//  consoleSocket.sendData("{O3STR,0," + flow + ",1,0," + elementList.press + "\r")
    consoleSocket.sendData("{O3STR,0," + flow + "," + pressureGadget.testTime + ",0," + elementList.press + "\r")
    console.log("Starting pressure gadget at", flow, "l/h,", elementList.press, "mbar")
}

function stopProtocol(){
    consoleSocket.sendData("{CNL_SIM\r")
}

function pauseProtocol(){
    consoleSocket.sendData("{ENT_SIM\r")
}

function clearError(){
    consoleSocket.sendData("{CNL_SIM\r")
    appMain.currentFsmState = fsmStates.STATE_MAX // force to analise next error notification (in the case error persists, like
                                                  // temperature error: the user cancels error but the temperature is still high)
                                                  // Azure Bug 10514: (SDV) Eventual error screen repetition without error code id after error validation
}

function protocolGeneratingView(){
    var limitPress
    var concent
    var flow
    var time
    var dose
    var vol
    const protVal = inputSelector.values().split(",")

    progressView.clearProgress()

    switch(protocolSelector.currentProtocol){
    case Const.protocol.syringe_auto:
        progressView.showProgress("gosth_1")
        progressView.showProgress("gosth_0")
        break
    case Const.protocol.manual_syringe:
        progressView.showProgress("gosth_1")
        progressView.showProgress("gosth_0")
        break
    case Const.protocol.continuous:
        concent = protVal[0]
        flow = protVal[1]
        time = protVal[2]
        dose = Math.round(concent * time * (flow * 1000 / 60))

        progressView.showProgress("dose",   0, dose)
        progressView.showProgress("time_m", 0, time * 60)
        progressView.showProgress("gosth_0")
        break
    case Const.protocol.open_bag:
        concent = protVal[0]
        flow = protVal[1]
        time = protVal[2]
        dose = Math.round(concent * time * (flow * 1000 / 60))
        vol  = Math.round(time * (flow * 1000 / 60))

        progressView.showProgress("dose",   0, dose)
        progressView.showProgress("volume", 0, vol)
        progressView.showProgress("time_m", 0, time * 60)
        progressView.showProgress("gosth_0")
        break
    case Const.protocol.closed_bag:
        concent = protVal[1]
        vol  = protVal[2] * 1000
        dose = concent * vol

        progressView.showProgress("dose",   0, dose)
        progressView.showProgress("volume", 0, vol)
        progressView.showProgress("gosth_0")
        break
    case Const.protocol.vaginal_insufflation:
         time = protVal[2]

         progressView.showProgress("time_m", 0, parseInt(time))
         progressView.showProgress("gosth_0")
         break
    case Const.protocol.rectal_insufflation:
         vol = protVal[2]

         progressView.showProgress("volume", 0, parseInt(vol))
         progressView.showProgress("gosth_0")
         break
    case Const.protocol.dose:
        dose = protVal[1]
        progressView.showProgress("dose", 0, parseInt(dose))
        progressView.showProgress("gosth_0")
        break
//  case Const.protocol.vacuum_time:
//  case Const.protocol.vacuum_pressure:
    }

    protocolCmd.forEach( item => { if( item.id === protocolSelector.currentProtocol ) limitPress = item.press } )
    pressureMetter.from = -limitPress * 0.55
    pressureMetter.to = limitPress * 1.12
    pressureMetter.reset(0)
}

function protocolVaccumView(){
    var limitPress
    var vacTime
    var press
    const protVal = inputSelector.values().split(",")

    progressView.clearProgress()

    switch(protocolSelector.currentProtocol){
    case Const.protocol.open_bag:
        vacTime = protVal[3]
        progressView.showProgress("time_s", 0, parseInt(vacTime))
        progressView.showProgress("gosth_0")
        break
    case Const.protocol.closed_bag:
        vacTime = protVal[0]
        progressView.showProgress("time_s", 0, parseInt(vacTime))
        progressView.showProgress("gosth_0")
        break
    case Const.protocol.vacuum_time:
        vacTime = protVal[0]
        progressView.showProgress("time_s", 0, parseInt(vacTime))
        break
    case Const.protocol.vacuum_pressure:
        press = parseInt(protVal[0]) * -1
        progressView.showProgress("pressure", 0, (systemUnits === "imperial") ? p2int(press).toFixed(1) : press)
        break
    }

    protocolCmd.forEach( item => { if( item.id === protocolSelector.currentProtocol ) limitPress = item.press } )
    pressureMetter.from = -limitPress * 0.55
    pressureMetter.to = limitPress * 1.12
    pressureMetter.reset(0)
}

function protocolWaitingView(){
    var limitPress
    var waitingTime
    const protVal = inputSelector.values().split(",")

    progressView.clearProgress()

    switch(protocolSelector.currentProtocol){
//    case Const.protocol.syringe_auto:
//    case Const.protocol.manual_syringe:
//    case Const.protocol.continuous:
//  case Const.protocol.open_bag:
    case Const.protocol.closed_bag:
        waitingTime = protVal[3]
        progressView.showProgress("time_m", 0, waitingTime * 60)
        progressView.showProgress("gosth_0")
        break
//    case Const.protocol.vaginal_insufflation:
//    case Const.protocol.rectal_insufflation:
//    case Const.protocol.dose:
//    case Const.protocol.vacuum_time:
//    case Const.protocol.vacuum_pressure:
    }

    protocolCmd.forEach( item => { if( item.id === protocolSelector.currentProtocol ) limitPress = item.press } )
    pressureMetter.from = -limitPress * 0.55
    pressureMetter.to = limitPress * 1.12
    pressureMetter.reset(0)
}

function elapsedTime(target_m, target_s, rem_m, rem_s){
    var total_s = (target_m * 60 + target_s) - (rem_m * 60 + rem_s)
    var elapsed_m = Math.trunc(total_s / 60)
    var elapsed_s = total_s - elapsed_m * 60
    return elapsed_m.toString().padStart(2, '0') + ":" + elapsed_s.toString().padStart(2, '0')
}
function addResultView(){
    const protVal = inputSelector.values().split(",")

    switch(protocolSelector.currentProtocol){
    case Const.protocol.syringe_auto:
        resultView.addResult(parseInt(last.dose, 16).toString(), "ug", "deepskyblue")
        break
    case Const.protocol.open_bag:
        resultView.addResult(parseInt(last.dose, 16).toString(), "ug", "deepskyblue")
        resultView.addResult(parseInt(last.volume, 16).toString(), "ml", "forestgreen")
        resultView.addResult(elapsedTime(protVal[2], 0, parseInt(last.rem_min, 16), parseInt(last.rem_sec, 16)), " ", "gold")
        break
    case Const.protocol.closed_bag:
        resultView.addResult(parseInt(last.dose, 16).toString(), "ug", "deepskyblue")
        resultView.addResult(parseInt(last.volume, 16).toString(), "ml", "forestgreen")
        break
    case Const.protocol.continuous:
        resultView.addResult(parseInt(last.dose, 16).toString(), "ug", "deepskyblue")
        resultView.addResult(parseInt(last.volume, 16).toString(), "ml", "forestgreen")
        break
    case Const.protocol.vaginal_insufflation:
        resultView.addResult(parseInt(last.dose, 16).toString(), "ug", "deepskyblue")
        resultView.addResult(elapsedTime(protVal[2], 0, parseInt(last.rem_min, 16), parseInt(last.rem_sec, 16)), " ", "gold")
        break
    case Const.protocol.rectal_insufflation:
        resultView.addResult(parseInt(last.dose, 16).toString(), "ug", "deepskyblue")
        resultView.addResult(parseInt(last.volume, 16).toString(), "ml", "forestgreen")
        break
    case Const.protocol.dose:
        resultView.addResult(parseInt(last.dose, 16).toString(), "ug", "deepskyblue")
        break
    case Const.protocol.vacuum_time:
        resultView.addResult( ( parseInt(protVal[0]) - parseInt(last.rem_vac_time, 16) ).toString(), "sec", "gold" )
        break
    }

//  resultView.addResult("12:03", "min", "darkgoldenrod")
//  resultView.addResult("968","mbar", "indianred")
}

function protocolEndView(){
    consoleSocket.sendData("{SET_P_INFO," + "1000" + "\r")

    resultView.clearResults()
    resultView.buttonColor = "green"
    resultView.buttonImage = "Images/outline_check_circle_white_48.png"
    addResultView()
    configArea.deviceInfo.workingTime = configArea.deviceInfo.workingTime + generationTime //  Azure Bug 10444: (SDV) Generation time always set to 01:01:01, (13/09/2024)
}

function protocolCancelView(){
    consoleSocket.sendData("{SET_P_INFO," + "1000" + "\r")

    resultView.clearResults()
    resultView.buttonColor = "tomato"
    resultView.buttonImage = "Images/outline_cancel_white_48.png"

    if(protocolSelector.currentProtocol !== Const.protocol.syringe_auto){ // Azure bug 10369: (SDV) Incorrect information during automatic syringe filling cancellation (Exception added 11/09/2024).
        addResultView()
    }
    configArea.deviceInfo.workingTime = configArea.deviceInfo.workingTime + generationTime //  Azure Bug 10444: (SDV) Generation time always set to 01:01:01, (13/09/2024)
}

function protocolErrorView(){
    consoleSocket.sendData("{SET_P_INFO," + "1000" + "\r")

    resultView.clearResults()
    resultView.buttonColor = "orange"
    resultView.buttonImage = "Images/outline_error_outline_white_48.png"
    configArea.deviceInfo.workingTime = configArea.deviceInfo.workingTime + generationTime //  Azure Bug 10444: (SDV) Generation time always set to 01:01:01, (13/09/2024)
}

function protocolOverPressureView(){
    consoleSocket.sendData("{SET_P_INFO," + "1000" + "\r")

    if(stateMachine.currentState !== "gadgetGenerating"){
        resultView.clearResults()
        resultView.buttonColor = "orange"
        resultView.buttonImage = "Images/OverPressure_01.png"
        configArea.deviceInfo.workingTime = configArea.deviceInfo.workingTime + generationTime //  Azure Bug 10444: (SDV) Generation time always set to 01:01:01, (13/09/2024)
    }
}

function showPressureMetterDuringVacuum(){
    if( ( protocolSelector.currentProtocol === Const.protocol.vacuum_time ) ||
        ( protocolSelector.currentProtocol === Const.protocol.vacuum_pressure ) )
        return

    pressureMetter.show()
}

function getProtocolFlow(protocol){
    let flow = 0
    let imputSplit = inputSelector.values().split(",")

    switch (protocol){
    case Const.protocol.continuous:
    case Const.protocol.open_bag:
    case Const.protocol.vaginal_insufflation:
    case Const.protocol.rectal_insufflation:  flow = imputSplit[1]; break
    case Const.protocol.dose:                 flow = DB.dbStorage_Get("dose_flow"); break
    case Const.protocol.closed_bag:           flow = inputSelector.maxAvailableFlow; break
    }
    return flow
}

function getProtocolMinFlow(protocol){
    let flow = 0
    let imputSplit = inputSelector.minValues().split(",")

    switch (protocol){
    case Const.protocol.continuous:
    case Const.protocol.open_bag:
    case Const.protocol.vaginal_insufflation:
    case Const.protocol.rectal_insufflation:  flow = imputSplit[1]; break
    case Const.protocol.dose:                 flow = 1; break
    case Const.protocol.closed_bag:           flow = 1; break // TODO: set max allowed flow here (corrspondigg flow o max allowed flow)
    }

    return flow
}

function getProtocolMaxFlow(protocol){
    let flow = 0
    let imputSplit = inputSelector.maxValues().split(",")

    switch (protocol){
    case Const.protocol.continuous:
    case Const.protocol.open_bag:
    case Const.protocol.vaginal_insufflation:
    case Const.protocol.rectal_insufflation:  flow = imputSplit[1]; break
    case Const.protocol.dose:
    case Const.protocol.closed_bag:           flow = inputSelector.maxAvailableFlow; break
    }

    return flow
}

function configurePressureGadget(){
    let elementList = protocolCmd.find(item => item.id === protocolSelector.currentProtocol)

    if(elementList === undefined){
        console.log("Protocol command not available...")
        return
    }
//////    let imputSplit = inputSelector.values().split(",")

    pressureGadget.configure(-elementList.press * 0.55, elementList.press * 1.12, 0)
}

function lookForMaxAvailableFlow(data){
    var candidate = ""
    var pattern = "available flow:"
    var pos = data.indexOf(pattern, data)

    if(pos > -1){
        pos += pattern.length
        candidate = data.substr(pos).trim()

        if(/^\d+$/.test(candidate)) // check just numbers
            inputSelector.maxAvailableFlow = parseInt(candidate, 10)
    }
}

/*
            id: waitingForProtocol
            id: protocolEditing
            id: protocolEditingParameter
            id: adjusting
            id: generating
            id: pause
            id: end
            id: cancel

*/


//function decodeSocket(data){
//    var index

//    console.log("decodeSocket data: ", data)

//    if ((index = data.indexOf("{SERIAL_ST")) >= 0){
//        index += ("{SERIAL_ST" + ",").length
//        manageSerialStatus(parseInt(data.substring(index, index + 1), 16))
//    }
//    if ((index = data.indexOf("{SERIAL_GET_DISC")) >= 0){
//        index += ("{SERIAL_GET_DISC" + ",").length
//        manageGetDicovered(data.substring(index))
//    }
//    if ((index = data.indexOf("{GETDAT")) >= 0){
//        index += ("{GETDAT" + ",").length
//        manageGetData(data.substring(index))
//    }

//}

//function manageSerialStatus(status){
//    var tmp = !!status ? appMain.bluetoothLinked() : appMain.bluetoothUnlinked()
//    toolBar.connectedIcon = !!status
//    configArea.deviceInfo.bluetoothInfo.state = !configArea.deviceInfo.bluetoothInfo.configPending ? (!!status ? "connected" : "disconnected") : configArea.deviceInfo.bluetoothInfo.state
//    configArea.deviceCalibration.linkGeneratorInfo.linkResult = !!status ? true : configArea.deviceCalibration.linkGeneratorInfo.linkResult
//}


//function manageGetData(data){
//    var index = 0   +3+3+6+3+3+9+9
//    manageAtmPressure(parseInt(data.substring(index, index + 4), 16))
//    index += 5
//    index += 5
//    manageTemperature(parseInt(data.substring(index, index + 4), 16))
//    index += 5
///*

//        manageTerapyState(parseInt(data.substring(index, index + 2), 16), parseInt(data.substring(index + 3, index + 5), 16))
//        index += 3
//        manageErrorState(parseInt(data.substring(index, index + 2), 16))
//        index += 3
//        manageTimeState(parseInt(data.substring(index, index + 2), 16), parseInt(data.substring(index + 3, index + 5), 16))
//        index += 6
//        manageMeanFlowState(parseInt(data.substring(index, index + 2), 16))
//        index += 3
//        manageMeanO3State(parseInt(data.substring(index, index + 2), 16))
//        index += 3
//        manageTotalDoseState(parseInt(data.substring(index, index + 8), 16))
//        index += 9
//        manageOutputVolumeState(parseInt(data.substring(index, index + 8), 16))
//        index += 9
//        managePressureState(parseInt(data.substring(index, index + 4), 16), parseInt(data.substring(index + 5, index + 9), 16))
//        index += 10
//        manageTemperatureState(parseInt(data.substring(index, index + 4), 16))
//        index += 5
//        manageVacuumTimeState(parseInt(data.substring(index, index + 4), 16))
//        index += 5
//        manageTherapyTimeState(parseInt(data.substring(index, index + 4), 16))
//        index += 5
//        manageMaxAvailableFlow(parseInt(data.substring(index, index + 4), 16))
//        index += 5
//        manageAutoHemoCycles(parseInt(data.substring(index, index + 4), 16))
//        index += 5
//        manageConfiguredFlushingTime(parseInt(data.substring(index, index + 4), 16))
//        index += 5
//        manageRemainingFlushingTime(parseInt(data.substring(index, index + 4), 16))
//        index += 5
//        manageOverpressureDuringTherapy(parseInt(data.substring(index, index + 2), 16))
//        index += 3
//        manageInsufflationState(parseInt(data.substring(index, index + 2), 16))
//        index += 3
//*/
//}
