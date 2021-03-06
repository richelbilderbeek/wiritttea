  #' Finds the full path of a file
#' @param filename the name of a file
#' @return the full path of the filename if an existing file could be found,
#'   stops otherwise
#' @examples
#'   path <- find_path("toy_example_1.RDa")
#'   testit::assert(file.exists(path))
#' @author Richel Bilderbeek
#' @export
find_path <- function(filename) {

  full_path <- system.file(
    "extdata", filename, package = "wiritttea"
  )

  if (file.exists(full_path)) {
    return(full_path)
  }

  stop(
    "find_path: ",
    "cannot find '", filename, "'"
  )
}


#' Finds the full path of files
#' @param filenames the names of files
#' @return the full path of the filenames if an existing file could be found,
#'   stops otherwise
#' @examples
#'   filenames <- wiritttea::find_paths(
#'     c("toy_example_1.RDa", "toy_example_2.RDa")
#'   )
#'   testit::assert(file.exists(filenames[1]))
#'   testit::assert(file.exists(filenames[2]))
#' @author Richel Bilderbeek
#' @export
find_paths <- function(filenames) {
  filenames <- as.vector(
    vapply(
      filenames,
      wiritttea::find_path,
      FUN.VALUE = "string"
    )
  )
  filenames
}
