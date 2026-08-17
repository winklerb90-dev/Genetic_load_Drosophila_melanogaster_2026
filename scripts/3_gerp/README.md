# Details on workflow
In this section multiple alignments are used to compare the neutral substitution rate to the observed substitutions to calculate a rejected substitution (RS) score
per site. As input, MultipleAlignmentFiles (MFA) per chromosome across 123 insect species referenced to *Drosophila melanogaster* were used, 
as well as a matching phylogenetic tree file:
- chr2L.maf.gz, chr2R.maf.gz, chr3L.maf.gz, chr3R.maf.gz, chr4.maf.gz, chrX.maf.gz
- << insert tree file >>

The methods go through various data structuring and formatting steps. The gerpcol command is used to calculate RS scores, but produces genomic locations
(the index of the output file) based on the length of the *D. melanogaster* sequence. Therefore, it is necessary to ensure that the sequence length 
matches the official genome assembly length ([can be found here](https://www.ncbi.nlm.nih.gov/datasets/genome/GCF_000001215.4/)) at every step that. 
Therefore, steps like extra filtering or trimming of NAs have been removed. The final output file of these methods contains the annotations, fitness and 
RS scores per genomic location and will be used in the section '4_statistical_analysis' and '5_misc':
- 
