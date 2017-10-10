#' Create figure 'figure_exit_statuses'
#' @param log_files_info log files' info, as returned from read_collected_log_files_info
#' @param filename name of the file the figure will be saved to
create_figure_exit_statuses <- function(
  log_files_info,
  filename
) {

  ggplot2::ggplot(
    data = log_files_info[ log_files_info$exit_status != "OK" & !is.na(log_files_info$exit_status), ],
    ggplot2::aes(x = "", fill = exit_status)
  ) +
    ggplot2::geom_bar() +
    ggplot2::coord_polar("y", start = 0) +
    ggplot2::xlab("Count") +
    ggplot2::labs(
      fill = "Exit status",
      title = "Reasons why simulation failed",
      caption = filename
    ) +
    ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0.5))

  ggplot2::ggsave(file = filename, width = 7, height = 7)
}