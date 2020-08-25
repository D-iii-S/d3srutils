#' C-like printf
#'
#' Behaves exactly like printf from C: no automatic line endings etc.
#'
#' @param fmt printf-style format
#' @param ... Arguments to be formatted.
#'
#' @export
printf <- function(fmt, ...) {
    writeLines(sprintf(fmt = fmt, ...), sep = "")
}
