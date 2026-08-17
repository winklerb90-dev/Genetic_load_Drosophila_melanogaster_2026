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
- dataset_gerp_method.csv

# Some notes on GERP++
The documentation on GERP++ is very scarce. An online tool is provided by [UCSC](https://genome.ucsc.edu/cgi-bin/hgTrackUi?db=hg19&g=allHg19RS_BW) but the
[official documentation](http://mendel.stanford.edu/sidowlab/downloads/gerp/index.html) is dead. An archived version can be found 
[here](https://web.archive.org/web/20240520010334/http://mendel.stanford.edu/sidowlab/downloads/GERP/index.html). Note, that there seems to be a bugged version
as mentioned by [tvkent](https://github.com/tvkent/GERPplusplus), but using either the [Bioconda](https://anaconda.org/bioconda/gerp) or the debugged one didnt
seem to effect anything but runtime (fixed version using V1 and being much slower compared to Bioconda V2 version). Also, when using the gerpelem command 
the output file will have more columns than what the manual suggests. This has been adressed in forums but I havent found an official explanation. 
