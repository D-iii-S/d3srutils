#!/usr/bin/env Rscript

msg <- function(x) {
    cat(sprintf("\n==> %s\n\n", x))
}

msg("Importing...")
library(devtools)
library(lintr)

msg("Generating documentation and README.md...")
devtools::document()
devtools::build_readme()

msg("Running lint...")
lintr::lint_dir("R")
lintr::lint_dir("bin")
