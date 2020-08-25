#' Camera-ready theme for ggplots
#'
#' Based on Tufte theme with several sizing adjustments.
#'
#' @export
camera_ready_theme <- function() {
    ggthemes::theme_tufte() +
    theme(
        text = element_text(size = 8),
        strip.text = element_text(size = 8),
        legend.text = element_text(size = 8),
        axis.line = element_line(size = 0.5, linetype = "solid"),
        panel.grid.major = element_line(
            color = "#C0C0C0", size = 0.2, linetype = "solid"
        ),
        panel.grid.minor = element_line(
            color = "#F0F0F0", size = 0.05, linetype = "solid"
        )
    )
}
