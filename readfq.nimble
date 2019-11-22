# Package

version       = "0.1.0"
author        = "Andreas Wilm"
description   = "Wrapper for Heng Li's kseq"
license       = "MIT"

requires "nim >= 0.19, zip >= 0.2.1"

skipDirs = @["tests"]

task test, "run the tests":
  exec "nim c -r -l:-lz tests/tester"
