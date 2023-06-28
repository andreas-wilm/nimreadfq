import times
import strutils
import zip/zlib
import zip/gzipfiles

import ../readfq
import nimbioseq
import fastx_reader


# https://stackoverflow.com/questions/36577570/how-to-benchmark-few-lines-of-code-in-nim
template benchmark(benchmarkName: string, code: untyped) =
  block:
    let t0 = epochTime()
    code
    let elapsed = epochTime() - t0
    let elapsedStr = elapsed.formatFloat(format = ffDecimal, precision = 3)
    echo "CPU Time [", benchmarkName, "] ", elapsedStr, "s"


proc readfq_count(path: string): int =
  for rec in readfq.readfq(path):
    inc result


proc readFastq_count(path: string): int =
  var i = 0
  for rec in readfastq(path):
    inc result


proc fastq_reader_count(path: string): int =
  for name, sequence, quality in fastq_reader(open(path)):
    inc result


when isMainModule:
  # see https://github.com/lh3/biofast/releases/tag/biofast-data-v1)
  var fq = "./M_abscessus_HiSeq.fq"

  benchmark "readfq count":
    echo "n=" & $readfq_count(fq)

  benchmark "bioseq count":
    echo "n=" & $readFastq_count(fq)

  benchmark "fastx count":
    echo "n=" & $fastq_reader_count(fq)

  # see https://github.com/lh3/biofast/releases/tag/biofast-data-v1)
  var fqgz = "./M_abscessus_HiSeq.fq.gz"

  benchmark "readfq gz count":
    echo "n=" & $readfq_count(fqgz)

  benchmark "bioseq gz count":
    echo "n=" & $readFastq_count(fqgz)

