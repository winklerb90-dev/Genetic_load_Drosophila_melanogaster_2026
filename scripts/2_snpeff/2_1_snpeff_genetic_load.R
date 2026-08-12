# Filter the genotypes by impact and calculate genetic load.
# This script reproduces the methods published by [Chen et al., 2025] in the study:
# 'Predicted deleterious mutations reveal the genetic architecture of male 
#  reproductive success in a lekking bird'
# Methods: https://zenodo.org/records/17060609?preview_file=rshuhuachen%2Fms_chicks_viability-resubmission.zip
# Especially scripts: 4_calc_load.R & function_calculate_load.R
# Start of script: ----

# Load packages:
library(tidyverse)
library(readr)
library(vroom)

# Import fitness and variant annotation data:
if(!file.exists("C:/path/input/input_file_workspace.RData")) {
  annotations <- read_csv("C:/path/coding_R/data/input/annotations.csv")
  
  fitness_data <- read_csv("C:/path/coding_R/data/input/fitness_data.csv")

  save.image("C:/path/coding_R/data/input/input_file_workspace.RData")
  
} else load("C:/path/coding_R/data/input/input_file_workspace.RData")

# Import the .vcf file which was created in section '1_filter_imputation':
# Ideally, only run once as this import is computationally very expensive
if (!file.exists("C:/Uni Mainz/11. Semester_Master/project_drosophila_selection/coding_R/vcf_workspace.RData")){
  vcf <- vroom("C:/path/coding_R/data/input/plink_output/dgrp2_QC_all_lines_imputed_correct.vcf",
               delim = "\t",
               escape_double = FALSE, 
               trim_ws = TRUE,
               skip = 11) %>% 
    rename(SNP = ID)
  
  save.image("C:/Uni Mainz/11. Semester_Master/project_drosophila_selection/coding_R/vcf_workspace.RData")
} else load("C:/Uni Mainz/11. Semester_Master/project_drosophila_selection/coding_R/vcf_workspace.RData")

# Filter the annotations for high impact variants:
# May look at: 1_snpsift.sh (in Chen et al. supplementary):  ANN[*].IMPACT = 'HIGH' <- specification from original script
# See https://pcingola.github.io/SnpEff/snpeff/inputoutput/ for more details on high impact.
high_annotations <-
  subset(annotations,
         site_class == "CHROMOSOME_LARGE_DELETION" |
           site_class == "CHROMOSOME_LARGE_DUPLICATION" |
           site_class == "CHROMOSOME_LARGE_INVERSION" |
           site_class == "EXON_DELETED" |
           site_class == "EXON_DELETED_PARTIAL" |
           site_class == "EXON_DUPLICATION" |
           site_class == "EXON_DUPLICATION_PARTIAL" |
           site_class == "EXON_INVERSION" |
           site_class == "EXON_INVERSION_PARTIAL" |
           site_class == "FRAME_SHIFT" |
           site_class == "GENE_DELETED" |
           site_class == "GENE_FUSION" |
           site_class == "GENE_FUSION_HALF" |
           site_class == "GENE_FUSION_REVERSE" |
           site_class == "GENE_REARRANGEMENT" |
           site_class == "PROTEIN_PROTEIN_INTERACTION_LOCUS" |
           site_class == "PROTEIN_STRUCTURAL_INTERACTION_LOCUS" |
           site_class == "RARE_AMINO_ACID" |
           site_class == "SPLICE_SITE_ACCEPTOR" | 
           site_class == "SPLICE_SITE_DONOR" |
           site_class == "STOP_LOST" | 
           site_class == "START_LOST" | 
           site_class == "STOP_GAINED" | 
           site_class == "TRANSCRIPT_DELETED")

# Join the high impact variant annotations with the vcf file:
high_annotated_vcf <-
  left_join(high_annotations,
            vcf,
            by="SNP") %>% 
  na.omit(annotated_vcf)

save.image("C:/path/coding_R/workspace_vcf_snpeff_filtered_non_ld.RData")

## Afterwards, you may skip the .vcf import and load directly: ----
load("C:/path/coding_R/workspace_vcf_snpeff_filtered_non_ld.RData")

# Rename: 
annotated_vcf <- high_annotated_vcf  

# Subset the variants by their chromosome type:
annotated_vcf <- annotated_vcf %>% 
  rename("CHROM" = 5) # remove '#' from col as it causes issues

vcf_a <- subset(annotated_vcf, # variants found on autosomes
                CHROM == "1" |
                CHROM == "2" |  
                CHROM == "3" |  
                CHROM == "4" | 
                CHROM == "6")

vcf_x <- subset(annotated_vcf, # variants found on X chrom
                CHROM == "5")

# Write the function to calculate mutational load: 
calculate_load_snpeff <- function(vcf, output_vcf, loadtype){  
  # only get GT info, PL and DP are filtered by already anyway 
  gt <- c(13:ncol(vcf))
  select_n3 <- function(x){x = substr(x,1,3)}
  vcf[gt] <- lapply(vcf[gt], select_n3)
  
  # calculate load
  load <- list()
  # loop over ids
  for( id in 13:(ncol(vcf))){
    # subset per id
    subset_id <- vcf[,c(1:9, id)]
    
    # filter for snps in het and hom
    het_data <- subset(subset_id, subset_id[[10]] == "1/0" | subset_id[[10]] == "0/1")
    hom_data <- subset(subset_id, subset_id[[10]] == "1/1")
    
    # count amount of snps in het and hom
    het_load_sum <- nrow(het_data)
    hom_load_sum <- nrow(hom_data)
    
    # count no of snps successfully genotyped
    n_genotyped <- nrow(subset_id) - nrow(subset(subset_id, subset_id[[10]] == "./."))
    n_total <- nrow(subset_id)
    
    # collect data in df
    df <- data.frame(id = colnames(vcf[id]),
                     n_total = n_total,
                     n_genotyped = n_genotyped,
                     het_load = het_load_sum / n_genotyped,
                     hom_load = hom_load_sum / n_genotyped,
                     total_load = (het_load_sum*0.5 + hom_load_sum) / n_genotyped,
                     loadtype = loadtype)
    load[[id]] <- df
  }
  # convert list to df
  load <- do.call(rbind.data.frame, load)
  
  if(output_vcf == TRUE){
    out <- list(load = load, vcf = vcf)
    return(out)
  }
  
  if(output_vcf==FALSE){
    return(load)}
}

# Run the function and calculate genetic load per chromosome type:
snpeff_load_x <- calculate_load_snpeff(vcf = vcf_x,
                                       loadtype = "high",
                                       output_vcf = FALSE) %>% 
  rename(line = id) %>% 
  mutate(line = as.character(gsub("line", "", line))) %>% # removes 'line'
  mutate(line = as.character(gsub("\\_.*", "", line))) # removes everything after '_'

colnames(snpeff_load_x) <- paste0("x_",
                                  colnames(snpeff_load_x))  # adds "x_" to each header

snpeff_load_x <- snpeff_load_x %>% 
  rename(line = x_line) # rename that for merging

snpeff_load_x <- snpeff_load_x[-c(1), ] # removes the first row, as it breaks the format

snpeff_load_x <- snpeff_load_x %>% 
  mutate(x_total_load_standardised = (x_total_load - mean(x_total_load)) / sd(x_total_load)) # zscore scaling

snpeff_load_a <- calculate_load_snpeff(vcf = vcf_a,
                                       loadtype = "high",
                                       output_vcf = FALSE) %>%  
  rename(line = id) %>% 
  mutate(line = as.character(gsub("line", "", line))) %>% 
  mutate(line = as.character(gsub("\\_.*", "", line)))

colnames(snpeff_load_a) <- paste0("a_",
                                  colnames(snpeff_load_a)) 

snpeff_load_a <- snpeff_load_a %>% 
  rename(line = a_line)

snpeff_load_a <- snpeff_load_a[-c(1), ]

snpeff_load_a <- snpeff_load_a %>% 
  mutate(a_total_load_standardised = (a_total_load - mean(a_total_load)) / sd(a_total_load)) # zscore scaling


snpeff_load_comb <- snpeff_load_a %>% 
  full_join(snpeff_load_x,
            by = "line") %>% 
  mutate(line = as.character(gsub("line", "", line))) 

# Merge per DGRP line with the fitness essays by Wong&Holman:
snpeff_dataset <- merge(fitness_data,
                        snpeff_load_comb,
                        by = "line")

snpeff_dataset <- snpeff_dataset[, c("line", "Trait", "trait_value", "Sex", 
                                     "Life_stage", "a_het_load", "a_hom_load",
                                     "a_total_load", "a_total_load_standardised",
                                     "x_het_load", "x_hom_load",
                                     "x_total_load", "x_total_load_standardised")]

# remove everything but the main dataset and SNP type info:
rm(annotated_vcf, annotations, snpeff_load_a, snpeff_load_comb, snpeff_load_x,
   fitness_data, calculate_load_snpeff)

# Save the final dataset as .csv file 
write.csv(snpeff_dataset,
          "C:/path/coding_R/data/output/datasets/C",
          row.names = FALSE)

# dataset_snpeff_high_impact.csv will be used in sections 4_statistics and 5_visualisation

## Optional, read the dataset: ----
snpeff_dataset <- read.csv("C:/path/coding_R/data/output/datasets/dataset_snpeff_high_impact.csv")

## Optional, Pre-analysis visualisations: ----
(barplot_snps_x <- ggplot() +
    geom_bar(data = vcf_x, # this data may have been removed from workspace in a previous step
             aes(x = as.factor(site_class),
                 fill = site_class),
             stat = "count",
             width = 0.2,
             position = position_nudge(x = 0.2),
             linetype = 2,
             colour = "black") +
    geom_bar(data = vcf_a, # same as above
             aes(x = as.factor(site_class),
                 fill = site_class),
             stat = "count",
             width = 0.2) +
    scale_y_continuous(breaks = c(0, 50, 100, 500, 1000, 2000, 2500)) +
    theme_bw())

(plot_corr <- ggplot(data = subset(snpeff_dataset,
                                   Trait == "fitness.early.life.f"),
                     aes(x = x_total_load_standardised,
                         y = a_total_load_standardised)) +
    geom_point() +
    geom_smooth(method = "lm") +
    xlab("Genetic load on autosomes") +
    ylab("Genetic load on X") +
    theme_bw())


(aut_load_fitness <- ggplot(data = snpeff_dataset,
                            aes(x = a_total_load_standardised,
                                y = trait_value)) +
    geom_point() +
    geom_smooth(method = "lm") +
    facet_wrap(~Trait) +
    xlab("Genetic load on autosomes") +
    ylab("Line mean fitness") +
    theme_bw())

(x_load_fitness <- ggplot(data = snpeff_dataset,
                          aes(x = x_total_load_standardised,
                              y = trait_value)) +
    geom_point() + 
    geom_smooth(method = "lm") +
    facet_wrap(~Trait) +
    xlab("Genetic load on X") + 
    ylab("Line mean fitness") + 
    theme_bw())

# End of script ----
