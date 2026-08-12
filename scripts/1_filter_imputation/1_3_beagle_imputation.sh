#!/bin/bash
#SBATCH -A >>insert_account_name<<
#SBATCH -J beagle_impute
#SBATCH -p parallel
#SBATCH -N 1
#SBATCH --tasks-per-node 4
#SBATCH -c 10
#SBATCH -C broadwell
#SBATCH -t 02:00:00
#SBATCH --mem=56g
#SBATCH -v
#SBATCH -o output_beagle_impute.%j.out
#SBATCH -e error_beagle_impute.%j.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=>>insert_email<<

# Load modules:
module load lang/Anaconda3/2023.03
conda activate /home/account_name/.conda/envs/conda_env_name # ensure that packages have been pre-compiled in the environment

# Manual/ Reference:
# https://github.com/adrianodemarino/Imputation_beagle_tutorial

# Description:
# Use Beagle to detect missing genotypes and replace/impute the missing sites based on location and likelihood.

# Run task:
cd ~/projects/account_name/data/plink/output/

beagle -Xms52g -Xmx52g gt=dgrp2_QC_all_lines.vcf.gz window=10.0 out=dgrp2_QC_all_lines_imputed

# may have to adjust memory settings

