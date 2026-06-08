#pragma once

#include "therapyControl/myTypes.h"
#include "therapyControl/Ozonette_fsm.h"

typedef struct VaccumParameters {
    int vacuumTime, maxVacuumPressure;
    bool pressureControl;
}VaccumParameters;

typedef struct InsuflattionParams {
    int flow, pressThreshold, O3concentration, volume, time;
}InsuflattionParamss;

typedef struct BaggingParams {
     int flow, pressThreshold, O3concentration, volume, time, vacuumTime;
}BaggingParams;

typedef struct salineHemoParams {
    int flow, pressThreshold, time, O3concentration, volume, vacuumTime, maxPressure, therapyTime, maxPressureOnReinfusion;
    int O3Acc;
    int bloodVolume, bottleVolume;
    uint8 autoHemoType, cycles;
    uint8 O3Step[AUTOHEMO_CONCENTRATION_SET_LON];
}salineHemoParams;

typedef struct DoseParams {
    int flow, pressThreshold, O3concentration, volume, dose;
}DoseParams;

typedef struct ManualParams {
    int flow, pressThreshold, O3concentration;
}ManualParams;
