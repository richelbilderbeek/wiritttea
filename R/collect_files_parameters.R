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
#'  testit::assert(all(rownames(df) == basename(filenames)))
#' @export
#' @author Richel Bilderbeek
collect_files_parameters <- function(filenames) {

  nrows <- length(filenames)
  df <- data.frame(
    rng_seed = rep(NA, nrows),
    sirg = rep(NA, nrows),
    siri = rep(NA, nrows),
    scr = rep(NA, nrows),
    erg = rep(NA, nrows),
    eri = rep(NA, nrows),
    age = rep(NA, nrows),
    mutation_rate = rep(NA, nrows),
    n_alignments = rep(NA, nrows),
    sequence_length = rep(NA, nrows),
    nspp = rep(NA, nrows),
    n_beast_runs = rep(NA, nrows),
    fixed_crown_age = rep(NA, nrows)
  )

  # Disable scientific notation
  old_scipen <- getOption("scipen")
  options(scipen = 999)

  # Collect the parameters
  for (i in seq(1, nrows)) {
    filename <- filenames[i]
    file <- NULL
    tryCatch(
      file <- wiritttes::read_file(filename),
      error = function(msg) { } # nolint msg should be unused
    )

    if (is.null(file)) {
      next
    }
    df$rng_seed[i] <- wiritttes::extract_seed(file)
    df$sirg[i] <- wiritttes::extract_sirg(file)
    df$siri[i] <- wiritttes::extract_siri(file)
    df$scr[i] <- wiritttes::extract_scr(file)
    df$erg[i] <- wiritttes::extract_erg(file)
    df$eri[i] <- wiritttes::extract_eri(file)
    df$age[i] <- wiritttes::extract_crown_age(file)
    df$mutation_rate[i] <- wiritttes::extract_mutation_rate(file)
    df$n_alignments[i] <- wiritttes::extract_napst(file)
    df$sequence_length[i] <- wiritttes::extract_sequence_length(file)
    df$nspp[i] <- wiritttes::extract_nspp(file)
    df$n_beast_runs[i] <- wiritttes::extract_nppa(file)
    df$fixed_crown_age[i] <- wiritttes::extract_fixed_crown_age(file)
  }

  # Restore original scientific notation
  options(scipen = old_scipen)


  rownames(df) <- basename(filenames)

  df
}
