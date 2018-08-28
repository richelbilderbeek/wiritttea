#' Create 'figure_error_max', showing the phylogeny with the biggest
#'   nLTT statistics error
#'   of all simulations
#' @param parameters parameters, as returned from read_collected_parameters
#' @param nltt_stats the nLTT statistics, as returned from
#'   read_collected_nltt_stats
#' @param filename name of the file the figure will be saved to
#' @param sample_size the number of nLTT statistics that will be sampled, use
#'   NA to sample all
#' @param raw_data_path the path where the raw data (the .RDa files) can
#'   be found
#' @author Richel Bilderbeek
#' @export
create_figure_error_max <- function(
  parameters,
  nltt_stats,
  filename,
  sample_size = NA,
  raw_data_path = system.file("extdata", package = "wiritttea")
) {

  mean_durspec <- NULL; rm(mean_durspec) # nolint, should fix warning: no visible binding for global variable

  # print("Add mean duration of speciation to parameters")
  parameters$mean_durspec <- PBD::pbd_mean_durspecs(
    eris = parameters$eri,
    scrs = parameters$scr,
    siris = parameters$siri
  )

  # Only select what is needed
  parameters <- subset(parameters, select = c(filename, mean_durspec) )

  nltt_stats <- stats::na.omit(nltt_stats)
  if (is.na(sample_size)) {
    sample_size <- nrow(nltt_stats)
  }

  # print("Order by nltt_stat, highest value first")
  df <- stats::na.omit(nltt_stats[with(nltt_stats, order(-nltt_stat)), ])
  filenames <- unique(utils::head(df, 1000)$filename)

  file <- wiritttes::read_file(paste0(raw_data_path, "/", df$filename[1]))

  posterior_stree <- wiritttes::get_posterior_tree(
    file = file,
    sti = as.numeric(df$sti[1]),
    ai = as.numeric(df$ai[1]),
    pi = as.numeric(df$pi[1]),
    si = as.numeric(df$si[1])
  )

  stree <- wiritttes::get_species_tree_by_index(
    file = file,
    sti = as.numeric(df$sti[1])
  )

  grDevices::svg(filename)
  n_rows <- 2
  n_cols <- 1
  graphics::par(mfrow = c(n_rows, n_cols))
  ape::plot.phylo(main = "posterior tree", posterior_stree, show.tip.label = FALSE)
  ape::plot.phylo(main = "original species tree", stree, show.tip.label = FALSE)
  grDevices::dev.off()
  graphics::par(mfrow = c(1, 1))
}

