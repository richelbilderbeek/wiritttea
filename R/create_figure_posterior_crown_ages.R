#' Create 'figure_posterior_distributions_crown_age'
#' @param posterior_crown_ages posterior crown ages, as returned from read_collected_pstr_crown_ages
#' @param filename name of the file the figure will be saved to
#' @export
create_figure_posterior_crown_ages <- function(
  posterior_crown_ages,
  filename
) {

  ggplot2::ggplot(
    data = posterior_crown_ages,
    ggplot2::aes(x = crown_age)
  ) + ggplot2::geom_histogram(na.rm = TRUE, binwidth = 0.1) +
  ggplot2::xlab("tree crown_age") +
  ggplot2::ylab("Count") +
  ggplot2::geom_hline(yintercept = 100, linetype = "dotted") +
  ggplot2::geom_vline(xintercept = 0.2, linetype = "dotted") +
  ggplot2::labs(
    title = "The distribution of tree crown ages",
    caption  = filename
  ) +
  ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0.5))

  # svg("~/figure_posterior_distribution_crown_ages_low_count.svg")
  # ggplot2::ggplot(
  #   data = posterior_crown_ages,
  #   ggplot2::aes(x = crown_age)
  # ) + ggplot2::geom_histogram(na.rm = TRUE, binwidth = 0.1) +
  #   ggplot2::coord_cartesian(ylim = c(0, 100)) +
  #   ggplot2::xlab("tree crown_age") +
  #   ggplot2::ylab("Count") +
  #   ggplot2::geom_hline(yintercept = 100, linetype = "dotted") +
  #   ggplot2::labs(
  #     title = "The distribution of tree crown_ages",
  #     caption  = "figure_posterior_distribution_crown_ages_low_count"
  #   ) +
  #   ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0.5))
  # dev.off()
  # svg("~/figure_posterior_distribution_crown_ages_high_count.svg")
  # ggplot2::ggplot(
  #   data = posterior_crown_ages,
  #   ggplot2::aes(x = crown_age)
  # ) + ggplot2::geom_histogram(na.rm = TRUE, binwidth = 0.001) +
  #   ggplot2::xlim(0.1, 0.2) +
  #   ggplot2::xlab("tree crown_age") +
  #   ggplot2::ylab("Count") +
  #   ggplot2::geom_vline(xintercept = 0.2, linetype = "dotted") +
  #   ggplot2::labs(
  #     title = "The distribution of tree crown_ages",
  #     caption  = "figure_posterior_distribution_crown_ages_high_count"
  #   ) +
  #   ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0.5))
  #
  #
  # print("Determine sample size")
  # n_sampled <- 500000
  # print(paste0("Using a sample of ", n_sampled, " of ", nrow(posterior_crown_ages), " observations"))
  #
  # print("Sample some of the crown_ages")
  # set.seed(42)
  # some_posterior_crown_ages <- dplyr::sample_n(posterior_crown_ages, size = n_sampled)
  # utils::head(some_posterior_crown_ages)
  #
  # print("Split posterior crown_ages per posterior index")
  # testit::assert("pi" %in% names(posterior_crown_ages))
  # `%>%` <- dplyr::`%>%`
  # df <- tidyr::spread(some_posterior_crown_ages, pi, crown_age)
  #   %>% dplyr::rename(pi1 = "1", pi2 = "2")
  #
  # print("Remove NA column")
  # df <- dplyr::select(df, -starts_with("<NA>"))
  # testit::assert(names(df) == c("filename", "sti", "ai", "si", "pi1", "pi2"))
  #
  # print("Remove NAs")
  # df <- stats::na.omit(df)
  # nrow(df)
  #
  # print("Group")
  # df <- dplyr::group_by(.data = df, filename, sti, ai)
  #
  # safe_mann_whitney <- function(pi1, pi2)
  # {
  #   p <- NA
  #   tryCatch(
  #       p <- stats::wilcox.test(
  #         pi1,
  #         pi2,
  #         correct = FALSE,
  #         exact = FALSE, # cannot compute exact p-value with ties
  #         na.action = stats::na.omit
  #       )$p.value,
  #       error = function(cond) {} # nolint
  #     )
  #   p
  # }
  #
  # df <- df %>% summarize(p_value = safe_mann_whitney(pi1, pi2))
  #
  # utils::head(df)
  # names(df)
  #
  # svg("~/figure_posterior_distribution_crown_ages_p_values.svg")
  # ggplot2::ggplot(
  #   stats::na.omit(df),
  #   ggplot2::aes(x = p_value, na.omit = TRUE)
  # ) +
  #   ggplot2::geom_histogram(binwidth = 0.01) +
  #   ggplot2::geom_vline(xintercept = 0.05, linetype = "dotted") +
  #   ggplot2::xlab("p value") +
  #   ggplot2::ylab("Count") +
  #   ggplot2::labs(
  #     title = "The distribution of p values of Mann-Whitney tests\nbetween posterior crown ages",
  #     caption  = "figure_posterior_distribution_crown_ages_p_values"
  #   ) +
  #   ggplot2::annotate("text", x = c(0.0, 0.125), y = 1450, label = c("different", "same")) +
  #   ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0.5))
  # dev.off()
  #
  #
  #
  #
  #
  #
  #
  #
  #
  #
  #
  #
  # # Show posterior with low, median and high p value
  # low  <- df[which(df$p_value == min(   df$p_value)), ]
  # low_filename <- paste0(posteriors_path, "/", low$filename[1])
  # low_sti <- as.numeric(low$sti[1])
  # low_ai <- as.numeric(low$ai[1])
  # low_file <- wiritttes::read_file(low_filename)
  # low_crown_ages1 <- wiritttes::get_posterior(low_file, sti = low_sti, ai = low_ai, pi = 1)$estimates$TreeHeight
  # low_crown_ages2 <- wiritttes::get_posterior(low_file, sti = low_sti, ai = low_ai, pi = 2)$estimates$TreeHeight
  # df_low <- data.frame(
  #   pi = as.factor(c(rep(1, length(low_crown_ages1)), rep(2, length(low_crown_ages2)))),
  #   crown_age  = c(low_crown_ages1, low_crown_ages2)
  # )
  #
  # svg("~/figure_posterior_distribution_crown_ages_lowest_p_value.svg")
  # options(warn = 1) # Allow outliers not to be plotted
  # ggplot2::ggplot(
  #   stats::na.omit(df_low),
  #   ggplot2::aes(x = crown_age, fill = pi)
  # ) +
  #   ggplot2::geom_histogram(binwidth = 0.001, position = "identity", alpha = 0.25) +
  #   ggplot2::xlab("tree crown_age") +
  #   ggplot2::ylab("Count") +
  #   ggplot2::xlim(0.14,0.17) +
  #   ggplot2::labs(
  #     title = "The distribution of tree crown_ages of two replicate  posteriors",
  #     caption  = paste0("p value = ", low$p_value, ", figure_posterior_distribution_crown_ages_lowest_p_value")
  #   ) +
  #   ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0.5))
  # options(warn = 2) # Be strict
  # dev.off()
  #
  #
  #
  #
  #
  #
  # high <- df[which(df$p_value == max(   df$p_value)), ]
  #
  # high_filename <- paste0(posteriors_path, "/", high$filename[1])
  # high_sti <- as.numeric(high$sti[1])
  # high_ai <- as.numeric(high$ai[1])
  # high_file <- wiritttes::read_file(high_filename)
  # high_crown_ages1 <- wiritttes::get_posterior(high_file, sti = high_sti, ai = high_ai, pi = 1)$estimates$TreeHeight
  # high_crown_ages2 <- wiritttes::get_posterior(high_file, sti = high_sti, ai = high_ai, pi = 2)$estimates$TreeHeight
  # df_high <- data.frame(
  #   pi = as.factor(c(rep(1, length(high_crown_ages1)), rep(2, length(high_crown_ages2)))),
  #   crown_age  = c(high_crown_ages1, high_crown_ages2)
  # )
  #
  # svg("~/figure_posterior_distribution_crown_ages_highest_p_value.svg")
  # options(warn = 1) # Allow outliers not to be plotted
  # ggplot2::ggplot(
  #   stats::na.omit(df_high),
  #   ggplot2::aes(x = crown_age, fill = pi)
  # ) +
  #   ggplot2::geom_histogram(binwidth = 0.001, position = "identity", alpha = 0.25) +
  #   ggplot2::xlab("tree crown_age") +
  #   ggplot2::ylab("Count") +
  #   ggplot2::xlim(0.14, 0.16) +
  #   ggplot2::labs(
  #     title = "The distribution of tree crown_ages of two replicate posteriors",
  #     caption  = paste0("p value = ", high$p_value, ", figure_posterior_distribution_crown_ages_highest_p_value")
  #   ) +
  #   ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0.5))
  # options(warn = 2) # Be strict

  ggplot2::ggsave(file = filename, width = 7, height = 7)
}