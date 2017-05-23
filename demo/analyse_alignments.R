# Analyse if the alignments are created successfully
library(wiritttea)
options(warn = 2) # Be strict
path_data <- "~/Peregrine20170523"
#path_data <- "~/GitHubs/wiritttea/inst/extdata"

args <- commandArgs(trailingOnly = TRUE)
if (length(args) > 0) path_data <- args[1]

print(paste("path_data:", path_data))
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
      df$n_ok[i] <- length(which(alignments == TRUE))
      df$n_nas[i] <- length(which(alignments == TRUE))
      df$n_nas_in_dist_matrix[i] <- length(which(alignments != TRUE))
      df$n_zeroes_in_dist_matrix[i] <- length(which(alignments != TRUE))
      gc() # Need to do so manually
    },
    error = function(cond) {} #nolint
  )
}

write.csv(df, "~/alignments.csv")
print(df)
