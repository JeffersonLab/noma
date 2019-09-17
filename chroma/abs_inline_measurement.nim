##  -*- C++ -*-
## ! \file
##  \brief Abstract inline measurements
## 

import
  chromabase

## ! \ingroup inline

type
  AbsInlineMeasurement* {.bycopy.} = object ## ! Virtual Destructor
  

proc destroyAbsInlineMeasurement*(this: var AbsInlineMeasurement)
proc getFrequency*(this: AbsInlineMeasurement): culong {.noSideEffect.}
proc `()`*(this: var AbsInlineMeasurement; update_no: culong; xml_out: var XMLWriter)
##  End namespace
