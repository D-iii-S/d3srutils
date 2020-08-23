#!/usr/bin/env Rscript

msg <- function(x) {
    cat(sprintf("\n==> %s\n\n", x))
}

msg("Importing...")
library(devtools)
library(lintr)

msg("Building README.md...")
devtools::build_readme()

msg("Running lint...")
lintr::lint_dir("R")
lintr::lint_dir("bin")
