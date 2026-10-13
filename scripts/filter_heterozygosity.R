#!/usr/bin/env Rscript

# load the library required
library(tidyverse)

# load heterozigosity table
heterozigosity_table <- read_tsv("results/quality_controls/samples_heterozygosity.het.tsv")

# compute mean heterozigosity
mean_heterozigosity <- mean(heterozigosity_table$F)

# compute standard deviation heterozigoisity
standard_deviaiton_heterozigosity <- sd(heterozigosity_table$F)

# plot heterozigosity F distribution
heterozigosity_f_distribution <- ggplot(heterozigosity_table, aes(x=F)) +
  geom_density() +
  geom_histogram(alpha=0.5, binwidth=0.001) +
  geom_vline(
    xintercept = mean_heterozigosity+3*standard_deviaiton_heterozigosity,
    linetype = "dashed" 
  ) +
  geom_vline(
    xintercept = mean_heterozigosity-3*standard_deviaiton_heterozigosity,
    linetype = "dashed" 
  )
jpeg(
  "results/quality_controls/heterozigosity_f_distribution.jpeg",
  width = 3120, height = 1728, res = 300
)
heterozigosity_f_distribution
dev.off()

# filter subjects based on excessive heterozigoisity
subjects_filtered <- heterozigosity_table %>%
    filter(F <= mean_heterozigosity + (3*standard_deviaiton_heterozigosity)) %>%
    filter(F >= mean_heterozigosity - (3*standard_deviaiton_heterozigosity)) %>%
    select(FID, IID)

# write table to a file
write_delim(subjects_filtered, 
            path = "results/quality_controls/samples_heterozygosity_qced.fam")