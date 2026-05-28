# Export rChEA3 Results to Excel

Write a rChEA3 results object (named list of data frames, one per
collection) to an Excel workbook, with one sheet per collection.

## Usage

``` r
exportResults(
  results,
  output_dir,
  output_file = "rChEA3_results",
  with_date = TRUE,
  verbose = TRUE
)
```

## Arguments

- results:

  A named list of data frames (e.g., the return of
  [`queryChEA3()`](https://ckntav.github.io/rChEA3/reference/queryChEA3.md)),
  where each element corresponds to a ChEA3 collection (e.g.,
  "Integrated–meanRank", "ENCODE–ChIP-seq", etc.). A single data frame
  is also accepted and will be written to one sheet.

- output_dir:

  A string specifying the output directory. This parameter is required
  and has no default.

- output_file:

  Base file name (without extension). Default: `"rChEA3_results"`.

- with_date:

  Logical; if `TRUE`, prepend today's date (ISO, `YYYY-MM-DD`) to the
  file name. Default: `TRUE`.

- verbose:

  Logical; if `TRUE`, print the saved path. Default: `TRUE`.

## Value

(Invisibly) the full path to the saved `.xlsx` file.

## Examples

``` r
# \donttest{
    data(a549_dex_downreg)
    results <- queryChEA3(genes = a549_dex_downreg, query_name = "test_a549_dex_downreg")
#> Available results 
#> ────────────────────────────── 
#>   ► Integrated Results
#>     ✔ Mean Rank — Average integrated ranks across libraries
#>         Use <your_result>[["Integrated--meanRank"]]
#>     ✔ Top Rank — Top integrated rank across libraries
#>         Use <your_result>[["Integrated--topRank"]]
#>   ──────────────────── 
#>   ► ChIP-Seq
#>     ✔ ENCODE — Interactions mined from the ENCODE project
#>         Use <your_result>[["ENCODE--ChIP-seq"]]
#>     ✔ ReMap — Interactions mined from the ReMap project
#>         Use <your_result>[["ReMap--ChIP-seq"]]
#>     ✔ Literature — Interactions mined from the literature
#>         Use <your_result>[["Literature--ChIP-seq"]]
#>   ──────────────────── 
#>   ► Coexpression
#>     ✔ ARCHS4 — TF-target coexpression in the ARCHS4 dataset
#>         Use <your_result>[["ARCHS4--Coexpression"]]
#>     ✔ GTEx — TF-target coexpression in the GTEx dataset
#>         Use <your_result>[["GTEx--Coexpression"]]
#>   ──────────────────── 
#>   ► Co-occurrence
#>     ✔ Enrichr — TF-target co-occurrence in Enrichr queries
#>         Use <your_result>[["Enrichr--Queries"]]
#>   ──────────────────── 
    exportResults(results,
    output_dir = tempdir(),
    output_file = "rChEA3_results_a549_dex_downreg.xlsx")
#>  > rChEA3 results saved in /tmp/RtmpGbzMAJ/20260528_rChEA3_results_a549_dex_downreg.xlsx
# }
```
