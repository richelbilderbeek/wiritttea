#' Create figure_lowest_ess: Which estimated parameter has the lowest ESS?
#' @param esses the ESSes, as returned from read_collected_esses
#' @param filename name of the file the figure will be saved to
create_figure_lowest_ess <- function(
  esses,
  filename
) {

  lowest <- NULL; rm(lowest) # nolint, should fix warning: no visible binding for global variable


  # Tally the count of each parameter having the lowest ESS per posterior
  parameter_names <- c("posterior", "likelihood", "prior", "treeLikelihood", "TreeHeight", "BirthDeath", "birthRate2", "relativeDeathRate2")

  esses$lowest <- apply(esses[ , parameter_names], 1, min)

  # This is stupid, but could not get something descent to work quickly enough
  # Feel encouraged to send an improvement
  for (i in seq(1, nrow(esses))) {
    this_lowest <- esses$lowest[i]
    if (is.na(this_lowest)) {
      next
    }
    for (parameter_name in parameter_names) {
      this_value <- esses[ , parameter_name][i]
      if (is.na(this_value)) {
        next
      }
      if (this_value == this_lowest) {
        esses$lowest[i] <- parameter_name
      }
    }
  }

  # Create the factors
  esses$lowest <- as.factor(esses$lowest)

  # Make a histogram

  grDevices::svg("~/figure_lowest_ess.svg")
  ggplot2::ggplot(
    data = esses,
    ggplot2::aes(x = lowest, fill = lowest)
  ) +
    ggplot2::geom_bar() +
    ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 90, hjust = 1)) +
    ggplot2::ggtitle("Parameters with lowest ESS") +
    ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0.5)) +
    ggplot2::labs(caption = "figure_lowest_ess")

  ggplot2::ggsave(file = filename, width = 7, height = 7)
}