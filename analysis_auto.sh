# Copyright (C) 2026 Berkem Toprak Elmacı
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License.

#!/usr/bin/env bash

CONDA_PATH=$(conda info --base 2>/dev/null || echo "$HOME/miniconda3")
CONDA_SETUP="$CONDA_PATH/etc/profile.d/conda.sh"
if [ -f "$CONDA_SETUP" ]; then
    source "$CONDA_SETUP"
    conda activate analysis
else
    echo "Conda kurulum dosyası yok ($CONDA_SETUP)"
    exit 1
fi

fastq_F=$(ls *.fastq*)
reference_F=$(ls *.fasta)

fastqc $fastq_F

fastp -i $fastq_F -o cleaned_SRR.fastq -h report.html -j report.json

bwa index $reference_F
bwa mem $reference_F cleaned_SRR.fastq > aligned_reads.sam

samtools view -S -b aligned_reads.sam > aligned_reads.bam
samtools sort aligned_reads.bam -o aligned_reads_sorted.bam
samtools index aligned_reads_sorted.bam

gatk CreateSequenceDictionary -R $reference_F
samtools faidx $reference_F

gatk AddOrReplaceReadGroups \
  -I aligned_reads_sorted.bam \
  -O aligned_reads_with_rg.bam \
  -RGID 1 \
  -RGLB lib1 \
  -RGPL ILLUMINA \
  -RGPU unit1 \
  -RGSM sample_x

samtools index aligned_reads_with_rg.bam

gatk HaplotypeCaller \
  -R $reference_F \
  -I aligned_reads_with_rg.bam \
  -O raw_variants.vcf


grep -v "##" raw_variants.vcf | head -n 10