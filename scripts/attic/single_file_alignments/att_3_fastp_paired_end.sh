#!/bin/bash
#SBATCH -A >>insert_account_name<<
#SBATCH -J fastp_paired
#SBATCH -p parallel
#SBATCH -n 1
#SBATCH -c 40
#SBATCH -C broadwell
#SBATCH -t 08:00:00
#SBATCH -v
#SBATCH -o output_fastp_paired.%j.out
#SBATCH -e error_fastp_paired.%j.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=>>insert_email<<

# Load modules:
module load bio/fastp/0.23.4-GCC-11.3.0

# Manual/ Reference:
# https://github.com/opengene/fastp

# Description:
# Applying filters to the raw fastq files (paired-end version)

# Run task:
for i in ~/projects/path/data/fastq_files/paired/*_1.fastq.gz

do

prefix="$(echo "$i" | cut -d '_' -f 1-6)"

fastp   -i "$prefix"_1.fastq.gz \
	-I "$prefix"_2.fastq.gz \
	-o "$prefix"_filtered_1.fastq.gz \
	-O "$prefix"_filtered_2.fastq.gz \
	-l 70 \ # read length filter: must be >= 70
	--html ~/projects/path/data/fastq_files/filtered/paired/fastp_report_paired.html \
	--json ~/projects/path/data/fastq_files/filtered/paired/fastp_report_paired.json \
        --report_title "fastp_report_drosmel_09042026"

done

mv ~/projects/path/data/fastq_files/paired/*_filtered_* ~/projects/path/data/fastq_files/filtered/paired/
