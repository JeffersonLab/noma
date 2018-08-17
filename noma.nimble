# Package
version       = "1.0.0"
author        = "Robert Edwards and Balint Joo and Frank Winter"
description   = "Lattice Field Theory library"
license       = "BSD-3"
skipDirs      = @["tests"]

# Want this
bin = @["noma"]

# Dependencies
requires "nim >= 0.17.0", "serializetools >= 1.7.0"

# Tasks
task test, "Run the test suite":
  exec "cd tests; nim c -r test_noma"

task docgen, "Regenerate the documentation":
  exec "nim doc2 --out:docs/noma.html noma.nim"

# Make sure chroma is installed
#before install:
#  echo "Building filehash"
#  exec "cd filehash; make"
