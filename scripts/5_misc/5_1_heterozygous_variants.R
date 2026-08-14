# Examining the occurence of heterozygous variants
# Comparison of homozygosity in variants when looking in:
# all - putatively deleterious and only putatively deleterious
# Start of script: ----

# Load package:
library(tidyverse)

## Import fitness and variant annotation data: ----
if(!file.exists("C:/path/coding_R/data/input/analysis_deleterious_variants/input_file_workspace.RData")) {
  annotations <- read_csv("C:/path/coding_R/data/output/annotations.csv")
  
  fitness_data <- read_csv("C:/path/coding_R/data/input/fitness_data.csv")
  
  
  save.image("C:/path/coding_R/data/input/analysis_deleterious_variants/input_file_workspace.RData")
  
} else load("C:/path/coding_R/data/input/analysis_deleterious_variants/input_file_workspace.RData")

 write.csv(vcf,
          "C:/path/coding_R/data/output/datasets/vcf_unaltered.csv",
          row.names = FALSE)
 
# Load the vcf file:
vcf <- read.csv("C:/path/coding_R/data/output/datasets/vcf_unaltered.csv")

load("C:/path/coding_R/vcf_workspace.RData")

vcf <- vcf %>% 
  rename("CHROM" = 1)

## filter for high impact variants: -----
# Taken from 1_snpsift.sh script (Chen et al supplementary)
# See https://pcingola.github.io/SnpEff/snpeff/inputoutput/ for more details on high impact
# ANN[*].IMPACT = 'HIGH' <- specification from original script
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

all_annotations <-
  filter(annotations,
         site_class != "CHROMOSOME_LARGE_DELETION" &
           site_class != "CHROMOSOME_LARGE_DUPLICATION" &
           site_class != "CHROMOSOME_LARGE_INVERSION" &
           site_class != "EXON_DELETED" &
           site_class != "EXON_DELETED_PARTIAL" &
           site_class != "EXON_DUPLICATION" &
           site_class != "EXON_DUPLICATION_PARTIAL" &
           site_class != "EXON_INVERSION" &
           site_class != "EXON_INVERSION_PARTIAL" &
           site_class != "FRAME_SHIFT" &
           site_class != "GENE_DELETED" &
           site_class != "GENE_FUSION" &
           site_class != "GENE_FUSION_HALF" &
           site_class != "GENE_FUSION_REVERSE" &
           site_class != "GENE_REARRANGEMENT" &
           site_class != "PROTEIN_PROTEIN_INTERACTION_LOCUS" &
           site_class != "PROTEIN_STRUCTURAL_INTERACTION_LOCUS" &
           site_class != "RARE_AMINO_ACID" &
           site_class != "SPLICE_SITE_ACCEPTOR" & 
           site_class != "SPLICE_SITE_DONOR" &
           site_class != "STOP_LOST" &
           site_class != "START_LOST" & 
           site_class != "STOP_GAINED" & 
           site_class != "TRANSCRIPT_DELETED")

# Join the impact variant annotations with the vcf file:
high_annotated_vcf <-
  left_join(high_annotations,
            vcf,
            by="SNP") %>% 
  na.omit(annotated_vcf)

all_annotated_vcf <- 
  left_join(all_annotations,
            vcf,
            by="SNP") %>% 
  na.omit(annotated_vcf)

write.csv(high_annotated_vcf,
          "C:/path/coding_R/data/output/datasets/vcf_high_snpeff_filter.csv",
          row.names = FALSE)

high_vcf <- read.csv("C:/path/coding_R/data/output/datasets/vcf_high_snpeff_filter.csv")

high_vcf <- high_vcf %>% 
  rename("Alt" = 8) %>% 
  rename("Chrom" = 5)

## Function to create a new df which only tracks the heterozygous genotypes: ----
track_het <- function(vcf){
  
  het_count <- c() # empty chain to track het occurrences

  het_lines <- c() # empty chain to track lines with het occurrences

  for (cell in 13:ncol(vcf)){
    n_het <- sum(vcf[[cell]] == "1/0" | 
                 vcf[[cell]] == "0/1",
                 na.rm= TRUE)
  
  if (n_het > 0) {
    het_lines <- c(het_lines, names(vcf)[cell])
    het_count <- c(het_count, n_het)
  }
}

  het_vcf <- vcf[, het_lines, drop = FALSE]

  count_vcf <- data.frame(column = het_lines,
                          yes_count = n_het)

  temp_df <- vcf[, c(1:12, 
                     match(het_lines,
                     names(vcf))),
                 drop = FALSE]

  het_variants <- temp_df %>% 
    pivot_longer(cols = 12:ncol(temp_df),
                 names_to = "line",
                 values_to = "genotype") %>% 
    filter(genotype == "1/0" | genotype == "0/1")
  
  return(het_variants)
}

high_het_variants <- track_het(high_vcf)
list_ids_high <- c(high_het_variants$FBID)

all_het_variants <- track_het(vcf)
 
## Skip the above and load the df directly: ----
# High impact and low + moderate impact 
high_het_variants <- read.csv("C:/path/coding_R/data/output/heterozygous_sites/high_het_variants.csv")

low_het_variants <- read.csv("C:/path/coding_R/data/output/heterozygous_sites/low_mod_het_variants.csv")


# Create chromosome type column and stack both dfs:
high_het_variants <- high_het_variants %>% 
  mutate(chrom_type = case_when(
         X.CHROM == "5" ~ "X",
         X.CHROM %in% c("1", "2", "3", "4", "6") ~ "Autosome")) %>% 
  select("SNP", "site_class","POS", "REF", "CHROM", "line", "genotype", "chrom_type") %>% 
  rename(ALT = CHROM)

high_het_variants$impact <- "high"

low_het_variants <- low_het_variants %>% 
  mutate(chrom_type = case_when(
         X.CHROM == "5" ~ "X",
         X.CHROM %in% c("1", "2", "3", "4", "6") ~ "Autosome")) %>% 
  select("SNP", "site_class","POS", "REF", "ALT", "line", "genotype", "chrom_type")

low_het_variants$impact <- "low or moderate"

stacked_het_variants <- rbind(high_het_variants,
                              low_het_variants)

## Visualise the heterozygous genotypes: ----
(bar_plot_het_sites <- ggplot(data = stacked_het_variants,
                              aes(x = impact,
                                  fill = chrom_type)) +
   geom_bar(stat = "count",
            position = "dodge",
            width = 0.5) +
   geom_text(stat = "count",
             aes(label = after_stat(count)),
             position = position_dodge(width = 0.5),
             color = "black",
             vjust = -0.5) +
   scale_fill_manual(name = "Chromosome type:",
                     values = c("#794E9A", "#007967"),
                     labels = c("Autosomes", "X Chromosome")) +
   ggtitle("Number of heterozygous genotypes") +
   xlab("SnpEff impact category") +
   ylab("Count [log10]") +
   theme_bw() +
   scale_y_log10(breaks = c(0, 10, 100, 1000, 2000, 3000)) +
   theme_bw() +
   theme(legend.position = c(0.3, 0.8),
         legend.background = element_rect(colour = "black"),
         text = element_text(size = 15)))

ggsave(filename = "C:/path/coding_R/data/plots/barplots_heterozygous_sites.png",
       plot = bar_plot_het_sites,
       width = 14, height = 8, units = "in", dpi = 300)

# End of script ----
