## code to prepare `a549_dex_downreg` dataset goes here
## This script reads Supplementary Table S3, extracts the first 15
## downregulated genes in A549 cells treated with dexamethasone,
## and saves them as a packaged dataset.

# --- Load required packages ---
library(readxl)
library(tidyverse)

# --- Locate the supplementary table within the installed package ---
datasupp_table3_path <- system.file(
    "extdata", "Tav_et_al_2023_SuppTableS3.XLSX",
    package = "rChEA3"
)

# --- Read the raw supplementary data ---
raw_data <- read_xlsx(datasupp_table3_path)

# --- Extract the first 15 downregulated genes ---
a549_dex_downreg <- raw_data %>%
    dplyr::filter(rna_category == "repressed") %>%
    pull(symbol) %>%
    head(15)

# Save the dataset into data/a549_dex_downreg.rda
#   - overwrite = TRUE allows updating
#   - compress = "xz" ensures small package size (Bioconductor friendly)
usethis::use_data(a549_dex_downreg, overwrite = TRUE, compress = "xz")
