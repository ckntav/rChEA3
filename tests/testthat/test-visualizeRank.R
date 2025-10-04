test_that("visualizeRank requires TF and Rank columns", {
  df_missing_tf <- data.frame(Rank = 1:5, Score = runif(5))
  df_missing_rank <- data.frame(TF = paste0("TF", 1:5), Score = runif(5))

  expect_error(visualizeRank(df_missing_tf), "Missing required columns.*TF")
  expect_error(visualizeRank(df_missing_rank), "Missing required columns.*Rank")
})

test_that("visualizeRank auto-detects metric", {
  # Test with FDR
  df_fdr <- data.frame(
    TF = paste0("TF", 1:5),
    Rank = 1:5,
    FDR = c(0.001, 0.01, 0.02, 0.03, 0.04),
    stringsAsFactors = FALSE
  )

  p <- visualizeRank(df_fdr, y_metric = "auto", top_n = 5)
  expect_s3_class(p, "ggplot")

  # Test with Score (integrated)
  df_score <- data.frame(
    TF = paste0("TF", 1:5),
    Rank = 1:5,
    Score = c(0.95, 0.85, 0.75, 0.65, 0.55),
    stringsAsFactors = FALSE
  )

  p_score <- visualizeRank(df_score, y_metric = "auto", top_n = 5)
  expect_s3_class(p_score, "ggplot")
})

test_that("visualizeRank validates y_metric parameter", {
  df <- data.frame(
    TF = paste0("TF", 1:3),
    Rank = 1:3,
    Score = c(0.9, 0.8, 0.7)
  )

  expect_error(visualizeRank(df, y_metric = "invalid"), "'arg' should be one of")
})

test_that("visualizeRank filters by FDR threshold", {
  df <- data.frame(
    TF = paste0("TF", 1:10),
    Rank = 1:10,
    FDR = c(0.001, 0.01, 0.02, 0.03, 0.04, 0.06, 0.08, 0.1, 0.15, 0.2),
    stringsAsFactors = FALSE
  )

  # With default threshold 0.05, should only show 5 TFs
  p <- visualizeRank(df, y_metric = "FDR", fdr_threshold = 0.05, top_n = 20)
  expect_s3_class(p, "ggplot")

  # Check subtitle mentions 5 significant TFs
  p_built <- ggplot2::ggplot_build(p)
  subtitle <- p$labels$subtitle
  expect_true(grepl("5", subtitle))
})

test_that("visualizeRank handles no significant results", {
  df <- data.frame(
    TF = paste0("TF", 1:3),
    Rank = 1:3,
    FDR = c(0.1, 0.2, 0.3),  # All above threshold
    stringsAsFactors = FALSE
  )

  p <- visualizeRank(df, y_metric = "FDR", fdr_threshold = 0.05)
  expect_s3_class(p, "ggplot")

  # Should mention "No TF passed"
  expect_true(grepl("No TF passed", p$labels$subtitle))
})

test_that("visualizeRank respects top_n parameter", {
  df <- data.frame(
    TF = paste0("TF", 1:20),
    Rank = 1:20,
    Score = seq(0.95, 0.05, length.out = 20),
    stringsAsFactors = FALSE
  )

  p <- visualizeRank(df, y_metric = "Score", top_n = 5)
  expect_s3_class(p, "ggplot")

  # Extract data from plot
  p_data <- ggplot2::layer_data(p)
  expect_equal(nrow(p_data), 5)
})

test_that("visualizeRank creates proper plot structure", {
  df <- data.frame(
    TF = c("MYC", "FOXO1", "STAT3"),
    Rank = 1:3,
    Score = c(0.95, 0.85, 0.75),
    stringsAsFactors = FALSE
  )

  p <- visualizeRank(df, y_metric = "Score", top_n = 3)

  expect_s3_class(p, "ggplot")
  expect_equal(p$labels$x, "Transcription factor (TF | Rank)")
  expect_equal(p$labels$y, "Score")
})

test_that("visualizeRank handles integrated meanRank detection", {
  df_meanrank <- data.frame(
    TF = paste0("TF", 1:3),
    Rank = 1:3,
    Score = c(0.9, 0.8, 0.7),
    Library = c("Lib1;Lib2", "Lib1;Lib3", "Lib2;Lib3"),
    stringsAsFactors = FALSE
  )

  p <- visualizeRank(df_meanrank, y_metric = "Score")
  expect_s3_class(p, "ggplot")
  expect_true(grepl("Mean Rank", p$labels$subtitle))
})

test_that("visualizeRank validates required columns for each metric", {
  df_no_fdr <- data.frame(TF = "TF1", Rank = 1, Score = 0.9)

  expect_error(visualizeRank(df_no_fdr, y_metric = "FDR"), 'Column "FDR" not found')

  df_no_score <- data.frame(TF = "TF1", Rank = 1, FDR = 0.01)

  expect_error(visualizeRank(df_no_score, y_metric = "Score"), 'Column "Score" not found')
})
