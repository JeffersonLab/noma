## The Nim implementation of the Chroma Lattice Field Tgheory library
## 
## The [serializetools](https://github.com/JeffersonLab/serializetools) module provides 
## tools for serialization and deserialization of keys and values to/from strings.
## 


import os, system
import 
  serializetools/serializebin, serializetools/serialstring

# Snarf build params from chroma-config
#from strutils import strip

#{.passC: "-I" & strip(staticExec("nimble path niledb")) & "/filehash" .}
#{.passL: strip(staticExec("nimble path niledb")) & "/filehash/libfilehash.a" .}

#{.passC: "-I" & strip(staticExec("pwd")) & "/filehash" .}
#{.passL: strip(staticExec("pwd")) & "/filehash/libfilehash.a" .}

const chroma_path = "/usr/local/Cellar/chroma/scalar"
const chroma_config   = chroma_path & "/bin/chroma-config"
const chroma_cxxflags = gorge(chroma_config & " --cxxflags")
const chroma_ldflags  = gorge(chroma_config & " --ldflags")
const chroma_libs     = gorge(chroma_config & " --libs")
const chroma_include  = chroma_path & "/include"

const qdp_path        = "/usr/local/Cellar/qdp++/scalar-Nd4"
const qdp_include     = qdp_path & "/include"

echo "\n\n\n"
echo "chroma_config= ", chroma_config
echo "cxxflags= ", chroma_cxxflags
echo "ldflags= ", chroma_ldflags
echo "libs= ", chroma_libs

#{.passC: gorge(chroma_path & "/chroma-config --cxxflags")}
#{.passL: gorge(chroma_path & "/chroma-config --libs")}

{.passC: chroma_cxxflags .}
{.passL: chroma_ldflags & " " & chroma_libs .}


proc callChroma*(fred: string): string =
  ## Bogus
  ##
  return "hello"


#------------------------------
type
  multi1d* {.header: qdp_include & "/qdp_multi.h", importcpp: "QDP::multi1d".} [T] = object

#proc constructmulti1d*[T](): multi1d[T] {. constructor, importcpp: "QDP::multi1d<T>(@)", header: qdp_include & "/qdp_multi.h".}
#proc constructmulti1d*[T](f: ptr T; ns1: cint): multi1d[T] {.constructor, importcpp: "QDP::multi1d<T>(@)", header: qdp_include & "/qdp_multi.h".}
proc constructmulti1d*[T](ns1: cint): multi1d[T] {.constructor, importcpp: "QDP::multi1d<'*0>(@)", header: qdp_include & "/qdp_multi.h".}
#proc destroymulti1d*[T](this: var multi1d[T]) {.importcpp: "#.~QDP::multi1d<T>()", header: qdp_include & "/qdp_multi.h".}
#proc constructmulti1d*[T](s: multi1d): multi1d[T] {.constructor, importcpp: "QDP::multi1d<T>(@)", header: qdp_include & "/qdp_multi.h".}
proc resize*[T](this: var multi1d[T]; ns1: cint) {.importcpp: "#.resize(@)", header: qdp_include & "/qdp_multi.h".}
proc size*[T](this: multi1d[T]): cint {.noSideEffect, importcpp: "#.size(@)", header: qdp_include & "/qdp_multi.h".}

proc `[]=`*[T](this: var multi1d[T]; i, j: cint) {.importcpp: "#[#] = #", header: qdp_include & "/qdp_multi.h".}
proc `[]`*[T](this: multi1d[T]; i: cint): T {.noSideEffect, importcpp: "#[#]", header: qdp_include & "/qdp_multi.h".}

#------------------------------
# Streams
type
  cppstring* {.header: "<string>", importcpp: "std::string".} = object
  istream* {.header: "<istream>", importcpp: "std::istream".} = object
  istringstream* {.header: "<sstream>", importcpp: "std::istringstream".} = object

proc constructCppString*(foo: string): cppstring {.constructor, importcpp: "std::string(@)", header: "<string>".}
proc constructStringStream*(foo: cstring): istringstream {.constructor, importcpp: "std::istringstream(@)", header: "<sstream>"}


#------------------------------
# XML support
type
  XMLReader* {.header: qdp_include & "/qdp_xmlio.h", importcpp: "QDP::XMLReader".} = object
  XMLWriter* {.header: qdp_include & "/qdp_xmlio.h", importcpp: "QDP::XMLWriter".} = object
  XMLFileWriter* {.header: qdp_include & "/qdp_xmlio.h", importcpp: "QDP::XMLBufferWriter".} = object
  XMLBufferWriter* {.header: qdp_include & "/qdp_xmlio.h", importcpp: "QDP::XMLBufferWriter".} = object

proc constructXMLReader*(foo: XMLReader): XMLReader {.constructor, importcpp: "QDP::XMLReader(@)", header: qdp_include & "/qdp_xmlio.h".}
proc constructXMLReader*(foo: istringstream): XMLReader {.constructor, importcpp: "QDP::XMLReader(@)", header: qdp_include & "/qdp_xmlio.h".}
proc openXMLReader*(this: XMLReader, foo: istringstream) {.importcpp: "#.open(@)", header: qdp_include & "/qdp_xmlio.h".}

                   
#---------------------------------------------------------------------------------------------
# QDP++ support
proc QDPLayoutSetLattSize*(nrow: multi1d[cint]) {.header: qdp_include & "/qdp_layout.h", importcpp: "QDP::Layout::setLattSize(@)".}
  # Call the QDP layout for the given lattice size

proc QDPLayoutSetLattSize*(nrow: openArray[int]) =
  # Call the QDP layout for the given lattice size
  var jrow = constructmulti1d[cint](cint(nrow.len))
  var kk: cint = 0
  for k in items(nrow):
    jrow[kk] = cint(k)
    inc(kk)
  QDPLayoutSetLattSize(jrow)

proc QDPLayoutSetLattSize*(nrow: seq[int]) =
  # Call the QDP layout for the given lattice size
  var jrow = constructmulti1d[cint](cint(nrow.len))
  var kk: cint = 0
  for k in items(nrow):
    jrow[kk] = cint(k)
    inc(kk)
  QDPLayoutSetLattSize(jrow)


proc QDPLayoutCreate*() {.header: qdp_include & "/qdp_layout.h", importcpp: "QDP::Layout::create(@)".}

#---------------------------------------------------------------------------------------------
# Chroma support
type
  AbsInlineMeasurement* {.header: chroma_include & "/meas/inline/abs_inline_measurement.h", importcpp: "Chroma::AbsInlineMeasurement".} = object

proc ChromaAbsInlineMeas*(this: AbsInlineMeasurement; update_no: int; xml_out: var XMLBufferWriter) {.header: chroma_include & "/meas/inline/abs_inline_measurement.h", importcpp: "#.operator()(@)".}
                    
proc ChromaInitialize*(argc:ptr cint; argv:ptr cstringArray) {.header: chroma_include & "/init/chroma_init.h", importcpp: "Chroma::initialize(@)".}
                    
proc ChromaInitialize*() =
  echo "arg-ness"
  var argc {.importc: "cmdCount", global.}: cint
  var argv {.importc: "cmdLine", global.}: cstringArray

  echo "Initialize chroma"
  ChromaInitialize(argc.addr, argv.addr)

                    
proc ChromaFinalize*() {.header: chroma_include & "/init/chroma_init.h", importcpp: "Chroma::finalize(@)".}
                    
proc ChromaRegisterInlineAggregate*(): bool {.header: chroma_include & "/meas/inline/inline_aggregate.h", importcpp: "Chroma::InlineAggregateEnv::registerAll(@)".}

proc ChromaReadInlineMeas*(xml: XMLReader, path: cstring): ptr AbsInlineMeasurement {.header: chroma_include & "/io/inline_io.h", importcpp: "Chroma::readInlineMeasurement(@)".}

proc linkageHack*(): bool =
  var foo: bool = true

  # Inline Measurements
  echo "call link"
  foo = ChromaRegisterInlineAggregate()
  echo "Success!"

  return foo

#proc ChromaInlineQIOReadObj*(update: cint)
#  # Call the QDP layout for the given lattice size
#  var jrow = constructmulti1d[cint](cint(nrow.len))
#  var kk: cint = 0
#  for k in items(nrow):
#    jrow[kk] = cint(k)
#    inc(kk)
#  QDPLayoutSetLattSize(jrow)



#------------------------------------------------------------------------
when isMainModule:
  echo "**initialize chroma"
  ChromaInitialize()
  
  echo "Linkage!"
  echo "Linkage = ", linkageHack()

  echo "**set layout**"
  QDPLayoutSetLattSize([4,4,4,16])

  echo "**create layout**"
  QDPLayoutCreate()

  echo "**get brave and execute some inline io**"
  let qio_read_xml = """<Fred>
      <Name>QIO_READ_NAMED_OBJECT</Name>
      <Frequency>1</Frequency>
      <NamedObject>
        <object_id>my_gauge_field</object_id>
        <object_type>Multi1dLatticeColorMatrix</object_type>
      </NamedObject>
      <File>
        <file_name>./gauge.lime</file_name>
      </File>
    </Fred>
"""

  echo "**construct string stream**"
  var istr = constructStringStream(qio_read_xml)
  
  echo "**messing around xmlreader**"
#  var xml_in: XMLReader(istr)
#  var xml_in: XMLReader(constructXMLReader(istr))

#  let xml_in: XMLReader = constructXMLReader(istr)
  var xml_in: XMLReader
  xml_in.openXMLReader(istr)

#  echo "**construct xmlreader**"
#  const xml_in = constructXMLReader(istr)

  echo "**xmlwriter stuff**"
  var update_no: int = 0
  var xml_out: XMLBufferWriter

  echo "**construct inline meas**"
  var meas_ptr = ChromaReadInlineMeas(xml_in, "/Fred")

  echo "**call inline meas**"
  ChromaAbsInlineMeas(meas_ptr[], update_no, xml_out)

  echo "**finalize chroma**"
  ChromaFinalize()
  
  echo "**exit!**"

  
