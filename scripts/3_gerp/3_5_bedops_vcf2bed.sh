#!/bin/bash
#========[ + + + + Requirements + + + + ]========#
# does not need to be change --------------------#
#SBATCH --partition=ki-smallcpu
#SBATCH --account=>>insert_account_name<<
#SBATCH --mail-type=ALL
#SBATCH -->>insert_email<<
#SBATCH -v
# -----------------------------------------------#

# with N = 1 these values should multiply to 40 -#
#SBATCH -N 1
#SBATCH --tasks-per-node 20
#SBATCH -c 2
# -----------------------------------------------#

# adjust below for each script ------------------#
#SBATCH -J bedops_vcf2bed
#SBATCH -t 00:10:00
#SBATCH -o output_bedops_vcf2bed.%j.out
#SBATCH -e error_bedops_vcf2bed.%j.err
# -----------------------------------------------#
#================================================#

#=========[ + + + + Reference + + + + ]==========#
# https://bedops.readthedocs.io/en/latest/content/reference/file-management/conversion/convert2bed.html
#================================================#

#=========[ + + + + Description + + + + ]========#
# Convert the .vcf file (created in section '1_filter_imputation'
# to .bed so that in the next step we can determine overlap with the
# .rates file (needs to be converted as well).
#================================================#

#=========[ + + + + Job Steps + + + + ]==========#
source activate base
conda activate gerp_env

cd /lustre/project/account_name/data/vcf

convert2bed -i vcf < dgrp2_QC_all_lines_imputed_correct.vcf > dgrp2_QC_all_lines_imputed_correct.bed
