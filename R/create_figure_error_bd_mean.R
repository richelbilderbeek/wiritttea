#' Create figure create_figure_error_bd_mean
#' @param parameters parameters, as returned from read_collected_parameters
#' @param nltt_stats the nLTT statistics, as returned from read_collected_nltt_stats
#' @param filename name of the file the figure will be saved to
create_figure_error_bd_mean <- function(
  parameters,
  nltt_stats,
  filename
) {

  `%>%` <- dplyr::`%>%`
  nltt_stat_means <- nltt_stats %>% dplyr::group_by(filename, sti, ai, pi) %>%
         dplyr::summarise(mean = mean(nltt_stat), sd = sd(nltt_stat))
  testit::assert(all(names(nltt_stat_means)
    == c("filename", "sti", "ai", "pi", "mean", "sd")))

  # print("Connect the mean nLTT stats and parameters")
  testit::assert("filename" %in% names(parameters))
  testit::assert("filename" %in% names(nltt_stat_means))
  df <- merge(x = parameters, y = nltt_stat_means, by = "filename", all = TRUE)

  # print("Only keep rows with the highest SCR (as those are a BD model)")
  # print(paste0("Rows before: ", nrow(df)))
  dplyr::count(df, scr)
  scr_bd <- max(stats::na.omit(df$scr))
  df <- df[ df$scr == scr_bd, ]
  # print(paste0("Rows after: ", nrow(df)))

  # print("Creating figure")

  ggplot2::ggplot(
    data = stats::na.omit(df),
    ggplot2::aes(x = mean)
  ) +
  ggplot2::geom_histogram(binwidth = 0.001) +
  ggplot2::facet_grid(erg ~ sirg) +
  ggplot2::scale_x_continuous("Mean nLTT statistic") +
  ggplot2::scale_y_continuous("Count") +
  ggplot2::labs(
    title = "Mean nLTT statistics\nfor different extinction (columns)\nand speciation inition rates (rows)",
    caption = filename
  ) +
  ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0.5))

  ggplot2::ggsave(file = filename, width = 7, height = 7)
}