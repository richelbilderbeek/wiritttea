#' Collects the number of taxa of all phylogenies belonging to a
#' multiple parameter file in the melted/uncast/long form
#' @param filenames names of the parameter file
#' @return A dataframe with all number of taxa of all files
#' @examples
#'   filenames <- c(
#'    find_path("toy_example_1.RDa"),
#'    find_path("toy_example_2.RDa")
#'  )
#'  df <- collect_files_n_taxa(filenames)
#'  testit::assert(names(df) == c("filename", "n_taxa"))
#'  testit::assert(nrow(df) == length(filenames))
#' @export
collect_files_n_taxa <- function(filenames) {

  if (length(filenames) < 1) {
    stop("there must be at least one filename supplied")
  }

  # Species trees
  n_taxa <- NULL
  for (filename in filenames) {
    gc() # Yes, need to do this manually :-(
    this_n_taxa <- NULL
    tryCatch(
      this_n_taxa <- collect_species_tree_n_taxa(
        filename = filename
      ),
      error = function(msg) {} # nolint
    )
    if (is.null(this_n_taxa)) {
      this_n_taxa <- data.frame(
        n_taxa = NA
      )
    }
    if (!is.null(n_taxa)) {
      n_taxa <- rbind(n_taxa, this_n_taxa)
    } else {
      n_taxa <- this_n_taxa
    }
  }
  df <- data.frame(
    filename = basename(filenames),
    n_taxa = n_taxa$n_taxa
  )
  testit::assert(nrow(df) == length(filenames))
  testit::assert(names(df) == c("filename", "n_taxa"))
  return(df)
}
