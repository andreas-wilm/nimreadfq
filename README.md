# Note

This repository was started before Heng Li wrote his article ["Fast high-level programming languages"](https://lh3.github.io/2020/05/17/fast-high-level-programming-languages), which contains a native Nim implementation (see klib below). His native Nim implementation is very fast out of the box and should in fact be used instead of this implementation.

# nimreadfq



A Nim wrapper for [Heng Li's kseq/readfq](https://github.com/lh3/readfq/), an efficient and fast parser for FastQ and Fasta files.
nimreadfq supports reading of FastQ and Fasta files from stdin (use "-"), gzipped or flat files and is fast (see benchmark below).

The main function is `readFQ()`, an iterator that yields `FQRecord(s)`. An alternative is `readFQPtr()`, which returns `FQRecordPtr(s)`. The difference is that the latter uses `ptr char` instead of strings and is thus potentially faster but memory is reused during iterations.

See `example.nim` and `tests/tester.nim` for code examples.

The initial Nim integration (and hard work) was done by [Haibao Tang](https://github.com/tanghaibao) as part of his [bio-pipeline
repo](https://github.com/tanghaibao/bio-pipeline/). Haibao generously [granted full rights to his code base](https://github.com/tanghaibao/bio-pipeline/issues/4), after which I started this separate package called [nimreadfq](https://github.com/andreas-wilm/nimreadfq) for integration into nimble.



## Benchmark

nimreadfq is significantly faster than packages with similar functionality. Below are example timings for reading 5,682,010 sequences from `M_abscessus_HiSeq.fq` ([source; see also `./benchmark/get_fq.sh`](https://github.com/lh3/biofast/releases/tag/biofast-data-v1)) run on my MacBook Pro 2019:

fastq:
- readfq: 10.4s
- klib: 7.5
- fastx: 41.1s
- bioseq: 44.3s

fastq.gz:
- klib gz: 14.8s
- readfq gz: 17.6s
- fastx: NA
- bioseq gz: 145.6s


How to reproduce results:

    cd ./benchmark
    nimble build
    ./benchmark
