#' Creates figures 'figure_error.svg', 'figure_error_head.svg'
#' and 'figure_error_tail.svg', showing the complete distribution of all
#' errors (measured as nLTT statistic)
#' @param parameters collected parameters, as returned from 'collect_parameters'
#' @param nltt_stats collected nLTT statistics, as returned from
#'   'read_collected_nltt_stats', assumes burn-in is already removed
#' @param svg_filenames the three filenames the figures will be saved as
#' @param verbose if set to TRUE, the function prints more information
#' @examples
#'   parameters <- read_collected_parameters()
#'   nltt_stats <- read_collected_nltt_stats(burn_in = 0.2)
#'   create_figure_error(
#'     parameters = parameters,
#'     nltt_stats = nltt_stats,
#'     filenames = paste0(path.expand("~"), "/figure_error_.svg")
#'   )
#' @export
#' @author Richel Bilderbeek
create_figure_error <- function(
  parameters,
  nltt_stats,
  filename,
  verbose = FALSE
) {

  if (verbose == TRUE) {
    print("Add mean duration of speciation to parameters")
  }

  filename <- NULL; rm(filename) # nolint, should fix warning: no visible binding for global variable
  mean_durspec <- NULL; rm(mean_durspec) # nolint, should fix warning: no visible binding for global variable
  nltt_stat <- NULL; rm(nltt_stat) # nolint, should fix warning: no visible binding for global variable

  parameters$mean_durspec <- PBD::pbd_mean_durspecs(
    eris = parameters$eri,
    scrs = parameters$scr,
    siris = parameters$siri
  )

  if (verbose == TRUE) {
    print("Prepare parameters for merge")
  }

  parameters <- subset(parameters, select = c(filename, mean_durspec) )

  if (verbose == TRUE) {
    print("Prepare nLTT stats for merge")
  }

  nltt_stats <- subset(nltt_stats, select = c(filename, nltt_stat) )

  if (verbose == TRUE) {
    print("Connect the nLTT stats and parameters")
  }
  testit::assert("filename" %in% names(parameters))
  testit::assert("filename" %in% names(nltt_stats))
  df <- merge(x = parameters, y = nltt_stats, by = "filename", all = TRUE)

  df <- stats::na.omit(df)

  my_colors <- grDevices::hsv(
    scales::rescale(sort(unique(df$mean_durspec)), to = c(0.0, 5.0 / 6.0)))

  if (verbose == TRUE) {
    print(paste0("Creating figure ", filename))
  }

  ggplot2::ggplot(
    data = df,
    ggplot2::aes(x = nltt_stat, fill = factor(mean_durspec))
  ) +
    ggplot2::geom_histogram(binwidth = 0.001) +
    ggplot2::scale_fill_manual(values = my_colors) +
    ggplot2::labs(
      title = "nLTT statistic distribution",
      x = latex2exp::TeX("nLTT statistic $\\Delta_{nLTT}$"),
      y = "Count",
      caption = basename(filename)
    ) + ggplot2::guides(fill = FALSE) +
    ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0.5))

  ggplot2::ggsave(file = filename, width = 7, height = 7)
}
