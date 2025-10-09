# rChEA3 0.2.0

# rChEA3 0.1.0

## Initial CRAN Release

This is the first release of rChEA3, an R client for the ChEA3 transcription 
factor enrichment API.

### Main Features

* **API Interface**
  - `queryChEA3()`: Query the ChEA3 API with gene lists to identify enriched 
    transcription factors
  - Retrieves results from 8 collections: integrated rankings (Mean Rank, 
    Top Rank), ChIP-seq data (ENCODE, ReMap, Literature), co-expression 
    (ARCHS4, GTEx), and co-occurrence (Enrichr queries)

* **Result Inspection**
  - `displayTopN()`: Display top-ranked transcription factors across all 
    collections
  - Results organized by evidence type with formatted output

* **Visualization**
  - `visualizeRank()`: Create publication-ready bar plots of TF enrichment
  - Automatic metric detection (FDR, p-value, or Score)
  - Customizable filtering and display options

* **Export Functions**
  - `exportResults()`: Export results to Excel workbooks with one sheet 
    per collection
  - `saveViz()`: Save visualizations in PDF, PNG, or SVG format
  - Automatic date stamping for reproducible file names

* **Example Data**
  - `a549_dex_downreg`: Example gene set from A549 cells treated with 
    dexamethasone (15 downregulated genes)

### Documentation

* Comprehensive vignette demonstrating the full workflow
* Detailed function documentation
* README with quick start guide

### Citation

Please cite the original ChEA3 publication when using this package:

Keenan et al. (2019). "ChEA3: transcription factor enrichment analysis by 
orthogonal omics integration." Nucleic Acids Research, 47(W1), W212–W224. 
https://doi.org/10.1093/nar/gkz446
