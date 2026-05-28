# Today's Date at Package Load Time

This variable stores the current date (in "yyyymmdd" format) at the time
the package is loaded. It is useful for reproducible filenames (e.g., in
[`saveViz()`](https://ckntav.github.io/rChEA3/reference/saveViz.md)),
and is automatically set when the package is attached.

## Usage

``` r
today
```

## Format

A character string (e.g., "20250908").

## Examples

``` r
# Print the date stored at package load
library(rChEA3)
today
#> [1] "20260528"

# Use it in a filename
paste0(today, "_rCHEA3_plot_meanRank.pdf")
#> [1] "20260528_rCHEA3_plot_meanRank.pdf"
```
