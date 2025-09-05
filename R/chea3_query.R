.check_chea3_collections <- function(x) {
    expected <- c("Integrated--meanRank", "Integrated--topRank",
                  "GTEx--Coexpression", "ARCHS4--Coexpression",
                  "ENCODE--ChIP-seq", "ReMap--ChIP-seq",
                  "Literature--ChIP-seq", "Enrichr--Queries")
    missing <- setdiff(expected, names(x))
    if (length(missing)) {
        warning("These collections are missing in the response: ",
                paste(missing, collapse = ", "))
    }
    invisible(x)
}

# Internal: map API names -> display section/label/description
.chea3_collection_table <- function() {
    data.frame(
        internal = c(
            "Integrated--meanRank", "Integrated--topRank",
            "ENCODE--ChIP-seq", "ReMap--ChIP-seq", "Literature--ChIP-seq",
            "ARCHS4--Coexpression", "GTEx--Coexpression",
            "Enrichr--Queries"
        ),
        section  = c(
            rep("Integrated Results", 2),
            rep("ChIP-Seq", 3),
            rep("Coexpression", 2),
            "Co-occurrence"
        ),
        label    = c(
            "Mean Rank", "Top Rank",
            "ENCODE", "ReMap", "Literature",
            "ARCHS4", "GTEx",
            "Enrichr"
        ),
        description = c(
            "Average integrated ranks across libraries",
            "Top integrated rank across libraries",
            "Interactions mined from the ENCODE project",
            "Interactions mined from the ReMap project",
            "Interactions mined from the literature",
            "TF-target coexpression in the ARCHS4 dataset",
            "TF-target coexpression in the GTEx dataset",
            "TF-target co-occurrence in Enrichr queries"
        ),
        stringsAsFactors = FALSE
    )
}

# Internal: pretty print what's available
.chea3_print_available <- function(parsed) {
    tab <- .chea3_collection_table()
    have <- tab[tab$internal %in% names(parsed), , drop = FALSE]

    if (!nrow(have)) {
        message("No known ChEA3 collections detected in the response.")
        return(invisible(NULL))
    }

    tick   <- if (requireNamespace("cli", quietly = TRUE)) cli::symbol$tick else "\u2714"
    dash   <- if (requireNamespace("cli", quietly = TRUE)) cli::symbol$line else "\u2500"
    green  <- function(x) if (requireNamespace("crayon", quietly = TRUE)) crayon::green(x) else x
    bold   <- function(x) if (requireNamespace("crayon", quietly = TRUE)) crayon::bold(x) else x
    italic <- function(x) if (requireNamespace("crayon", quietly = TRUE)) crayon::italic(x) else x

    # --- New header
    cat(bold("Available results"), "\n")
    cat(paste0(paste(rep(dash, 30), collapse = "")), "\n")

    sections <- unique(have$section)
    for (sec in sections) {
        cat("  \u25BA ", bold(sec), "\n", sep = "")
        sec_rows <- have[have$section == sec, , drop = FALSE]
        for (i in seq_len(nrow(sec_rows))) {
            internal <- sec_rows$internal[i]
            cat("    ", green(tick), " ",
                sec_rows$label[i], " ",
                "\u2014 ", sec_rows$description[i], "\n", sep = "")
            cat("        ",
                italic(paste0("Use <your_result>[[\"", internal, "\"]]")),
                "\n", sep = "")
        }
        cat(paste0("  ", paste(rep(dash, 20), collapse = "")), "\n")
    }
    invisible(NULL)
}

#' Query ChEA3 API for TF enrichment
#'
#' @param genes Character vector of HGNC gene symbols.
#' @param query_name Optional query name (default: "rChEA3_query").
#' @param verbose Logical; if TRUE, print a grouped summary of available
#'   result collections (default: TRUE).
#'
#' @return A named list of data frames. Each element corresponds to a ChEA3
#'   collection and contains an enrichment table with transcription factors and
#'   their statistics. The expected names are:
#'   c("Integrated--meanRank", "Integrated--topRank",
#'     "GTEx--Coexpression", "ARCHS4--Coexpression",
#'     "ENCODE--ChIP-seq", "ReMap--ChIP-seq",
#'     "Literature--ChIP-seq", "Enrichr--Queries").
#' @export
#'
#' @examples
#' \dontrun{
#' results <- chea3_query(c("SMAD9","FOXO1","MYC","STAT1","STAT3","SMAD3"))
#' }
chea3_query <- function(genes, query_name = "rChEA3_query", verbose = TRUE) {
    stopifnot(is.character(genes), length(genes) > 0)

    url <- "https://maayanlab.cloud/chea3/api/enrich/"
    payload <- list(query_name = query_name, gene_set = unname(genes))

    resp <- httr::POST(url, body = payload, encode = "json")

    if (httr::status_code(resp) != 200) {
        stop("ChEA3 API request failed with status ", httr::status_code(resp))
    }

    txt <- httr::content(resp, "text", encoding = "UTF-8")
    parsed <- jsonlite::fromJSON(txt)

    # results as list of R dataframes (one per collection)
    .check_chea3_collections(parsed)
    if (isTRUE(verbose)) {
        # try to get the symbol name on the left-hand side
        .chea3_print_available(parsed)
    }

    .chea3_clean_all(parsed)
}
