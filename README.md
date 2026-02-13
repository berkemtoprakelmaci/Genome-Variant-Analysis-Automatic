Genome Variant Analysis Automatic

This project provides an automated end-to-end bioinformatics pipeline to process raw sequencing data into variant calls. It handles the entire workflow starting from raw FASTQ files and a reference FASTA:

Quality Control: Generates QC reports using `FastQC`.
Pre-processing: Trims adapters and filters low-quality reads with `fastp`.
Alignment: Indexes the reference and aligns reads using `BWA MEM`.
Post-alignment: Converts, sorts, and indexes files using `samtools`, and prepares them for GATK by adding Read Groups.
Variant Calling: Identifies germline variants using `GATK4 HaplotypeCaller` to produce a VCF file.

Efficiency: It replaces a long series of manual terminal commands with a single automated execution, saving time and reducing human error.
Scalability: The script is designed to automatically detect fastq and fasta files in the working directory, making it easy to swap datasets.

USAGE
Set up the Environment: Ensure you have Conda installed. Create the environment using:
`conda env create -f environment.yml`
Activate Environment:
`conda activate analysis`
Prepare Data: Place your `.fastq` or `.fastq.gz` files and your reference `.fasta` file in the same directory as the script.
Must: Only one `.fasta` and only one `.fastq` or `.fastq.gz` file in same directory with bash
project-folder/
├── analysis_auto.sh
├── reference_genome.fasta
└── sample_data.fastq (or .fastq.gz)
Run:
`bash analysis_auto.sh`
Maintainer: Berkem Toprak Elmacı/(https://github.com/berkemtoprakelmaci/)

Example directory after analysis:
SRR37151357.fastq.gz     aligned_reads_sorted.bam       cleaned_SRR.fastq     sequence.dict       sequence.fasta.fai
SRR37151357_fastqc.html  aligned_reads_sorted.bam.bai   raw_variants.vcf      sequence.fasta      sequence.fasta.pac
SRR37151357_fastqc.zip   aligned_reads_with_rg.bam      raw_variants.vcf.idx  sequence.fasta.amb  sequence.fasta.sa
aligned_reads.bam        aligned_reads_with_rg.bam.bai  report.html           sequence.fasta.ann
aligned_reads.sam        analysis_auto.sh               report.json           sequence.fasta.bwt
