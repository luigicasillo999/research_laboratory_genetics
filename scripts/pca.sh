#!/bin/bash -e

# ----------------------------------------
# create directories where to store results
# ----------------------------------------

mkdir -p results/pca

# ----------------------------------------
# Principal Component Analysis
# ----------------------------------------

# compute compute first 10 principal components 
plink \
  --bfile results/genotypes_quality_checked/samples \
  --pca 10 \
  --out results/pca/samples

# plot pca
Rscript scripts/plot_pca.r