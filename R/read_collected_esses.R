#' Read all the collected ESSes of all simulations' posteriors
#' @param filename name of the CSV file, as created by 'collect_files_esses'
#' @return a dataframe
#' @examples
#'   df <- read_collected_esses()
#'   expected_names <- c("filename", "sti", "ai", "pi", "posterior",
#'     "likelihood", "prior", "treeLikelihood", "TreeHeight", "BirthDeath",
#'     "birthRate2", "relativeDeathRate2")
#'   testit::assert(names(df) == expected_names)
#'   testit::assert(is.factor(df$filename))
#'   testit::assert(is.factor(df$sti))
#'   testit::assert(is.factor(df$ai))
#'   testit::assert(is.factor(df$pi))
#' @author Richel Bilderbeek
#' @export
read_collected_esses <- function(
  filename = wiritttea::find_path("collect_files_esses.csv")) {

  testit::assert(file.exists(filename))
  df <- utils::read.csv(
    file = filename,
    header = TRUE,
    stringsAsFactors = FALSE,
    row.names = 1
  )
  df$filename <- as.factor(df$filename)
  df$sti <- as.factor(df$sti)
  df$ai <- as.factor(df$ai)
  df$pi <- as.factor(df$pi)

  expected_names <- c("filename", "sti", "ai", "pi", "posterior", "likelihood", "prior", "treeLikelihood", "TreeHeight", "BirthDeath", "birthRate2", "relativeDeathRate2")

  testit::assert(names(df) == c(
    "filename",
    "sti",
    "ai",
    "pi",
    "posterior",
    "likelihood",
    "prior",
    "treeLikelihood",
    "TreeHeight",
    "BirthDeath",
    "birthRate2",
    "relativeDeathRate2"))
  testit::assert(is.factor(df$filename))
  testit::assert(is.factor(df$sti))
  testit::assert(is.factor(df$ai))
  testit::assert(is.factor(df$pi))

  df
}
