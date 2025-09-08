#' Print the top-n rows for each ChEA3 collection
#'
#' @param results A named list of data frames (the output of `chea3_query()`).
#' @param n Number of rows to show per table (default: 10).
#' @param columns Optional character vector of column names to display
#'   (keeps intersection with what's present in each data frame).
#'
#' @return (Invisibly) a named list of data frames, each truncated to the first
#'   \code{n} rows (and \code{columns} if provided).
#' @export
displayTopN <- function(
        results,
        n = 10,
        columns = c("Rank", "TF", "Scaled Rank", "Set_name", "Intersect", "Score", "FET p-value", "FDR",
                    "Odds Ratio")
) {
    if (!is.list(results) || is.null(names(results))) {
        stop("`results` must be a *named* list of data frames.")
    }
    if (!is.numeric(n) || length(n) != 1 || is.na(n) || n < 0) {
        stop("`n` must be a single non-negative number.")
    }

    # style helpers (match your .chea3_print_available)
    dash   <- if (requireNamespace("cli", quietly = TRUE)) cli::symbol$line else "\u2500"
    tick   <- if (requireNamespace("cli", quietly = TRUE)) cli::symbol$tick else "\u2714"
    green  <- function(x) if (requireNamespace("crayon", quietly = TRUE)) crayon::green(x) else x
    bold   <- function(x) if (requireNamespace("crayon", quietly = TRUE)) crayon::bold(x) else x
    italic <- function(x) if (requireNamespace("crayon", quietly = TRUE)) crayon::italic(x) else x

    tab <- .chea3_collection_table()
    have <- tab[tab$internal %in% names(results), , drop = FALSE]

    if (!nrow(have)) {
        message("No known ChEA3 collections detected in `results`.")
        return(invisible(list()))
    }

    # Header
    cat(bold(sprintf("Top %d per collection", n)), "\n")
    cat(paste0(paste(rep(dash, 30), collapse = "")), "\n")

    out_list <- list()

    for (sec in unique(have$section)) {
        cat("  \u25BA ", bold(sec), "\n", sep = "")
        sec_rows <- have[have$section == sec, , drop = FALSE]

        for (i in seq_len(nrow(sec_rows))) {
            internal <- sec_rows$internal[i]
            label    <- sec_rows$label[i]
            desc     <- sec_rows$description[i]

            df <- results[[internal]]
            if (!is.data.frame(df)) {
                cat("    ", italic(sprintf("%s - not a data.frame, skipping.\n", label)), sep = "")
                next
            }

            # Column subset (optional)
            if (!is.null(columns)) {
                keep <- intersect(columns, colnames(df))
                if (length(keep) == 0L) {
                    cat("    ", italic(sprintf(
                        "%s - requested columns not found; showing all columns.\n", label
                    )), sep = "")
                } else {
                    df <- df[, keep, drop = FALSE]
                }
            }

            # Truncate and print
            cat("    ", green(tick), " ", bold(label), " - ", desc, "\n", sep = "")
            if (nrow(df) == 0L) {
                cat("        ", italic("(no rows)\n"), sep = "")
                # out_list[[internal]] <- df
            } else {
                top_df <- utils::head(df, n)
                # indent printed table a bit (row.names always FALSE)
                capture <- utils::capture.output(print(top_df, row.names = FALSE))
                cat(paste0("        ", capture), sep = "\n")
                cat("\n")
                # out_list[[internal]] <- top_df
            }
        }
        cat(paste0("  ", paste(rep(dash, 20), collapse = "")), "\n")
    }

    # invisible(out_list)
}
