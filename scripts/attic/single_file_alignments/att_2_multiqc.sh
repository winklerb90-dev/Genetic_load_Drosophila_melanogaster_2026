#!/bin/bash
#SBATCH -A >>insert_account_name<<
#SBATCH -J multiqc
#SBATCH -p parallel
#SBATCH -n 1
#SBATCH -c 40
#SBATCH -C broadwell
#SBATCH -t 02:00:00
#SBATCH -v
#SBATCH -o output_multiqc.%j.out
#SBATCH -e error_multiqc.%j.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=>>insert_email<<

# Load modules:
module load bio/MultiQC/1.7-foss-2018a-Python-3.6.4

# Manual/ Reference:
# https://docs.seqera.io/multiqc/

# Description:
# Summarises and combines the single files QC reports from FastQC into one report

# Run task:
multiqc ~/projects/acc_name/path/data/fastqc_reports/filtered/

mv ~/projects/acc_name/path/scripts/multiqc_data/ ~/projects/path/data/fastqc_reports/filtered/multiqc/
mv ~/projects/acc_name/path/scripts/multiqc_report.html ~/projects/path/data/fastqc_reports/filtered/multiqc/
