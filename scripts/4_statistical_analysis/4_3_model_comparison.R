# Validate and compare models between standardised and non-standardised versions:
# Start of script: ----

# Load packages:
library(brms)
library(tidyverse)

## Load the models: ----
# Described in 4_1_modelling_non_standardised.R & 4_2_modelling_standardised.R 
# stand = z-scored ; non_stand = unstandardised values

### SnpEff models: ----
complete_young_snpeff_non_stand <- readRDS("C:/path/coding_R/models/complete_model_young_snpeff_non_stand.rds")
complete_old_snpeff_non_stand <- readRDS("C:/path/coding_R/models/complete_model_old_snpeff_non_stand.rds")
complete_young_snpeff_stand <- readRDS("C:/path/coding_R/models/complete_model_young_snpeff_stand.rds")
complete_old_snpeff_stand <- readRDS("C:/path/coding_R/models/complete_model_old_snpeff_stand.rds")

### GERP models: ----
# Load alterative models for gerp-standardised to avoid errors due to line 21
# being removed as an outlier (running models described below in script)
complete_young_gerp_non_stand <- readRDS("C:/path/coding_R/models/complete_model_young_gerp_non_stand.rds")
complete_old_gerp_non_stand <- readRDS("C:/path/coding_R/models/complete_model_old_gerp_non_stand.rds")
#complete_young_gerp_stand <- readRDS("C:/path/coding_R/models/complete_model_young_gerp_stand.rds")
#complete_old_gerp_stand <- readRDS("C:/path/coding_R/models/complete_model_old_gerp_stand.rds")
alt_complete_model_young_gerp <- readRDS("C:/path/coding_R/models/alt_complete_model_young_gerp_stand.rds")
alt_complete_model_old_gerp <- readRDS("C:/path/coding_R/models/alt_complete_model_old_gerp_stand.rds")

## Compare the standardised against non-standardised models via leave-one-out 
## cross validation: 
## Approximate guidelines: ----
## 1)
# https://users.aalto.fi/~ave/CV-FAQ.html#se_diff
# "If elpd difference (elpd_diff in loo package) is less than 4, the difference 
# is small (Sivula et al., 2025)). If elpd difference (elpd_diff in loo package)
# is larger than 4, then compare that difference to standard error of elpd_diff 
# (provided e.g. by loo package) (Sivula et al., 2025)." See also Section How to interpret in Standard error (SE) of elpd difference (elpd_diff)?.

## 2)
# https://discourse.mc-stan.org/t/if-elpd-diff-se-diff-2-is-this-noteworthy/20549/3
# "Nowadays, I personally feel comfortable, if I have a large NN , and if elpddiff/SEdiff ≥4
## |elpd_diff / se_diff| > 2 

### SnpEff models: ----
brms::loo(complete_young_snpeff_stand, complete_young_snpeff_non_stand)
# Model comparisons:
#                                  elpd_diff se_diff
# complete_young_snpeff_non_stand  0.0       0.0   
# complete_young_snpeff_stand     -4.3       1.1  

brms::loo(complete_old_snpeff_stand, complete_old_snpeff_non_stand)
# Model comparisons:
#                                elpd_diff se_diff
# complete_old_snpeff_non_stand  0.0       0.0   
# complete_old_snpeff_stand     -4.2       1.1   

### Gerp models: ----
brms::loo(complete_young_gerp_non_stand, alt_complete_model_young_gerp)
# Model comparisons:
#                                elpd_diff se_diff
# complete_young_gerp_non_stand  0.0       0.0   
# alt_complete_model_young_gerp -3.8       2.1   

brms::loo(complete_old_gerp_non_stand, alt_complete_model_old_gerp)
# Model comparisons:
#                              elpd_diff se_diff
# complete_old_gerp_non_stand  0.0       0.0   
# alt_complete_model_old_gerp -2.3       1.3   


## Create data and run alternative models for gerp-standardised: ----
# Models contain outlier line 21 just for comparison sake
gerp_dataset <- read.csv("C:/path/coding_R/data/output/datasets/dataset_gerp_method.csv")

gerp_cleaned <- gerp_dataset %>% 
  select("line", "Trait", "trait_value", "Sex",  "a_total_load_standardised",
         "x_total_load_standardised") %>% 
  rename(autosomes = a_total_load_standardised,
         x = x_total_load_standardised) %>% 
  pivot_longer(cols = c(autosomes, x),
               names_to = "chromosome",
               values_to = "mutation_load")

gerp_dataset_young <- subset(gerp_cleaned,
                             str_detect(Trait, "early"))

gerp_dataset_old <- subset(gerp_cleaned,
                           str_detect(Trait, "late"))

alt_complete_model_young_gerp <- brm(trait_value ~ 0 + mutation_load * Sex * chromosome + (1|line),
                                     data = gerp_dataset_young,
                                     family = gaussian(), # model[i] ~ Normal(μ, σ) ; μ (mean) = 0, σ (sd) = 1
                                     prior = c(prior(normal(0, 1), class = b), #  b = μ ~ Normal(0, 1)
                                               prior(exponential(1), class = sigma)), # σ ~ Exp(1) ; cant be negative, value is the reciprocal of expected standard deviation; here 1/lambda = 1
                                     iter = 8000, warmup = 4000, chains = 4, cores = 4, # run specifics
                                     seed = 1,
                                     file = "C:/path/coding_R/models/alt_complete_model_young_gerp_stand")
alt_complete_model_young_gerp <- readRDS("C:/path/coding_R/models/alt_complete_model_young_gerp_stand.rds")

alt_complete_model_old_gerp <- brm(trait_value ~ 0 + mutation_load * Sex * chromosome + (1|line),
                                   data = gerp_dataset_old,
                                   family = gaussian(), # model[i] ~ Normal(μ, σ) ; μ (mean) = 0, σ (sd) = 1
                                   prior = c(prior(normal(0, 1), class = b), #  b = μ ~ Normal(0, 1)
                                             prior(exponential(1), class = sigma)), # σ ~ Exp(1) ; cant be negative, value is the reciprocal of expected standard deviation; here 1/lambda = 1
                                   iter = 8000, warmup = 4000, chains = 4, cores = 4, # run specifics
                                   seed = 1,
                                   file = "C:/path/coding_R/models/alt_complete_model_old_gerp_stand")
alt_complete_model_old_gerp <- readRDS("C:/path/coding_R/models/alt_complete_model_old_gerp_stand.rds")

rm(gerp_cleaned, gerp_dataset, gerp_dataset_old, gerp_dataset_young,
   alt_complete_model_old_gerp, alt_complete_model_young_gerp)

# End of script: ----
