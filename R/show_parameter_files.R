#' Creates a nice knitr::table to show one or more parameter files
#' @param filenames names of the parameter files
#' @export
#' @author Richel Bilderbeek
show_parameter_files <- function(filenames) {
  df <- collect_parameters(
    filenames = filenames
  )
  my_table <- knitr::kable(df)
  my_table
}
