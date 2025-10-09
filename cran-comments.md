## R CMD check results

0 errors ✓ | 0 warnings ✓ | 0 notes ✓

## Resubmission

The package provides an R interface to the ChEA3 transcription factor 
enrichment web API. All API calls are wrapped in \donttest{} as they 
require internet connectivity.

This is a resubmission. In this version I have:

* Added single quotes around software/API names ('ChEA3', 'ChIP-seq') in the 
  DESCRIPTION file as per CRAN guidelines
* Added web reference (<https://maayanlab.cloud/chea3/>) and publication 
  reference (Keenan (2019) <doi:10.1093/nar/gkz446>) to the DESCRIPTION file
* Removed default paths from `exportResults()` and `saveViz()` functions. 
  The `output_dir` parameter is now required to comply with CRAN policies 
  about not writing to user directories by default