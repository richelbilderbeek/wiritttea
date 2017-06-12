# Analyse the files' ESSes
options(warn = 2) # Be strict
path_data <- "~/Peregrine20170710"
esses_filename <- "~/20170710_esses.csv"

args <- commandArgs(trailingOnly = TRUE)
if (length(args) > 0) path_data <- args[1]
if (length(args) > 1) esses_filename <- args[2]

# Create file if absent
if (!file.exists(esses_filename)) {

  my_filenames <- head(list.files(path_data, pattern = "*.RDa", full.names = TRUE))

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
    pi = rep(seq(1, nppa), times = n_files * nstpist * napst * nppa),
    ess = rep(NA, n_rows)
  )

  for (i in seq_along(my_filenames))
  {
    my_filename <- my_filenames[i]
    index_from <- ((i - 1) * nppf) + 1
    index_to <- (i * nppf)
    print(paste(my_filename, index_from, index_to))
    tryCatch({
      df_sub <- wiritttea::collect_file_esses(my_filename)
      df[, index_from:index_to] <- df_sub
    }, error = function(cond) {} # nolint
    )
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
