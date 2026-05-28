# Changelog

## rChEA3 1.0.1

### New features

- [`queryChEA3()`](https://ckntav.github.io/rChEA3/reference/queryChEA3.md)
  gains a `url` argument so users can target a local or self-hosted
  ChEA3 instance instead of the public API. Defaults to the public
  endpoint `https://maayanlab.cloud/chea3/api/enrich/`.

## rChEA3 0.2.1

### Minor updates

- Package now available on CRAN: `install.packages("rChEA3")`
- Updated documentation in vignette and README: added installation
  instructions following CRAN acceptance

## rChEA3 0.2.0

CRAN release: 2025-10-15

### Resubmission (CRAN)

This version addresses CRAN reviewer comments from the initial
submission:

- **Formatting Software Names**: Added single quotes around software/API
  names (‘ChEA3’) in DESCRIPTION as per CRAN guidelines
- **References**: Added web reference to the ChEA3 API
  (<https://maayanlab.cloud/chea3/>) and original paper Keenan (2019)
  (<doi:10.1093/nar/gkz446>) in DESCRIPTION
- **Writing Files**: Removed default paths from
  [`exportResults()`](https://ckntav.github.io/rChEA3/reference/exportResults.md)
  and
  [`saveViz()`](https://ckntav.github.io/rChEA3/reference/saveViz.md)
  functions. The `output_dir` parameter is now required (users must
  explicitly specify their desired directory) to comply with CRAN
  policies

## rChEA3 0.1.0

### Initial CRAN release

This is the first release of rChEA3, an R client for the ChEA3
transcription factor enrichment API.

#### Main features

- **API Interface**
  - [`queryChEA3()`](https://ckntav.github.io/rChEA3/reference/queryChEA3.md):
    Query the ChEA3 API with gene lists to identify enriched
    transcription factors
  - Retrieves results from 8 collections: integrated rankings (Mean
    Rank, Top Rank), ChIP-seq data (ENCODE, ReMap, Literature),
    co-expression (ARCHS4, GTEx), and co-occurrence (Enrichr queries)
- **Result Inspection**
  - [`displayTopN()`](https://ckntav.github.io/rChEA3/reference/displayTopN.md):
    Display top-ranked transcription factors across all collections
  - Results organized by evidence type with formatted output
- **Visualization**
  - [`visualizeRank()`](https://ckntav.github.io/rChEA3/reference/visualizeRank.md):
    Create publication-ready bar plots of TF enrichment
  - Automatic metric detection (FDR, p-value, or Score)
  - Customizable filtering and display options
- **Export Functions**
  - [`exportResults()`](https://ckntav.github.io/rChEA3/reference/exportResults.md):
    Export results to Excel workbooks with one sheet per collection
  - [`saveViz()`](https://ckntav.github.io/rChEA3/reference/saveViz.md):
    Save visualizations in PDF, PNG, or SVG format
  - Automatic date stamping for reproducible file names
- **Example Data**
  - `a549_dex_downreg`: Example gene set from A549 cells treated with
    dexamethasone (15 downregulated genes)

#### Documentation

- Comprehensive vignette demonstrating the full workflow
- Detailed function documentation
- README with quick start guide

#### Citation

Please cite the original ChEA3 publication when using this package:

Keenan et al. (2019). “ChEA3: transcription factor enrichment analysis
by orthogonal omics integration.” Nucleic Acids Research, 47(W1),
W212–W224. <https://doi.org/10.1093/nar/gkz446>
