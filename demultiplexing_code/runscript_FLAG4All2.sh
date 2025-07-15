#!/bin/bash
set -e
#export PYTHONPATH=$PYTHONPATH:/usr/local/lib/python3.6/dist-packages
SAMPLE=KT
for kval in 4 5
  do
    singularity exec -B $PWD ~/tools/souporcell/souporcell_latest.sif souporcell_pipeline.py \
    -i $SAMPLE.bam -b ${SAMPLE}barcodes.tsv \
    -f ~/refseq/refdata-cellranger-GRCh38-3.0.0/fasta/genome.fa -t 15 -o souporcellk${kval}${SAMPLE} \
    --common_variants ~/tools/souporcell/common_variants_grch38.vcf --skip_remap True -k ${kval}
    done

