
<!-- README.md is generated from README.Rmd. Please edit that file -->

# D3S R Utils

Collection of various simple functions that we copy over and over again.

## Installation

``` r
# install.packages("devtools")
devtools::install_github("D-iii-S/d3srutils")
library("d3s")
```

## Function Overview

| Function                   | Description                                       |
| :------------------------- | :------------------------------------------------ |
| `camera_ready_theme`       | Camera-ready theme for ggplots.                   |
| `logger_banner`            | Logs a banner message.                            |
| `logger_crazy`             | Logs a detailed debugging message.                |
| `logger_debug`             | Logs a debugging message.                         |
| `logger_info`              | Logs an information message.                      |
| `logger_level`             | Set logging level.                                |
| `logger_progress_init`     | Initializes logger-based progress messages.       |
| `logger_progress`          | Inform about one task completion.                 |
| `logger_warn`              | Logs a warning message.                           |
| `printf`                   | C-like printf.                                    |
| `simple_jobs_collect`      | Waits for completion of all simple-jobs.          |
| `simple_jobs_init`         | Initializes simple-jobs.                          |
| `simple_jobs_submit`       | Submits new task to simple-jobs.                  |
| `write_csv_non_scientific` | Save tibble into CSV without scientific notation. |

## Development

  - Run `./bin/make.R` before commit to ensure that `README.md` is
    up-to-date and the code is well-formatted.
