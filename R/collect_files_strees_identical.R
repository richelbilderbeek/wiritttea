#' Collects if the two sampled species trees (from the same incipient
#' species trees) have the same branching times.
#' @param filenames names of the parameter file
#' @return A data frame with filenames and TRUE/FALSEs
#' @examples
#'  filenames <- c(
#'    find_path("toy_example_3.RDa"),
#'    find_path("toy_example_4.RDa")
#'  )
#'  df <- collect_files_strees_identical(filenames)
#'  testit::assert(
#'    names(df) ==
#'    c("filename", "strees_identical")
#'  )
#'  testit::assert(nrow(df) == 2)
#' @export
collect_files_strees_identical <- function(filenames) {

  if (length(filenames) < 1) {
    stop(
      "there must be at least one filename supplied"
    )
  }

  # Species trees
  df <- data.frame(
    filename = basename(filenames),
    strees_identical = rep(NA, length(filenames))
  )

  for (i in seq_along(filenames)) {
    tryCatch( {
      file <- wiritttes::read_file(filenames[i])
      df$strees_identical[i] <- have_same_strees(file)
      gc() # Really needed to do manual garbage collection
    }, error = function(msg) {} # nolint
    )
  }
  df
}
