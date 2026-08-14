#!/bin/bash
#SBATCH -A >>insert_account_name<<
#SBATCH -J bwa-mem2_single-end
#SBATCH -p parallel
#SBATCH -N 1
#SBATCH --tasks-per-node 10
#SBATCH -c 4
#SBATCH -C broadwell
#SBATCH -t 48:00:00
#SBATCH -v
#SBATCH -o output_bwa-mem2_single-end.%j.out
#SBATCH -e error_bwa-mem2_single-end.%j.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=>>insert_email<<

# Load modules:
module load lang/Anaconda3/2023.03

conda activate /home/user_name/.conda/envs/bwa_env/bwa_env # make sure bwa-mem2 is already pre-compiled in this env

# Manual/ Reference:
# https://github.com/lh3/bwa?tab=readme-ov-file
# https://github.com/bwa-mem2/bwa-mem2
# https://linuxize.com/post/gzip-command-in-linux/

# Description:
# Running BWA-MEM2 alignments for single-end files with read length >= 70
# Index pre compiled (> bwa index "reference_file".fq.gz files/test/paired/SRR018293_1.fastq.gz

# Run task:
index_file=~/projects/acc_name/path/data/reference_assembly/Drosophila_melanogaster.BDGP6.54.dna.toplevel.fa.gz

for i in ~/projects/acc_name/path/data/fastq_files/filtered/single/*.fastq.gz # iterates through the files

do

prefix="$(echo "$i" | cut -d '_' -f 1-6)" # same as paired-end, cuz of "filtered' tag

bwa-mem2 mem -t 10 $index_file $i | gzip -3 > "$prefix".sam.gz # unlike paired-end, no need to gunzip input files

done # gzip compression goes from 1 to 9 (1=fastest, 9=most compressed, -> slightly nudged towards speed)

mv ~/projects/acc_name/path/data/fastq_files/filtered/single/*.sam.gz ~/projects/acc_name/path/data/sam_files/single/


