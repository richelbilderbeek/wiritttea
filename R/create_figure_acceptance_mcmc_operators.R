#' Create the figure 'Operator acceptances'
#' @param df_operators data frame with the collected operator acceptances
#' @param svg_filename the name of the file the figure is saved to
#' @return nothing, it saves a file
#' @author Richel Bilderbeek
#' @export
create_figure_acceptance_mcmc_operators <- function(
  df_operators,
  svg_filename
) {
  optimum_acceptance_level <- 0.234
  ggplot2::ggplot(
    na.omit(df_operators),
    ggplot2::aes(x = operator, y = p, fill = operator)
  ) +
    ggplot2::geom_boxplot() +
    ggplot2::labs(
      title = "Operator acceptances",
      x = "Operator",
      y = "Acceptance",
      caption = "figure_acceptance_mcmc_operators"
    ) +
    ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0.5)) +
    ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 90, hjust = 1)) +
    ggplot2::geom_hline(yintercept = optimum_acceptance_level,
      linetype = "dashed")

  ggplot2::ggsave(file = svg_filename, width = 7, height = 7)
}