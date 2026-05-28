# Print the top-n rows for each ChEA3 collection

Print the top-n rows for each ChEA3 collection

## Usage

``` r
displayTopN(
  results,
  n = 10,
  columns = c("Rank", "TF", "Scaled Rank", "Set_name", "Intersect", "Score",
    "FET p-value", "FDR", "Odds Ratio")
)
```

## Arguments

- results:

  A named list of data frames (the output of
  [`queryChEA3()`](https://ckntav.github.io/rChEA3/reference/queryChEA3.md)).

- n:

  Number of rows to show per table (default: 10).

- columns:

  Optional character vector of column names to display (keeps
  intersection with what's present in each data frame).

## Value

(Invisibly) a named list of data frames, each truncated to the first `n`
rows (and `columns` if provided).

## Examples

``` r
# \donttest{
    genes <- c("TP53", "MYC", "STAT3", "FOXO1", "BRCA1")
    results <- queryChEA3(genes, verbose = FALSE)

    # Display top 10 TFs from each collection
    displayTopN(results)
#> Top 10 per collection 
#> ────────────────────────────── 
#>   ► Integrated Results
#>     ✔ Mean Rank - Average integrated ranks across libraries
#>          Rank      TF  Score
#>             1  ZBTB24  48.33
#>             2  CSRNP1  66.00
#>             3   FOSL2  66.80
#>             4   RUNX1  73.80
#>             5    ETS2  79.75
#>             6    ANHX  86.00
#>             7     MYB  92.50
#>             8   KLF15 110.00
#>             9 POU5F1B 111.50
#>            10    ELF1 113.40
#> 
#>     ✔ Top Rank - Top integrated rank across libraries
#>          Rank     TF     Score
#>             1 ZBTB24 0.0006143
#>             2 HIVEP1 0.0006223
#>             3    SRY 0.0007123
#>             4   ZXDB 0.0012290
#>             5   MAFF 0.0012450
#>             6  MYOD1 0.0014250
#>             7 ZNF266 0.0018430
#>             8 ZNF800 0.0018670
#>             9     AR 0.0021370
#>            10 ZNF575 0.0024570
#> 
#>   ──────────────────── 
#>   ► ChIP-Seq
#>     ✔ ENCODE - Interactions mined from the ENCODE project
#>          Rank     TF Scaled Rank             Set_name Intersect FET p-value  FDR
#>             1  CEBPB    0.008475      CEBPB_C2C12_MM9         3    0.009772 0.59
#>             2  CEBPD    0.016950      CEBPD_K562_HG19         2    0.018070 0.59
#>             3 ZNF384    0.025420    ZNF384_CH12LX_MM9         3    0.019260 0.59
#>             4   IRF3    0.033900     IRF3_HELAS3_HG19         3    0.019570 0.59
#>             5   E2F4    0.042370      E2F4_CH12LX_MM9         3    0.021010 0.59
#>             6   ATF2    0.050850     ATF2_H1HESC_HG19         3    0.021370 0.59
#>             7   CTCF    0.059320 CTCF_OSTEOBLAST_HG19         3    0.022910 0.59
#>             8   ATF3    0.067800       ATF3_A549_HG19         3    0.023260 0.59
#>             9   JUND    0.076270    JUND_GM12878_HG19         2    0.023640 0.59
#>            10   MXI1    0.084750     MXI1_H1HESC_HG19         3    0.023800 0.59
#>          Odds Ratio
#>               9.358
#>              12.580
#>               7.167
#>               7.120
#>               6.919
#>               6.871
#>               6.680
#>               6.639
#>              10.850
#>               6.577
#> 
#>     ✔ ReMap - Interactions mined from the ReMap project
#>          Rank     TF Scaled Rank Set_name Intersect FET p-value   FDR Odds Ratio
#>             1  EOMES    0.003367    EOMES         3     0.01318 0.651      8.331
#>             2  FOXP1    0.006734    FOXP1         3     0.01337 0.651      8.285
#>             3 POU5F1    0.010100   POU5F1         3     0.01344 0.651      8.268
#>             4  KMT2B    0.013470    KMT2B         2     0.07561 0.651      5.558
#>             5   RFX2    0.016840     RFX2         2     0.07569 0.651      5.554
#>             6  DEAF1    0.020200    DEAF1         2     0.07595 0.651      5.543
#>             7   KLF3    0.023570     KLF3         2     0.07595 0.651      5.543
#>             8   TBXT    0.026940     TBXT         2     0.07604 0.651      5.539
#>             9  CXXC4    0.030300    CXXC4         2     0.07604 0.651      5.539
#>            10  BACH2    0.033670    BACH2         2     0.07604 0.651      5.539
#> 
#>     ✔ Literature - Interactions mined from the literature
#>          Rank     TF Scaled Rank                                 Set_name Intersect
#>             1   EGR1    0.006098        EGR1_19374776_CHIPCHIP_THP1_HUMAN         2
#>             2   ESR1    0.012200        ESR1_15608294_CHIPCHIP_MCF7_HUMAN         2
#>             3  NANOG    0.018290       NANOG_18347094_CHIPCHIP_MESC_MOUSE         4
#>             4   E2F4    0.024390      E2F4_17652178_CHIPCHIP_JURKAT_HUMAN         3
#>             5  STAT4    0.030490        STAT4_19710469_CHIPCHIP_TH1_MOUSE         3
#>             6  BACH1    0.036590 BACH1_22875853_CHIPPCR_HELAANDSCP4_HUMAN         3
#>             7  STAT3    0.042680  STAT3_22323479_CHIPSEQ_MACROPHAGE_MOUSE         1
#>             8  PPARD    0.048780    PPARD_23208498_CHIPSEQ_MDAMB231_HUMAN         2
#>             9   E2F7    0.054880         E2F7_22180533_CHIPSEQ_HELA_HUMAN         1
#>            10 POU5F1    0.060980      POU5F1_16153702_CHIPCHIP_HESC_HUMAN         2
#>          FET p-value    FDR Odds Ratio
#>            0.0002281 0.0589    123.000
#>            0.0003840 0.0589     94.090
#>            0.0026980 0.2410     10.120
#>            0.0031380 0.2410     14.330
#>            0.0088110 0.3490      9.738
#>            0.0100300 0.3490      9.264
#>            0.0101400 0.3490    121.200
#>            0.0106100 0.3490     16.770
#>            0.0134000 0.3490     90.890
#>            0.0141500 0.3490     14.360
#> 
#>   ──────────────────── 
#>   ► Coexpression
#>     ✔ ARCHS4 - TF-target coexpression in the ARCHS4 dataset
#>          Rank     TF Scaled Rank              Set_name Intersect FET p-value FDR
#>             1 ZBTB24   0.0006143 ZBTB24_ARCHS4_PEARSON         1     0.08493   1
#>             2   ZXDB   0.0012290   ZXDB_ARCHS4_PEARSON         1     0.08493   1
#>             3 ZNF266   0.0018430 ZNF266_ARCHS4_PEARSON         1     0.08493   1
#>             4 ZNF575   0.0024570 ZNF575_ARCHS4_PEARSON         1     0.08493   1
#>             5  FOXP3   0.0030710  FOXP3_ARCHS4_PEARSON         1     0.08520   1
#>             6  FOXO1   0.0036860  FOXO1_ARCHS4_PEARSON         1     0.08520   1
#>             7 ZNF395   0.0043000 ZNF395_ARCHS4_PEARSON         1     0.08520   1
#>             8  PRDM9   0.0049140  PRDM9_ARCHS4_PEARSON         1     0.08520   1
#>             9 ZSCAN4   0.0055280 ZSCAN4_ARCHS4_PEARSON         1     0.08520   1
#>            10   ATF7   0.0061430   ATF7_ARCHS4_PEARSON         1     0.08520   1
#>          Odds Ratio
#>               13.46
#>               13.46
#>               13.46
#>               13.46
#>               13.42
#>               13.42
#>               13.42
#>               13.42
#>               13.42
#>               13.42
#> 
#>     ✔ GTEx - TF-target coexpression in the GTEx dataset
#>          Rank      TF Scaled Rank Set_name Intersect FET p-value   FDR Odds Ratio
#>             1  HIVEP1   0.0006223   HIVEP1         3   0.0001694 0.272      40.39
#>             2    MAFF   0.0012450     MAFF         2   0.0042970 0.999      27.02
#>             3  ZNF800   0.0018670   ZNF800         2   0.0043250 0.999      26.93
#>             4   FOSL2   0.0024890    FOSL2         2   0.0043520 0.999      26.84
#>             5    ETV6   0.0031110     ETV6         2   0.0043520 0.999      26.84
#>             6   TGIF1   0.0037340    TGIF1         2   0.0043520 0.999      26.84
#>             7    ETS2   0.0043560     ETS2         2   0.0043520 0.999      26.84
#>             8   KLF15   0.0049780    KLF15         1   0.0843900 1.000      13.56
#>             9    EGR1   0.0056000     EGR1         1   0.0846600 1.000      13.51
#>            10 FOXD4L5   0.0062230  FOXD4L5         1   0.0846600 1.000      13.51
#> 
#>   ──────────────────── 
#>   ► Co-occurrence
#>     ✔ Enrichr - TF-target co-occurrence in Enrichr queries
#>          Rank    TF Scaled Rank Set_name Intersect FET p-value      FDR Odds Ratio
#>             1   SRY   0.0007123      SRY         5   1.465e-07 7.98e-06      69.19
#>             2 MYOD1   0.0014250    MYOD1         5   1.489e-07 7.98e-06      68.95
#>             3    AR   0.0021370       AR         5   1.489e-07 7.98e-06      68.95
#>             4 NR5A1   0.0028490    NR5A1         5   1.489e-07 7.98e-06      68.95
#>             5   PGR   0.0035610      PGR         5   1.514e-07 7.98e-06      68.71
#>             6  TP73   0.0042740     TP73         5   1.514e-07 7.98e-06      68.71
#>             7  E2F3   0.0049860     E2F3         5   1.514e-07 7.98e-06      68.71
#>             8 SMAD3   0.0056980    SMAD3         5   1.514e-07 7.98e-06      68.71
#>             9  ESR1   0.0064100     ESR1         5   1.514e-07 7.98e-06      68.71
#>            10  ARNT   0.0071230     ARNT         5   1.514e-07 7.98e-06      68.71
#> 
#>   ──────────────────── 

    # Display only top 5 with specific columns
    displayTopN(results, n = 5, columns = c("Rank", "TF", "Score", "FDR"))
#> Top 5 per collection 
#> ────────────────────────────── 
#>   ► Integrated Results
#>     ✔ Mean Rank - Average integrated ranks across libraries
#>          Rank     TF Score
#>             1 ZBTB24 48.33
#>             2 CSRNP1 66.00
#>             3  FOSL2 66.80
#>             4  RUNX1 73.80
#>             5   ETS2 79.75
#> 
#>     ✔ Top Rank - Top integrated rank across libraries
#>          Rank     TF     Score
#>             1 ZBTB24 0.0006143
#>             2 HIVEP1 0.0006223
#>             3    SRY 0.0007123
#>             4   ZXDB 0.0012290
#>             5   MAFF 0.0012450
#> 
#>   ──────────────────── 
#>   ► ChIP-Seq
#>     ✔ ENCODE - Interactions mined from the ENCODE project
#>          Rank     TF  FDR
#>             1  CEBPB 0.59
#>             2  CEBPD 0.59
#>             3 ZNF384 0.59
#>             4   IRF3 0.59
#>             5   E2F4 0.59
#> 
#>     ✔ ReMap - Interactions mined from the ReMap project
#>          Rank     TF   FDR
#>             1  EOMES 0.651
#>             2  FOXP1 0.651
#>             3 POU5F1 0.651
#>             4  KMT2B 0.651
#>             5   RFX2 0.651
#> 
#>     ✔ Literature - Interactions mined from the literature
#>          Rank    TF    FDR
#>             1  EGR1 0.0589
#>             2  ESR1 0.0589
#>             3 NANOG 0.2410
#>             4  E2F4 0.2410
#>             5 STAT4 0.3490
#> 
#>   ──────────────────── 
#>   ► Coexpression
#>     ✔ ARCHS4 - TF-target coexpression in the ARCHS4 dataset
#>          Rank     TF FDR
#>             1 ZBTB24   1
#>             2   ZXDB   1
#>             3 ZNF266   1
#>             4 ZNF575   1
#>             5  FOXP3   1
#> 
#>     ✔ GTEx - TF-target coexpression in the GTEx dataset
#>          Rank     TF   FDR
#>             1 HIVEP1 0.272
#>             2   MAFF 0.999
#>             3 ZNF800 0.999
#>             4  FOSL2 0.999
#>             5   ETV6 0.999
#> 
#>   ──────────────────── 
#>   ► Co-occurrence
#>     ✔ Enrichr - TF-target co-occurrence in Enrichr queries
#>          Rank    TF      FDR
#>             1   SRY 7.98e-06
#>             2 MYOD1 7.98e-06
#>             3    AR 7.98e-06
#>             4 NR5A1 7.98e-06
#>             5   PGR 7.98e-06
#> 
#>   ──────────────────── 
# }
```
