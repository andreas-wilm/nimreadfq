# nimreadfq

A Nim wrapper for [Heng Li's kseq/readfq](https://github.com/lh3/readfq/), an efficient and fast parser for FastQ and Fasta files.
nimreadfq supports reading of FastQ and Fasta files from stdin (use "-"), gzipped or flat files and is **very** fast (see benchmark below).

The main function is `readFQ()`, an iterator that yields `FQRecord(s)`. An alternative is `readFQPtr()`, which returns `FQRecordPtr(s)`. The difference is that the latter uses `ptr char` instead of strings and is thus potentially faster but memory is reused during iterations.

See `example.nim` and `tests/tester.nim` for code examples.


The initial Nim integration (and hard work) was done by [Haibao Tang](https://github.com/tanghaibao) as part of his [bio-pipeline
repo](https://github.com/tanghaibao/bio-pipeline/). Haibao generously [granted full rights to his code base](https://github.com/tanghaibao/bio-pipeline/issues/4), after which I started this separate package called [nimreadfq](https://github.com/andreas-wilm/nimreadfq) for integration into nimble.

## Benchmark

nimreadfq is almost an order of magnitude faster than packages with similar functionality.

Below are timing for reading 500k sequences on a Surface Book 2 running WSL2 (first 500k sequences from SRR8616947_1):

Gzipped FastQ:
- readfq gz: 1.490s
- bioseq gz: 18.731s

Flat file FastQ:
- readfq: 1.250s
- bioseq: 8.898s
- fastx: 6.486s

How to reproduce results:

    cd ./benchmark
    nimble build
    ./benchmark

