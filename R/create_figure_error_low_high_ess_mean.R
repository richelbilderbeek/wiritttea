#' Create figure 'figure_error_low_high_ess' using mean nLTT statistics
#' @param parameters parameters, as returned from read_collected_parameters
#' @param nltt_stats the nLTT statistics, as returned from read_collected_nltt_stats
#' @param esses the ESSes, as returned from read_collected_esses
#' @param filename name of the file the figure will be saved to
#' @param sample_size the number of nLTT statistics that will be sampled, use
#'   NA to sample all
#' @export
create_figure_error_low_high_ess_mean <- function(
  parameters,
  nltt_stats,
  esses,
  filename,
  sample_size = NA
) {

  sti <- NULL; rm(sti) # nolint, should fix warning: no visible binding for global variable
  ai <- NULL; rm(ai) # nolint, should fix warning: no visible binding for global variable
  nltt_stat <- NULL; rm(nltt_stat) # nolint, should fix warning: no visible binding for global variable
  median <- NULL; rm(median) # nolint, should fix warning: no visible binding for global variable
  scr <- NULL; rm(scr) # nolint, should fix warning: no visible binding for global variable
  ess_type <- NULL; rm(ess_type) # nolint, should fix warning: no visible binding for global variable

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
  testit::assert("filename" %in% names(parameters))
  testit::assert("filename" %in% names(nltt_stat_means))
  if (is.na(sample_size)) {
    sample_size <- nrow(nltt_stats)
  }
  df <- merge(
    x = parameters,
    y = dplyr::sample_n(nltt_stats, size = sample_size),
    by = "filename", all = TRUE)
  df_mean <- merge(x = parameters, y = nltt_stat_means, by = "filename", all = TRUE)

  # Calculate median ESS
  median_ess <- stats::median(stats::na.omit(esses$treeLikelihood))

  # Calculate the types
  esses$ess_type <- esses$treeLikelihood > median_ess
  # Convert: TRUE -> OK
  esses$ess_type[ esses$ess_type == TRUE ] <- "High"
  esses$ess_type[ esses$ess_type == FALSE ] <- "Low"
  esses$ess_type <- as.factor(esses$ess_type)

  # Merge with the ESSes
  df <- merge(x = df, y = esses, by = c("filename", "sti", "ai", "pi"), all = TRUE)
  df_mean <- merge(x = df_mean, y = esses, by = c("filename", "sti", "ai", "pi"), all = TRUE)


  ggplot2::ggplot(
    data = stats::na.omit(df_mean),
    ggplot2::aes(x = as.factor(scr), y = mean, fill = ess_type)
  ) + ggplot2::geom_boxplot() +
      ggplot2::facet_grid(erg ~ sirg) +
      ggplot2::xlab(latex2exp::TeX("$\\lambda$ (probability per lineage per million years)")) +
      ggplot2::ylab(latex2exp::TeX("$\\bar{\\Delta_{nLTT}}$")) +
      ggplot2::labs(
        title = "The effect of a low and high ESS of tree likelihood on mean nLTT statistic for\ndifferent speciation completion rates (x axis boxplot),\nspeciation initiation rates (columns)\nand extinction rates (rows)",
        caption  = "figure_error_low_high_ess_mean"
      ) +
      ggplot2::labs(fill = latex2exp::TeX("ESS tree\nlikelihood")) +
      ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0.5))

    ggplot2::ggsave(file = filename, width = 7, height = 7)
}



#   grDevices::svg("~/figure_error_expected_mean_dur_spec_low_high_ess.svg")
#   set.seed(42)
#   n_sampled <- 5000
#   n_data_points <- nrow(stats::na.omit(df))
#   nltt_stat_cutoff <- 0.12
#
#   options(warn = 1) # Allow points not to be plotted
#   ggplot2::ggplot(
#     data = dplyr::sample_n(stats::na.omit(df), size = n_sampled), # Out of 7M
#     ggplot2::aes(x = mean_durspec, y = nltt_stat, color = ess_type)
#   ) + ggplot2::geom_jitter(width = 0.01, alpha = 0.2) +
#     ggplot2::geom_smooth(method = "lm") +
#     ggpmisc::stat_poly_eq(
#       formula = y ~ x,
#       eq.with.lhs = paste(latex2exp::TeX("$\\Delta_{nLTT}$"), "~`=`~"),
#       eq.x.rhs = latex2exp::TeX(" \\bar{t_{ds}}"),
#       ggplot2::aes(label = paste(..eq.label.., ..adj.rr.label.., sep = "~~~~")),
#       parse = TRUE) +
#     ggplot2::geom_smooth(method = "loess") +
#     ggplot2::scale_y_continuous(limits = c(0, nltt_stat_cutoff)) + # Will have some outliers unplotted
#     ggplot2::xlab(latex2exp::TeX(" t_\\bar{ds}} (million years)")) +
#     ggplot2::ylab(latex2exp::TeX("$\\Delta_{nLTT}$")) +
#     ggplot2::labs(
#       title = "nLTT statistic\nfor different expected mean duration of speciation,\nfor ESSes",
#       caption  = paste0("n = ", n_sampled, " / ", n_data_points, ", figure_error_expected_mean_dur_spec_ess_low_high")
#     ) +
#     ggplot2::labs(color = latex2exp::TeX("ESS type")) +
#     ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0.5))
#
#   options(warn = 2) # Be strict
#
#   grDevices::dev.off()
#
#   grDevices::svg("~/figure_error_expected_mean_dur_spec_mean_low_high_ess.svg")
#   options(warn = 1) # Allow points to fall off plot range
#
#   ggplot2::ggplot(
#     data = stats::na.omit(df_mean),
#     ggplot2::aes(x = mean_durspec, y = mean, color = ess_type)
#   ) +
#     ggplot2::geom_point() +
#     ggplot2::geom_smooth(method = "lm", size = 0.5) +
#     ggpmisc::stat_poly_eq(
#       formula = y ~ x,
#       eq.with.lhs = paste(latex2exp::TeX("$\\bar{\\Delta_{nLTT}}$"), "~`=`~"),
#       eq.x.rhs = latex2exp::TeX(" \\bar{t_{ds}}"),
#       ggplot2::aes(label = paste(..eq.label.., ..adj.rr.label.., sep = "~~~~")),
#       parse = TRUE) +
#     #ggplot2::scale_y_continuous(limits = c(0, nltt_stat_cutoff)) + # Will have some outliers unplotted
#     ggplot2::geom_smooth(method = "loess", size = 0.5) +
#     ggplot2::xlab(latex2exp::TeX(" t_\\bar{ds}} (million years)")) +
#     ggplot2::ylab(latex2exp::TeX("$\\bar{\\Delta_{nLTT}}$")) +
#     ggplot2::labs(
#       title = "Mean nLTT statistic\nfor different expected mean duration of speciation,\nfor tree likelihood ESSes aboven and below median",
#       caption  = "figure_error_expected_mean_dur_spec_mean_low_high_ess"
#     ) +
#     ggplot2::labs(color = latex2exp::TeX("ESS type")) +
#     ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0.5))
#
#
#   options(warn = 2) # Be strict
#
#   ggplot2::ggsave(file = filename, width = 7, height = 7)
# }