# Analyse the files' ESSes
options(warn = 2) # Be strict
date <- "20170710"
path_data <- paste0("~/wirittte_data/", date)
esses_filename <- paste0("~/esses_", date, ".csv")

args <- commandArgs(trailingOnly = TRUE)
if (length(args) > 0) path_data <- args[1]
if (length(args) > 1) esses_filename <- args[2]


# nstpist: Number of Species Trees Per Incipient Species Tree
# napst: Number of Alignments per Species Tree
# nppa: Number of Posteriors per Alignment
create_log_filenames <- function(rda_filename, nstpist, napst, nppa)
{
  log_filenames <- NULL
  base <- tools::file_path_sans_ext(rda_filename)
  for (sti in seq(1, nstpist)) {
    for (ai in seq(1, napst)) {
      for (pi in seq(1, nppa)) {
        log_filenames <- c(log_filenames,
          paste0(base, "_", sti, "_", ai, "_", pi, ".log")
        )
      }
    }
  }
  log_filenames
}

test_create_log_filenames <- function() {
  rda_filename <- "test.RDa"
  log_filenames <- create_log_filenames(rda_filename, 2,2,2)
  testit::assert(log_filenames[1] == "test_1_1_1.log")
  testit::assert(log_filenames[2] == "test_1_1_2.log")
  testit::assert(log_filenames[3] == "test_1_2_1.log")
  testit::assert(log_filenames[4] == "test_1_2_2.log")
  testit::assert(log_filenames[5] == "test_2_1_1.log")
  testit::assert(log_filenames[6] == "test_2_1_2.log")
  testit::assert(log_filenames[7] == "test_2_2_1.log")
  testit::assert(log_filenames[8] == "test_2_2_2.log")
}
test_create_log_filenames()
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

