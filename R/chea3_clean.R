# Internal helpers (not exported)

#' @keywords internal
.check_chea3_collections <- function(x) {
    expected <- c("Integrated--meanRank", "Integrated--topRank",
                  "GTEx--Coexpression", "ARCHS4--Coexpression",
                  "ENCODE--ChIP-seq", "ReMap--ChIP-seq",
                  "Literature--ChIP-seq", "Enrichr--Queries")
    missing    <- setdiff(expected, names(x))
    unexpected <- setdiff(names(x), expected)

    if (length(missing)) {
        warning("These collections are missing in the response: ",
                paste(missing, collapse = ", "), call. = FALSE)
    }
    if (length(unexpected)) {
        warning("Unexpected collections in the response: ",
                paste(unexpected, collapse = ", "), call. = FALSE)
    }
    invisible(x)
}

#' @keywords internal
.chea3_clean_all <- function(results) {
    stopifnot(is.list(results))
    out <- lapply(names(results), function(nm) .chea3_clean(results[[nm]], nm))
    rlang::set_names(out, names(results))
}

#' @keywords internal
.chea3_clean <- function(df, collection) {
    stopifnot(is.data.frame(df), is.character(collection), length(collection) == 1)

    if (collection %in% c("Integrated--meanRank", "Integrated--topRank")) {
        df <- dplyr::mutate(
            df,
            dplyr::across(tidyselect::any_of("Rank"),  as.integer),
            dplyr::across(tidyselect::any_of("Score"), as.numeric)
        )
    } else {
        df <- dplyr::mutate(
            df,
            dplyr::across(tidyselect::any_of(c("Rank", "Intersect", "Set length")),
                          as.integer),
            dplyr::across(tidyselect::any_of(c("Scaled Rank", "FET p-value",
                                               "FDR", "Odds Ratio")),
                          as.numeric)
        )
    }
    df
}
