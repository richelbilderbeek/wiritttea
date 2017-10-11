#' Create figure 'figure_error_low_high_ess'
#' @param parameters parameters, as returned from read_collected_parameters
#' @param nltt_stats the nLTT statistics, as returned from read_collected_nltt_stats
#' @param esses the ESSes, as returned from read_collected_esses
#' @param filename name of the file the figure will be saved to
#' @param sample_size the number of nLTT statistics that will be sampled, use
#'   NA to sample all
#' @export
create_figure_error_low_high_ess <- function(
  parameters,
  nltt_stats,
  esses,
  filename,
  sample_size = NA
) {

  sti <- NULL; rm(sti) # nolint, should fix warning: no visible binding for global variable
  ai <- NULL; rm(ai) # nolint, should fix warning: no visible binding for global variable
  nltt_stat <- NULL; rm(nltt_stat) # nolint, should fix warning: no visible binding for global variable

  # Take the mean of the nLTT stats
  `%>%` <- dplyr::`%>%`
  nltt_stat_means <- nltt_stats %>% dplyr::group_by(filename, sti, ai, pi) %>%
         dplyr::summarise(mean = mean(nltt_stat))
  testit::assert(all(names(nltt_stat_means)
    == c("filename", "sti", "ai", "pi", "mean")))

  # print("Add mean duration of speciation to parameters")
  parameters$mean_durspec <- PBD::pbd_mean_durspecs(
    eris = parameters$eri,
    scrs = parameters$scr,
    siris = parameters$siri
  )

  # Connect the mean nLTT stats and parameters
  if (is.na(sample_size)) {
    sample_size <- nrow(nltt_stats)
  }
  testit::assert("filename" %in% names(parameters))
  testit::assert("filename" %in% names(nltt_stat_means))
  df <- merge(x = parameters, y = dplyr::sample_n(nltt_stats, size = sample_size), by = "filename", all = TRUE)

  # Calculate median ESS
  median_ess <- median(stats::na.omit(esses$treeLikelihood))

  # Calculate the types
  esses$ess_type <- esses$treeLikelihood > median_ess
  # Convert: TRUE -> OK
  esses$ess_type[ esses$ess_type == TRUE ] <- "High"
  esses$ess_type[ esses$ess_type == FALSE ] <- "Low"
  esses$ess_type <- as.factor(esses$ess_type)

  # Merge with the ESSes
  df <- merge(x = df, y = esses, by = c("filename", "sti", "ai", "pi"), all = TRUE)

  ggplot2::ggplot(
    data = stats::na.omit(df),
    ggplot2::aes(x = as.factor(scr), y = nltt_stat, fill = ess_type)
  ) + ggplot2::geom_boxplot() +
      ggplot2::facet_grid(erg ~ sirg) +
      ggplot2::xlab(latex2exp::TeX("$\\lambda$ (probability per lineage per million years)")) +
      ggplot2::ylab(latex2exp::TeX("$\\Delta_{nLTT}$")) +
      ggplot2::labs(
        title = "The effect of a low and high ESS of tree likelihood on nLTT statistic for\ndifferent speciation completion rates (x axis boxplot),\nspeciation initiation rates (columns)\nand extinction rates (rows)",
        caption  = "figure_error_low_high_ess"
      ) +
      ggplot2::labs(fill = latex2exp::TeX("ESS tree\nlikelihood")) +
      ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0.5))

  ggplot2::ggsave(file = filename, width = 7, height = 7)
}
