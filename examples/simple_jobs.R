#!/usr/bin/env Rscript

require("tidyverse")
require("d3s")

emulate_bootstrap <- function(x, subset_size, replicas) {
    res <- c()

	for (i in 1:replicas) {
		x_subset <- sample(x, size=subset_size)
		res <- c(res, mean(x_subset))
	}
	
	res
}

make_tibble_with_samples <- function(x_type, x_samples) {
    tibble(type=rep(x_type, length(x_samples)), sample=x_samples)
}

TYPE_COUNT <- 8
INPUT_SAMPLES <- 5000
SUBSET_SIZE <- 10
REPLICAS <- 50000

x <- tibble(type=c(), value=c())
for (i in 1:TYPE_COUNT) {
    x <- x %>% add_row(tibble(type=sprintf("type-%d", i), value=rnorm(INPUT_SAMPLES, mean=2*i*TYPE_COUNT)))
}

# Do the pseudo-bootstrap

x_types <- unique(x$type)

logger_info("Computing in single-threaded mode ...")
x_result_single <- tibble(type=c(), sample=c())
for (i in x_types) {
    x_samples <- emulate_bootstrap((x %>% filter(type == i))[["value"]], SUBSET_SIZE, REPLICAS)
    x_result_single <- x_result_single %>% add_row(make_tibble_with_samples(i, x_samples))
}
logger_info(" ... finished.")


logger_info("Computing in simple-jobs mode ...")
x_result_multi <- tibble(type=c(), sample=c())
simple_jobs_init()
for (i in x_types) {
    simple_jobs_submit(emulate_bootstrap((x %>% filter(type == i))[["value"]], SUBSET_SIZE, REPLICAS), i)
}
x_results <- simple_jobs_collect()
for (i in x_types) {
    x_result_multi <- x_result_multi %>% add_row(make_tibble_with_samples(i, x_results[[i]]))
}
logger_info(" ... finished.")

