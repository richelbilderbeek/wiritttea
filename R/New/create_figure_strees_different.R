#' Create figure_strees_different
#' Analyse if the two sampled species trees are identical
#' @param filename name of the file the figure will be saved to
create_figure_strees_different <- function(
  df_strees <- wiritttea::read_collected_strees_identical(strees_filename),
  filename
) {


  ggplot2::ggplot(
    df_strees,
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