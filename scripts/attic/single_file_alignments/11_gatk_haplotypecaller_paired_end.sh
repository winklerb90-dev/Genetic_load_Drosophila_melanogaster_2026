#!/bin/bash
#SBATCH -A >>insert_acc_name
#SBATCH -J gatk_haplotypecaller_paired_end
#SBATCH -p parallel
#SBATCH -n 1
#SBATCH -c 1
#SBATCH -C skylake
#SBATCH -t 01:00:00
#SBATCH -v
#SBATCH -o output_gatk_haplotypecaller_paired_end.%j.out
#SBATCH -e error_gatk_haplotypecaller_paired_end.%j.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=>>insert_email<<

# Load modules:
module load bio/GATK/4.6.0.0-GCCcore-13.3.0-Java-17.0.1

# Manual/ Reference:
# https://gatk.broadinstitute.org/hc/en-us/articles/360037225632-HaplotypeCaller

# Description
# Determination of putative haplotypes per chromosome/ genotype per loci -> ~ differences in sample against reference

# Run task:
reference="$HOME/projects/acc_name/path/data/reference_assembly/Drosophila_melanogaster.BDGP6.54.dna.toplevel.fa"

for i in ~/projects/acc_name/path/data/bam_files/paired/with_rg/*_sorted.bam

do

prefix="$(echo "$i" | cut -d '.' -f 1)"

gatk --java-options "-Xmx32g" HaplotypeCaller \
        -R "$reference" \
        -I "$i" \
        -O "$prefix".vcf.gz \
        --verbosity INFO \
	--max-alternate-alleles 1
#        --native-pair-hmm-threads 32 \
#        --max-alternate-alleles 1 \
#        --dont-use-soft-clipped-bases true
done

mv ~/projects/acc_name/path/data/bam_files/paired/with_rg/*.vcf.gz ~/projects/acc_name/path/data/vcf_files/paired/
