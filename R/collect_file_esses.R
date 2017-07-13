#' Collects the ESSes of all phylogenies belonging to a
#' parameter file in the melted/uncast/long form
#'
#' @param filename name of the parameter file, can be read by
#'   wiritttess:read_file
#' @return A dataframe of ESSes for each posterior
#' @examples
#'   df <- wiritttea::collect_file_esses(
#'     filename = wiritttea::find_path("toy_example_3.RDa"))
#'   testit::assert(nrow(df) == 8)
#' @export
collect_file_esses <- function(filename) {

  if (length(filename) != 1) {
    stop(
      "there must be exactly one filename supplied"
    )
  }
  if (!wiritttes::is_valid_file(filename = filename)) {
    stop(
      "invalid file '", filename, "'"
    )
  }

  file <- wiritttes::read_file(filename)
  n_species_trees <- 2
  n_alignments <- wiritttes::extract_napst(file)
  n_beast_runs <- wiritttes::extract_nppa(file)
  n_rows <- n_species_trees * n_alignments * n_beast_runs

  testit::assert(n_species_trees > 0)
  testit::assert(n_alignments > 0)
  testit::assert(n_beast_runs > 0)
  testit::assert(n_rows > 0)

  df <- data.frame(
     filename = rep(basename(filename), n_rows),
     sti = rep(
       seq(1, n_species_trees), each = n_alignments * n_beast_runs, times = 1
     ),
     ai  = rep(
       seq(1, n_alignments), each = n_beast_runs, times = n_species_trees
     ),
     pi = rep(seq(1, n_beast_runs), times = n_species_trees * n_alignments),
     posterior = rep(NA, n_rows),
     likelihood = rep(NA, n_rows),
     prior = rep(NA, n_rows),
     treeLikelihood = rep(NA, n_rows),
     TreeHeight = rep(NA, n_rows),
     BirthDeath = rep(NA, n_rows),
     birthRate2 = rep(NA, n_rows),
     relativeDeathRate2 = rep(NA, n_rows)
  )
  index <- 1

  for (sti in 1:2) {
    for (ai in seq(1, n_alignments)) {
      for (pi in seq(1, n_beast_runs)) {

        this_esses <- NA
        tryCatch({
            posterior <- wiritttes::get_posterior(
              file, sti = sti, ai = ai, pi = pi)
            traces <- posterior$estimates
            this_esses <- RBeast::calc_esses(
              traces = traces,
              sample_interval = 1000
            )
          },
          error = function(msg) {} # nolint
        )

        if (is.data.frame(this_esses)) {
          df$posterior[index] <- this_esses$posterior
          df$likelihood[index] <- this_esses$likelihood
          df$prior[index] <- this_esses$prior
          df$treeLikelihood[index] <- this_esses$treeLikelihood
          df$TreeHeight[index] <- this_esses$TreeHeight
          df$BirthDeath[index] <- this_esses$BirthDeath
          df$birthRate2[index] <- this_esses$birthRate2
          df$relativeDeathRate2[index] <- this_esses$relativeDeathRate2
        }
        index <- index + 1
      }
    }
  }
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
    "relativeDeathRate2"
    )
  )
  df
}
