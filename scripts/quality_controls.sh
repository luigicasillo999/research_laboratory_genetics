#!/bin/bash -e

# ----------------------------------------
# create directories where to store results
# ----------------------------------------

mkdir -p results/quality_controls results/genotypes_quality_checked

# ----------------------------------------
# gwas standard quality controls
# ----------------------------------------

# remove variants with MAF < 0.01, HWE deviation p-value < 1e-6, genotyping missing call rate > 0.01
# remove subjects with sample missing call rate > 0.01
# write the list of remaining variants and a list of the remaining subjects
plink \
  --bfile data/genotypes/samples \
  --maf 0.01 \
  --hwe 1e-6 \
  --geno 0.01 \
  --mind 0.01 \
  --write-snplist \
  --make-just-fam \
  --out results/quality_controls/samples_standard_qced

# ----------------------------------------
# remove subjects with exceding heterozygosity
# ----------------------------------------

# get a list of the independent variants
plink \
  --bfile data/genotypes/samples \
  --keep results/quality_controls/samples_standard_qced.fam \
  --extract results/quality_controls/samples_standard_qced.snplist \
  --indep-pairwise 200 50 0.25 \
  --out results/quality_controls/independent_variants

# compute subjects' heterozygoisty rate using independent variants
plink \
  --bfile data/genotypes/samples \
  --keep results/quality_controls/samples_standard_qced.fam \
  --extract results/quality_controls/independent_variants.prune.in \
  --het \
  --out results/quality_controls/samples_heterozygosity

# remove individuals with heterozygisity rate > 3 standard deviation in R
sed -E 's/^ +// ; s/ +/\t/g' results/quality_controls/samples_heterozygosity.het > results/quality_controls/samples_heterozygosity.het.tsv
Rscript scripts/filter_heterozygosity.r

# ----------------------------------------
# remove relatives
# ----------------------------------------

# remove closely related individuals
plink \
  --bfile data/genotypes/samples \
  --extract results/quality_controls/independent_variants.prune.in \
  --keep results/quality_controls/samples_heterozygosity_qced.fam \
  --rel-cutoff 0.125 \
  --out results/quality_controls/samples_kinship_qced

# ----------------------------------------
# generate final files
# ----------------------------------------

# generate final fileset including quality checked variants and subjects
plink \
  --bfile data/genotypes/samples \
  --keep results/quality_controls/samples_kinship_qced.rel.id \
  --extract results/quality_controls/samples_standard_qced.snplist \
  --make-bed \
  --out results/genotypes_quality_checked/samples