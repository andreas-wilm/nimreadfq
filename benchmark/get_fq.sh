#!/bin/bash

test -e biofast-data-v1.tar.gz || wget -nd https://github.com/lh3/biofast/releases/download/biofast-data-v1/biofast-data-v1.tar.gz
if [ ! -e M_abscessus_HiSeq.fq ]; then
    tar xvzf biofast-data-v1.tar.gz  biofast-data-v1/M_abscessus_HiSeq.fq 
    mv biofast-data-v1/M_abscessus_HiSeq.fq .
    rmdir biofast-data-v1/
fi
