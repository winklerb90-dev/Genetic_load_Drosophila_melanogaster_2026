
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
#SBATCH -J phast_msa_view_2L
#SBATCH -t 00:45:00
#SBATCH -o output_phast_msa_view_2L.%j.out
#SBATCH -e error_phast_msa_view_2L.%j.err
# -----------------------------------------------#
#================================================#
#=========[ + + + + Reference + + + + ]==========#
# https://manpages.debian.org/testing/phast/msa_view.1.en.html
#================================================#
#=========[ + + + + Description + + + + ]========#
# Convert .maf per chrom to .fasta per chrom but
# keep matching nucleotide structure. This was run
# per chromosome file, so change files accordingly.
#================================================#

#=========[ + + + + Job Steps + + + + ]==========#
module load lang/Anaconda3/2024.06-1
source activate base
conda activate >>insert_conda_env_name< # make sure packages are compiled before

cd /lustre/project/account_name/data/maf_files/

gzip -dk chr2L.maf.gz # change depending on chromosome file

msa_view chr2L.maf  --refseq ../reference_fasta/ref_dm6_chr2L.fa  --out-format FASTA > chr2L_ref.fasta # change depending on chromosome file

sed -i 's/\*/N/g' chr2L_ref.fasta # replaces '*' with 'N' to label missing nucleotides

mv chr2L_ref.fasta ../new_fasta_files/

rm chr2L.maf
