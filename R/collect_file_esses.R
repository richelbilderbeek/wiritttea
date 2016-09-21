#' Collects the ESSes of all phylogenies belonging to a
#' parameter file in the melted/uncast/long form
#'
#' @param filename name of the parameter file
#' @return A dataframe of ESSes for each posterior
#' @examples
#'   filename <- find_path("toy_example_3.RDa")
#'   df <- collect_file_esses(filename)
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

  file <- wiritttea::read_file(filename)
  parameters <- file$parameters
  n_species_trees <- 2
  n_alignments <- as.numeric(parameters$n_alignments[2])
  n_beast_runs <- as.numeric(parameters$n_beast_runs[2])
  n_rows <- n_species_trees * n_alignments * n_beast_runs

  df <- data.frame(
     filename = rep(basename(filename), n_rows),
     sti = rep(
       seq(1, n_species_trees), each = n_alignments * n_beast_runs, times = 1
     ),
     ai  = rep(
       seq(1, n_alignments), each = n_beast_runs, times = n_species_trees
     ),
     pi  = rep(seq(1, n_beast_runs), times = n_species_trees * n_alignments),
     min_ess = rep(NA, n_rows)
  )
  index <- 1

  for (sti in 1:2) {
    for (ai in seq(1, n_alignments)) {
      for (pi in seq(1, n_beast_runs)) {

        min_ess <- NA
        tryCatch(
          min_ess <- min(
            RBeast::calc_esses(
              traces = wiritttes::get_posterior(
                file, sti = sti, ai = ai, pi = pi
              )$estimates,
              sample_interval = 1000
            )
          ),
          error = function(msg) {
            # OK
          }
        )

        df$min_ess[index] <- min_ess
        index <- index + 1
      }
    }
  }
  testit::assert(names(df)
    == c("filename", "sti", "ai", "pi", "min_ess")
  )
  df
}
