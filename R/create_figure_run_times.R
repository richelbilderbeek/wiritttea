#' figure_run_times: distribution of runtimes
#' @param filename name of the file the figure will be saved to
#' @param log_files_info log files' info, as returned from read_collected_log_files_info
create_figure_run_times <- function(
  log_files_info,
  filename
) {

  ggplot2::ggplot(
    data = log_files_info[ log_files_info$sys_time > 600,  ],
    ggplot2::aes(x = sys_time, fill = exit_status)
  ) + ggplot2::geom_histogram(binwidth = 600, na.rm = TRUE) +
    ggplot2::scale_x_continuous(breaks = seq(3600, 36000, 3600)) +
    ggplot2::labs(
      title = "Distribution of run-times",
      fill = "Exit status",
      caption = filename
    ) + ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0.5))

  ggplot2::ggsave(file = filename, width = 7, height = 7)
}