
simple_jobs_env <- new.env(parent = emptyenv())
simple_jobs_env$tasks <- 0
simple_jobs_env$max <- 1
simple_jobs_env$ids <- list()
simple_jobs_env$results <- list()

#' Initializes simple-jobs.
#'
#' @param max_jobs Maximum number of concurrent jobs.
#'
#' @export
simple_jobs_init <- function(max_jobs = NULL) {
    if (is.null(max_jobs)) {
        max_jobs <- parallel::detectCores() * 1.5
    }
    simple_jobs_env$tasks <- 0
    simple_jobs_env$max <- max_jobs
    simple_jobs_env$ids <- list()
    simple_jobs_env$results <- list()

    NULL
}

# Collects results from finished simple-jobs.
#
simple_jobs_collect_ <- function() {
    done_jobs <- parallel::mccollect(wait = FALSE, timeout = 1)

    if (is.null(done_jobs)) {
        0
    } else {
        for (i in names(done_jobs)) {
            ii <- sprintf("pid-%s", i)
            if (!(ii %in% names(simple_jobs_env$ids))) {
                next
            }
            if (ii %in% names(simple_jobs_env$results)) {
                next
            }
            simple_jobs_env$results[[ii]] <- done_jobs[[i]]
            simple_jobs_env$tasks <- simple_jobs_env$tasks - 1
        }
        length(done_jobs)
    }
}

#' Submits new task to simple-jobs.
#'
#' @param expr Expression to evaluate asynchronously in a new thread (process).
#' @param name Custom name of the new task.
#' @return Job name
#'
#' @export
simple_jobs_submit <- function(expr, name = NULL) {
    # Block to avoid excessive parallelism.
    while (simple_jobs_env$tasks >= simple_jobs_env$max) {
        simple_jobs_collect_()
    }

    x <- parallel::mcparallel(expr)
    if (is.null(name)) {
        name <- sprintf(".job.%d", x[["pid"]])
    }
    x[["user_job_name"]] <- name

    simple_jobs_env$ids[[sprintf("pid-%d", x[["pid"]])]] <- x
    simple_jobs_env$tasks <- simple_jobs_env$tasks + 1

    name
}

#' Waits for completion of all simple-jobs.
#'
#' @return Task results as list, indexed by task name.
#'
#' @export
simple_jobs_collect <- function() {
    while (simple_jobs_env$tasks > 0) {
        simple_jobs_collect_()
    }

    res <- list()

    for (i in names(simple_jobs_env$ids)) {
        i_job <- simple_jobs_env$ids[[i]]
        i_job_name <- i_job[["user_job_name"]]
        res[[i_job_name]] <- simple_jobs_env$results[[i]]
    }

    simple_jobs_env$ids <- list()
    simple_jobs_env$results <- list()

    res
}
