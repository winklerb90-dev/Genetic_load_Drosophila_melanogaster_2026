#!/bin/bash
#SBATCH -A >>insert_account_name<<
#SBATCH -J samtools_sort_index_bam
#SBATCH -p parallel
#SBATCH -n 1
#SBATCH -c 1
#SBATCH -C skylake
#SBATCH -t 01:00:00
#SBATCH -v
#SBATCH -o output_samtools_sort_index_bam.%j.out
#SBATCH -e error_samtools_sort_index_bam.%j.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=>>insert_email<<

# Load modules:
module load bio/SAMtools/1.17-GCC-12.2.0

# Manual/ Reference:
# https://www.htslib.org/doc/samtools-sort.html
# https://www.htslib.org/doc/samtools-index.html
# https://bioinformatics.stackexchange.com/questions/13997/samtools-index-chromosome-blocks-not-continuous

# Description:
# BAM files need to be sorted & indexed in order to call variants with GATK haplotypecaller;
# .bai as default index file

# Run task:
## sorting:
for i in ~/projects/acc_name/path/data/bam_files/paired/with_rg/*_rg.bam

do

prefix="$(echo "$i" | cut -d '.' -f 1)"

samtools sort $i -o "$prefix"_sorted.bam

done


## indexing:
for j in ~/projects/acc_name/path/data/bam_files/paired/with_rg/*_sorted.bam

do

prefix2="$(echo "$j" | cut -d '.' -f 1)"

samtools index $j "$prefix2".bam.bai

done
