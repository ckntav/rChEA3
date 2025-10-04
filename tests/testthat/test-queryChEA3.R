test_that("queryChEA3 requires character vector input", {
  expect_error(queryChEA3(123), "is.character")
  expect_error(queryChEA3(NULL), "is.character")
  expect_error(queryChEA3(character(0)), "length\\(genes\\) > 0")
})

test_that("queryChEA3 returns a named list", {
  skip_if_offline()
  skip_on_cran()

  genes <- c("SMAD9", "FOXO1", "MYC")
  result <- queryChEA3(genes, verbose = FALSE)

  expect_type(result, "list")
  expect_true(length(names(result)) > 0)
})

test_that("queryChEA3 returns expected collections", {
  skip_if_offline()
  skip_on_cran()

  genes <- c("SMAD9", "FOXO1", "MYC", "STAT1", "STAT3")
  result <- queryChEA3(genes, verbose = FALSE)

  expected_collections <- c(
    "Integrated--meanRank", "Integrated--topRank",
    "GTEx--Coexpression", "ARCHS4--Coexpression",
    "ENCODE--ChIP-seq", "ReMap--ChIP-seq",
    "Literature--ChIP-seq", "Enrichr--Queries"
  )

  # Should have at least some of the expected collections
  expect_true(any(expected_collections %in% names(result)))
})

test_that("queryChEA3 data frames have correct structure", {
  skip_if_offline()
  skip_on_cran()

  genes <- c("SMAD9", "FOXO1", "MYC")
  result <- queryChEA3(genes, verbose = FALSE)

  # Check that all elements are data frames
  expect_true(all(sapply(result, is.data.frame)))

  # Check that TF and Rank columns exist where expected
  if ("Integrated--meanRank" %in% names(result)) {
    expect_true("TF" %in% names(result[["Integrated--meanRank"]]))
    expect_true("Rank" %in% names(result[["Integrated--meanRank"]]))
    expect_true("Score" %in% names(result[["Integrated--meanRank"]]))
  }
})

test_that("queryChEA3 verbose parameter works", {
  skip_if_offline()
  skip_on_cran()

  genes <- c("MYC", "FOXO1")

  # With verbose = FALSE, should not print
  expect_silent(queryChEA3(genes, verbose = FALSE))

  # With verbose = TRUE, should print (captured output)
  expect_output(queryChEA3(genes, verbose = TRUE), "Available results")
})

test_that(".rchea3_clean converts types correctly", {
  # Test integrated collection
  df_integrated <- data.frame(
    TF = c("TF1", "TF2"),
    Rank = c("1", "2"),
    Score = c("0.95", "0.85"),
    stringsAsFactors = FALSE
  )

  cleaned <- rChEA3:::.rchea3_clean(df_integrated, "Integrated--meanRank")
  expect_type(cleaned$Rank, "integer")
  expect_type(cleaned$Score, "double")

  # Test regular collection
  df_regular <- data.frame(
    TF = c("TF1", "TF2"),
    Rank = c("1", "2"),
    "FET p-value" = c("0.001", "0.005"),
    check.names = FALSE,
    stringsAsFactors = FALSE
  )

  cleaned_reg <- rChEA3:::.rchea3_clean(df_regular, "ENCODE--ChIP-seq")
  expect_type(cleaned_reg$Rank, "integer")
  expect_type(cleaned_reg[["FET p-value"]], "double")
})
