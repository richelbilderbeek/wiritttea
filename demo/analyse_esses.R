# Analyse the files' ESSes
options(warn = 2) # Be strict
path_data <- "~/Peregrine20170710"
esses_filename <- "~/esses_20170710.csv"

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

# New approach, reads the files created by BEAST
if (!file.exists(esses_filename)) {

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

#Investigations
df_esses <- wiritttea::read_collected_esses(esses_filename)

# Plotting ESSes as density plot
if (1 == 2) {
  ggplot2::ggplot(df_esses,  ggplot2::aes(min_ess)) +
    ggplot2::geom_density(alpha = 0.25, ggplot2::aes(y = ..density..), position = 'identity')
}


if (1 == 2) {
  df_n_taxa <- read.csv("~/n_taxa.csv")

  names(df_n_taxa)
  df_n_taxa$filename <- as.factor(df_n_taxa$filename)

  head(df_n_taxa)
  df_esses
}

# Profiling
if (1==2) {
  rprof_tmp_output <- "~/tmp_rprof"
  Rprof(rprof_tmp_output)
  my_filenames <- list.files(path_data, pattern="*.RDa", full.names=TRUE)
  wiritttea::collect_files_esses(filenames = my_filenames)
  Rprof(NULL)
  summaryRprof(rprof_tmp_output)
}
