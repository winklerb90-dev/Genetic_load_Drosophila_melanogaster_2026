#!/bin/bash
#SBATCH -A >>insert_account_name<<
#SBATCH -J plink_frequencies
#SBATCH -p parallel
#SBATCH -N 1
#SBATCH --tasks-per-node 10
#SBATCH -c 4
#SBATCH -C broadwell
#SBATCH -t 01:00:00
#SBATCH -v
#SBATCH -o output_plink_frequencies.%j.out
#SBATCH -e error_plink_frequencies.%j.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=>>insert_email<<

# Load modules:
module load lang/Anaconda3/2023.03

conda activate /home/user_name/.conda/envs/bwa_env/bwa_env # make sure that plink is already pre-compiled in this env

# Manual/ Reference:
# https://www.cog-genomics.org/plink/

# Description:
# Retrieve minar allele frequency (MAF) and write it to plink.frq

# Run task:
cd ~/projects/acc_name/path/data/plink/output/

plink   --bfile dgrp2_QC_all_lines_imputed_correct \
	--freq

mv ~/projects/acc_name/path/data/plink/output/plink.frq ~/projects/acc_name/path/data/plink/output/non_ldpruned_plink.frq
