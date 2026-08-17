# Original code from Tom Keaney's github: https://github.com/tomkeaney
# DGRP variant annotations were downloaded from the [DGRP website](http://dgrp2.gnets.ncsu.edu/data/website/dgrp.fb557.annot.txt) and gene annotations for all the genes covered by DGRP variants, from the `org.Dm.eg.db` database object from `Bioconductor`.
# These will be useful later when we aim to identify whether variants with notable associations with a trait overlap with any genes.

# Helper function to split a vector into chunks 
chunker <- function(x, max_chunk_size) split(x, ceiling(seq_along(x) / max_chunk_size))

if(!file.exists("data/derived/annotations.csv")){
  
  # Load annotation file, get important info
  
  annot <- read.table("data/input/dgrp.fb557.annot.txt", header = FALSE, stringsAsFactors = FALSE)
  
  get.info <- function(rows){
    lapply(rows, function(row){
      site.class.field <- strsplit(annot$V3[row], split = "]")[[1]][1]
      num.genes <- str_count(site.class.field, ";") + 1
      output <- cbind(rep(annot$V1[row], num.genes), 
                      do.call("rbind", lapply(strsplit(site.class.field, split = ";")[[1]], 
                                              function(x) strsplit(x, split = "[|]")[[1]])))
      if(ncol(output) == 5) return(output[,c(1,2,4,5)]) # only return SNPs that have some annotation. Don't get the gene symbol
      else return(NULL)
    }) %>% do.call("rbind", .)
  }
  
  variant.details <- lapply(chunker(1:nrow(annot), max_chunk_size = 10000), get.info) %>% 
    do.call("rbind", .) %>% as.data.frame()
  
  names(variant.details) <- c("SNP", "FBID", "site.class", "distance.to.gene")
  variant.details$FBID <- unlist(str_extract_all(variant.details$FBID, "FBgn[:digit:]+")) # clean up text strings for Flybase ID
  variant.details %>%
    dplyr::filter(site.class != "FBgn0003638") %>% # NB this is a bug in the DGRP's annotation file
    mutate(chr = str_remove_all(substr(SNP, 1, 2), "_")) # get chromosome now for faster sorting later
  
  annotations <- variant.details
} else annotations <- read_csv("data/derived/annotations.csv")

annotations <-
  annotations %>% 
  left_join(read.csv("data/Input/all_dmel_genes.csv")) %>% 
  dplyr::select(SNP, FBID, site.class, distance.to.gene, gene_name, chromosome)
