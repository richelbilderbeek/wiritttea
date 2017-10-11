#' Create 'figure_ess_expected_mean_dur_spec_alignment_length'
#' @param parameters parameters, as returned from read_collected_parameters
#' @param esses the ESSes, as returned from read_collected_esses
#' @param filename name of the file the figure will be saved to
create_figure_ess_expected_mean_dur_spec_alignment_length <- function(
  parameters,
  esses,
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
  parameters <- dplyr::select(parameters, c(filename, mean_durspec, sequence_length))
  esses <- dplyr::select(esses, c(filename, likelihood))

  # Connect the mean nLTT stats and parameters
  testit::assert("filename" %in% names(parameters))
  testit::assert("filename" %in% names(esses))
  df <- merge(x = parameters, y = esses, by = "filename", all = TRUE)

  ggplot2::ggplot(
    data = stats::na.omit(df),
    ggplot2::aes(x = mean_durspec, y = likelihood, color = as.factor(sequence_length))
  ) + ggplot2::geom_jitter(width = 0.01, alpha = 0.2) +
    ggplot2::geom_smooth(method = "lm") +
    ggpmisc::stat_poly_eq(
      formula = y ~ x,
      eq.with.lhs = paste(latex2exp::TeX("$\\bar{\\Delta_{nLTT}}$"), "~`=`~"),
      eq.x.rhs = latex2exp::TeX(" \\bar{t_{ds}}"),
      ggplot2::aes(label = paste(..eq.label.., ..adj.rr.label.., sep = "~~~~")),
      parse = TRUE) +
    ggplot2::scale_y_continuous(limits = c(0, 1300)) + # Allows equations to be shown well
    ggplot2::geom_smooth(method = "loess") +
    ggplot2::xlab(latex2exp::TeX(" t_\\bar{ds}} (million years)")) +
    ggplot2::ylab("ESS") +
    ggplot2::labs(
      title = paste0("Effective sample sizes of tree likelihood,\nfor different expected mean duration of speciation,\nfor different DNA alignment lengths"),
      caption = filename
    ) +
    ggplot2::labs(color = latex2exp::TeX("$l_a$")) +
    ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0.5))


  ggplot2::ggsave(file = filename, width = 7, height = 7)
}