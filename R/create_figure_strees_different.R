#' Create figure_strees_different
#' Analyse if the two sampled species trees are identical
#' @param strees_identical dataframe with which species trees are identical,
#'   as returned from read_collected_strees_identical
#' @param filename name of the file the figure will be saved to
create_figure_strees_different <- function(
  strees_identical,
  filename
) {

  ggplot2::ggplot(
    strees_identical,
    ggplot2::aes(x = strees_identical, fill = strees_identical)
  ) + ggplot2::geom_bar() +
      ggplot2::xlab("") +
      ggplot2::labs(
      title = "How often do sampled species trees differ?",
      caption  = filename,
      fill = "Are the\nsampled\nspecies tree\ndifferent?") +
    ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0.5))

  ggplot2::ggsave(file = filename, width = 7, height = 7)
}