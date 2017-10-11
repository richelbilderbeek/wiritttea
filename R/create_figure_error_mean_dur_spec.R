#' Create 'figure_error_mean_dur_spec'
#' @param parameters parameters, as returned from read_collected_parameters
#' @param nltt_stats the nLTT statistics, as returned from read_collected_nltt_stats
#' @param filename name of the file the figure will be saved to
create_figure_error_mean_dur_spec <- function(
  parameters,
  nltt_stats,
  filename
) {

  mean_durspec <- NULL; rm(mean_durspec) # nolint, should fix warning: no visible binding for global variable
  scr <- NULL; rm(scr) # nolint, should fix warning: no visible binding for global variable
  nltt_stat <- NULL; rm(nltt_stat) # nolint, should fix warning: no visible binding for global variable
  ..eq.label.. <- NULL; rm(..eq.label..) # nolint, should fix warning: no visible binding for global variable
  ..adj.rr.label.. <- NULL; rm(..adj.rr.label..) # nolint, should fix warning: no visible binding for global variable


  # Add mean duration of speciation to parameters
  parameters$mean_durspec <- PBD::pbd_mean_durspecs(
    eris = parameters$eri,
    scrs = parameters$scr,
    siris = parameters$siri
  )

  # Only select the columns we need
  parameters <- dplyr::select(parameters, c(filename, mean_durspec, scr))
  nltt_stats <- dplyr::select(nltt_stats, c(filename, nltt_stat))

  # Connect the mean nLTT stats and parameters
  testit::assert("filename" %in% names(parameters))
  testit::assert("filename" %in% names(nltt_stats))
  df <- merge(x = parameters, y = nltt_stats, by = "filename", all = TRUE)

  # Calculate mean BD error
  scr_bd <- max(stats::na.omit(df$scr))
  mean_bd_error <- mean(stats::na.omit(df[ df$scr == scr_bd, ]$nltt_stat))

  # Creating figure

  set.seed(42)
  n_sampled <- 2000
  n_data_points <- nrow(stats::na.omit(df))

  options(warn = 1) # Allow points falling out of range

  ggplot2::ggplot(
    data = dplyr::sample_n(stats::na.omit(df), size = n_sampled), # Out of 7M
    ggplot2::aes(x = mean_durspec, y = nltt_stat)
  ) + ggplot2::geom_jitter(width = 0.01, alpha = 0.1) +
    ggplot2::geom_smooth(method = "lm", color = "blue", size = 0.5, alpha = 0.25) +
    ggpmisc::stat_poly_eq(
      formula = y ~ x,
      eq.with.lhs = paste(latex2exp::TeX("$\\Delta_{nLTT}$"), "~`=`~"),
      eq.x.rhs = latex2exp::TeX(" \\bar{t_{ds}}"),
      ggplot2::aes(label = paste(..eq.label.., ..adj.rr.label.., sep = "~~~~")),
      color = "blue",
      parse = TRUE) +
    ggplot2::geom_smooth(method = "loess", color = "red", size = 0.5, alpha = 0.25) +
    ggplot2::geom_hline(yintercept = mean_bd_error, linetype = "dotted") +
    ggplot2::scale_y_continuous(limits = c(0, 0.05)) + # Will have some outliers unplotted
    ggplot2::xlab(latex2exp::TeX(" t_\\bar{ds}} (million years)")) +
    ggplot2::ylab(latex2exp::TeX("$\\Delta_{nLTT}$")) +
    ggplot2::labs(
      title = "nLTT statistic for different expected mean duration of speciation",
      caption = filename
    ) +
    ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0.5))

  options(warn = 2) # Be strict

  ggplot2::ggsave(file = filename, width = 7, height = 7)
}