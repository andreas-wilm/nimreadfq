import unittest
import md5
import strutils

import ../kseq


test "readfq test.fasta.gz":
  var res = ""
  for rec in readfq("./tests/test.fasta.gz"):
    res = res & $rec & "\n"
  check $toMD5($res) == "21aa45c3b9110a7df328680f8b8753e8"#  gzip -dc tests/test.fasta.gz | md5sum


test "readfq seq.txt":
  # tests mixed fa and fastq and messy input
  var i = 0
  for rec in readfq("./tests/seq.txt"):
    inc i
    check rec.name == $i
    if i == 1:
      check len(rec.sequence) == 15 and len(rec.quality) == 0
    elif i == 2:
      check len(rec.sequence) == 10 and len(rec.comment) > 0
    elif i == 3:
      check len(rec.quality) == len(rec.sequence)


test "readfq SRR396637_1.seqs1-2.fastq.gz":
  var res = ""
  for rec in readfq("./tests/SRR396637_1.seqs1-2.fastq.gz"):
    res = res & $rec & "\n"
  check $toMD5($res) == "299882b15a2dc87f496a88173dd485ad"#  gzip -dc SRR396637_1.seqs1-2.fastq.gz | md5sum


test "readFQPtr test.fasta.gz":
  var res = ""
  var recs: seq[string]
  for rec in readFQPtr("./tests/test.fasta.gz"):
    # ptr char are reused but here we convert to string on the fly
    recs.add($rec)
  res = $recs.join("\n") & "\n"
  check $toMD5($res) == "21aa45c3b9110a7df328680f8b8753e8"#  gzip -dc tests/test.fasta.gz | md5sum