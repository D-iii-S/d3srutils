logger_env <- new.env(parent = emptyenv())
logger_env$level <- 99
logger_env$progress <- list()
logger_env$progress$msg <- "Call logger_progress_init() first (%.0f tasks done)"
logger_env$progress$count <- 0
logger_env$progress$step <- 1
logger_env$progress$max <- 100

#' Set logging level.
#'
#' Messages with higher (more detailed) level will not be printed.
#'
#' @param new_level One of `warn`, `info`, `debug` or `crazy`.
#' @param ... Arguments to be formatted.
#'
#' @export
logger_level <- function(new_level) {
    new_level <- tolower(new_level)
    if (new_level == "warn") {
        logger_env$level <- 2
    } else if (new_level == "info") {
        logger_env$level <- 3
    } else if (new_level == "debug") {
        logger_env$level <- 4
    } else if (new_level == "crazy") {
        logger_env$level <- 5
    }
}

logger_msg <- function(prefix, level, fmt, ...) {
    if (level <= logger_env$level) {
        msg <- sprintf(fmt, ...)
        now <- strftime(Sys.time(), "%Y-%m-%d %H:%M:%S")
        line <- sprintf("# %s %5s %5s | %s", now, Sys.getpid(), prefix, msg)
        writeLines(line, sep = "\n")
    }
}

# TODO: merge these into the same manpage

#' Logs a warning message.
#'
#' @param fmt sprintf-like formatting string.
#' @param ... Values to be passed to `fmt`.
#'
#' @export
logger_warn <- function(fmt, ...) {
    logger_msg("WARN", 2, fmt, ...)
}

#' Logs an information message.
#'
#' @param fmt sprintf-like formatting string.
#' @param ... Values to be passed to `fmt`.
#'
#' @export
logger_info <- function(fmt, ...) {
    logger_msg("INFO", 3, fmt, ...)
}

#' Logs a debugging message.
#'
#' @param fmt sprintf-like formatting string.
#' @param ... Values to be passed to `fmt`.
#'
#' @export
logger_debug <- function(fmt, ...) {
    logger_msg("DEBUG", 4, fmt, ...)
}

#' Logs a detailed debugging message.
#'
#' @param fmt sprintf-like formatting string.
#' @param ... Values to be passed to `fmt`.
#'
#' @export
logger_crazy <- function(fmt, ...) {
    logger_msg("DEBUG", 5, fmt, ...)
}

#' Logs a banner message.
#'
#' Useful for delimiting big parts of your long-running scripts.
#'
#' @param fmt sprintf-like formatting string.
#' @param ... Values to be passed to `fmt`.
#'
#' @export
logger_banner <- function(fmt, ...) {
    fmt <- paste(c("|", fmt, "|"), sep = "", collapse = " ")
    line <- sprintf(fmt, ...)
    line <- paste(rep("-", nchar(line) - 2), sep = "", collapse = "")
    logger_info("")
    logger_info("")
    logger_info(".%s.", line)
    logger_info(fmt, ...)
    logger_info("`%s'", line)
    logger_info("")
}

#' Initializes logger-based progress messages.
#'
#' @param fmt sprintf-like formatting string that will receive percentage.
#' @param task_count How many tasks to expect.
#' @param steps How many tasks has to finish before message is printed.
#'
#' @export
logger_progress_init <- function(msg, task_count, steps = 0.1) {
    if (steps <= 0) steps <- 0.1
    if (steps < 1)  steps <- round(task_count * steps)
    if (steps == 0) steps <- 1

    logger_env$progress <- list(
        msg = msg,
        count = 0,
        step = steps,
        max = task_count
    )
}

#' Inform about one task completion.
#'
#' May print message from `logger_progress_init`.
#'
#' @export
logger_progress <- function() {
    logger_env$progress$count <- logger_env$progress$count + 1
    if ((logger_env$progress$count %% logger_env$progress$step) == 0) {
        percent <- 100 * logger_env$progress$count / logger_env$progress$max
        logger_info(logger_env$progress$msg, percent)
    }
}
