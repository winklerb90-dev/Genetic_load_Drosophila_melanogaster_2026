#!/bin/bash
#SBATCH -A >>insert_account_name<<
#SBATCH -J snpeff_annotation
#SBATCH -p parallel
#SBATCH -n 1
#SBATCH -c 1
#SBATCH -C skylake
#SBATCH -t 00:20:00
#SBATCH -v
#SBATCH -o output_snpeff_annotation.%j.out
#SBATCH -e error_snpeff_annotation.%j.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=>>insert_email<<

# Load modules:
module load lang/Anaconda3/2023.03
module load bio/BCFtools/1.14-GCC-11.2.0

# Activate conda
eval "$(conda shell.bash hook)"
conda activate snpeff_env # make sure snpeff is pre compiled

# Manual/ Reference:
# https://pcingola.github.io/SnpEff/snpeff/running/

# Description:
# Annotation of variants via SnpEff

# Run task:
for i in ~/projects/acc_name/path/data/vcf_files/paired/*vcf.gz

do

prefix="$(echo "$i" | cut -d '_' -f 1-6)"

java -jar -Xmx16g ~/projects/acc_name/path/data/snpeff_files/snpEff/snpEff.jar BDGP6.115 $i > "$prefix".ann.vcf \
	-noStats
#	-stats "$prefix" doesnt produce correct .html files

done

mv ~/projects/acc_name/path/data/vcf_files/paired/*.ann.vcf ~/projects/acc_name/path/data/annotation_files/
# mv ~/projects/acc_name/path/data/vcf_files/paired/*html ~/projects/acc_name/path/data/annotation_files/
# mv ~/projects/acc_name/path6/data/vcf_files/paired/*genes.txt ~/projects/acc_name/path/data/annotation_files/
