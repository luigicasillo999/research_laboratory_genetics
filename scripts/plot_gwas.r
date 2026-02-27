#!/usr/bin/env Rscript

# load libraries
library(tidyverse)
library(qqman)

# change working directory to research_laboratory_genetics if needed
# getwd()
# setwd("/PATH_TO_DIRECTORY/research_laboratory_genetics/")

# read gwas
gwas <- read_table("results/gwas/samples.assoc.logistic")

# if read_table reads an empty last column do this:
gwas <- gwas %>%
  select(where(~!(all(is.na(.)))))

# remove missing values
gwas <- gwas %>%
  drop_na()

# plot gwas as manhattan plot
manhattan(gwas)

# save manhattan plot
jpeg(
  "results/gwas/samples_gwas_manhattan.jpeg",
  width = 3120, height = 1728, res = 300
)
manhattan(gwas)
dev.off()

# multiple testing correction
gwas[,"Adjusted P-value"] <- p.adjust(gwas$P, "BH")

# filter only significant associations
gwas_significant <- gwas %>%
  filter(`Adjusted P-value` < 0.05)

# save the list of significant variants
write_delim(
  gwas_significant, 
  "results/gwas/significant_variants.tsv", 
  delim = "\t"
  )