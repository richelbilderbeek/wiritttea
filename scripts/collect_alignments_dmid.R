# Collect the alignment's DMIDs
library(wiritttea)
options(warn = 2) # Be strict

args <- commandArgs(trailingOnly = TRUE)
if (length(args) == 0) {
  stop("Supply a source folder as a first argument, e.g. '~/wirittte_data/stub'")
}
if (length(args) == 1) {
  stop("Supply a target filename as a second argument, e.g. '~/alignment_dmid_stub.csv'")
}
if (length(args) != 2) {
  stop("Supply two parameters: a source folder and a target filename, ",
    "e.g. '~/wirittte_data/stub ~/alignment_dmid_stub.csv'")
}

#args <- c("/home/richel/wirittte_data/20170926", "~/alignment_dmid_20170926.csv")

path_data <- args[1]
alignment_dmid_filename <- args[2]

print(paste("path_data:", path_data))
print(paste("alignment_dmid_filename:", alignment_dmid_filename))

my_filenames <- list.files(path_data, pattern = "*.RDa", full.names = TRUE)

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
  my_filename <- my_filenames[file_index]
  testit::assert(file.exists(my_filename))

  tryCatch({
    file <- wiritttes::read_file(my_filename) # Can fail
    this_n_alignments <- wiritttes::extract_napst(file) * 2
    testit::assert(this_n_alignments == n_alignments)
    ai <- 1 + ((row - 1 ) %% n_alignments)
    alignment <- wiritttes::get_alignment_by_index(file, ai)
    m <- ape::dist.dna(x = alignment, model = "JC69", as.matrix = TRUE)
    dmid <- wiritttea::calc_dmid(m)
    df$dmid[row] <- dmid
  }, error = function(cond) {} #nolint
  )
  gc() # Need to do so manually
}

# Save
write.csv(df, alignment_dmid_filename)
