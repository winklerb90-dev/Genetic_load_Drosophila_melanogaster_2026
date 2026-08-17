# Details on data

The project is based on publically available data. As most of the files are too big to upload, the below links show where to find them:
- dgrp2.bed, dgrp2.bim, dgrp2.bam
  -  genotype calls at biallelic sites (bed), accompanied by two supplementary files (bim, fam)
  -  created by [Mackay et al, 2012](https://pmc.ncbi.nlm.nih.gov/articles/PMC3683990/)
  -  formerly hosted on: http://dgrp.gnets.ncsu.edu/
  -  can be found at: https://web.archive.org/web/20250805002615/http://dgrp.gnets.ncsu.edu/
  -  required for section '1_filter_imputation'
- annotations.csv
  - contains variant annotations for more than 4 million variants
  - created from: http://dgrp2.gnets.ncsu.edu/data/website/dgrp.fb557.annot.txt &
    https://bioconductor.org/packages/release/data/annotation/html/org.Dm.eg.db.html
  - required for sections '2_snpeff' and '3_gerp'
- fitness_data.csv
  - line mean fitness measurements from early- and late-life male and female flies
  - created by [Wong & Holman, 2023](https://academic.oup.com/evolut/article/77/12/2642/7279223)
  - required for sections '2_snpeff' and '3_gerp'
-   chr2L.maf.gz, chr2R.maf.gz, chr3L.maf.gz, chr3R.maf.gz, chr4.maf.gz, chrX.maf.gz
    - contain multiple alignments across 123 insect species referenced to *Drosophila Melanogaster* per chromosome
    - can be found at [UCSC multiz124way](https://hgdownload.soe.ucsc.edu/goldenPath/dm6/multiz124way/maf/)
    - required for section '3_gerp'
- dm6.124way.sequenceNames.nh
    - phylogenetic tree in newick format matching the .maf files above
    - can be found at [UCSC multiz124way](https://hgdownload.soe.ucsc.edu/goldenPath/dm6/multiz124way/)
    - > tr -d '\r\n' <dm6.124way.sequenceNames.nh> flat_dm6.124way.sequenceNames.nh.txt # converts into one line text file
    - required for section '3_gerp'
