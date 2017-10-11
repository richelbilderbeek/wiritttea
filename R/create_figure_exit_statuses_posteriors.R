#' Create figure_exit_statuses_posteriors: How many parameter estimates are OK?
#' @param esses the ESSes, as returned from read_collected_esses
#' @param filename name of the file the figure will be saved to
create_figure_exit_statuses_posteriors <- function(
  esses,
  filename
) {

  # How many NA's?

  is_ok <- function(x) {
    !is.na(x)
  }

  `%>%` <- dplyr::`%>%`
  esses_ok <- esses  %>% count(is_ok(posterior))

  names(esses_ok) <- c("ok", "n")
  esses_ok[ esses_ok$ok == TRUE, 1] <- "OK"
  esses_ok[ esses_ok$ok == FALSE, 1] <- "Fail"
  names(esses_ok) <- c("status", "n")
  esses_ok$status <- as.factor(esses_ok$status)

  svg("~/figure_exit_statuses_posteriors.svg")
  ggplot2::ggplot(
    data = esses_ok,
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