# **Details on the workflow**
In this section the genotypes are merged with annotations and then filtered by their estimated function.
Only those with high impact (as defined by SnpEff) are kept. Afterwards, the genetic load is calculated and then the 
data set is merged with the fitness essays. The following input files are required:
- dgrp2_QC_all_lines_imputed_correct.vcf <-- created in section '1_filter_imputation'
- annotations.csv
- fitness_data.csv

The final data set is used in the sections '4_statistics' and '5_visualisation':
- dataset_snpeff_high_impact.csv
