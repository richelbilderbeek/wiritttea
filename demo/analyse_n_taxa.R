# Analyse the number of taxa
library(wiritttea)
options(warn = 2) # Be strict
path_data <- "~/Peregrine20170509"
n_taxa_filename <- "~/n_taxa.csv"

args <- commandArgs(trailingOnly = TRUE)
if (length(args) > 0) path_data <- args[1]
if (length(args) > 1) n_taxa_filename <- args[2]

print(paste("path_data:", path_data))
print(paste("n_taxa_filename:", n_taxa_filename))



print("Create n_taxa data file if absent")
if (!file.exists(n_taxa_filename)) {
  print("File is absent, recreating")

  print("Collecting .RDa files")
  my_filenames <- list.files(path_data, pattern = "*.RDa", full.names = TRUE)

  print("Collecting # taxa")
  df_n_taxa <- wiritttea::collect_files_n_taxa(filenames = my_filenames)

  print("Saving # taxa")
  write.csv(df_n_taxa, n_taxa_filename)
}

print("Load n_taxa data")
df_n_taxa <- wiritttea::read_collected_n_taxa(n_taxa_filename)

print("Measure the success rate")
df_n_taxa_na <- df_n_taxa[is.na(df_n_taxa$n_taxa), ]

n_fail <- sum(df_n_taxa_na)
n_success <- nrow(df_n_taxa) - n_fail
df_success <- data.frame(
  name = c("success", "fail"), n = c(n_success, n_fail)
)
print(df_success)

if (1 == 2) {

print("Plot  the success rate")
ggplot2::ggplot(
  df_success,
  ggplot2::aes(
    x = factor(""),
    y = df_success$n,
    fill = df_success$name
  )
) +
  ggplot2::geom_bar(stat = "identity") +
  ggplot2::scale_x_discrete("") +
  ggplot2::scale_y_continuous("number of parameter sets") +
  ggplot2::coord_polar(theta = "y") +
  ggplot2::ggtitle("Incipient species trees created")

}
