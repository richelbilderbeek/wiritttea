#' Create 'figure_error_expected_mean_dur_spec_sampling'
#' @param parameters parameters, as returned from read_collected_parameters
#' @param nltt_stats the nLTT statistics, as returned from read_collected_nltt_stats
#' @param filename name of the file the figure will be saved to
#' @author Richel Bilderbeek
#' @export
create_figure_error_mean_dur_spec_sampling <- function(
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

  # Only select the columns we need
  parameters <- dplyr::select(parameters, c(filename, mean_durspec))
  nltt_stats <- dplyr::select(nltt_stats, c(filename, sti, nltt_stat))

  # Connect the mean nLTT stats and parameters
  testit::assert("filename" %in% names(parameters))
  testit::assert("filename" %in% names(nltt_stats))
  df <- merge(x = parameters, y = nltt_stats, by = "filename", all = TRUE)

  # Rename column
  df$sti <- plyr::revalue(df$sti, c("1" = "youngest", "2" = "oldest"))

  set.seed(42)
  n_sampled <- 5000
  n_data_points <- nrow(stats::na.omit(df))
  options(warn = 1) # Allow points not to be plotted
  ggplot2::ggplot(
    data = dplyr::sample_n(stats::na.omit(df), size = n_sampled), # Out of 7M
    ggplot2::aes(x = mean_durspec, y = nltt_stat, color = as.factor(sti))
  ) + ggplot2::geom_jitter(width = 0.01, alpha = 0.2) +
    ggplot2::geom_smooth(method = "lm", size = 0.5, alpha = 0.25) +
    ggpmisc::stat_poly_eq(
      formula = y ~ x,
      eq.with.lhs = paste(latex2exp::TeX("$\\Delta_{nLTT}$"), "~`=`~"),
      eq.x.rhs = latex2exp::TeX(" \\bar{t_{ds}}"),
      ggplot2::aes(label = paste(..eq.label.., ..adj.rr.label.., sep = "~~~~")),
      parse = TRUE) +
    ggplot2::geom_smooth(method = "loess", size = 0.5, alpha = 0.25) +
    ggplot2::scale_y_continuous(limits = c(0, 0.05)) + # Will have some outliers unplotted
    ggplot2::xlab(latex2exp::TeX(" t_\\bar{ds}} (million years)")) +
    ggplot2::ylab(latex2exp::TeX("$\\Delta_{nLTT}$")) +
    ggplot2::labs(
      title = "nLTT statistic for different expected mean duration of speciation\nfor different sampling methods",
      caption  = paste0("n = ", n_sampled, " / ", n_data_points, ", ", filename)
    ) +
    ggplot2::labs(color = "Sampling") +
    ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0.5))
  options(warn = 2) # Be strict

  ggplot2::ggsave(file = filename, width = 7, height = 7)
}