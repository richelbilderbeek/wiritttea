# Analyse if the alignments are created successfully
library(wiritttea)
options(warn = 2) # Be strict
path_data <- "~/Peregrine20170523"
#path_data <- "~/GitHubs/wiritttea/inst/extdata"
alignments_dmid_filename <- "~/alignments_dmid.csv"

args <- commandArgs(trailingOnly = TRUE)
if (length(args) > 0) path_data <- args[1]
if (length(args) > 1) alignments_dmid_filename <- args[2]

print(paste("path_data:", path_data))
print(paste("alignments_dmid_filename:", alignments_dmid_filename))

if (!file.exists(alignments_dmid_filename)) {

  my_filenames <- head(list.files(path_data, pattern = "*.RDa", full.names = TRUE))

  # Assume all files have the same number of alignments
  n_alignments <- wiritttes::extract_napst(wiritttes::read_file(my_filenames[1])) * 2

  df <- data.frame(
    filename = rep(basename(my_filenames), each = n_alignments),
    ai = rep(seq(1, n_alignments), times = length(my_filenames)),
    dmid = rep(NA, length(my_filenames), each = n_alignments)
  )

  n_rows <- nrow(df)

  for (row in seq(1, n_rows)) {
    file_index <- 1 + trunc((row - 1)/ 4)
    print(file_index)
    my_filename <- my_filenames[file_index]
    print(my_filename)
    testit::assert(file.exists(my_filename))

    tryCatch({
      file <- wiritttes::read_file(my_filename) # Can fail
      this_n_alignments <- wiritttes::extract_napst(file) * 2
      testit::assert(this_n_alignments == n_alignments)
      ai <- 1 + ((row - 1 ) %% n_alignments)
      print(paste("ai:", ai))
      alignment <- wiritttes::get_alignment_by_index(file, ai)
      print("alignment")
      m <- ape::dist.dna(x = alignment, model = "JC69", as.matrix = TRUE)
      print("m")
      dmid <- wiritttea::calc_dmid(m)
      print("dmid: ")
      print(dmid)
      df$dmid[row] <- dmid
    }, error = function(cond) {} #nolint
    )
    gc() # Need to do so manually
  }

  # Save
  write.csv(df, alignments_dmid_filename)
}

df <- read.csv(alignments_dmid_filename)
