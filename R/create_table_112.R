#' Table 112: Which estimated parameter has the lowest ESS?
#' @param esses the ESSes, as returned from read_collected_esses
#' @param filename name of the file the table will be saved to
create_table_112 <- function(
  esses,
  filename
) {

  # Tally the count of each parameter having the lowest ESS per posterior
  parameter_names <- c("posterior", "likelihood", "prior", "treeLikelihood", "TreeHeight", "BirthDeath", "birthRate2", "relativeDeathRate2")

  esses$lowest <- apply(esses[ , parameter_names], 1, min)

  # This is stupid, but could not get something descent to work quickly enough
  # Feel encouraged to send an improvement
  for (i in seq(1, nrow(esses))) {
    this_lowest <- esses$lowest[i]
    if (is.na(this_lowest)) {
      next
    }
    for (parameter_name in parameter_names) {
      this_value <- esses[ , parameter_name][i]
      if (is.na(this_value)) {
        next
      }
      if (this_value == this_lowest) {
        esses$lowest[i] <- parameter_name
      }
    }
  }

  # Tally the lowest
  esses$lowest <- as.factor(esses$lowest)

  tibble_tally <- dplyr::count(esses, lowest)
  df_tally <- as.data.frame(tibble_tally)

  utils::write.csv(df_tally, filename)
}