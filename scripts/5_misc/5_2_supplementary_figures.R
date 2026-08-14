# Supplementary plots to show composition of variants and gerp scores
# Start of the script: ----

# Load packages:
library(tidyverse)
library(patchwork)


## Bar plots: ----
### SnpEff Data: ----
# load the data:
load("C:/Uni Mainz/11. Semester_Master/project_drosophila_selection/coding_R/vcf_workspace.RData")
annotations <- read_csv("C:/Uni Mainz/11. Semester_Master/project_drosophila_selection/coding_R/data/output/annotations.csv")

 # Remove unnecessary columns:
cut_ann <- annotations[1:3]

cut_vcf <- vcf[1:3]

# Rename for merging and to remove '#' from chrom col:
colnames(cut_vcf) <- c("chrom_number","pos", "SNP")

# Join the two dfs:
ann_vcf <- left_join(cut_vcf,
                     cut_ann,
                     by = "SNP",
                     keep = FALSE) %>% 
  na.omit(ann_vcf)

# Re-factor anns and chrom:
ann_vcf$chrom_number <- as.factor(ann_vcf$chrom_number)
ann_vcf$site_class <- as.factor(ann_vcf$site_class)

# Assign impact level:
# https://pcingola.github.io/SnpEff/snpeff/inputoutput/
ann_vcf <- ann_vcf %>% 
  mutate(impact = case_when(
    site_class %in% c("CHROMOSOME_LARGE_DELETION", 
                      "CHROMOSOME_LARGE_DUPLICATION", 
                      "CHROMOSOME_LARGE_INVERSION",
                      "EXON_DELETED",
                      "EXON_DELETED_PARTIAL",
                      "EXON_DUPLICATION",
                      "EXON_DUPLICATION_PARTIAL",
                      "EXON_INVERSION",
                      "EXON_INVERSION_PARTIAL",
                      "FRAME_SHIFT",
                      "GENE_DELETED",
                      "GENE_FUSION",
                      "GENE_FUSION_HALF",
                      "GENE_FUSION_REVERSE",
                      "GENE_REARRANGEMENT" ,
                      "PROTEIN_PROTEIN_INTERACTION_LOCUS",
                      "PROTEIN_STRUCTURAL_INTERACTION_LOCUS",
                      "RARE_AMINO_ACID",
                      "SPLICE_SITE_ACCEPTOR",
                      "SPLICE_SITE_DONOR",
                      "STOP_LOST",
                      "START_LOST",
                      "STOP_GAINED","TRANSCRIPT_DELETED") ~ "high",
    site_class %in% c("CODON_INSERTION",
                      "CODON_CHANGE_PLUS CODON_INSERTION",
                      "CODON_DELETION",
                      "CODON_CHANGE_PLUS CODON_DELETION",
                      "GENE_DUPLICATION",
                      "NON_SYNONYMOUS_CODING",
                      "SPLICE_SITE_BRANCH_U12",
                      "UTR_5_DELETED",
                      "NEXT_PROT",
                      "TRANSCRIPT_DUPLICATION",
                      "GENE_INVERSION",
                      "TRANSCRIPT_INVERSION") ~ "moderate",
    site_class %in% c("CODON_CHANGE",
                      "NON_SYNONYMOUS_START",
                      "NON_SYNONYMOUS_STOP",
                      "SPLICE_SITE_REGION",
                      "SPLICE_SITE_BRANCH",
                      "START_GAINED",
                      "SYNONYMOUS_CODING",
                      "SYNONYMOUS_START",
                      "SYNONYMOUS_STOP",
                      "MOTIF",
                      "MOTIF_DELETED",
                      "FEATURE_FUSION") ~ "low",
    site_class %in% c("CDS",
                      "DOWNSTREAM",
                      "EXON",
                      "GENE",
                      "INTERGENIC",
                      "INTERGENIC_CONSERVED",
                      "INTRAGENIC",
                      "INTRON",
                      "INTRON_CONSERVED",
                      "MICRO_RNA",
                      "TRANSCRIPT",
                      "REGULATION",
                      "UPSTREAM",
                      "UTR_3_PRIME",
                      "UTR_3_DELETED",
                      "UTR_5_PRIME",
                      "FRAME_SHIFT_BEFORE_CDS_START",
                      "FRAME_SHIFT_AFTER_CDS_END",
                      "CHROMOSOME_ELONGATION") ~ "modifier")) %>% 
  na.omit(ann_vcf)

Ann_vcf <- ann_vcf %>% 
  mutate(chrom_type = case_when(
    chrom_number == "5" ~ "X",
    chrom_number %in% c("1", "2", "3", "4", "6") ~ "Autosome"))

# Source - https://stackoverflow.com/a/5210833; Posted by Gavin Simpson, modified by community. See post 'Timeline' for change history; Retrieved 2026-07-08, License - CC BY-SA 4.0
# Set the levels of annotations to decrease with level size:
ann_vcf <- within(ann_vcf,
                  site_class <- factor(site_class,
                                       levels=names(sort(table(site_class),
                                                         decreasing=TRUE))))
ann_vcf <- within(ann_vcf,
                  impact <- factor(impact,
                                   levels=names(sort(table(impact),
                                                     decreasing=TRUE))))

# Visualisation: 
(barplot_anns_impact <- ggplot(data = ann_vcf,
                               aes(x = impact,
                                   fill = ifelse(impact == "high", chrom_type, "grey"))) +
    geom_bar(position = position_dodge(width = 1)) +
    scale_y_log10(breaks = NULL) +
    geom_text(stat = "count",
              aes(label = after_stat(count)),
      position = position_dodge(width = 1),
      color = "black",
      hjust = 3) +
    coord_flip() +
    scale_fill_manual(name = "Chromosome type and impact:",
                      values = c("#794E9A", "darkgrey", "#007967"),
                      labels = c("Autosome", "Low or moderate impact or modifier", "X Chromosome")) +
    ggtitle("A. Number of variants per functional impact class.") +
    xlab("SnpEff impact category") +
    ylab("log10 (Number of variants)") +
    theme_bw() +
    theme(legend.position = c(0.8, 0.9),
          legend.background = element_rect(colour = "black"),
          text = element_text(size = 10)))

(barplot_anns_anns <- ggplot(data = ann_vcf,
                             aes(x = site_class,
                                 fill = ifelse(impact == "high", chrom_type, "grey"))) +
    geom_bar(position = position_dodge(width = 1)) +
    scale_y_log10(breaks = NULL) +
    geom_text(stat = "count",
              aes(label = after_stat(count)),
              position = position_dodge(1),
              color = "black",
              hjust = 3) +
    scale_fill_manual(name = "Impact and chromosome:",
                      values = c("#794E9A", "darkgrey", "#007967"),
                      labels = c("High Impact, Autosome", "Low or moderate impact or modifier", "High Impact, X Chromosome")) +
    ggtitle("B. Number of variant types located on the X chromosome and autosomes.") +
    xlab("SnpEff variant type") +
    ylab("log10 (Number of variants)") +
    coord_flip() +
    theme_bw() +
    theme(axis.text.y = element_text(angle = 30, vjust = 0.5, hjust=1),
         legend.position = c(0.8, 0.9),
         legend.background = element_rect(colour = "black"),  
         text = element_text(size = 10)))


(upper_row_barplots <- ((barplot_anns_impact) / (barplot_anns_anns)) +
    plot_layout(axis_titles = "collect_x",
                ncol = 2))

ggsave(filename = "C:/path/coding_R/data/plots/supplementary/barplots_snpeff.png",
       plot = upper_row_barplots, width = 14, height = 8, units = "in", dpi = 300)

# Optional, save plot as workspace because dfs take long to load:
rm(ann_vcf, annotations, barplot_anns_anns, barplot_anns_impact, cut_ann,
   cut_vcf, vcf)

save.image("C:/path/coding_R/data/plots/supplementary/workspace_upper_barplots.RData")

### Gerp Data: ----
# Load data:
stacked_gerp_rates <- read.csv("C:/path/coding_R/data/input/intersection_tsv_files/stacked_gerp_rates_intersection.csv") 

cut_gerp_df <- stacked_gerp_rates[1:6]

colnames(cut_gerp_df) <- c("index", "chrom_number", "start", "pos", "neutral rate", "RS")

cut_gerp_df$chrom_number <- as.factor(cut_gerp_df$chrom_number)

cut_gerp_df <- cut_gerp_df %>% 
  mutate(chrom_type = case_when(
    chrom_number == "5" ~ "X",
    chrom_number %in% c("1", "2", "3", "4", "6") ~ "Autosome"))

x_higherequal_4 <- subset(cut_gerp_df,
                          chrom_type == "X" & RS >= 4) # 196.374

autosomes_higherequal_4 <- subset(cut_gerp_df,
                                  chrom_type == "Autosome" & RS >= 4) # 1.302.241

(barplot_gerp_scores <- ggplot(data = cut_gerp_df) +
    geom_density(aes(x = RS,
                     colour = chrom_type),
                 linewidth = 1) +
    geom_vline(xintercept = 4,
               linetype = "dashed",
               linewidth = 1) +
    scale_colour_manual(name = "Chromosome type:",
                      values = c("#794E9A", "#007967"),
                      labels = c("Autosomes", "X Chromosome")) +
    ggtitle("Distribution of rejected substitution scores") +
    xlab("Rejected substitution score") +
    ylab("Density") +
    theme_bw() +
    theme(text = element_text(size = 15)))

ggsave(filename = "C:/path/coding_R/data/plots/supplementary/density_plot_gerp.png",
       plot = barplot_gerp_scores, width = 14, height = 8, units = "in", dpi = 300)

# Optional, histogram:
# Think its the worse option here, cuz of data size difference
(barplot_gerp_scores <- ggplot(data = cut_gerp_df) +
    geom_histogram(aes(x = RS,
                     fill = chrom_type),
                 stat = "bin") +
    geom_vline(xintercept = 4,
               linetype = "dashed",
               linewidth = 1) +
    scale_fill_manual(name = "Chromosome type:",
                        values = c("#794E9A", "#007967"),
                        labels = c("Autosomes", "X Chromosome")) +
    xlab("Rejected substitution score") +
    ylab("Density") +
    theme_bw() +
    theme(text = element_text(size = 15)))

## Box plots: ----
### SnpEff data: ----
snpeff_dataset <- read.csv("C:/Uni Mainz/11. Semester_Master/project_drosophila_selection/coding_R/data/output/datasets/dataset_chen_method.csv")

# subset per filter type and scaled/unscaled:
snpeff_subset_non_stand <- snpeff_dataset %>% 
  select(a_total_load, x_total_load) %>% 
  pivot_longer(cols = c(a_total_load, x_total_load), 
               names_to = "chromosome",
               values_to = "genetic_load")

snpeff_subset_stand <- snpeff_dataset %>% 
  select(a_total_load_standardised, x_total_load_standardised) %>% 
  pivot_longer(cols = c(a_total_load_standardised, x_total_load_standardised), 
               names_to = "chromosome",
               values_to = "genetic_load")

# Create the box plots:
(boxplot_snpeff_non_stand <- ggplot(data = snpeff_subset_non_stand) +
    geom_boxplot(aes(x = chromosome,
                     y = genetic_load,
                     fill = chromosome),
                 show.legend = FALSE) +
    scale_fill_manual(values = c("#794E9A", "#007967")) +
    xlab("") +
    ylab("Genetic load") +
    scale_x_discrete(labels = c("Autosomes", "X chromosome")) +
    ggtitle(" A. Genetic load [SnpEff, unscaled]") +
    theme_bw() +
    theme(text = element_text(size = 15)))

(boxplot_snpeff_stand <- ggplot(data = snpeff_subset_stand) +
    geom_boxplot(aes(x = chromosome,
                     y = genetic_load,
                     fill = chromosome),
                 show.legend = FALSE) +
    scale_fill_manual(values = c("#794E9A", "#007967")) +
    xlab("") +
    ylab("Genetic load [z-score]") +
    scale_x_discrete(labels = c("Autosomes", "X chromosome")) +
    ggtitle(" B. Genetic load [SnpEff, scaled]") +
    theme_bw() +
    theme(text = element_text(size = 15)))

### Gerp data: ----
gerp_dataset <- read.csv("C:/Uni Mainz/11. Semester_Master/project_drosophila_selection/coding_R/data/output/datasets/dataset_gerp_method.csv")

# Subset per filter type and scaled/unscaled:
gerp_subset_non_stand <- gerp_dataset %>% 
  select(a_total_load, x_total_load) %>% 
  pivot_longer(cols = c(a_total_load, x_total_load), 
               names_to = "chromosome",
               values_to = "genetic_load") 

gerp_subset_non_stand <- subset(gerp_subset_non_stand,
                                genetic_load != 0) # remove line 21 outlier

gerp_subset_stand <- gerp_dataset %>% 
  select(a_total_load_standardised, x_total_load_standardised) %>% 
  pivot_longer(cols = c(a_total_load_standardised, x_total_load_standardised), 
               names_to = "chromosome",
               values_to = "genetic_load")

gerp_subset_stand <- subset(gerp_subset_stand,
                            genetic_load > -10) # remove line 21 outlier

# Create the box plots:
(boxplot_gerp_non_stand <- ggplot(data = gerp_subset_non_stand) +
    geom_boxplot(aes(x = chromosome,
                     y = genetic_load,
                     fill = chromosome),
                 show.legend = FALSE) +
    scale_fill_manual(values = c("#794E9A", "#007967")) +
    xlab("") +
    ylab("Genetic load") +
    scale_x_discrete(labels = c("Autosomes", "X chromosome")) +
    ggtitle(" C. Genetic load [GERP, unscaled]") +
    theme_bw() +
    theme(text = element_text(size = 15)))

(boxplot_gerp_stand <- ggplot(data = gerp_subset_stand) +
    geom_boxplot(aes(x = chromosome,
                     y = genetic_load,
                     fill = chromosome),
                 show.legend = FALSE) +
    scale_fill_manual(values = c("#794E9A", "#007967")) +
    xlab("") +
    ylab("Genetic load [z-score]") +
    scale_x_discrete(labels = c("Autosomes", "X chromosome")) +
    ggtitle(" D. Genetic load [GERP, scaled]") +
    theme_bw() +
    theme(text = element_text(size = 15)))

# Combine the plots:
(left_boxplots <- ((boxplot_snpeff_non_stand) / (boxplot_gerp_non_stand)) +
    plot_layout(axis_titles = "collect_y",
                ncol = 1))

(right_boxplots <- ((boxplot_snpeff_stand) / (boxplot_gerp_stand)) +
    plot_layout(axis_titles = "collect_y",
                ncol = 1))

(comb_boxplots <- (left_boxplots | right_boxplots))


ggsave(filename = "C:/path/coding_R/data/plots/comb_boxplots.png",
       plot = comb_boxplots, width = 14, height = 8, units = "in", dpi = 300)
 
# End of script ---- 
