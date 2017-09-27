#' Read all the collected nLTT statistics of all simulations
#' @param filename the name of the CSV containing the collected nLTT
#'   statistics. Default value is 'inst/extdata/collected_files_nltt_stats.csv'
#' @param burn_in_fraction fraction of posterior states being discarded,
#'   where 0.0 keeps the full posterior, 0.1 (a commonly used value)
#'   discards the first 10 percent
#' @return a dataframe, with columns `filename` (name of the file),
#'   `sti` (species tree index), `ai` (alignment index), `pi` (posterior
#'   index), `si` (state index) and `nltt_stat` (the nLTT statistic between
#'   that posteriors's state and the nLTT of the original
#'   species tree (which is either 'youngest' for `sti` equals 1, or
#'   'oldest' for `sti` equals 2)
#' @examples
#'   df <- read_collected_nltt_stats(burn_in_fraction = 0.1)
#'   expected_names <- c("filename", "sti", "ai", "pi", "si", "nltt_stat")
#'   testit::assert(names(df) == expected_names)
#'   testit::assert(is.factor(df$filename))
#'   testit::assert(is.factor(df$sti))
#'   testit::assert(is.factor(df$ai))
#'   testit::assert(is.factor(df$pi))
#'   testit::assert(is.factor(df$si))
#' @author Richel Bilderbeek
#' @export
read_collected_nltt_stats <- function(
  filename = find_path("collect_files_nltt_stats.csv"),
  burn_in_fraction
) {
  if (!file.exists(filename)) {
    stop("file not found")
  }
  if (burn_in_fraction < 0.0) {
    stop("burn_in_fraction must be at least zero")
  }
  if (burn_in_fraction > 1.0) {
    stop("burn_in_fraction must be at most one")
  }
  df <- utils::read.csv(
    file = filename,
    header = TRUE,
    stringsAsFactors = FALSE,
    row.names = 1
  )

  # Remove burn-in
  max_si <- max(stats::na.omit(df$si))
  si_lower_bound <- burn_in_fraction * max_si
  df <- df[df$si > si_lower_bound, ]

  df$filename <- as.factor(df$filename)
  df$sti <- as.factor(df$sti)
  df$ai <- as.factor(df$ai)
  df$pi <- as.factor(df$pi)
  df$si <- as.factor(df$si)

  testit::assert(is.factor(df$filename))
  testit::assert(is.factor(df$sti))
  testit::assert(is.factor(df$ai))
  testit::assert(is.factor(df$pi))
  testit::assert(is.factor(df$si))

  df
}
