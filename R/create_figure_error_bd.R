#' Create figure create_figure_error_bd
#' @param parameters parameters, as returned from read_collected_parameters
#' @param nltt_stats the nLTT statistics, as returned from read_collected_nltt_stats
#' @param filename name of the file the figure will be saved to
#' @author Richel Bilderbeek
#' @export
create_figure_error_bd <- function(
  parameters,
  nltt_stats,
  filename
) {

  testit::assert("filename" %in% names(parameters))
  testit::assert("filename" %in% names(nltt_stats))
  df <- merge(x = parameters, y = nltt_stats, by = "filename", all = TRUE)

  # print("Only keep rows with the highest SCR (as those are a BD model)")
  # print(paste0("Rows before: ", nrow(df)))
  dplyr::count(df, scr)
  scr_bd <- max(stats::na.omit(df$scr))
  df <- df[ df$scr == scr_bd, ]
  # print(paste0("Rows after: ", nrow(df)))

  ggplot2::ggplot(
    data = stats::na.omit(df),
    ggplot2::aes(x = nltt_stat)
  ) +
    ggplot2::geom_histogram(binwidth = 0.001) +
    ggplot2::facet_grid(erg ~ sirg) +
    ggplot2::labs(
      title =
        "nLTT statistics\nfor different extinction (columns)\nand speciation inition rates (rows)",
      x = "nLTT statistic",
      y = "Count",
      caption = filename
    ) +
    ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0.5))

  ggplot2::ggsave(file = filename, width = 7, height = 7)
}