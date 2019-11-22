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
  # convenience type for FastQ or Fasta records
  FQRecordPtr* = object
    name*: ptr char
    comment*: ptr char# optional
    sequence*: ptr char
    quality*: ptr char# optional
  FQRecord* = object
    name*: string
    comment*: string# optional
    sequence*: string
    quality*: string# optional


proc kseq_init*(fp: gzFile): ptr kseq_t {.header: kseqh, importc: "kseq_init".}


proc kseq_rewind*(seq: ptr kseq_t) {.header: kseqh, importc: "kseq_rewind".}


proc kseq_read*(seq: ptr kseq_t): int {.header: kseqh, importc: "kseq_read".}


iterator readFQPtr*(path: string): FQRecordPtr =
  # - ptr char will be reused on next iteration
  # - for stdin use "-" as path
  # - gz[d]open default even for flat file format
  var result: FQRecordPtr# 'result' not implicit in iterators
  var fp: GzFile
  if path == "-":
    fp = gzdopen(0, "r")
  else:
    fp = gzopen(path, "r")

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
  discard gzclose(fp)


iterator readFQ*(path: string): FQRecord =
  var result: FQRecord# 'result' not implicit in iterators
  for rec in readFQPtr(path):
    result.name = $rec.name
    result.comment = $rec.comment
    result.sequence = $rec.sequence
    result.quality = $rec.quality
    yield result


proc fqfmt(name: string, comment: string, sequence: string, quality: string): string =
  var fastq = false
  var header = ">"
  if len(quality) > 0:
    fastq = true
    header = "@"
  result = header & name
  if comment != "":
    result = result & " " & comment
  result = result & "\n" & sequence
  if fastq:
    result = result & "\n+\n" & quality


proc `$`*(rec: FQRecord): string =
  return fqfmt(rec.name, rec.comment, rec.sequence, rec.quality)


proc `$`*(rec: FQRecordPtr): string =
  return fqfmt($rec.name, $rec.comment, $rec.sequence, $rec.quality)

