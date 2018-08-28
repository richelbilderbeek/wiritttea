#' Create 'figure_error_expected_mean_dur_spec_alignment_length'
#' @param parameters parameters, as returned from read_collected_parameters
#' @param nltt_stats the nLTT statistics, as returned from read_collected_nltt_stats
#' @param filename name of the file the figure will be saved to
#' @author Richel Bilderbeek
#' @export
create_figure_error_mean_dur_spec_mean_alignment_length <- function(
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

  parameters$mean_durspec <- PBD::pbd_mean_durspecs(
    eris = parameters$eri,
    scrs = parameters$scr,
    siris = parameters$siri
  )

  # Take the mean of the nLTT stats
  `%>%` <- dplyr::`%>%`
  nltt_stat_means <- nltt_stats %>% dplyr::group_by(filename, sti, ai, pi) %>%
         dplyr::summarise(mean = mean(nltt_stat))
  testit::assert(all(names(nltt_stat_means)
    == c("filename", "sti", "ai", "pi", "mean")))

  # Only select the columns we need
  parameters <- dplyr::select(parameters, c(filename, scr, mean_durspec, sequence_length))

  nltt_stats <- dplyr::select(nltt_stats, c(filename, nltt_stat))

  # Connect the mean nLTT stats and parameters
  testit::assert("filename" %in% names(parameters))
  testit::assert("filename" %in% names(nltt_stats))
  testit::assert("filename" %in% names(nltt_stat_means))
  df <- merge(x = parameters, y = nltt_stats, by = "filename", all = TRUE)
  df_mean <- merge(x = parameters, y = nltt_stat_means, by = "filename", all = TRUE)

  # Calculate mean BD error
  scr_bd <- max(stats::na.omit(df$scr))
  mean_bd_error_1000  <- mean(stats::na.omit(df[ df$scr == scr_bd & df$sequence_length == 1000 , ]$nltt_stat))
  mean_bd_error_10000 <- mean(stats::na.omit(df[ df$scr == scr_bd & df$sequence_length == 10000, ]$nltt_stat))

  nltt_stat_cutoff <- 0.1

  options(warn = 1) # Allow points to fall off plot range

  ggplot2::ggplot(
    data = stats::na.omit(df_mean),
    ggplot2::aes(x = mean_durspec, y = mean, color = as.factor(sequence_length))
  ) + ggplot2::geom_point() +
    ggplot2::geom_smooth(method = "lm", size = 0.5) +
    ggpmisc::stat_poly_eq(
      formula = y ~ x,
      eq.with.lhs = paste(latex2exp::TeX("$\\bar{\\Delta_{nLTT}}$"), "~`=`~"),
      eq.x.rhs = latex2exp::TeX(" \\bar{t_{ds}}"),
      ggplot2::aes(label = paste(..eq.label.., ..adj.rr.label.., sep = "~~~~")),
      parse = TRUE) +
    ggplot2::scale_y_continuous(limits = c(0, nltt_stat_cutoff)) + # Will have some outliers unplotted
    ggplot2::geom_smooth(method = "loess", size = 0.5) +
    ggplot2::geom_hline(yintercept = mean_bd_error_1000, linetype = "dotted", color = scales::hue_pal()(2)[1]) +
    ggplot2::geom_hline(yintercept = mean_bd_error_10000, linetype = "dotted", color = scales::hue_pal()(2)[2]) +
    ggplot2::xlab(latex2exp::TeX(" t_\\bar{ds}} (million years)")) +
    ggplot2::ylab(latex2exp::TeX("$\\bar{\\Delta_{nLTT}}$")) +
    ggplot2::labs(
      title = "Mean nLTT statistic\nfor different expected mean duration of speciation,\nfor different DNA alignment lengths",
      caption  = filename
    ) +
    ggplot2::labs(color = latex2exp::TeX("$l_a$")) +
    ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0.5))

  ggplot2::ggsave(file = filename, width = 7, height = 7)

 options(warn = 2) # Be strict
}