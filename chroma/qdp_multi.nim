##  -*- C++ -*-
## ! @file
##  @brief Multi-dimensional arrays
##  
##  Support for reference semantic multi-dimensional arrays
## 

import
  qdp_config

## ! @defgroup multi  Multi-dimensional arrays
## 
##  Container classes that provide 1D, 2D, 3D and 4D multidimensional
##  array semantics.
## 
##  @{
## 
## ! Container for a multi-dimensional 1D array

type
  multi1d* {.bycopy.}[T] = object ##  Basic cosntructor. Null (0x0) array_pointer, no copymem, no fast memory
                              ## ! Resize for most types
  

proc constructmulti1d*[T](): multi1d[T] {.constructor.}
proc constructmulti1d*[T](f: ptr T; ns1: cint): multi1d[T] {.constructor.}
proc constructmulti1d*[T](ns1: cint): multi1d[T] {.constructor.}
proc destroymulti1d*[T](this: var multi1d[T])
proc constructmulti1d*[T](s: multi1d): multi1d[T] {.constructor.}
proc resize*[T](this: var multi1d[T]; ns1: cint)
proc size*[T](this: multi1d[T]): cint {.noSideEffect.}
proc size1*[T](this: multi1d[T]): cint {.noSideEffect.}
proc `+=`*[T](this: var multi1d[T]; s1: multi1d[T])
proc `+=`*[T](this: var multi1d[T]; s1: T)
proc `-=`*[T](this: var multi1d[T]; s1: multi1d[T])
proc `-=`*[T](this: var multi1d[T]; s1: T)
proc `*=`*[T](this: var multi1d[T]; s1: multi1d[T])
proc `*=`*[T](this: var multi1d[T]; s1: T)
proc `/=`*[T](this: var multi1d[T]; s1: multi1d[T])
proc `/=`*[T](this: var multi1d[T]; s1: T)
proc slice*[T](this: multi1d[T]): ptr T {.noSideEffect.}
proc `()`*[T](this: var multi1d[T]; i: cint): var T
proc `()`*[T](this: multi1d[T]; i: cint): T {.noSideEffect.}
proc `[]`*[T](this: var multi1d[T]; i: cint): var T
proc `[]`*[T](this: multi1d[T]; i: cint): T {.noSideEffect.}
proc moveToFastMemoryHint*[T](this: var multi1d[T]; copy: bool = false)
proc revertFromFastMemoryHint*[T](this: var multi1d[T]; copy: bool = false)