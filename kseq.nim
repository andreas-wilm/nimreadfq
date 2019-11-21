import zip/zlib

# https://forum.nim-lang.org/t/2668
from os import splitPath
const kseqh = currentSourcePath().splitPath.head & "/kseq/kseq.h"

type
  kstring_t = object
    ll: int
    m: int
    s*: ptr char
  kstream_t = object
    begin: int
    endd: int
    is_eof: int
  kseq_t = object
    name*: kstring_t
    comment*: kstring_t
    seq*: kstring_t
    qual*: kstring_t
    last_char: int
    f: ptr kstream_t
  gzFile = pointer

proc kseq_init*(fp: gzFile): ptr kseq_t {.header: kseqh, importc: "kseq_init".}

proc kseq_rewind*(seq: ptr kseq_t) {.header: kseqh, importc: "kseq_rewind".}

proc kseq_read*(seq: ptr kseq_t): int {.header: kseqh, importc: "kseq_read".}


