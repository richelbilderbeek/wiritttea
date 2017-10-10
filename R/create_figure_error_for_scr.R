#' Create figure create_figure_error_for_scr
#' @param parameters parameters, as returned from read_collected_parameters
#' @param nltt_stats the nLTT statistics, as returned from read_collected_nltt_stats
#' @param filename name of the file the figure will be saved to
create_figure_error_for_scr <- function(
  parameters,
  nltt_stats,
  filename
) {

  # Add mean duration of speciation to parameters
  parameters$mean_durspec <- PBD::pbd_mean_durspecs(
    eris = parameters$eri,
    scrs = parameters$scr,
    siris = parameters$siri
  )

  # Take the mean of the nLTT stats
  `%>%` <- dplyr::`%>%`
  nltt_stat_means <- nltt_stats %>% dplyr::group_by(filename, sti, ai, pi) %>%
         dplyr::summarise(mean = mean(nltt_stat), sd = sd(nltt_stat))
  testit::assert(all(names(nltt_stat_means)
    == c("filename", "sti", "ai", "pi", "mean", "sd")))

  # Connect the mean nLTT stats and parameters
  testit::assert("filename" %in% names(parameters))
  testit::assert("filename" %in% names(nltt_stat_means))
  df <- merge(x = parameters, y = nltt_stat_means, by = "filename", all = TRUE)

  ggplot2::ggplot(
    data = stats::na.omit(df),
    ggplot2::aes(x = as.factor(scr), y = mean)
  ) + ggplot2::geom_boxplot() +
  ggplot2::facet_grid(erg ~ sirg) +
  ggplot2::xlab("Speciation completion rate (probability per lineage per million years)") +
  ggplot2::ylab("Mean nLTT statistics") +
  ggplot2::labs(
    title = "Mean nLTT statistic for\ndifferent speciation completion rates (x axis boxplot),\nspeciation initiation rates (columns)\nand extinction rates (rows)",
    caption  = filename
  ) +
  ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0.5))

  ggplot2::ggsave(file = filename, width = 7, height = 7)
}