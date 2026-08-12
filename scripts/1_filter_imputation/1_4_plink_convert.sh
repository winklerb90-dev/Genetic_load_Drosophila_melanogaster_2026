#!/bin/bash
#SBATCH -A >>insert_account_name<<
#SBATCH -J plink_convert
#SBATCH -p parallel
#SBATCH -N 1
#SBATCH --tasks-per-node 10
#SBATCH -c 4
#SBATCH -C broadwell
#SBATCH -t 01:00:00
#SBATCH -v
#SBATCH -o output_plink_convert.%j.out
#SBATCH -e error_plink_convert.%j.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=>>insert_email<<

# load modules:
module load lang/Anaconda3/2023.03
conda activate /home/account_name/.conda/envs/conda_env_name # ensure that packages have been pre-compiled in the environment

# Manual/ Reference:
# https://www.cog-genomics.org/plink/

# Description:
# After the imputation of missing genotypes via BEAGLE,
# convert the .vcf.gz file back into .bed, .bim, .fam formats.

# run task:
cd ~/projects/account_name/data/plink/output/

plink	--vcf dgrp2_QC_all_lines_imputed.vcf.gz \
    	--make-bed \
	    --out dgrp2_QC_all_lines_imputed
