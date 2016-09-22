#' Collects the parameters of its input files
#' @param filenames names of the parameter files
#' @return a data.frame, one per parameter file. If all filenames are invalid,
#'   a simpler data.frame is returned
#' @examples
#'  filenames <- c(
#'    find_path("toy_example_1.RDa"),
#'    find_path("toy_example_2.RDa"),
#'    find_path("toy_example_3.RDa")
#'  )
#'  df <- collect_files_parameters(filenames)
#'  testit::assert(nrow(df) == 3)
#' @export
#' @author Richel Bilderbeek
collect_files_parameters <- function(filenames) {

  parameter_names <- NULL

  # Find parameter filenames
  for (filename in filenames) {
    if (!wiritttes::is_valid_file(filename = filename)) {
      next
    }
    file <- wiritttes::read_file(filename)
    parameter_names <- names(file$parameters)
    break
  }
  if (is.null(parameter_names)) {
    df <- data.frame(
      message = "No valid files supplied",
      stringsAsFactors = FALSE
    )
    testit::assert(class(df) == "data.frame")
    return(df)
  }

  # Disable scientific notation
  old_scipen <- getOption("scipen")
  options(scipen = 999)

  # Collect the parameters
  df <- NULL
  for (filename in filenames) {
    file <- NULL
    tryCatch(
      file <- wiritttes::read_file(filename),
      error = function(msg) { } # nolint msg should be unused
    )
    if (!is.null(file)) {
      parameter_values <- as.numeric(
        file$parameters[2, , 2]
      )
      testit::assert(length(parameter_values) == length(parameter_names))
      if (is.null(df)) {
        df <- data.frame(parameter_values = parameter_values)
      } else {
        df <- cbind(df, parameter_values)
      }
    } else {
      new_col <- rep(NA, times = length(parameter_names))
      testit::assert(length(new_col) == length(parameter_names))
      if (is.null(df)) {
        df <- data.frame(parameter_values = new_col)
      } else {
        df <- cbind(df, new_col)
      }
    }
  }

  tidy_df <- t(df)
  rownames(tidy_df) <- c(basename(filenames))
  colnames(tidy_df) <- parameter_names
  tidy_df <- data.frame(tidy_df)

  # Restore original scientific notation
  options(scipen = old_scipen)


  testit::assert(class(tidy_df) == "data.frame")
  tidy_df
}