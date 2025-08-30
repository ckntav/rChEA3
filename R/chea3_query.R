#' Query ChEA3 API for TF enrichment
#'
#' @param genes Character vector of HGNC gene symbols.
#' @param query_name Optional query name (default: "rChEA3_query").
#'
#' @return A named list of data frames, one per collection, containing
#'   transcription factor enrichment results.
#' @export
#'
#' @examples
#' \dontrun{
#' chea3_query(c("SMAD9","FOXO1","MYC","STAT1","STAT3","SMAD3"))
#' }
chea3_query <- function(genes, query_name = "rChEA3_query") {
    stopifnot(is.character(genes), length(genes) > 0)

    url <- "https://maayanlab.cloud/chea3/api/enrich/"
    payload <- list(query_name = query_name, gene_set = unname(genes))

    resp <- httr::POST(url, body = payload, encode = "json")

    if (httr::status_code(resp) != 200) {
        stop("ChEA3 API request failed with status ", httr::status_code(resp))
    }

    txt <- httr::content(resp, "text", encoding = "UTF-8")
    parsed <- jsonlite::fromJSON(txt)

    # on retourne une liste de data.frames (un par collection)
    parsed
}
