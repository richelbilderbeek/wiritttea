#' Create 'figure_error_posterior_nltt_si',
#'  showing phylogenies with the top 10 biggest nLTT statistics error
#' of all simulations
#' @param parameters parameters, as returned from read_collected_parameters
#' @param nltt_stats the nLTT statistics, as returned from read_collected_nltt_stats
#' @param filename name of the file the figure will be saved to
#' @param sample_size the number of nLTT statistics that will be sampled, use
#'   NA to sample all
#' @author Richel Bilderbeek
#' @export
create_figure_error_posterior_nltt_si <- function(
  parameters,
  nltt_stats,
  filename,
  sample_size = NA
) {

  sti <- NULL; rm(sti) # nolint, should fix warning: no visible binding for global variable
  ai <- NULL; rm(ai) # nolint, should fix warning: no visible binding for global variable
  nltt_stat <- NULL; rm(nltt_stat) # nolint, should fix warning: no visible binding for global variable
  scr <- NULL; rm(scr) # nolint, should fix warning: no visible binding for global variable
  mean_durspec <- NULL; rm(mean_durspec) # nolint, should fix warning: no visible binding for global variable
  sequence_length <- NULL; rm(sequence_length) # nolint, should fix warning: no visible binding for global variable
  ..eq.label.. <- NULL; rm(..eq.label..) # nolint, should fix warning: no visible binding for global variable
  ..adj.rr.label.. <- NULL; rm(..adj.rr.label..) # nolint, should fix warning: no visible binding for global variable

  # print("Add mean duration of speciation to parameters")
  parameters$mean_durspec <- PBD::pbd_mean_durspecs(
    eris = parameters$eri,
    scrs = parameters$scr,
    siris = parameters$siri
  )

  # Only select what is needed
  parameters <- subset(parameters, select = c(filename, mean_durspec) )

  nltt_stats <- stats::na.omit(nltt_stats)
  if (is.na(sample_size)) {
    sample_size <- nrow(nltt_stats)
  }

  ggplot2::ggplot(
    dplyr::sample_n(nltt_stats, size = sample_size),
    ggplot2::aes(x = as.numeric(si), y = nltt_stat)) +
    ggplot2::geom_point(alpha = 0.01) +
    ggplot2::geom_smooth(method = "lm") +
    # ggplot2::geom_vline(xintercept = 100, linetype = "dotted") +
    ggpmisc::stat_poly_eq(
      formula = y ~ x,
      eq.with.lhs = paste(latex2exp::TeX("$\\Delta_{nLTT}$"), "~`=`~"),
      eq.x.rhs = latex2exp::TeX(" si"),
      ggplot2::aes(label = paste(..eq.label.., ..adj.rr.label.., sep = "~~~~")),
      color = "black",
      parse = TRUE) +
    ggplot2::xlab(latex2exp::TeX("posterior state index, $s_i$")) +
    ggplot2::ylab(latex2exp::TeX("nLTT statistic $\\Delta_{nLTT}$")) +
    ggplot2::labs(
      title = "nLTT statistic values in a posterior",
      caption = filename
    ) +
    ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0.5))

  ggplot2::ggsave(file = filename, width = 7, height = 7)
}
