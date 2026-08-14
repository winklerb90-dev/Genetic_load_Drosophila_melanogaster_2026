#!/bin/bash
#SBATCH -A >>insert_acc_name<<
#SBATCH -J bwa-mem2_paired-end
#SBATCH -p parallel
#SBATCH -N 1
#SBATCH --tasks-per-node 20
#SBATCH -c 2
#SBATCH -C broadwell
#SBATCH -t 48:00:00
#SBATCH -v
#SBATCH -o output_bwa-mem2_paired-end.%j.out
#SBATCH -e error_bwa-mem2_paired-end.%j.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=>>insert_email<<

# load modules:
module load lang/Anaconda3/2023.03

conda activate /home/user_name/.conda/envs/bwa_env/bwa_env # make sure that bwa-mem2 is already pre-compiled in this env

# Manual/ Reference:
# https://github.com/lh3/bwa?tab=readme-ov-file
# https://github.com/bwa-mem2/bwa-mem2
# https://linuxize.com/post/gzip-command-in-linux/

# Description
# running BWA-MEM2 alignments for paired-end files with read length >= 70
# index pre compiled (> bwa index "reference_file".fq.gz files/test/paired/SRR018293_1.fastq.gz

# Run task:
index_file=~/projects/acc_name/path/data/reference_assembly/Drosophila_melanogaster.BDGP6.54.dna.toplevel.fa.gz

for i in ~/projects/acc_name/path/data/fastq_files/filtered/paired/*_1.fastq.gz # iterates through the first of the paired files

do # for each * _1 file the code will run for both files

prefix="$(echo "$i" | cut -d '_' -f 1-6)" # takes curr file i and splits at "_" (includes all _ in the path!!!), then extracts part before "_" (i.e., only file name)

bwa-mem2 mem -t 20 $index_file <(gunzip -c "$prefix"_filtered_1.fastq.gz) <(gunzip -c "$prefix"_filtered_2.fastq.gz) | gzip -3 > "$prefix".sam.gz

done # gzip compression goes from 1 to 9 (1=fastest, 9=most compressed, -> slightly nudged towards speed)

mv ~/projects/acc_name/path/data/fastq_files/filtered/paired/*.sam.gz ~/projects/acc_name/path/data/sam_files/paired/
