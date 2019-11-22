# Package

version       = "0.1.0"
author        = "Andreas Wilm"
description   = "Benchmark for nimreadfq"
license       = "MIT"

bin = @["benchmark"]

requires "nim >= 0.19, zip >= 0.2.1, nimbioseq >= 0.3.2, fastx_reader >= 0.1.0"
