#!/bin/bash
set -e
#export PYTHONPATH=$PYTHONPATH:/usr/local/lib/python3.6/dist-packages
export PYTHONPATH=$PYTHONPATH:/home/ubuntu/miniconda3/envs/flng/lib/python3.8/site-packages
for SAMPLE in WSSS_F_LNG10293351+WSSS_F_LNG10831895 WSSS_F_LNG10293352+WSSS_F_LNG10831896
do
    #flag the CB: tags in the BAM
    sed "s/^/$SAMPLE-/" $SAMPLE/starsolo/counts/Gene/cr3/barcodes.tsv >> KTbarcodes.tsv
#    samtools index $SAMPLE/starsolo/Aligned.sortedByCoord.out.bam
    python3 ~/tools/linuxshell-genomics/FlagBAM.py $SAMPLE $SAMPLE/starsolo/Aligned.sortedByCoord.out.bam
    rm -r $SAMPLE
done

#merge the BAMS according to donors
#samtools merge F37.bam FCAImmP7504909.bam FCAImmP7504910.bam FCAImmP7504911.bam FCAImmP7504912.bam FCAImmP7504913.bam 
#samtools merge F61.bam FCAImmP7862084.bam FCAImmP7862085.bam FCAImmP7862086.bam FCAImmP7862087.bam FCAImmP7862088.bam \
#FCAImmP7862089.bam FCAImmP7862090.bam FCAImmP7862091.bam FCAImmP7862092.bam FCAImmP7862093.bam FCAImmP7862094.bam FCAImmP7862096.bam
#samtools index F37.bam
#samtools index F61.bam
#rm FCA*.bam
samtools merge KT.bam WSSS_F_LNG10293351+WSSS_F_LNG10831895.bam WSSS_F_LNG10293352+WSSS_F_LNG10831896.bam -@ 16
samtools index KT.bam
rm WSSS_F_LNG10293351+WSSS_F_LNG10831895.bam WSSS_F_LNG10293352+WSSS_F_LNG10831896.bam
SAMPLE=KT
for kval in 4 5
  do
    singularity exec -B $PWD ~/tools/souporcell/souporcell.sif souporcell_pipeline.py \
    -i $SAMPLE.bam -b ${SAMPLE}barcodes.tsv \
    -f ~/refseq/refdata-cellranger-GRCh38-3.0.0/fasta/genome.fa -t 15 -o souporcellk${kval}${SAMPLE} \
    --common_variants ~/tools/souporcell/common_variants_grch38.vcf --skip_remap True -k ${kval}
    done

