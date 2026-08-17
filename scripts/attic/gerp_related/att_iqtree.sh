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
#SBATCH --tasks-per-node 10
#SBATCH -c 4
# -----------------------------------------------#

# adjust below for each script ------------------#
#SBATCH -J iqtree_4
#SBATCH -t 24:00:00
#SBATCH -o output_iqtree_4.%j.out
#SBATCH -e error_iqtree_4.%j.err
# -----------------------------------------------#
#================================================#

#=========[ + + + + Reference + + + + ]==========#
# https://iqtree.github.io/doc/Command-Reference
#================================================#

#=========[ + + + + Description + + + + ]========#
# Create a phylogenetic tree from the fasta file
# which contains the sequences of whole-genomes
# from 124 insect species.
#================================================#

#=========[ + + + + Job Steps + + + + ]==========#
module load lang/Anaconda3/2024.06-1
source activate base
conda activate gerp_env

cd /lustre/project/acc_name/path/data/fasta_files/

iqtree -s chr4_filtered.fasta -st DNA -T auto

# -st DNA : specify type of input; .fasta contains: A,C,G,T,- (gaps) and N (missing data)
# -T auto : auto-determine and use cores
