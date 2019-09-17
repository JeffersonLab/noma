## 
##  Absolute basic stuff to use chroma
## 
## ! \file
##  \brief Primary include file for CHROMA library code
## 
##  This is the absolute basic stuff to use Chroma in say
##  library codes.
## 

import
  qdp

##  #include "chroma_config.h"   // turn off by default using config file

nil
##  Extremely basic types

type
  PlusMinus* = enum
    MINUS = -1, PLUS = 1


##  Useful constants

when BASE_PRECISION == 32:
  var fuzz*: Real = 1e-05
elif BASE_PRECISION == 64:
  var fuzz*: Real = 1e-10
var twopi*: Real = 6.283185307179586
