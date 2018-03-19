#' Create 'figure_error_expected_mean_dur_spec_median' (tailing median: use the median nLTT statistic)
#' @param parameters parameters, as returned from read_collected_parameters
#' @param nltt_stats the nLTT statistics, as returned from read_collected_nltt_stats
#' @param filename name of the file the figure will be saved to
#' @author Richel Bilderbeek
#' @export
create_figure_error_mean_dur_spec_median <- function(
  parameters,
  nltt_stats,
  filename
) {

  sti <- NULL; rm(sti) # nolint, should fix warning: no visible binding for global variable
  ai <- NULL; rm(ai) # nolint, should fix warning: no visible binding for global variable
  nltt_stat <- NULL; rm(nltt_stat) # nolint, should fix warning: no visible binding for global variable
  mean_durspec <- NULL; rm(mean_durspec) # nolint, should fix warning: no visible binding for global variable
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
         dplyr::summarise(mean = mean(nltt_stat))
  nltt_stat_medians <- nltt_stats %>% dplyr::group_by(filename, sti, ai, pi) %>%
         dplyr::summarise(median = stats::median(nltt_stat))
  testit::assert(all(names(nltt_stat_means)
    == c("filename", "sti", "ai", "pi", "mean")))
  testit::assert(all(names(nltt_stat_medians)
    == c("filename", "sti", "ai", "pi", "median")))

  # Connect the mean nLTT stats and parameters
  testit::assert("filename" %in% names(parameters))
  testit::assert("filename" %in% names(nltt_stat_means))
  df_means <- merge(x = parameters, y = nltt_stat_means, by = "filename", all = TRUE)
  df_medians <- merge(x = parameters, y = nltt_stat_medians, by = "filename", all = TRUE)

  # Calculate mean BD error
  testit::assert(max(stats::na.omit(df_means$scr)) == max(stats::na.omit(df_medians$scr)))
  scr_bd <- max(stats::na.omit(df_means$scr))

  mean_bd_error <- mean(stats::na.omit(df_means[ df_means$scr == scr_bd, ]$mean))
  median_bd_error <- mean(stats::na.omit(df_medians[ df_medians$scr == scr_bd, ]$median))

  options(warn = 1) # Allow points falling out of range
  ggplot2::ggplot(
    data = stats::na.omit(df_medians),
    ggplot2::aes(x = mean_durspec, y = median)
  ) + ggplot2::geom_point() +
    ggplot2::geom_smooth(method = "lm", color = "blue", size = 0.5, alpha = 0.25) +
    ggpmisc::stat_poly_eq(
      formula = y ~ x,
      eq.with.lhs = paste(latex2exp::TeX("$\\widetilde{\\Delta_{nLTT}}$"), "~`=`~"),
      eq.x.rhs = latex2exp::TeX(" \\bar{t_{ds}}"),
      ggplot2::aes(label = paste(..eq.label.., ..adj.rr.label.., sep = "~~~~")),
      color = "blue",
      parse = TRUE) +
    ggplot2::geom_smooth(method = "loess", color = "red", size = 0.5, alpha = 0.25) +
    ggplot2::geom_hline(yintercept = mean_bd_error, linetype = "dotted") +
    ggplot2::scale_y_continuous(limits = c(0, 0.05)) + # Will have some outliers unplotted
    ggplot2::xlab(latex2exp::TeX("Mean duration of speciation t_\\bar{ds}}")) +
    ggplot2::ylab(latex2exp::TeX("Median nLTT statistic $\\widetilde{\\Delta_{nLTT}}$")) +
    ggplot2::labs(
      title = "Median nLTT statistic for different duration of speciations",
      caption  = filename
    ) +
    ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0.5))

  options(warn = 2) # Be strict

  ggplot2::ggsave(file = filename, width = 7, height = 7)
}