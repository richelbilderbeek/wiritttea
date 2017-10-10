#' Table 109: Successes and reasons of failures
#' @param filename name of the file the table will be saved to
create_table_109 <- function(
  df_log_files <- wiritttea::read_collected_log_files_info(log_files_filename),
  filename
) {

  write.csv(df_log_files, filename)

  # Why did these fail?
  ggplot2::ggplot(
    data = df_log_files,
    ggplot2::aes(x = exit_status)
  ) +
    ggplot2::geom_bar() +
    ggplot2::scale_y_log10() +
    ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 90, hjust = 1))

  ggplot2::ggsave(file = filename, width = 7, height = 7)
}