# Query ChEA3 API for TF enrichment

\#' Sends a gene list to the ChEA3 web service to identify enriched
transcription factors using multiple evidence sources. The gene list
should consist of HGNC-approved gene symbols.

## Usage

``` r
queryChEA3(
  genes,
  query_name = "rChEA3_query",
  verbose = TRUE,
  url = "https://maayanlab.cloud/chea3/api/enrich/"
)
```

## Arguments

- genes:

  Character vector of HGNC gene symbols.

- query_name:

  Optional query name (default: "rChEA3_query").

- verbose:

  Logical; if TRUE, print a grouped summary of available result
  collections (default: TRUE).

- url:

  Character; full URL of the ChEA3 enrichment endpoint. Defaults to the
  public API at `"https://maayanlab.cloud/chea3/api/enrich/"`. Override
  this to point at a local or self-hosted ChEA3 instance (see
  <https://github.com/MaayanLab/chea3>). The URL must include the full
  `enrich/` path.

## Value

A named list of data frames. Each element corresponds to a ChEA3
collection and contains an enrichment table with transcription factors
and their statistics. The expected names are: c("Integrated–meanRank",
"Integrated–topRank", "GTEx–Coexpression", "ARCHS4–Coexpression",
"ENCODE–ChIP-seq", "ReMap–ChIP-seq", "Literature–ChIP-seq",
"Enrichr–Queries").

## Examples

``` r
# \donttest{
    results <- queryChEA3(c("SMAD9","FOXO1","MYC","STAT1","STAT3","SMAD3"))
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
    names(results)
#> [1] "Integrated--meanRank" "Integrated--topRank"  "GTEx--Coexpression"  
#> [4] "ReMap--ChIP-seq"      "Enrichr--Queries"     "ENCODE--ChIP-seq"    
#> [7] "ARCHS4--Coexpression" "Literature--ChIP-seq"
    head(results[["Integrated--meanRank"]])
#>     Query Name Rank      TF Score
#> 1 rChEA3_query    1   FOSL2 62.60
#> 2 rChEA3_query    2    ETS2 74.25
#> 3 rChEA3_query    3  ZNF225 76.00
#> 4 rChEA3_query    4   RUNX1 81.00
#> 5 rChEA3_query    5  PLSCR1 89.00
#> 6 rChEA3_query    6 BHLHE40 93.75
#>                                                                                                     Library
#> 1       ARCHS4 Coexpression,51;ENCODE ChIP-seq,105;Enrichr Queries,92;ReMap ChIP-seq,61;GTEx Coexpression,4
#> 2                     Literature ChIP-seq,148;ARCHS4 Coexpression,90;Enrichr Queries,52;GTEx Coexpression,7
#> 3                                                               ARCHS4 Coexpression,78;GTEx Coexpression,74
#> 4 Literature ChIP-seq,20;ARCHS4 Coexpression,56;Enrichr Queries,24;ReMap ChIP-seq,183;GTEx Coexpression,122
#> 5                                                              ARCHS4 Coexpression,76;GTEx Coexpression,102
#> 6                         ARCHS4 Coexpression,5;ENCODE ChIP-seq,43;ReMap ChIP-seq,180;GTEx Coexpression,147
#>             Overlapping_Genes
#> 1 SMAD3,STAT1,MYC,STAT3,FOXO1
#> 2 SMAD3,STAT1,MYC,STAT3,FOXO1
#> 3                 STAT1,SMAD9
#> 4 SMAD3,STAT1,MYC,STAT3,FOXO1
#> 5                 STAT1,STAT3
#> 6     SMAD3,STAT1,STAT3,FOXO1

    # Querying a local ChEA3 server
    # results <- queryChEA3(
    #     c("SMAD9","FOXO1","MYC"),
    #     url = "http://localhost:8080/chea3/api/enrich/"
    # )
# }
```
