import zip/zlib

# https://forum.nim-lang.org/t/2668
from os import splitPath

const kseqh = currentSourcePath().splitPath.head & "/kseq/kseq.h"


type
  kstring_t = object
    ll: int
    m: int
    s: ptr char
  kstream_t = object
    begin: int
    endd: int
    is_eof: int
  kseq_t = object
    name: kstring_t
    comment: kstring_t
    seq: kstring_t
    qual: kstring_t
    last_char: int
    f: ptr kstream_t
  gzFile = pointer
  # convenience type for fastq or fasta records
  FQRecord* = object
    name*: ptr char
    comment*: ptr char# optional
    sequence*: ptr char
    quality*: ptr char# optional


proc kseq_init*(fp: gzFile): ptr kseq_t {.header: kseqh, importc: "kseq_init".}


proc kseq_rewind*(seq: ptr kseq_t) {.header: kseqh, importc: "kseq_rewind".}


proc kseq_read*(seq: ptr kseq_t): int {.header: kseqh, importc: "kseq_read".}


iterator readfq*(fp: GzFile): FQRecord =
  # NOTE: ptr char will be reused on next iteration
  var result: FQRecord# not implicit in iterators
  doAssert fp != nil
  let rec = kseq_init(fp)
  while true:
    if kseq_read(rec) < 0:
      break
    result.name = rec.name.s
    result.comment = rec.comment.s
    result.sequence = rec.seq.s
    result.quality = rec.qual.s
    yield result


proc `$`*(rec: FQRecord): string =
  var fastq = false
  var header = ">"
  if len($rec.quality) > 0:
    fastq = true
    header = "@"

  result = header & $rec.name
  if $rec.comment != "":
    result = result & " " & $rec.comment
  result = result & "\n" & $rec.sequence
  if fastq:
    result = result & "\n+\n" & $rec.quality


# FIXME add optional functions and type that provide string copy of ptr char?