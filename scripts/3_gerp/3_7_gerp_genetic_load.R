# Calculate genetic load based on GERP++ rejected substitution rates
# Takes intersection .tsv files of .rates and .vcf as input.
# Based on the script from :"Predicted deleterious mutations reveal the genetic
# architecture of male reproductive success in a lekking bird", Chen et al. 2024
# Start of script ----

# load packages:
library(tidyverse)
library(vroom)

# load data:
if (!file.exists("C:/Uni Mainz/11. Semester_Master/project_drosophila_selection/coding_R/data/input/intersection_tsv_files/stacked_gerp_rates_intersection.csv")){
gerp_rates_intersection_chr_X <- vroom("C:/Uni Mainz/11. Semester_Master/project_drosophila_selection/coding_R/data/input/intersection_tsv_files/gerp_rates_intersection_chr_X.tsv.gz", 
                                       delim = "\t", escape_double = FALSE,
                                       col_names = FALSE, trim_ws = TRUE)

gerp_rates_intersection_chr_2L <- vroom("C:/Uni Mainz/11. Semester_Master/project_drosophila_selection/coding_R/data/input/intersection_tsv_files/gerp_rates_intersection_chr_2L.tsv.gz", 
                                             delim = "\t", escape_double = FALSE, 
                                             col_names = FALSE, trim_ws = TRUE)

gerp_rates_intersection_chr_2R <- vroom("C:/Uni Mainz/11. Semester_Master/project_drosophila_selection/coding_R/data/input/intersection_tsv_files/gerp_rates_intersection_chr_2R.tsv.gz", 
                                        delim = "\t", escape_double = FALSE, 
                                        col_names = FALSE, trim_ws = TRUE)

gerp_rates_intersection_chr_3L <- vroom("C:/Uni Mainz/11. Semester_Master/project_drosophila_selection/coding_R/data/input/intersection_tsv_files/gerp_rates_intersection_chr_3L.tsv.gz", 
                                        delim = "\t", escape_double = FALSE, 
                                        col_names = FALSE, trim_ws = TRUE)

gerp_rates_intersection_chr_3R <- vroom("C:/Uni Mainz/11. Semester_Master/project_drosophila_selection/coding_R/data/input/intersection_tsv_files/gerp_rates_intersection_chr_3R.tsv.gz", 
                                        delim = "\t", escape_double = FALSE, 
                                        col_names = FALSE, trim_ws = TRUE)

gerp_rates_intersection_chr_4 <- vroom("C:/Uni Mainz/11. Semester_Master/project_drosophila_selection/coding_R/data/input/intersection_tsv_files/gerp_rates_intersection_chr_4.tsv.gz", 
                                        delim = "\t", escape_double = FALSE, 
                                        col_names = FALSE, trim_ws = TRUE)

stacked <- rbind(gerp_rates_intersection_chr_2L, gerp_rates_intersection_chr_2R,
                 gerp_rates_intersection_chr_3L, gerp_rates_intersection_chr_3L,
                 gerp_rates_intersection_chr_4, gerp_rates_intersection_chr_X)

write.csv(stacked,
          "C:/Uni Mainz/11. Semester_Master/project_drosophila_selection/coding_R/data/input/intersection_tsv_files/stacked_gerp_rates_intersection.csv")


} else read.csv("C:/Uni Mainz/11. Semester_Master/project_drosophila_selection/coding_R/data/input/intersection_tsv_files/stacked_gerp_rates_intersection.csv") -> stacked_gerp_rates 

fitness_data <- read_csv("Uni Mainz/11. Semester_Master/project_drosophila_selection/coding_R/data/input/fitness_data.csv")

fitness_data_lines <- as.list(read.delim2("C:/Uni Mainz/11. Semester_Master/project_drosophila_selection/coding_R/data/input/fitness_data_lines.txt",
                                          header=FALSE))

# preliminary stats:
#mean(gerp_rates_intersection_chr_X$X5) # 3.630922
#mean(gerp_rates_intersection_chr_2L$X5) # -0.08796867
#mean(gerp_rates_intersection_chr_2R$X5) # 4.378943
#mean(gerp_rates_intersection_chr_3L$X5) # 3.030476
#mean(gerp_rates_intersection_chr_3R$X5) # 4.704694
#mean(gerp_rates_intersection_chr_4$X5) # 1.348679

#(density_test <- ggplot(data = stacked) +
#    geom_density(aes(x = X5,
#                     fill = X1,
#                     alpha = 0.5)))

# set chromosome number as factor:
stacked_gerp_rates$X1 <- as.factor(stacked_gerp_rates$X1)


# subset by chromosome type + gerp score >= 4:
x_gerp_scores <- subset(stacked_gerp_rates,
                        X1 == "5") 
x_gerp_scores_higherequal4 <- subset(x_gerp_scores,
                                     X5 >= 4)

autosomes_gerp_scores <- subset(stacked_gerp_rates,
                                X1 == "1" |
                                  X1 == "2" |
                                  X1 == "3" |  
                                  X1 == "4" |
                                  X1 == "6")
autosomes_gerp_scores_higherequal4 <- subset(autosomes_gerp_scores,
                                             X5 >= 4)



# calculate genetic load function:
calculate_load_gerp <- function(vcf, output_vcf){
  names(vcf)[1:11] <- c("chr", "start", "pos", "neutral_rate_n", "rs_score", "ref", "alt", "qual", "info","format")
  names(vcf)[12:216] <- unlist(fitness_data_lines)
  
  # only get GT info, PL and DP are filtered by already anyway 
  gt <- c(12:ncol(vcf)) 
  select_n3 <- function(x){x = substr(x,1,3)}
  vcf[gt] <- lapply(vcf[gt], select_n3)
  
  # calculate load
  load <- list()
  # loop over ids
  for( id in 12:(ncol(vcf))){ 
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
                     total_load = (het_load_sum*0.5 + hom_load_sum) / n_genotyped)
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

# create gerp load data for X chromosome: ----
gerp_load_x <- calculate_load_gerp(x_gerp_scores_higherequal4, FALSE) %>% 
  rename(line = id)

colnames(gerp_load_x) <- paste0("x_",
                                colnames(gerp_load_x))  # adds "x_" to each header

gerp_load_x <- gerp_load_x %>% 
  rename(line = x_line) # rename that for merging

# check below first if necessary:
# chen_load_x <- chen_load_x[-c(1), ] # removes the first row, as it breaks the format

gerp_load_x <- gerp_load_x %>% 
  mutate(x_total_load_standardised = (x_total_load - mean(x_total_load)) / sd(x_total_load)) # zscore scaling

# create gerp load data for autosomes: ----
gerp_load_autosomes <- calculate_load_gerp(autosomes_gerp_scores_higherequal4, FALSE) %>% 
  rename(line = id)

colnames(gerp_load_autosomes) <- paste0("a_",
                                 colnames(gerp_load_autosomes))  # adds "x_" to each header

gerp_load_autosomes <- gerp_load_autosomes %>% 
  rename(line = a_line) # rename that for merging

# check below first if necessary:
# chen_load_a <- chen_load_a[-c(1), ] # removes the first row, as it breaks the format

gerp_load_autosomes <- gerp_load_autosomes %>% 
  mutate(a_total_load_standardised = (a_total_load - mean(a_total_load)) / sd(a_total_load)) # zscore scaling

# join the two data sets:
gerp_load_comb <- gerp_load_a %>% 
  full_join(chen_load_x,
            by = "line") #%>% 
#  mutate(line = as.character(gsub("line", "", line))) # check if necessary

gerp_dataset <- merge(fitness_data,
                      gerp_load_comb,
                      by = "line")


# save as .csv:
write.csv(gerp_dataset,
          "C:/Uni Mainz/11. Semester_Master/project_drosophila_selection/coding_R/data/output/datasets/dataset_gerp_method.csv",
          row.names = FALSE)

# End of script: ----


# attic function:
calculate_load_gerp <- function(vcf, output_vcf){
  names(vcf)[1:10] <- c("chr", "start", "pos", "neutral_rate_n", "rs_score", "ref", "alt", "qual", "info","format")
  names(vcf)[11:215] <- unlist(fitness_data_lines)
  
  # only get GT info, PL and DP are filtered by already anyway 
  gt <- c(12:ncol(vcf)) 
  select_n3 <- function(x){x = substr(x,1,3)}
  vcf[gt] <- lapply(vcf[gt], select_n3)
  
  # calculate load
  load <- list()
  # loop over ids
  for( id in 11:(ncol(vcf))){ 
    # subset per id
    subset_id <- vcf[,c(1:10, id)] 
    
    # filter for snps in het and hom
    het_data <- subset(subset_id, subset_id[[11]] == "1/0" | subset_id[[11]] == "0/1")
    hom_data <- subset(subset_id, subset_id[[11]] == "1/1")
    
    # count amount of snps in het and hom
    het_load_sum <- nrow(het_data)
    hom_load_sum <- nrow(hom_data)
    
    # count no of snps successfully genotyped
    n_genotyped <- nrow(subset_id) - nrow(subset(subset_id, subset_id[[11]] == "./."))
    n_total <- nrow(subset_id)
    
    # collect data in df
    df <- data.frame(id = colnames(vcf[id]),
                     n_total = n_total,
                     n_genotyped = n_genotyped,
                     het_load = het_load_sum / n_genotyped,
                     hom_load = hom_load_sum / n_genotyped,
                     total_load = (het_load_sum*0.5 + hom_load_sum) / n_genotyped)
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
