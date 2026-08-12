#!/bin/bash
#========[ + + + + Requirements + + + + ]========#
# does not need to be change --------------------#
#SBATCH --partition=ki-smallcpu
#SBATCH --account=>>insert_account_name<<
#SBATCH --mail-type=ALL
#SBATCH --mail-user=>>insert_email<<
#SBATCH -v
# -----------------------------------------------#

# with N = 1 these values should multiply to 40 -#
#SBATCH -N 1
#SBATCH --tasks-per-node 20
#SBATCH -c 2
# -----------------------------------------------#

# adjust below for each script ------------------#
#SBATCH -J bedtools_intersect2R.sh
#SBATCH -t 01:00:00
#SBATCH -o output_bedtools_intersect2R.%j.out
#SBATCH -e error_bedtools_intersect2R.%j.err
# -----------------------------------------------#
#================================================#

#=========[ + + + + Reference + + + + ]==========#
# Based on script from "Predicted deleterious
# mutations reveal the genetic architecture of
# male reproductive success in a lekking bird",
# Chen et al. 2024
# manual: https://bedtools.readthedocs.io/en/latest/content/tools/intersect.html
#================================================#

#=========[ + + + + Description + + + + ]========#
# In the previous scripts, the the .rates (rejected substitutions) file
# and the .vcf (genotype info) have been turned into .bed files.
# This script merges them per chromosome.
#================================================#

#=========[ + + + + Job Steps + + + + ]==========#
module load lang/Anaconda3/2024.06-1
source activate base
conda activate gerp_env

cd /lustre/project/acoount_name/data/

# change the file names per chromosome, e.g., this is for chromosome 2R:
bedtools intersect -a gerp_rates/chr_2R_rates.bed \
                   -b vcf/dgrp2_QC_all_lines_imputed_correct.bed \
                   -wa \
                   -wb | cut -f 6-10 --complement > bed_intersection_files/gerp_rates_intersection_chr_2R.tsv

gzip bed_intersection_files/gerp_rates_intersection_chr_2R.tsv
