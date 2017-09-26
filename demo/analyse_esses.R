# Analyse the files' ESSes
options(warn = 2) # Be strict
date <- "20170710"
path_data <- paste0("~/wirittte_data/", date)
esses_filename <- paste0("~/esses_", date, ".csv")

args <- commandArgs(trailingOnly = TRUE)
if (length(args) > 0) path_data <- args[1]
if (length(args) > 1) esses_filename <- args[2]



# Create file if absent
if (!file.exists(esses_filename)) {

  my_filenames <- list.files(
    path_data,
    pattern = "article_.*\\.RDa",
    full.names = TRUE)

  df <- wiritttea::collect_files_esses(
    my_filenames, show_progress = TRUE)
  write.csv(df, esses_filename)
}

#Investigations
df_esses <- wiritttea::read_collected_esses(esses_filename)

# How many NA's?
library(dplyr)
knitr::kable(df_esses  %>% count(is.na(min_ess)))

# What are ESSes dependent on SIRG?
# Read parameters
parameters_filename <- paste0("~/GitHubs/wirittte_data/parameters_", date, ".csv")
parameters <- wiritttea::read_collected_parameters(parameters_filename)
# Prepare parameters for merge
parameters$filename <- row.names(parameters)
parameters$filename <- as.factor(parameters$filename)
df <- merge(x = parameters, y = df_esses, by = "filename", all = TRUE)

# Plot the ESSes per SIRG?
ggplot2::ggplot(
  data = na.omit(df),
  ggplot2::aes(min_ess, fill = as.factor(sirg))
) + ggplot2::geom_histogram(alpha = 0.5)

ggplot2::ggplot(
  data = na.omit(df),
  ggplot2::aes(min_ess, fill = as.factor(sirg))
) + ggplot2::geom_density(alpha = 0.5)

# Plot the ESSes per SIRG, per sequence length
ggplot2::ggplot(
  data = na.omit(df),
  ggplot2::aes(min_ess, fill = as.factor(sirg))
) + ggplot2::facet_grid(sequence_length ~ .) + ggplot2::geom_histogram(alpha = 0.5)

ggplot2::ggplot(
  data = na.omit(df),
  ggplot2::aes(min_ess, fill = as.factor(sirg))
) + ggplot2::facet_grid(sequence_length ~ .) + ggplot2::geom_density(alpha = 0.5)

