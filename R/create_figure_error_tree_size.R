#' Create figure 'figure_error_tree_size'
#' @param n_taxa the number of taxa, as returned from read_collected_n_taxa
#' @param nltt_stats the nLTT statistics, as returned from read_collected_nltt_stats
#' @param filename name of the file the figure will be saved to
#' @export
create_figure_error_tree_size <- function(
  n_taxa,
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

  nltt_stats$filename <- as.vector(nltt_stats$filename)
  nltt_stats$filename <- basename(nltt_stats$filename)

  # Take the mean of the nLTT stats
  `%>%` <- dplyr::`%>%`
  nltt_stat_means <- nltt_stats %>% dplyr::group_by(filename, sti, ai, pi) %>%
         dplyr::summarise(mean = mean(nltt_stat))
  testit::assert(all(names(nltt_stat_means)
    == c("filename", "sti", "ai", "pi", "mean")))

  # Connect the mean nLTT stats and n_taxa
  testit::assert("filename" %in% names(n_taxa))
  testit::assert("filename" %in% names(nltt_stat_means))
  df_mean <- merge(x = nltt_stat_means, y = n_taxa, by = "filename", all = TRUE)
  df <- merge(x = nltt_stats, y = n_taxa, by = "filename", all = TRUE)
  n_all <- nrow(df)
  df <- stats::na.omit(df)

  grDevices::svg("~/figure_error_tree_size.svg")
  n <- 2000
  cut_x <- 2000
  cut_y <- 0.125
  set.seed(42)

  options(warn = 1) # Be milder for ylim

  ggplot2::ggplot(
    data = dplyr::sample_n(df, size = n),
    ggplot2::aes(x = n_taxa, y = nltt_stat)
  ) + ggplot2::geom_point(alpha = 0.1) +
    ggplot2::geom_smooth(method = "lm", color = "blue", size = 0.5, alpha = 0.25) +
    ggpmisc::stat_poly_eq(
      formula = y ~ x,
      eq.with.lhs = paste(latex2exp::TeX("$\\Delta_{nLTT}$"), "~`=`~"),
      eq.x.rhs = latex2exp::TeX(" $n_t$"),
      ggplot2::aes(label = paste(..eq.label.., ..adj.rr.label.., sep = "~~~~")),
      color = "blue",
      parse = TRUE) +
    ggplot2::geom_smooth(method = "loess", color = "red", size = 0.5, alpha = 0.25) +
    ggplot2::ylim(c(0, cut_y)) +
    ggplot2::xlab(latex2exp::TeX("$n_t$")) +
    ggplot2::ylab(latex2exp::TeX("$\\Delta_{nLTT}$")) +
    ggplot2::labs(
      title = "The effect of number of taxa on nLTT statistic",
      caption  = paste0("(n = ", n, "/", n_all, "), error_tree_size")
    ) +
    ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0.5))

  ggplot2::ggsave(file = filename, width = 7, height = 7)


  ggplot2::ggplot(
    data = stats::na.omit(df_mean),
    ggplot2::aes(x = n_taxa, y = mean)
  ) +
    ggplot2::geom_point() +
    ggplot2::geom_smooth(method = "lm", color = "blue", size = 0.5, alpha = 0.25) +
    ggpmisc::stat_poly_eq(
      formula = y ~ x,
      eq.with.lhs = paste(latex2exp::TeX("$\\bar{\\Delta_{nLTT}}$"), "~`=`~"),
      eq.x.rhs = latex2exp::TeX(" $n_t$"),
      ggplot2::aes(label = paste(..eq.label.., ..adj.rr.label.., sep = "~~~~")),
      color = "blue",
      parse = TRUE) +
    ggplot2::geom_smooth(method = "loess", color = "red", size = 0.5, alpha = 0.25) +
    ggplot2::ylim(c(0, cut_y)) +
    ggplot2::xlab(latex2exp::TeX("$n_t$")) +
    ggplot2::ylab(latex2exp::TeX("$\\bar{\\Delta_{nLTT}}$")) +
    ggplot2::labs(
      title = "The effect of number of taxa on mean nLTT statistic",
      caption  = "Figure 'error_tree_size_mean'"
    ) +
    ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0.5))

  ggplot2::ggsave(file = filename, width = 7, height = 7)
}