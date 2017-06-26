# Analyse the files' ESSes
options(warn = 2) # Be strict
path_data <- "~/Peregrine20170710"
esses_filename <- "~/GitHubs/wirittte_data/esses_20170710.csv"
parameters_filename <- "~/GitHubs/wirittte_data/parameters_20170710.csv"
use_classic <- FALSE


args <- commandArgs(trailingOnly = TRUE)
if (length(args) > 0) path_data <- args[1]
if (length(args) > 1) esses_filename <- args[2]
if (length(args) > 2) use_classic <- ifelse(args[3] == "TRUE", TRUE, FALSE)


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

# New approach, reads the files created by BEAST
if (!file.exists(esses_filename) && !use_classic) {

  print("Use new approach")

  my_filenames <- list.files(
    path_data,
    pattern = "article_.*\\.RDa",
    full.names = TRUE)

  # nstpist: Number of Species Trees Per Incipient Species Tree
  nstpist <- 2
  # napst: Number of Alignments per Species Tree
  napst <- wiritttes::extract_napst(wiritttes::read_file(my_filenames[1]))
  # nppa: Number of Posteriors per Alignment
  nppa <- wiritttes::extract_nppa(wiritttes::read_file(my_filenames[1]))
  # nppf: Number of Posteriors Per File
  nppf <- nstpist * napst * nppa
  n_files <- length(my_filenames)
  n_rows <- n_files * nppf


  df <- data.frame(
    filename = rep(basename(my_filenames), each = nppf),
    sti = rep(seq(1,2), each = napst * nppa, times = n_files),
    ai = rep(seq(1, napst), each = nstpist, times = n_files * nppa),
    pi = rep(seq(1, nppa), times = n_files * nstpist * napst),
    min_ess = rep(NA, n_rows)
  )

  index <- 1
  for (i in seq_along(my_filenames)) {

    rda_filename <- my_filenames[i]
    log_filenames <- create_log_filenames(rda_filename, nstpist, napst, nppa)

    for (log_filename in log_filenames) {

      tryCatch({
        estimates <- RBeast::parse_beast_log(log_filename)
        min_ess <- min(
          RBeast::calc_esses(
            traces = estimates,
            sample_interval = 1000
          )
        )
        df$min_ess[index] <- min_ess
      }, error = function(cond) {} # nolint
      )
      index <- index + 1
    }
  }

  write.csv(df, esses_filename)
}

# Classic approach, takes 72 minutes per file
if (!file.exists(esses_filename) && use_classic) {

  print("Use classic approach")

  my_filenames <- list.files(path_data, pattern = "*.RDa", full.names = TRUE)

  # Assume all files have the same number of alignments

  # nstpist: Number of Species Trees Per Incipient Species Tree
  nstpist <- 2
  # napst: Number of Alignments per Species Tree
  napst <- wiritttes::extract_napst(wiritttes::read_file(my_filenames[1]))
  # nppa: Number of Posteriors per Alignment
  nppa <- wiritttes::extract_nppa(wiritttes::read_file(my_filenames[1]))
  # nppf: Number of Posteriors Per File
  nppf <- nstpist * napst * nppa
  n_files <- length(my_filenames)
  n_rows <- n_files * nppf

  df <- data.frame(
    filename = rep(basename(my_filenames), each = nppf),
    sti = rep(seq(1,2), each = napst * nppa, times = n_files),
    ai = rep(seq(1, napst), each = nstpist, times = n_files * nppa),
    pi = rep(seq(1, nppa), times = n_files * nstpist * napst),
    min_ess = rep(NA, n_rows)
  )
  testit::assert(names(df) == c("filename", "sti", "ai", "pi", "min_ess"))

  for (i in seq_along(my_filenames))
  {
    my_filename <- my_filenames[i]
    index_from <- ((i - 1) * nppf) + 1
    index_to <- (i * nppf)
    tryCatch({
      df_sub <- wiritttea::collect_file_esses(my_filename)
      df[index_from:index_to, ] <- df_sub
    }, error = function(cond) {} # nolint
    )
  }

  testit::assert(names(df) == c("filename", "sti", "ai", "pi", "min_ess"))
  write.csv(df, esses_filename)
}


#Investigations
df_esses <- wiritttea::read_collected_esses(esses_filename)

# How many NA's?
library(dplyr)
knitr::kable(df_esses  %>% count(is.na(min_ess)))

# Plotting ESSes distributions
#   as density plot
ggplot2::ggplot(subset(df_esses, !is.na(min_ess)),
  ggplot2::aes(min_ess)) +
  ggplot2::geom_density(alpha = 0.25, ggplot2::aes(y = ..density..), position = 'identity') +
  ggplot2::labs(title = "Effective Sample Sizes", x = "Effective Sample Size", y = "Density")
#   as histogram
ggplot2::ggplot(subset(df_esses, !is.na(min_ess)),
  ggplot2::aes(min_ess)) +
  ggplot2::geom_histogram() +
  ggplot2::labs(title = "Effective Sample Sizes", x = "Effective Sample Size", y = "Count")

# What are ESSes dependent on SIRG?
# Read parameters
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

