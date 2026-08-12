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
#SBATCH -J samtools_faidx_ref_fasta
#SBATCH -t 00:15:00
#SBATCH -o output_samtools_faidx_ref_fasta.%j.out
#SBATCH -e error_samtools_faidx_ref_fasta.%j.err
# -----------------------------------------------#
#================================================#
#=========[ + + + + Reference + + + + ]==========#
# https://www.htslib.org/doc/samtools-faidx.html
# The file is the 2014 dm6 assembly, downloaded
# with this command:
# wget https://hgdownload.soe.ucsc.edu/goldenPath/dm6/bigZips/dm6.fa.gz
#================================================#
#=========[ + + + + Description + + + + ]========#
# Split the reference .fasta file per chromosome.
# Will be used as reference for phast msa_view.
#================================================#

#=========[ + + + + Job Steps + + + + ]==========#
module load bio/SAMtools/1.23.1-GCC-13.3.0

cd /lustre/project/account_name/data/reference_fasta/

gunzip dm6.fa.gz

samtools faidx dm6.fa chr2L > ref_dm6_chr2L.fa
samtools faidx dm6.fa chr2R > ref_dm6_chr2R.fa
samtools faidx dm6.fa chr3L > ref_dm6_chr3L.fa
samtools faidx dm6.fa chr3R > ref_dm6_chr3R.fa
samtools faidx dm6.fa chr4 > ref_dm6_chr4.fa
samtools faidx dm6.fa chrX > ref_dm6_chrX.fa
