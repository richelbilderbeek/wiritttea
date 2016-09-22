#' Performs the full analysis on all the .RDa files present in a
#' given folder. These .RDa files are in the format
#' created by the 'wirittttes' package
#' @param folder path of the folder containing the RDa files
#' @return nothing, but will create multiple .CSV files in the folder
#' @examples
#'   folder <- "~/GitHubs/wiritttea/inst/extdata"
#'   if (file.exists(folder)) {
#'     do_analysis(folder = folder)
#'     testit::assert(length(list.files(folder, pattern = "\\.csv")) > 0)
#'   }
#' @export
collect_all <- function(folder = "~/GitHubs/wiritttea/inst/extdata")
{
  rda_files <- list.files(folder, pattern = "\\.RDa", full.names = TRUE)
  collect_functions <- ls(getNamespace("wiritttea"), pattern = "collect_files_")
  for (f in collect_functions)
  {
    print(f)
    df <- do.call(f, list(filenames = rda_files))
    testit::assert(class(df) == "data.frame")
    csv_filename <- paste0(folder, "/", f, ".csv")
    write.csv(
      x = df,
      file = csv_filename,
      row.names = TRUE
    )
  }
}

