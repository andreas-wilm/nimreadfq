# Package

version       = "0.1.1"
author        = "Andreas Wilm"
description   = "Wrapper for Heng Li's kseq"
license       = "MIT"

requires "nim >= 0.19, zip >= 0.2.1"

skipDirs = @["tests"]

task test, "run the tests":
  exec "nim c -r tests/tester"
