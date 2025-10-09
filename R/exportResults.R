#' Export rChEA3 Results to Excel
#'
#' Write a rChEA3 results object (named list of data frames, one per collection)
#' to an Excel workbook, with one sheet per collection.
#'
#' @param results A named list of data frames (e.g., the return of
#'   \code{queryChEA3()}), where each element corresponds to a ChEA3
#'   collection (e.g., "Integrated--meanRank", "ENCODE--ChIP-seq", etc.).
#'   A single data frame is also accepted and will be written to one sheet.
#' @param output_dir A string specifying the output directory. This parameter
#' is required and has no default.
#' @param output_file Base file name (without extension). Default: \code{"rChEA3_results"}.
#' @param with_date Logical; if \code{TRUE}, prepend today's date (ISO, \code{YYYY-MM-DD})
#'   to the file name. Default: \code{TRUE}.
#' @param verbose Logical; if \code{TRUE}, print the saved path. Default: \code{TRUE}.
#'
#' @return (Invisibly) the full path to the saved \code{.xlsx} file.
#' @export
#'
#' @examples
#' \donttest{
#'     data(a549_dex_downreg)
#'     results <- queryChEA3(genes = a549_dex_downreg, query_name = "test_a549_dex_downreg")
#'     exportResults(results,
#'     output_dir = tempdir(),
#'     output_file = "rChEA3_results_a549_dex_downreg.xlsx")
#' }

exportResults <- function(results,
                          output_dir,
                          output_file = "rChEA3_results",
                          with_date = TRUE,
                          verbose = TRUE) {
    if (!requireNamespace("writexl", quietly = TRUE)) {
        stop("Package 'writexl' is required but not installed.", call. = FALSE)
    }

    # Check that output_dir is provided
    if (missing(output_dir)) {
        stop("'output_dir' must be specified. Use tempdir() for temporary files or specify your desired directory.",
             call. = FALSE)
    }

    # Accept a single data.frame as convenience
    if (is.data.frame(results)) {
        results <- list(Results = results)
    }
    if (!is.list(results) || length(results) == 0) {
        stop("'results' must be a non-empty list of data frames (or a data frame).", call. = FALSE)
    }

    # Desired sheet order (only keep what exists)
    desired_order <- c(
        "Integrated--meanRank",
        "Integrated--topRank",
        "ENCODE--ChIP-seq",
        "ReMap--ChIP-seq",
        "Literature--ChIP-seq",
        "ARCHS4--Coexpression",
        "GTEx--Coexpression",
        "Enrichr--Queries"
    )
    results <- results[intersect(desired_order, names(results))]

    # Coerce all to data.frame
    to_write <- lapply(results, function(x) {
        if (!is.data.frame(x)) x <- as.data.frame(x)
        x
    })

    # Ensure output dir
    if (!dir.exists(output_dir)) dir.create(output_dir, recursive = TRUE)

    # Strip accidental .xlsx extension from output_file
    output_file <- sub("\\.xlsx$", "", output_file, ignore.case = TRUE)
    if (isTRUE(with_date)) {
        output_file <- paste0(get_today(), "_", output_file)
    }
    filepath <- file.path(output_dir, paste0(output_file, ".xlsx"))

    # Sanitize sheet names (Excel ≤31 chars; forbid : \ / ? * [ ])
    sanitize_sheet <- function(x) {
        if (length(x) == 0 || is.na(x) || !nzchar(x)) x <- "Sheet"
        x <- gsub("[:\\\\/\\?\\*\\[\\]]", "-", x)
        substr(x, 1, 31)
    }
    nm <- names(to_write)
    if (is.null(nm)) nm <- rep("Sheet", length(to_write))
    nm <- vapply(nm, sanitize_sheet, character(1))
    nm <- make.unique(nm, sep = "_")
    names(to_write) <- nm

    # Write workbook
    writexl::write_xlsx(x = to_write, path = filepath)

    if (isTRUE(verbose)) {
        message(" > rChEA3 results saved in ", filepath)
    }
    invisible(filepath)
}
