# **Details on the workflow**
This section takes a genotype and two supplementary files in PLINK format, filters them,
recodes them to a .vcf file, imputes missing data and converts the .vcf file back into the original PLINK formats.
Afterwards, the first two scripts are re-run as a safety check and the final .vcf file can be used for subsequent steps in R. 
The following input files are needed:  
- dgrp2.bed
- dgrp2.bim
- dgrp2.fam

After scripts 1_1 to 1_4 you will end up with files called:
- dgrp2_QC_all_lines_imputed.bed
- dgrp2_QC_all_lines_imputed.bim
- dgrp2_QC_all_lines_imputed.fam

To ensure that everything is correct re-run scripts 1_1 and 1_2 (changing file names is given in #comments at the end of the scripts)
which will give you these final files:
- dgrp2_QC_all_lines_imputed_correct.bed
- dgrp2_QC_all_lines_imputed_correct.bim
- dgrp2_QC_all_lines_imputed_correct.fam
- dgrp2_QC_all_lines_imputed_correct.vcf

Import the .vcf file into local for further steps in RStudio.
