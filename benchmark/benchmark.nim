import times
import strutils
import zip/zlib
import zip/gzipfiles

import ../readfq
import nimbioseq
import fastx_reader

# Translated straight from from Heng Li's Python implementation:
# https://github.com/lh3/readfq/blob/master/readfq.py
iterator readfqnative*(fp: Stream): (string, string, string) = # this is a generator function
  var
    name = ""
    seqs: seq[char]
    last = ""# this is a buffer keeping the last unprocessed line
    leng = 0
    sq = ""
  while true: # mimic closure; is it a bad idea?
    if last.len == 0: # the first record or a record following a fastq
      for l in fp.lines: # search for the start of the next record
        if l[0] in ">@":#if ">@".contains(l[0]): # fasta/q header line
          last = l# save this line
          break
    if last.len == 0:
      break
    name = last[1..<last.len].split(" ")[0]
    seqs = @[]
    last = ""
    for l in fp.lines: # read the sequence
      if l[0] in "@+>":
        last = l
        break
      seqs.add(l)
    if last.len == 0 or last[0] != '+': # this is a fasta record
      yield (name, join(seqs, ""), "") # yield a fasta record
      if last.len == 0:
        break
    else: # this is a fastq record
      sq = join(seqs, "")
      leng = 0
      seqs = @[]
      for l in fp.lines: # read the quality
        seqs.add(l)
        leng += l.len
        if leng >= sq.len: # have read enough quality
          last = ""
          yield (name, sq, join(seqs, "")); # yield a fastq record
          break
      if last.len > 0: # reach EOF before reading enough quality
        yield (name, sq, "") # yield a fasta record instead
        break


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
  var path = "SRR8616947_1.500k.fastq.gz"

  benchmark "readfq gz count":
    echo "n=" & $readfq_count(path)

  benchmark "bioseq gz count":
    echo "n=" & $readFastq_count(path)


  path = "SRR8616947_1.500k.fastq"

  benchmark "readfq count":
    echo "n=" & $readfq_count(path)

  benchmark "bioseq count":
    echo "n=" & $readFastq_count(path)

  benchmark "fastx count":
    echo "n=" & $fastq_reader_count(path)


