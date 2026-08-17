The scripts have been written for Unix and R and are structured as followed:

1. Filtering and imputation of genotypes with PLINK and Beagle (Unix)
2. Estimating impact of variants with SnpEff and calculating genetic load (R)
3. Calculating rejected substitutions with GERP++ and calculating genetic load (Unix/R)
4. Statistical analysis with brms (R)
5. Miscellaneous (R)

The script 'conda_packages.sh' shows how to activate a conda environment and load the required packages in a slurm environment.  
  
The attic directory contains scripts which have been dismissed at some point during the project but are functional otherwise (like alignments of DGRP fasta files).
