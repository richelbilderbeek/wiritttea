#' Create figure 'alignment_qualities'
#' @param df_alignments data frame with alignments, as returned by 'read_collected_alignments'
#' @param filename the name of the file the figure is saved to
#' @return nothing, it saves a file
#' @author Richel Bilderbeek
#' @export
create_figure_alignment_qualities <- function(
  df_alignments,
  filename
) {

  df <- data.frame(
    status = c("ok", "zero", "na"),
    n = c(
      sum(df_alignments$n_alignments_ok),
      sum(df_alignments$n_alignments_zeroes),
      sum(df_alignments$n_alignments_na)
    )
  )
  df$status <- as.factor(df$status)

  ggplot2::ggplot(
    data = df,
    ggplot2::aes(x = status, y = n, fill = status)
  ) + ggplot2::geom_col() +
    ggplot2::ylab(label = "count") +
    ggplot2::labs(
      fill = "quality",
      title = "Alignment qualities",
      caption  = "Figure 220"
    ) +
    ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0.5))

  ggplot2::ggsave(file = filename, width = 7, height = 7)
}