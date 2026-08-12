#!/bin/bash
#SBATCH -A >>insert_account_name<<
#SBATCH -J plink_filtering
#SBATCH -p parallel
#SBATCH -N 1
#SBATCH --tasks-per-node 10
#SBATCH -c 4
#SBATCH -C broadwell 
#SBATCH -t 00:05:00
#SBATCH -v
#SBATCH -o output_plink_filtering.%j.out
#SBATCH -e error_plink_filtering.%j.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=>>insert_email<<

# Load modules:
module load lang/Anaconda3/2023.03
conda activate /home/account_name/.conda/envs/conda_env_name # ensure that packages have been pre-compiled in the environment

# Manual/ Reference:
# https://www.cog-genomics.org/plink/

# Description:
# Filter the PLINK input files according to the criteria described below:
# Keep SNPs for which at least 90% of the 205 DGRP lines were successfully genotyped &
# allow samples with no sex information; Filtering for minor allele frequency has been removed as 
# variants of interest may be rare.

# Run task:
cd ~/projects/account_name/data/plink/input/

plink   --bfile dgrp2 \
	      --geno 0.1 \
	      --allow-no-sex \
	      --make-bed \
	      --out ../output/dgrp2_QC_all_lines

sed 's/_//g' ../output/dgrp2_QC_all_lines.fam > copy_dgrp2_QC_all_lines.fam # removes '_' from line names in new copy file

rm ../output/dgrp2_QC_all_lines.fam # delete original .fam file

mv ../output/copy_dgrp2_QC_all_lines.fam dgrp2_QC_all_lines.fam # replace original .fam file

# may use below instead after filtering and imputation as control (without sed part):
# --bfile /output/dgrp2_QC_all_lines_imputed 
# --out /output/dgrp2_QC_all_lines_imputed_correct
