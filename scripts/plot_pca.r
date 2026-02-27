#!/usr/bin/env Rscript

# import libraries
library(tidyverse)

# change working directory to research_laboratory_genetics if needed
# getwd()
# setwd("/PATH_TO_DIRECTORY/research_laboratory_genetics/")

# load pca
column_names <- c("id_1", "id_2", "PC1", "PC2", "PC3", "PC4", "PC5", "PC6", "PC7", "PC8", "PC9", "PC10")
pca <- read_delim("results/pca/samples.eigenvec", delim = " ", col_names = column_names)

# plot pca
pca_plot <- ggplot(pca, aes(x=PC1, y=PC2)) +
  geom_point()

# save pca plot
jpeg(
  "results/pca/samples_pca.jpeg",
  width = 3120, height = 1728, res = 300
)
pca_plot
dev.off()

# plot pca of samples and 1000GP subjects
pca_samples_and_1000gp <- read_delim("results/pca/samples_and_1000GP.eigenvec", delim = " ", col_names = column_names)
population_1000gp <-  read_delim("data/1000GP/1000GP_Phase3.sample")
pca_plot_samples_and_1000gp <- pca_samples_and_1000gp %>%
  left_join(population_1000gp, by = join_by(id_1 == ID)) %>%
  replace_na(list(GROUP = "samples")) %>%
  arrange(GROUP) %>%
  ggplot(aes(x=PC1, y=PC2, colour = GROUP)) +
  geom_point(alpha=0.5) +
  scale_color_manual(values = c("green", "blue", "red", "gold", "black", "magenta"))
