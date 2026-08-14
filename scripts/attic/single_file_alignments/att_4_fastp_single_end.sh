#!/bin/bash
#SBATCH -A >>insert_account_name<<
#SBATCH -J fastp_single
#SBATCH -p parallel
#SBATCH -n 1
#SBATCH -c 40
#SBATCH -C broadwell
#SBATCH -t 08:00:00
#SBATCH -v
#SBATCH -o output_fastp_single.%j.out
#SBATCH -e error_fastp_single.%j.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=>>insert_email<<

# Load modules:
module load bio/fastp/0.23.4-GCC-11.3.0

# Manual/ Reference:
# https://github.com/opengene/fastp

# Description:
# Applying filters to the raw fastq files (single-end version)

# Run task:
for i in ~/projects/account_name/path/data/fastq_files/single/*fastq.gz

do

prefix="$(echo "$i" | cut -d '.' -f 1)"

fastp   -i "$prefix".fastq.gz \
        -o "$prefix"_filtered.fastq.gz \
        -l 70 \ # read length filter: must be >= 70
#        --html ~/projects/account_name/path/data/fastq_files/filtered/single/"fastp_report_single.html"
#        --json ~/projects/account_name/path/data/fastq_files/filtered/single/"fastp_report_single.json"
        --report_title "fastp_report_drosmel_single_09042026"

done

mv ~/projects/account_name/path/data/fastq_files/single/*_filtered* ~/projects/account_name/path/data/fastq_files/filtered/single/


