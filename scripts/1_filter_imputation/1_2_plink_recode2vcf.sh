#!/bin/bash
#SBATCH -A >>insert_account_name<<
#SBATCH -J plink_recode2vcf
#SBATCH -p parallel
#SBATCH -N 1
#SBATCH --tasks-per-node 10
#SBATCH -c 4
#SBATCH -C broadwell
#SBATCH -t 00:10:00
#SBATCH -v
#SBATCH -o output_plink_recode2vcf.%j.out
#SBATCH -e error_plink_recode2vcf.%j.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=>>insert_email<<

# load modules:
module load lang/Anaconda3/2023.03
conda activate /home/account_name/.conda/envs/conda_env_name # ensure that packages have been pre-compiled in the environment

# Manual/ Reference:
# https://www.cog-genomics.org/plink/

# Description:
# Beagle package needs a .vcf file for data imputation, so recode the PLINK format files to .vcf;
# Also, .vcf files are required for further steps in RStudio

# Run task:
cd ~/projects/account_name/data/plink/output/

plink   --bfile dgrp2_QC_all_lines \
        --keep-allele-order \
        --recode vcf \
        --out dgrp2_QC_all_lines
		
# may use below instead after filtering and imputation as control (without sed part):
# --bfile dgrp2_QC_all_lines_imputed_correct 
# --out dgrp2_QC_all_lines_imputed_correct
