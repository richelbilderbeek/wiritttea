#' Create 'figure_error_expected_mean_dur_spec_mean_sampling'
#' @param parameters parameters, as returned from read_collected_parameters
#' @param nltt_stats the nLTT statistics, as returned from read_collected_nltt_stats
#' @param filename name of the file the figure will be saved to
#' @author Richel Bilderbeek
#' @export
create_figure_error_mean_dur_spec_mean_sampling <- function(
  parameters,
  nltt_stats,
  filename
) {
  sti <- NULL; rm(sti) # nolint, should fix warning: no visible binding for global variable
  ai <- NULL; rm(ai) # nolint, should fix warning: no visible binding for global variable
  nltt_stat <- NULL; rm(nltt_stat) # nolint, should fix warning: no visible binding for global variable
  scr <- NULL; rm(scr) # nolint, should fix warning: no visible binding for global variable
  mean_durspec <- NULL; rm(mean_durspec) # nolint, should fix warning: no visible binding for global variable
  sequence_length <- NULL; rm(sequence_length) # nolint, should fix warning: no visible binding for global variable
  ..eq.label.. <- NULL; rm(..eq.label..) # nolint, should fix warning: no visible binding for global variable
  ..adj.rr.label.. <- NULL; rm(..adj.rr.label..) # nolint, should fix warning: no visible binding for global variable

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

  # Only select the columns we need
  parameters <- dplyr::select(parameters, c(filename, mean_durspec))

  # Connect the mean nLTT stats and parameters
  testit::assert("filename" %in% names(parameters))
  testit::assert("filename" %in% names(nltt_stat_means))
  df <- merge(x = parameters, y = nltt_stat_means, by = "filename", all = TRUE)

  # Rename column
  df$sti <- plyr::revalue(df$sti, c("1" = "youngest", "2" = "oldest"))

  options(warn = 1) # Allow points to fall off plot range

  ggplot2::ggplot(
    data = stats::na.omit(df),
    ggplot2::aes(x = mean_durspec, y = mean, color = sti)
  ) + ggplot2::geom_point() +
    ggplot2::geom_smooth(method = "lm", size = 0.5, alpha = 0.25) +
    ggpmisc::stat_poly_eq(
      formula = y ~ x,
      eq.with.lhs = paste(latex2exp::TeX("$\\bar{\\Delta_{nLTT}}$"), "~`=`~"),
      eq.x.rhs = latex2exp::TeX(" \\bar{t_{ds}}"),
      ggplot2::aes(label = paste(..eq.label.., ..adj.rr.label.., sep = "~~~~")),
      parse = TRUE) +
    ggplot2::scale_y_continuous(limits = c(0, 0.05)) + # Will have some outliers unplotted
    ggplot2::geom_smooth(method = "loess", size = 0.5, alpha = 0.25) +
    ggplot2::xlab(latex2exp::TeX(" t_\\bar{ds}} (million years)")) +
    ggplot2::ylab(latex2exp::TeX("$\\bar{\\Delta_{nLTT}}$")) +
    ggplot2::labs(
      title = "Mean nLTT statistic for different duration of speciations\nfor different sampling methods",
      caption  = filename
    ) +
    ggplot2::labs(color = "Sampling") +
    ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0.5))

  ggplot2::ggsave(file = filename, width = 7, height = 7)

  options(warn = 2) # Be strict
}