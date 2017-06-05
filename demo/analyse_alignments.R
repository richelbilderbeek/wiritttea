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
    n_alignments_ok = rep(0, length(my_filenames)),
    n_alignments_zeroes = rep(0, length(my_filenames)),
    n_alignments_na = rep(0, length(my_filenames))
  )

  for (i in seq_along(my_filenames)) {

    my_filename <- my_filenames[i]
    #print(my_filename)
    testit::assert(file.exists(my_filename))

    tryCatch( {
        file <- wiritttes::read_file(my_filename) # Can fail
        n_alignments <- wiritttes::extract_napst(file) * 2
        for (j in seq(1, n_alignments)) {
          #print(j)
          alignment <- wiritttes::get_alignment_by_index(file, j)
          m <- ape::dist.dna(x = alignment, model = "JC69", as.matrix = TRUE)
          #print(m)
          # Detect if there is at least one NA
          if (!all(!is.na(m))) {
            df$n_alignments_na[i] <- df$n_alignments_na[i] + 1
          } else if (sum(m == 0.0) - nrow(m) > 0) {
            # Detect zeroes, except those on the diagonal
            df$n_alignments_zeroes[i] <- df$n_alignments_zeroes[i] + 1
          } else {
            df$n_alignments_ok[i] <- df$n_alignments_ok[i] + 1
          }
          gc() # Need to do so manually
        }
      },
      error = function(cond) {} #nolint
    )
  }

  # Save
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

