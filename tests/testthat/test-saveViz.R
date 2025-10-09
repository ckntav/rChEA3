test_that("saveViz saves PDF correctly", {
  df <- data.frame(
    TF = paste0("TF", 1:5),
    Rank = 1:5,
    Score = seq(0.95, 0.55, length.out = 5)
  )

  viz <- visualizeRank(df, y_metric = "Score", top_n = 5)
  temp_dir <- tempdir()

  path <- saveViz(viz, output_dir = temp_dir, output_file = "test_pdf",
                  format = "pdf", with_date = FALSE, verbose = FALSE)

  expect_true(file.exists(path))
  expect_true(grepl("\\.pdf$", path))

  # Clean up
  unlink(path)
})

test_that("saveViz saves PNG correctly", {
  df <- data.frame(
    TF = paste0("TF", 1:3),
    Rank = 1:3,
    Score = c(0.9, 0.8, 0.7)
  )

  viz <- visualizeRank(df, y_metric = "Score", top_n = 3)
  temp_dir <- tempdir()

  path <- saveViz(viz, output_dir = temp_dir, output_file = "test_png",
                  format = "png", with_date = FALSE, verbose = FALSE)

  expect_true(file.exists(path))
  expect_true(grepl("\\.png$", path))

  # Clean up
  unlink(path)
})

test_that("saveViz saves SVG correctly", {
  df <- data.frame(
    TF = paste0("TF", 1:3),
    Rank = 1:3,
    Score = c(0.9, 0.8, 0.7)
  )

  viz <- visualizeRank(df, y_metric = "Score", top_n = 3)
  temp_dir <- tempdir()

  path <- saveViz(viz, output_dir = temp_dir, output_file = "test_svg",
                  format = "svg", with_date = FALSE, verbose = FALSE)

  expect_true(file.exists(path))
  expect_true(grepl("\\.svg$", path))

  # Clean up
  unlink(path)
})

test_that("saveViz validates format parameter", {
  df <- data.frame(TF = "TF1", Rank = 1, Score = 0.9)
  viz <- visualizeRank(df, y_metric = "Score", top_n = 1)

  expect_error(
    saveViz(viz, format = "invalid"),
    "'arg' should be one of"
  )
})

test_that("saveViz creates directory if missing", {
  df <- data.frame(TF = "TF1", Rank = 1, Score = 0.9)
  viz <- visualizeRank(df, y_metric = "Score", top_n = 1)

  temp_subdir <- file.path(tempdir(), "test_saveviz_subdir")
  if (dir.exists(temp_subdir)) unlink(temp_subdir, recursive = TRUE)

  path <- saveViz(viz, output_dir = temp_subdir, output_file = "test",
                  format = "pdf", with_date = FALSE, verbose = FALSE)

  expect_true(dir.exists(temp_subdir))
  expect_true(file.exists(path))

  # Clean up
  unlink(temp_subdir, recursive = TRUE)
})

test_that("saveViz verbose parameter works", {
  df <- data.frame(TF = "TF1", Rank = 1, Score = 0.9)
  viz <- visualizeRank(df, y_metric = "Score", top_n = 1)
  temp_dir <- tempdir()

  # verbose = FALSE: no message
  expect_silent(
    path1 <- saveViz(viz, output_dir = temp_dir, output_file = "test_silent",
                     format = "pdf", with_date = FALSE, verbose = FALSE)
  )

  # verbose = TRUE: should show message
  expect_message(
    path2 <- saveViz(viz, output_dir = temp_dir, output_file = "test_verbose",
                     format = "pdf", with_date = FALSE, verbose = TRUE),
    "Visualization.*saved"
  )

  # Clean up
  unlink(c(path1, path2))
})

test_that("saveViz returns invisible path", {
  df <- data.frame(TF = "TF1", Rank = 1, Score = 0.9)
  viz <- visualizeRank(df, y_metric = "Score", top_n = 1)
  temp_dir <- tempdir()

  path <- saveViz(viz, output_dir = temp_dir, output_file = "test_return",
                  format = "pdf", with_date = FALSE, verbose = FALSE)

  expect_type(path, "character")
  expect_true(file.exists(path))

  # Clean up
  unlink(path)
})

test_that("saveViz respects width and height parameters", {
  df <- data.frame(TF = "TF1", Rank = 1, Score = 0.9)
  viz <- visualizeRank(df, y_metric = "Score", top_n = 1)
  temp_dir <- tempdir()

  path <- saveViz(viz, output_dir = temp_dir, output_file = "test_dimensions",
                  format = "pdf", width = 10, height = 6,
                  with_date = FALSE, verbose = FALSE)

  expect_true(file.exists(path))

  # Clean up
  unlink(path)
})

test_that("saveViz works with base R plots", {
  temp_dir <- tempdir()

  # Create a simple plot function
  simple_plot <- function() {
    plot(1:10, 1:10, main = "Test Plot")
  }

  # This should work with any printable plot object
  path <- saveViz(simple_plot, output_dir = temp_dir, output_file = "test_base",
                  format = "pdf", with_date = FALSE, verbose = FALSE)

  expect_true(file.exists(path))

  # Clean up
  unlink(path)
})

test_that("saveViz requires output_dir", {
    df <- data.frame(TF = "TF1", Rank = 1, Score = 0.9)
    viz <- visualizeRank(df, y_metric = "Score", top_n = 1)

    expect_error(
        saveViz(viz, output_file = "test"),
        "'output_dir' must be specified. Please specify your desired directory."
    )
})
