test_that("displayTopN requires named list input", {
  expect_error(displayTopN(list(data.frame())), "named")
  expect_error(displayTopN("not a list"), "named")
})

test_that("displayTopN validates n parameter", {
  mock_results <- list("Test" = data.frame(TF = "MYC", Rank = 1))

  expect_error(displayTopN(mock_results, n = "ten"), "single non-negative number")
  expect_error(displayTopN(mock_results, n = -5), "single non-negative number")
  expect_error(displayTopN(mock_results, n = c(1, 2)), "single non-negative number")
})

test_that("displayTopN displays integrated results", {
  mock_integrated <- list(
    "Integrated--meanRank" = data.frame(
      TF = c("TF1", "TF2", "TF3"),
      Rank = 1:3,
      Score = c(0.95, 0.85, 0.75),
      stringsAsFactors = FALSE
    )
  )

  expect_output(displayTopN(mock_integrated, n = 2), "Integrated Results")
  expect_output(displayTopN(mock_integrated, n = 2), "Mean Rank")
})

test_that("displayTopN respects n parameter", {
  mock_data <- list(
    "ENCODE--ChIP-seq" = data.frame(
      TF = paste0("TF", 1:20),
      Rank = 1:20,
      "FET p-value" = runif(20, 0, 0.05),
      check.names = FALSE,
      stringsAsFactors = FALSE
    )
  )

  # Capture output and check it doesn't show more than n rows
  output <- capture.output(displayTopN(mock_data, n = 5))
  # Should not contain TF11 or higher when only showing top 5
  expect_false(any(grepl("TF11", output)))
})

test_that("displayTopN handles column subsetting", {
  mock_data <- list(
    "ENCODE--ChIP-seq" = data.frame(
      TF = c("TF1", "TF2"),
      Rank = 1:2,
      "FET p-value" = c(0.001, 0.002),
      "Extra Column" = c("A", "B"),
      check.names = FALSE,
      stringsAsFactors = FALSE
    )
  )

  # Should only show requested columns
  output <- capture.output(displayTopN(mock_data, columns = c("TF", "Rank")))
  expect_false(any(grepl("Extra Column", output)))
})

test_that("displayTopN handles empty data frames", {
  mock_empty <- list(
    "ENCODE--ChIP-seq" = data.frame(
      TF = character(0),
      Rank = integer(0),
      stringsAsFactors = FALSE
    )
  )

  expect_output(displayTopN(mock_empty), "no rows")
})
