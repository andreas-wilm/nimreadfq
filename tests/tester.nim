import unittest

import zip/zlib
import ../kseq

test "readgz":
  #let fp = gzopen("/home/wilma/genomics/readfq-nim.git/SRR396637_1.fastq.gz", "r")
  let fp = gzopen("./tests/test.fasta.gz", "r")
  #let fp = gzopen("/home/wilma/local/src/nimkseq.fork.git/tests/test.fasta.gz", "r")
  let seq = kseq_init(fp)
  #var ll: int;

  while true:
    if kseq_read(seq) < 0:
      break
    echo seq.name.s
    echo seq.seq.s


