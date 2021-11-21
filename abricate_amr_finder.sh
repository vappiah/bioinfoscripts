#!/bin/bash

DATADIR=$1

samples=(ls $DATADIR/*)
for sample in ${samples[@]}
do
bname=$(basename $sample .fasta)
abricate $sample --csv > ${bname}.amr.csv
done
abricate --summary *.csv --csv > AMR.summary.csv

