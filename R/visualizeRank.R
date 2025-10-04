#' Visualize top transcription factors (TFs) from ChEA3 results
#'
#' Create a bar plot of the most significant transcription factors from a
#' ChEA3 result table. The y-axis can be based on `FDR`, `FET p-value`,
#' or `Score` (for integrated results). Bars are ordered by rank (Rank = 1
#' at the top).
#'
#' The plot subtitle automatically reports the number of *significant TFs*
#' (after filtering by `fdr_threshold` or `p_threshold` when applicable),
#' while `top_n` controls how many of those TFs are displayed. For
#' integrated collections (`Mean Rank` and `Top Rank`), the subtitle shows
#' a descriptive label instead of individual library names.
#'
#' @param df_result A ChEA3 result data frame. Must contain at least columns:
#'   - `TF` (transcription factor symbol),
#'   - `Rank` (integer rank).
#'   Optionally: `FDR`, `FET p-value`, `Score`.
#' @param y_metric Character; which metric to use on the y-axis. One of:
#'   - `"auto"` (default): use FDR if present, otherwise FET p-value, otherwise Score.
#'   - `"FDR"`: use FDR (requires `FDR` column).
#'   - `"FET p-value"`: use Fisher’s exact test p-value (requires `FET p-value` column).
#'   - `"Score"`: use Score (used in integrated meanRank/topRank).
#' @param fdr_threshold Numeric; FDR cutoff for significance (default `0.05`).
#'   Used only if `y_metric = "FDR"`.
#' @param p_threshold Numeric; p-value cutoff for significance (default `0.05`).
#'   Used only if `y_metric = "FET p-value"`.
#' @param query_name Character; name of the input gene set, shown in the subtitle (default `myGeneList`)
#' @param title_plot Character; main plot title (default `rChEA3 results (transcription factor enrichment analysis)`)
#' @param top_n Integer; number of TFs to display (default `10`). The subtitle
#'   reports the total number of significant TFs, while only the top_n by rank
#'   are plotted.
#' @param fill_color Character; fill color of the bars (default `"#7AAACE"`).
#'
#' @return A `ggplot` object.
#' @importFrom stats setNames
#' @importFrom rlang .data
#' @export
#'
#' @examples
#' \dontrun{
#' # Assuming `res` is a data frame returned by queryChEA3()[["Integrated--meanRank"]]
#' visualizeRank(res, y_metric = "Score", top_n = 15)
#'
#' # Plot based on FDR
#' res_chip <- queryChEA3(c("MYC","FOXO1"))[["ENCODE--ChIP-seq"]]
#' visualizeRank(res_chip, y_metric = "FDR", fdr_threshold = 0.01)
#' }
visualizeRank <- function(df_result,
                                y_metric = c("auto", "FDR", "FET p-value", "Score"),
                                fdr_threshold = 0.05,
                                p_threshold = 0.05,
                                query_name = "myGeneList",
                                title_plot = "rChEA3 results (transcription factor enrichment analysis)",
                                top_n = 10,
                                fill_color = "#7AAACE") {
    y_metric <- match.arg(y_metric)

    # --- Checks
    needed <- c("TF", "Rank")
    miss <- setdiff(needed, colnames(df_result))
    if (length(miss)) stop("Missing required columns: ", paste(miss, collapse = ", "))

    if (!is.numeric(df_result$Rank)) suppressWarnings(df_result$Rank <- as.numeric(df_result$Rank))
    if (!is.numeric(top_n) || length(top_n) != 1 || is.na(top_n) || top_n < 1) top_n <- 10L
    top_n <- as.integer(top_n)

    # Helpers from your mapping table
    tab <- .chea3_collection_table()
    lab_map <- setNames(tab$label, tab$internal)
    desc_map <- setNames(tab$description, tab$internal)
    pretty_lib <- function(internal) {
        lbl <- unname(lab_map[internal]); dsc <- unname(desc_map[internal])
        if (is.na(lbl)) internal else paste0(lbl, " - ", dsc)
    }

    # Detect Integrated by schema
    is_integrated <- ("Score" %in% names(df_result)) && !any(c("FDR", "FET p-value") %in% names(df_result))
    is_meanrank <- is_integrated && ("Library" %in% names(df_result)) && any(grepl(";", df_result$Library, fixed = TRUE))
    is_toprank  <- is_integrated && !is_meanrank

    # Auto y_metric
    if (y_metric == "auto") {
        if ("FDR" %in% names(df_result)) y_metric <- "FDR"
        else if ("FET p-value" %in% names(df_result)) y_metric <- "FET p-value"
        else if ("Score" %in% names(df_result)) y_metric <- "Score"
        else stop('Could not auto-detect metric: none of "FDR", "FET p-value", or "Score" found.')
    }

    # --- Metric-specific filtering
    df_sign <- df_result
    thresh_label <- NULL
    ylab <- NULL
    hline_val <- NULL

    if (y_metric == "FDR") {
        if (!("FDR" %in% names(df_result))) stop('Column "FDR" not found.')
        df_sign <- dplyr::filter(df_sign, !is.na(.data$FDR), .data$FDR <= fdr_threshold)
        ylab <- expression(-log[10](FDR))
        hline_val <- -log10(fdr_threshold)
        df_sign$.metric_val <- df_sign$FDR
        thresh_label <- paste0("FDR \u2264 ", fdr_threshold)
    } else if (y_metric == "FET p-value") {
        if (!("FET p-value" %in% names(df_result))) stop('Column "FET p-value" not found.')
        df_sign <- dplyr::filter(df_sign, !is.na(.data[["FET p-value"]]), .data[["FET p-value"]] <= p_threshold)
        ylab <- expression(-log[10](italic(p)))
        hline_val <- -log10(p_threshold)
        df_sign$.metric_val <- df_sign[["FET p-value"]]
        thresh_label <- paste0("p \u2264 ", p_threshold)
    } else { # Score: no significance filter
        if (!("Score" %in% names(df_result))) stop('Column "Score" not found.')
        ylab <- "Score"
        hline_val <- NA_real_
        df_sign$.metric_val <- df_sign$Score
    }

    # --- Count significant BEFORE slicing
    n_sig <- nrow(df_sign)

    # Early exit if nothing passes
    if (n_sig == 0L) {
        library_line <- NULL
        if (is_meanrank) {
            library_line <- pretty_lib("Integrated--meanRank")
        } else if (is_toprank) {
            library_line <- pretty_lib("Integrated--topRank")
        } else if ("Library" %in% names(df_result) && any(!is.na(df_result$Library))) {
            libs <- unique(stats::na.omit(df_result$Library))
            library_line <- paste0("Library: ",
                                   paste(vapply(libs, pretty_lib, FUN.VALUE = character(1)), collapse = ", "))
        }
        subtitle_plot <- paste(
            c(paste0("Input: ", query_name),
              library_line,
              paste0("No TF passed ", if (!is.null(thresh_label)) thresh_label else "selection")),
            collapse = "\n"
        )
        return(
            ggplot2::ggplot() +
                ggplot2::theme_void() +
                ggplot2::labs(title = title_plot, subtitle = subtitle_plot)
        )
    }

    # --- Now order by Rank and slice the ones to SHOW
    df_plot <- df_sign |>
        dplyr::arrange(.data$Rank) |>
        dplyr::slice_head(n = top_n) |>
        dplyr::mutate(label = paste(.data$TF, .data$Rank, sep = " | "))

    level_order <- rev(df_plot$label)  # so Rank 1 is at top
    df_plot$label <- factor(df_plot$label, levels = level_order)

    # --- Subtitle
    library_line <- NULL
    if (is_meanrank) {
        library_line <- pretty_lib("Integrated--meanRank")
    } else if (is_toprank) {
        library_line <- pretty_lib("Integrated--topRank")
    } else if ("Library" %in% names(df_plot) && any(!is.na(df_plot$Library))) {
        libs <- unique(stats::na.omit(df_plot$Library))
        library_line <- paste0("Library: ",
                               paste(vapply(libs, pretty_lib, FUN.VALUE = character(1)), collapse = ", "))
    }

    subtitle_bits <- c(
        paste0("Input: ", query_name),
        library_line,
        if (!is.null(thresh_label))
            paste0("Total number of significant TFs: ", n_sig, " (", thresh_label, ")")
        else
            paste0("TFs shown: ", nrow(df_plot), " / ", n_sig)
    )
    subtitle_plot <- paste(subtitle_bits, collapse = "\n")

    # --- Plot
    if (y_metric %in% c("FDR", "FET p-value")) {
        p <- ggplot2::ggplot(df_plot, ggplot2::aes(x = .data$label, y = -log10(.data$.metric_val))) +
            ggplot2::geom_col(fill = fill_color) +
            ggplot2::geom_hline(yintercept = -log10(if (y_metric == "FDR") fdr_threshold else p_threshold),
                                linetype = "dashed", color = "grey30") +
            ggplot2::coord_flip() +
            ggplot2::theme_minimal(base_size = 12) +
            ggplot2::labs(
                title = title_plot,
                subtitle = subtitle_plot,
                x = "Transcription factor (TF | Rank)",
                y = ylab
            ) +
            ggplot2::scale_y_continuous(expand = ggplot2::expansion(mult = c(0, 0.05)))
    } else {
        p <- ggplot2::ggplot(df_plot, ggplot2::aes(x = .data$label, y = .data$.metric_val)) +
            ggplot2::geom_col(fill = fill_color) +
            ggplot2::coord_flip() +
            ggplot2::theme_minimal(base_size = 12) +
            ggplot2::labs(
                title = title_plot,
                subtitle = subtitle_plot,
                x = "Transcription factor (TF | Rank)",
                y = "Score"
            ) +
            ggplot2::scale_y_continuous(expand = ggplot2::expansion(mult = c(0, 0.05)))
    }

    return(p)
}
