#' Collect the nLTT values of the species trees with outgroup
#' @param filename name of the file containing the parameters and results
#' @param dt the resolution of the nLTT plot,
#'   must be in range <0,1>, default is 0.001
#' @return a data frame
#' @examples
#'   dt <- 0.1
#'   filename <- find_path("toy_example_3.RDa")
#'   df <- collect_file_stree_nltts(filename, dt = dt)
#'   testit::assert(names(df) == c("sti", "t", "nltt"))
#'   testit::assert(nrow(df) == 2 * (1 + (1/dt)))
#' @author Richel Bilderbeek
#' @export
collect_file_stree_nltts <- function(
  filename,
  dt
) {
  if (!wiritttes::is_valid_file(filename)) {
    stop("invalid file")
  }

  id <- NULL; rm(id) # nolint, should fix warning: collect_file_stree_nltts: no visible binding for global variable ‘id’

  file <- wiritttes::read_file(filename)

  df <- NULL

  for (sti in 1:2) {
    nltt_values <- nLTT::get_nltt_values(
      list(wiritttes::get_species_tree_by_index(file = file, sti = sti)),
      dt = dt
    )

    # Remove id column
    nltt_values <- subset(
      nltt_values,
      select = -c(id) # nolint Putting 'nltt_values$' before ID will mess up the
    )
    testit::assert(!is.null(nltt_values$nltt))

    n_nltt_values <- nrow(nltt_values)
    this_df <- data.frame(
      sti = rep(sti, n_nltt_values)
    )
    this_df <- cbind(this_df, nltt_values)
    if (is.null(df)) {
      df <- this_df
    } else {
      df <- rbind(df, this_df)
    }
  }
  testit::assert(!is.null(df$nltt))
  df$sti <- as.factor(df$sti)

  df
}
