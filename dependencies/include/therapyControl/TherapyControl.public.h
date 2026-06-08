#pragma once

#include "therapyControl/Errors.h"
#ifdef __cplusplus
extern "C" {
#endif

  int ModuleBoot();
  int ModuleShutdown();
  const char *errorDescriptor( OZONETTE_APP_ERRORS index );

#ifdef __cplusplus
}
#endif
