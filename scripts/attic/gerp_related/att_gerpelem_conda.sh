#!/bin/bash
#========[ + + + + Requirements + + + + ]========#
# does not need to be change --------------------#
#SBATCH --partition=ki-parallel
#SBATCH --account=>>insert_account_name<<
#SBATCH --mail-type=ALL
#SBATCH --mail-user=>>insert_email<<
#SBATCH -v
# -----------------------------------------------#

# with N = 1 these values should multiply to 40 -#
#SBATCH -N 1
#SBATCH --tasks-per-node 10
#SBATCH -c 4
# -----------------------------------------------#

# adjust below for each script ------------------#
#SBATCH --mem=224G
#SBATCH -J gerpelem_4
#SBATCH -t 24:00:00
#SBATCH -o output_gerpelem_4.%j.out
#SBATCH -e error_gerpelem_4.%j.err
# -----------------------------------------------#
#================================================#

#=========[ + + + + Reference + + + + ]==========#
# formerly on: http://mendel.stanford.edu/SidowLab/downloads/gerp/
# manual can be found at: https://web.archive.org/web/20240520010334/http://mendel.stanford.edu/sidowlab/downloads/GERP/index.html
# gerpcol -h
# For the version of tvkent:
# download the gerp tar.gz file from:
# https://github.com/tvkent/GERPplusplus
# compile it and use that instead (but ran much slower for me)
#================================================#

#=========[ + + + + Description + + + + ]========#
# Evaluate gerp rates created by previous
# gerpcol command. Find elements of higher
# substitution rate than expected.
#================================================#

#=========[ + + + + Job Steps + + + + ]==========#
module load lang/Anaconda3/2024.06-1
source activate base
conda activate gerp_env

cd /lustre/project/acc_name/path/data/new_gerp_rates/

gerpelem -f  chr_4.rates \
         -v

# gerpelem -h to see the default flags and values

mv chr_4.rates.elems ../new_gerp_elems/
