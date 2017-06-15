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
  df <- collect_files_alignments(my_filenames)
  write.csv(df, alignments_filename)
}

df <- read.csv(alignments_filename)
n_ok <- sum(df$n_alignments_ok)
n_na <- sum(df$n_alignments_na)
n_zeroes <- sum(df$n_alignments_zeroes)

df_problematic <- df[is.na(df$n_alignments_ok) | df$n_alignments_na > 0, ]
df_plottable <- df_problematic[!is.na(df_problematic$n_alignments_ok), ]

if (1 == 2) {

  for (filename in head(df_plottable$filename, n = 1)) {
    file <- wiritttes::read_file(paste0(path_data, "/", filename))

    for (i in seq(1, wiritttes::extract_napst(file))) {
      alignment <- wiritttes::get_alignment_by_index(file, i)
      image(alignment)
    }
  }
}

