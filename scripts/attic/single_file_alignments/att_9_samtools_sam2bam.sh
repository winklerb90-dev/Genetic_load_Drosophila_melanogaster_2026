#!/bin/bash
#SBATCH -A >>insert_acc_name<<
#SBATCH -J samtools_convert_sam_bam
#SBATCH -p parallel
#SBATCH -N 1
#SBATCH --tasks-per-node 10
#SBATCH -c 4
#SBATCH -C broadwell
#SBATCH -t 30:00:00
#SBATCH -v
#SBATCH -o output_samtools_convert_sam_bam.%j.out
#SBATCH -e error_samtools_convert_sam_bam.%j.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=>>insert_email<<

# Load modules:
module load bio/SAMtools/1.17-GCC-12.2.0

# Manual/ Reference:
# https://davetang.org/wiki/tiki-index.php?page=SAMTools#Converting_a_SAM_file_to_a_BAM_file

# Description:
# BWA aligner creates .sam files; GATK haplotypecaller takes .bam files; -> convert .sam to .bam
# SAM = Sequence Alignment Map; BAM = Binary Alignment Map

# Run task:
for i in ~/projects/acc_name/path/data/sam_files/paired/*sam.gz
do
prefix="$(echo "$i" | cut -d '.' -f 1)"
gzip -cd $i | samtools view -h -o "$prefix".bam
done

for j in ~/projects/acc_name/path/data/sam_files/single/*sam.gz
do
prefix2="$(echo "$j" | cut -d '.' -f 1)"
gzip -cd $j | samtools view -o "$prefix2".bam
done

mv ~/projects/acc_name/path/data/sam_files/paired/*.bam ~/projects/acc_name/path/data/bam_files/paired/

#mv ~/projects/acc_name/path/data/sam_files/single/*.bam ~/projects/acc_name/path/data/bam_files/single/
