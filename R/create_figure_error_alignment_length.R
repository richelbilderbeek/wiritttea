#' Create figure 'error_alignment_length'
#' @param parameters parameters, as returned by read_collected_parameters
#' @param nltt_stats nLTT stats, as returned by read_collected_nltt_stats
#' @param filename name of the file the figure is saved to
#' @param n_sampled, the number of nLTT statistics sampled, NA denotes all
#' @return nothing, only creates a file
#' @export
#' @author Richel Bilderbeek
create_figure_error_alignment_length <- function(
  parameters,
  nltt_stats,
  filename,
  n_sampled = NA
) {

  sirg <- NULL; rm(sirg) # nolint, should fix warning: no visible binding for global variable
  scr <- NULL; rm(scr) # nolint, should fix warning: no visible binding for global variable
  erg <- NULL; rm(erg) # nolint, should fix warning: no visible binding for global variable
  sequence_length <- NULL; rm(sequence_length) # nolint, should fix warning: no visible binding for global variable
  filename <- NULL; rm(filename) # nolint, should fix warning: no visible binding for global variable
  nltt_stat <- NULL; rm(nltt_stat) # nolint, should fix warning: no visible binding for global variable

  # Select only those columns that we need
  parameters <- dplyr::select(parameters, c(sirg, scr, erg, sequence_length, filename))
  nltt_stats <- dplyr::select(nltt_stats, c(filename, nltt_stat))

  # Connect the mean nLTT stats and parameters
  testit::assert("filename" %in% names(parameters))
  testit::assert("filename" %in% names(nltt_stats))
  df <- merge(x = parameters, y = nltt_stats, by = "filename", all = TRUE)

  n_data <- nrow(stats::na.omit(df))

  if (is.na(n_sampled)) {
    n_sampled <- n_data
  }

  ggplot2::ggplot(
    data = dplyr::sample_n(stats::na.omit(df), n_sampled),
    ggplot2::aes(x = as.factor(scr), y = nltt_stat, fill = as.factor(sequence_length))
  ) + ggplot2::geom_boxplot(outlier.alpha = 0.1, outlier.size = 0.5) +
      ggplot2::facet_grid(erg ~ sirg) +
      ggplot2::xlab("Speciation completion rate (probability per lineage per million years)") +
      ggplot2::ylab("nLTT statistic") +
      ggplot2::labs(
        title = paste0(
          "The effect of alignment length on nLTT statistic for\n",
          "different speciation completion rates (x axis boxplot),\n",
          "speciation initiation rates (columns)\n",
          "and extinction rates (rows) (n = ", n_sampled, "/", n_data, ")"
        ),
        fill = "Sequence\nlength (bp)",
        caption  = "figure_error_alignment_length_mean"
      ) +
      ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0.5))

  ggplot2::ggsave(file = filename, width = 7, height = 7)
}