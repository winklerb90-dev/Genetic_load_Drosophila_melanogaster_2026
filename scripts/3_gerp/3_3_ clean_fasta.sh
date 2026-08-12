#!/bin/bash
#========[ + + + + Requirements + + + + ]========#
# does not need to be changed -------------------#
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
#SBATCH -J clean_fasta_2L
#SBATCH -t 00:30:00
#SBATCH -o output_clean_fasta_2L.%j.out
#SBATCH -e error_clean_fasta_2L.%j.err
# -----------------------------------------------#
#================================================#

#=========[ + + + + Reference + + + + ]==========#
# none
#================================================#

#=========[ + + + + Description + + + + ]========#
# Because we cant trim data with TrimAl (cuz it
# changes the number of nucleotides), which also
# seems to have assured the correct structure of
# files, we have to assure the correct structure manually.
#================================================#

#=========[ + + + + Job Steps + + + + ]==========#
module load lang/Anaconda3/2024.06-1
source activate base
conda activate gerp_env

cd /lustre/project/account_name/data/fasta_files

# change the files for each chromosome, e.g., this is for chromosome 4 files:
# removes space from headers, e.g., > dm6 becomes >dm6
sed -E 's/^>[[:space:]]+/>/' chr2_ref.fasta > chr2_ref_fixed.fasta

# single-line sequences, white-space-removal & conversion to uppercase:
awk '
/^>/ {
  if (name!="") print seq
  print
  name=$0
  seq=""
  next
}
{
  gsub(/[[:space:]]/, "")
  seq=seq toupper($0)
}
END {print seq}
' chr4_ref_fixed.fasta > chr4_ref_clean.fasta

rm chr4_ref_fixed.fasta
