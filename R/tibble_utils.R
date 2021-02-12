#' Save tibble into CSV without scientific notation.
#'
#' See https://github.com/tidyverse/readr/issues/671 for reasoning
#' behind this function.
#'
#' @param x Tibble to save
#' @param filename CSV filename
#' @param ... Additional parameters for readr::format_csv
#'
#' @export
write_csv_non_scientific <- function(x, filename, ...) {
    do_format <- function(xx, ...) {
        numeric_cols <- vapply(xx, is.numeric, logical(1))
        x[numeric_cols] <- lapply(xx[numeric_cols], format, ...)
        x
    }

    fd <- file(filename)
    writeLines(readr::format_csv(do_format(x, scientific = FALSE), ...), fd)
    close(fd)
}
