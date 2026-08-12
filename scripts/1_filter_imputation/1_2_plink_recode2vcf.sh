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
#SBATCH --mail-user=>>email_name<<

# load modules:
module load lang/Anaconda3/2023.03
conda activate /home/account_name/.conda/envs/bwa_env/bwa_env # plink already pre-compiled in this env

# manual/ reference:
# https://www.cog-genomics.org/plink/

# desc:
# Beagle package needs vcf file for imputation, so recode bfiles to vcf
# also RStudio analysis may need .vcf input

# run task:
cd ~/projects/m2_jgu-salmosex/drosophila_selection_project_2026/data/plink/output/

plink   --bfile dgrp2_QC_all_lines_imputed_correct \
        --keep-allele-order \
        --recode vcf \
        --out dgrp2_QC_all_lines_imputed_correct

plink   --bfile dgrp2_QC_all_lines_imputed_correct_ldpruned \
	--keep-allele-order \
	--recode vcf \
	--out dgrp2_QC_all_lines_imputed_correct_ldpruned
