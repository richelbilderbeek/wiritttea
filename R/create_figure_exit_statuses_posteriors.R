#' Create figure_exit_statuses_posteriors: How many parameter estimates are OK?
#' @param esses the ESSes, as returned from read_collected_esses
#' @param filename name of the file the figure will be saved to
create_figure_exit_statuses_posteriors <- function(
  df_esses,
  filename
) {


  # How many NA's?

  is_ok <- function(x) {
    !is.na(x)
  }

  `%>%` <- dplyr::`%>%`
  df_esses_ok <- df_esses  %>% count(is_ok(posterior))

  names(df_esses_ok) <- c("ok", "n")
  df_esses_ok[ df_esses_ok$ok == TRUE, 1] <- "OK"
  df_esses_ok[ df_esses_ok$ok == FALSE, 1] <- "Fail"
  names(df_esses_ok) <- c("status", "n")
  df_esses_ok$status <- as.factor(df_esses_ok$status)

  svg("~/figure_exit_statuses_posteriors.svg")
  ggplot2::ggplot(
    data = df_esses_ok,
    ggplot2::aes(x = status, y = n, fill = status)
  ) + ggplot2::geom_col() +
      ggplot2::ylab(label = "count") +
      ggplot2::labs(
      fill = "Exit status",
      title = "Posterior exit statuses",
      caption  = filename
    ) +
    ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0.5))

  ggplot2::ggsave(file = filename, width = 7, height = 7)
}