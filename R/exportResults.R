#' Export rChEA3 Results to Excel
#'
#' Write a rChEA3 results object (named list of data frames, one per collection)
#' to an Excel workbook, with one sheet per collection.
#'
#' @param results A named list of data frames (e.g., the return of
#'   \code{chea3_query()}), where each element corresponds to a ChEA3
#'   collection (e.g., "Integrated--meanRank", "ENCODE--ChIP-seq", etc.).
#'   A single data frame is also accepted and will be written to one sheet.
#' @param output_dir Directory where the workbook will be written. Default: \code{"."}.
#' @param output_file Base file name (without extension). Default: \code{"rChEA3_results"}.
#' @param with_date Logical; if \code{TRUE}, prepend today's date (ISO, \code{YYYY-MM-DD})
#'   to the file name. Default: \code{TRUE}.
#' @param verbose Logical; if \code{TRUE}, print the saved path. Default: \code{TRUE}.
#'
#' @return (Invisibly) the full path to the saved \code{.xlsx} file.
#' @export
#'
#' @examples
#' data(a549_dex_downreg)
#' results <- queryChEA3(genes = a549_dex_downreg, query_name = "test_a549_dex_downreg")
#' exportResults(results, output_dir = tempdir(), output_file = "rChEA3_results_a549_dex_downreg.xlsx")
exportResults <- function(results,
                          output_dir = ".",
                          output_file = "rChEA3_results",
                          with_date = TRUE,
                          verbose = TRUE) {
    stopifnot(requireNamespace("writexl", quietly = TRUE))

    if (!dir.exists(output_dir)) {
        dir.create(output_dir, recursive = TRUE)
    }

    if (isTRUE(with_date)) {
        output_file <- paste0(today, "_", output_file)
    }

    filepath <- file.path(output_dir, paste0(output_file, ".xlsx"))

    # ensure sheet names are valid (Excel ≤ 31 chars, unique)
    sheet_names <- substr(names(results), 1, 31)
    sheet_names <- make.unique(sheet_names)

    # convert GRanges to data.frame if needed
    names(results) <- sheet_names

    writexl::write_xlsx(results, path = filepath)
    if (isTRUE(verbose)) {
        message(" > rChEA3 results saved in ", filepath)
    }
    invisible(filepath)
}
