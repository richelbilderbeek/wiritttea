#' Create 'figure_ess_distribution'
#' @param parameters parameters, as returned from read_collected_parameters
#' @param esses the ESSes, as returned from read_collected_esses
#' @param filename name of the file the figure will be saved to
#' @author Richel Bilderbeek
#' @export
create_figure_ess_distribution <- function(
  parameters,
  esses,
  filename
) {

  variable <- NULL; rm(variable) # nolint, should fix warning: no visible binding for global variable
  value <- NULL; rm(value) # nolint, should fix warning: no visible binding for global variable
  ess <- NULL; rm(ess) # nolint, should fix warning: no visible binding for global variable
  parameter <- NULL; rm(parameter) # nolint, should fix warning: no visible binding for global variable

  # Melt data, convert to long form
  esses_long <- reshape2::melt(esses,
    id = c("filename", "sti", "ai", "pi")
  )
  testit::assert(is.factor(esses_long$variable))

  esses_long <- dplyr::rename(esses_long, parameter = variable)
  esses_long <- dplyr::rename(esses_long, ess = value)

  # print("Connect the ESSes and parameters")
  testit::assert("filename" %in% names(parameters))
  testit::assert("filename" %in% names(esses))
  df <- merge(x = parameters, y = esses_long, by = "filename", all = TRUE)


  ggplot2::ggplot(
    data = stats::na.omit(df),
    ggplot2::aes(x = ess, fill = parameter)) +
    ggplot2::geom_histogram(alpha = 0.5, position = "identity", binwidth = 10) +
    ggplot2::facet_grid(erg ~ scr) +
    ggplot2::labs(
      title =
        "The distribution of Effective Sample Sizes per parameter estimate\nfor different speciation completion (columns) and extinction rates",
      x = "Effective Sample Size",
      y = "Count",
      caption = filename
    ) +
    ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0.5)) +
    ggplot2::geom_vline(xintercept = 200, linetype = "dotted")

  ggplot2::ggsave(file = filename, width = 7, height = 7)
}
