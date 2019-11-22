# nimreadfq

A Nim wrapper for [Heng Li's kseq/readfq](https://github.com/lh3/readfq/), an efficient and fast parser for FastQ and Fasta files.

The initial Nim integration was done by [Haibao Tang](https://github.com/tanghaibao) as part of his [bio-pipeline
repo](https://github.com/tanghaibao/bio-pipeline/). Haibao [granted full rights to his code base](https://github.com/tanghaibao/bio-pipeline/issues/4), after which I started this separate package called [nimreadfq](https://github.com/andreas-wilm/nimreadfq) for integration into nimble.

nimreadfq supports reading of FastQ and Fasta files from stdin (use "-"), gzipped or flat files.

The main function is `readFQ()`, an iterator that yields `FQRecord(s)`. An alternative is `readFQPtr()`, which returns `FQRecordPtr(s)`. The difference is that the latter uses `ptr char` instead of strings and is thus potentially faster but memory is reused during iterations.

See `example.nim` and `tests/tester.nim` for examples.