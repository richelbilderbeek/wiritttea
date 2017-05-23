# Analyse if the alignments are created successfully
library(wiritttea)
options(warn = 2) # Be strict
path_data <- "~/Peregrine20170523"
#path_data <- "~/GitHubs/wiritttea/inst/extdata"
alignments_filename <- "~/alignments.csv"

args <- commandArgs(trailingOnly = TRUE)
if (length(args) > 0) path_data <- args[1]
if (length(args) > 1) alignments_filename <- args[2]

print(paste("path_data:", path_data))
print(paste("alignments_filename:", alignments_filename))

if (!file.exists(alignments_filename)) {
  my_filenames <- list.files(path_data, pattern = "*.RDa", full.names = TRUE)

  df <- data.frame(
    filename = basename(my_filenames),
    n_alignments_ok = rep(NA, length(my_filenames)),
    n_alignments_na = rep(NA, length(my_filenames))
  )

  for (i in seq_along(my_filenames)) {

    my_filename <- my_filenames[i]
    testit::assert(file.exists(my_filename))

    tryCatch( {
        file <- wiritttes::read_file(my_filename) # Can fail
        n_alignments <- wiritttes::extract_napst(file) * 2
        df$n_alignments_ok[i] <- 0
        df$n_alignments_na[i] <- n_alignments

        alignments <- wiritttes::has_alignments(file)
        df$n_alignments_ok[i] <- length(which(alignments == TRUE))
        df$n_alignments_na[i] <- length(which(alignments != TRUE))
        gc() # Need to do so manually
      },
      error = function(cond) {} #nolint
    )
  }

  # Save
  write.csv(df, alignments_filename)
}

df <- read.csv(alignments_filename)
df_problematic <- df[is.na(df$n_alignments_ok) | df$n_alignments_na > 0, ]
df_plottable <- df_problematic[!is.na(df_problematic$n_alignments_ok), ]

if (1 == 2) {

  for (filename in df_plottable$filename) {
    file <- wiritttes::read_file(filename)
    for (i in seq(1, 4)) {
      alignment <- wiritttes::get_alignment_by_index(file, i)


    }
  }
  article_1_1_0_3_1_729.RDa
}

