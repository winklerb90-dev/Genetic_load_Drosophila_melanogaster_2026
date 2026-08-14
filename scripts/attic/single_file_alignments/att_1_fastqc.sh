#!/bin/bash
#SBATCH -A >>insert_account_name<<
#SBATCH -J fastqc_batch1_paired
#SBATCH -p parallel
#SBATCH -n 1
#SBATCH -c 40
#SBATCH -C broadwell
#SBATCH -t 08:00:00
#SBATCH -v
#SBATCH -o output_fastqc_batch1_paired.%j.out
#SBATCH -e error_fastqc_batch1_paired.%j.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=>>insert_email<<

# Load modules:
module load bio/FastQC/0.11.9-Java-11

# Manual/ Reference:
# https://www.bioinformatics.babraham.ac.uk/projects/fastqc/

# Desc:
# Quality control of single fastq files; necessary step for summarised QC report;
# Run in batches of hundred to speed up the process

# Run task:
for i in ~/projects/path/data/fastq_files/filtered/paired/batch1/*
do
	fastqc i \
	-o ~/projects/path/data/fastqc_reports/filtered $i
done

