
<!-- README.md is generated from README.Rmd. Please edit that file -->

# rChEA3

<!-- badges: start -->

<!-- badges: end -->

An R client for the ChEA3 transcription factor enrichment API. Submit
gene lists, retrieve TF rankings from multiple evidence sources, and
integrate results directly into your R/Bioconductor analysis pipeline.

An R client for the [ChEA3](https://maayanlab.cloud/chea3/)
transcription factor enrichment API.  
ChEA3 integrates ChIP-seq, co-expression, and literature evidence to
prioritize transcription factors regulating a given gene set.  
This package provides convenient functions to query the API, retrieve
results across multiple collections, and prepare outputs for downstream
analysis.

## Installation

You can install the development version of rChEA3 from
[GitHub](https://github.com/) with:

``` r
# install.packages("pak")
pak::pak("ckntav/rChEA3")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(rChEA3)
## basic example code
```

What is special about using `README.Rmd` instead of just `README.md`?
You can include R chunks like so:

``` r
summary(cars)
#>      speed           dist       
#>  Min.   : 4.0   Min.   :  2.00  
#>  1st Qu.:12.0   1st Qu.: 26.00  
#>  Median :15.0   Median : 36.00  
#>  Mean   :15.4   Mean   : 42.98  
#>  3rd Qu.:19.0   3rd Qu.: 56.00  
#>  Max.   :25.0   Max.   :120.00
```

You’ll still need to render `README.Rmd` regularly, to keep `README.md`
up-to-date. `devtools::build_readme()` is handy for this.

You can also embed plots, for example:

<img src="man/figures/README-pressure-1.png" width="100%" />

In that case, don’t forget to commit and push the resulting figure
files, so they display on GitHub and CRAN.

## Citation

If you use this package, please cite: Keiichiro D. et al. (2019). ChEA3:
transcription factor enrichment analysis by orthogonal omics
integration. Nucleic Acids Research, 47(W1), W212–W224.
