# Table 112: Which estimated parameter has the lowest ESS?
options(warn = 2) # Be strict
date <- "20170710"
esses_filename <- paste0("~/GitHubs/wirittte_data/esses_", date, ".csv")

args <- commandArgs(trailingOnly = TRUE)
if (length(args) > 0) esses_filename <- args[1]

if (!file.exists(esses_filename)) {
  stop("esses_filename absent, please run analyse_esses.R")
}


# Read the ESSES
df_esses <- wiritttea::read_collected_esses(esses_filename)

# Tally the count of each parameter having the lowest ESS per posterior
parameter_names <- c("posterior", "likelihood", "prior", "treeLikelihood", "TreeHeight", "BirthDeath", "birthRate2", "relativeDeathRate2")

df_esses$lowest <- apply(df_esses[ , parameter_names], 1, min)

# This is stupid, but could not get something descent to work quickly enough
# Feel encouraged to send an improvement
for (i in seq(1, nrow(df_esses))) {
  this_lowest <- df_esses$lowest[i]
  if (is.na(this_lowest)) {
    next
  }
  for (parameter_name in parameter_names) {
    this_value <- df_esses[ , parameter_name][i]
    if (is.na(this_value)) {
      next
    }
    if (this_value == this_lowest) {
      df_esses$lowest[i] <- parameter_name
    }
  }
}

# Tally the lowest
df_esses$lowest <- as.factor(df_esses$lowest)

tibble_tally <- dplyr::count(df_esses, lowest)
df_tally <- as.data.frame(tibble_tally)

write.csv(df_tally, "~/table_112.csv")
