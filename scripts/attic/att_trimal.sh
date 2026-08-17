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
#SBATCH -J trimal_2L
#SBATCH -t 10:00:00
#SBATCH -o output_trimal_2L.%j.out
#SBATCH -e error_trimal_2L.%j.err
# -----------------------------------------------#
#================================================#

#=========[ + + + + Reference + + + + ]==========#
# https://trimal.readthedocs.io/en/latest/usage.html
#================================================#

#=========[ + + + + Description + + + + ]========#
# Trim .fasta multi alignment files using the
# heuristic Automated1 method as described here:
# https://trimal.readthedocs.io/en/latest/algorithms.html
#================================================#

#=========[ + + + + Job Steps + + + + ]==========#
module load lang/Anaconda3/2024.06-1
source activate base
conda activate gerp_env

cd /lustre/project/acc_name/path/data/fasta_files/

trimal -in chr2L.fasta -out chr2L_filtered.fasta -automated1 -htmlout chr2L_trim_report.html

mv chr2L_trim_report.html trim_reports/

#=========[ + + + + Job Steps + + + + ]==========#
