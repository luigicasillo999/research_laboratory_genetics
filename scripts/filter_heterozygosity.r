#!/usr/bin/env Rscript

# load the library required
library(tidyverse)

# change working directory to research_laboratory_genetics if needed
# getwd()
# setwd("/PATH_TO_DIRECTORY/research_laboratory_genetics/")

# load heterozigosity table
heterozigosity_table <- read_tsv("results/quality_controls/samples_heterozygosity.het.tsv")

# compute mean heterozigosity
mean_heterozigosity <- mean(heterozigosity_table$F)

# compute standard deviation heterozigoisity
standard_deviaiton_heterozigosity <- sd(heterozigosity_table$F)

# plot heterozigosity F distribution
ggplot(heterozigosity_table, aes(x=F)) +
  geom_density() +
  geom_histogram(alpha=0.5) +
  geom_vline(
    xintercept = mean_heterozigosity+3*standard_deviaiton_heterozigosity,
    linetype = "dashed" 
  ) +
  geom_vline(
    xintercept = mean_heterozigosity-3*standard_deviaiton_heterozigosity,
    linetype = "dashed" 
  )

# filter subjects based on excessive heterozigoisity
subjects_filtered <- heterozigosity_table |>
    filter(F <= mean_heterozigosity + (3*standard_deviaiton_heterozigosity)) |>
    filter(F >= mean_heterozigosity - (3*standard_deviaiton_heterozigosity)) |>
    select(FID, IID)

# write table to a file
write_delim(subjects_filtered, 
            file = "results/quality_controls/samples_heterozygosity_qced.fam" , 
            delim = "\t", 
            quote=NULL, 
            col_names=FALSE)
