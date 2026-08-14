#!/bin/bash
#SBATCH -A >>insert_account_name<<
#SBATCH -J plink_ld_pruning
#SBATCH -p parallel
#SBATCH -N 1
#SBATCH --tasks-per-node 10
#SBATCH -c 4
#SBATCH -C broadwell
#SBATCH -t 01:00:00
#SBATCH -v
#SBATCH -o output_plink_ld_pruning.%j.out
#SBATCH -e error_plink_ld_pruning.%j.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=>>insert_email<<

# Load modules:
module load lang/Anaconda3/2023.03

conda activate /home/user_name/.conda/envs/bwa_env/bwa_env # make sure that plink is already pre-compiled in this env

# Manual/ Reference:
# https://www.cog-genomics.org/plink/

# Description
# prunes SNPs within 100kB sliding windows, sliding 10 variants along each step, allowing max pairwise correlation (r^2) threshold of 0.2 between loci
# plink.prune.in -> subset of markers in approximate linkage equilibrium
# plink.prune.out -> excluded variants in linkage disequilibrium

# Run task:
cd ~/projects/acc_name/path/data/plink/output/

plink   --bfile dgrp2_QC_all_lines_imputed_correct \
      	--indep-pairwise 100 10 0.2 # output: plink.prune.in & plink.prune.out

plink  --bfile dgrp2_QC_all_lines_imputed_correct \
       --extract plink.prune.in \
       --make-bed \
       --out dgrp2_QC_all_lines_imputed_correct_ldpruned

plink  --bfile dgrp2_QC_all_lines_imputed_correct_ldpruned \
       --freq

mv  ~/projects/acc_name/path/data/plink/output/plink.frq ~/projects/acc_name/path/data/plink/output/ldpruned_plink.frq
