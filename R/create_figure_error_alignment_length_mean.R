#' Create figure 'figure_error_alignment_length_mean'
#' @param parameters parameters, as returned by read_collected_parameters
#' @param nltt_stats nLTT statistics, as returned by read_collected_nltt_stats
#' @param esses ESSes, as returned by read_collected_esses
#' @param filename name of the file the figure will be saved to
#' @author Richel Bilderbeek
#' @export
create_figure_error_alignment_length_mean <- function(
  parameters,
  nltt_stats,
  esses,
  filename
) {

  `%>%` <- dplyr::`%>%`

  nltt_stat_means <- nltt_stats %>% dplyr::group_by(filename, sti, ai, pi) %>%
    dplyr::summarise(mean = mean(nltt_stat), sd = sd(nltt_stat))

  testit::assert(all(names(nltt_stat_means)
    == c("filename", "sti", "ai", "pi", "mean", "sd")))

  # Connect the mean nLTT stats and parameters
  testit::assert("filename" %in% names(parameters))
  testit::assert("filename" %in% names(nltt_stat_means))
  df_means <- merge(x = parameters, y = nltt_stat_means, by = "filename", all = TRUE)

  # Merge with the ESSes
  df_means <- merge(x = df_means, y = esses,
    by = c("filename", "sti", "ai", "pi"), all = TRUE)

  ggplot2::ggplot(
    data = stats::na.omit(df_means),
    ggplot2::aes(x = as.factor(scr), y = mean, fill = as.factor(sequence_length))
  ) + ggplot2::geom_boxplot() +
      ggplot2::facet_grid(erg ~ sirg) +
      ggplot2::xlab(latex2exp::TeX("Speciation completion rate $\\lambda$")) +
      ggplot2::ylab(latex2exp::TeX("Mean nLTT statistics, $\\bar{\\Delta_{nLTT}}$")) +
      ggplot2::labs(
        fill = latex2exp::TeX("Sequence\nlength $l_a$"),
        title = "The effect of alignment length on mean nLTT statistic for\ndifferent speciation completion rates (x axis boxplot),\nspeciation initiation rates (columns)\nand extinction rates (rows)",
        caption  = filename
      ) +
      ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0.5))

  ggplot2::ggsave(file = filename, width = 7, height = 7)

}