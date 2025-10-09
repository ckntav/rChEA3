test_that("exportResults validates input", {
  expect_error(exportResults(list(), output_dir = temp_dir), "non-empty list")
  expect_error(exportResults("not a list", output_dir = temp_dir), "non-empty list")
})

test_that("exportResults accepts single data frame", {
  df <- data.frame(TF = "MYC", Rank = 1, Score = 0.95)
  temp_dir <- tempdir()

  path <- exportResults(df, output_dir = temp_dir, output_file = "test_single",
                        with_date = FALSE, verbose = FALSE)

  expect_true(file.exists(path))
  expect_true(grepl("\\.xlsx$", path))

  # Clean up
  unlink(path)
})

test_that("exportResults creates directory if missing", {
  df <- data.frame(TF = "MYC", Rank = 1)
  temp_subdir <- file.path(tempdir(), "test_export_subdir")

  # Ensure it doesn't exist
  if (dir.exists(temp_subdir)) unlink(temp_subdir, recursive = TRUE)

  path <- exportResults(df, output_dir = temp_subdir, output_file = "test",
                        with_date = FALSE, verbose = FALSE)

  expect_true(dir.exists(temp_subdir))
  expect_true(file.exists(path))

  # Clean up
  unlink(temp_subdir, recursive = TRUE)
})

test_that("exportResults strips .xlsx extension from output_file", {
  df <- data.frame(TF = "MYC", Rank = 1)
  temp_dir <- tempdir()

  path <- exportResults(df, output_dir = temp_dir, output_file = "test.xlsx",
                        with_date = FALSE, verbose = FALSE)

  # Should not have double .xlsx.xlsx
  expect_false(grepl("\\.xlsx\\.xlsx$", path))
  expect_true(grepl("\\.xlsx$", path))

  # Clean up
  unlink(path)
})

test_that("exportResults sanitizes sheet names", {
  # Sheet names with forbidden characters
  results <- list(
    "Test:Name" = data.frame(TF = "TF1", Rank = 1),
    "Test/Name" = data.frame(TF = "TF2", Rank = 2)
  )

  temp_dir <- tempdir()
  path <- exportResults(results, output_dir = temp_dir, output_file = "test_sanitize",
                        with_date = FALSE, verbose = FALSE)

  expect_true(file.exists(path))

  # Clean up
  unlink(path)
})

test_that("exportResults orders sheets correctly", {
  results <- list(
    "ENCODE--ChIP-seq" = data.frame(TF = "TF1", Rank = 1),
    "Integrated--meanRank" = data.frame(TF = "TF2", Rank = 2),
    "Integrated--topRank" = data.frame(TF = "TF3", Rank = 3)
  )

  temp_dir <- tempdir()
  path <- exportResults(results, output_dir = temp_dir, output_file = "test_order",
                        with_date = FALSE, verbose = FALSE)

  expect_true(file.exists(path))

  # Read back and check order (Integrated should come first)
  sheets <- readxl::excel_sheets(path)
  expect_equal(sheets[1], "Integrated--meanRank")
  expect_equal(sheets[2], "Integrated--topRank")

  # Clean up
  unlink(path)
})

test_that("exportResults verbose parameter works", {
  df <- data.frame(TF = "MYC", Rank = 1)
  temp_dir <- tempdir()

  # verbose = FALSE: no message
  expect_silent(
    path1 <- exportResults(df, output_dir = temp_dir, output_file = "test_silent",
                           with_date = FALSE, verbose = FALSE)
  )

  # verbose = TRUE: should show message
  expect_message(
    path2 <- exportResults(df, output_dir = temp_dir, output_file = "test_verbose",
                           with_date = FALSE, verbose = TRUE),
    "rChEA3 results saved"
  )

  # Clean up
  unlink(c(path1, path2))
})

test_that("exportResults returns invisible path", {
  df <- data.frame(TF = "MYC", Rank = 1)
  temp_dir <- tempdir()

  path <- exportResults(df, output_dir = temp_dir, output_file = "test_return",
                        with_date = FALSE, verbose = FALSE)

  expect_type(path, "character")
  expect_true(file.exists(path))

  # Clean up
  unlink(path)
})

test_that("exportResults handles long sheet names", {
  # Excel sheet names must be <= 31 chars
  results <- list(
    "This_is_a_very_long_sheet_name_that_exceeds_limit" = data.frame(TF = "TF1", Rank = 1)
  )

  temp_dir <- tempdir()
  path <- exportResults(results, output_dir = temp_dir, output_file = "test_long",
                        with_date = FALSE, verbose = FALSE)

  expect_true(file.exists(path))

  sheets <- readxl::excel_sheets(path)
  expect_true(nchar(sheets[1]) <= 31)

  # Clean up
  unlink(path)
})

test_that("exportResults requires output_dir", {
    df <- data.frame(TF = "MYC", Rank = 1, Score = 0.95)

    expect_error(
        exportResults(df, output_file = "test"),
        "'output_dir' must be specified. Please specify your desired directory."
    )
})
