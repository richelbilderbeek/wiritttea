# Analyse the files' ESSes
options(warn = 2) # Be strict
path_data <- "~/Peregrine20170208"

df_na

# Create file if absent
if (!file.exists(esses_filename)) {
  my_filenames <- list.files(path_data, pattern = "*.RDa", full.names = TRUE)
  write.csv(wiritttea::collect_files_esses(filenames = my_filenames), esses_filename)
}

#Investigations
df_esses <- wiritttea::read_collected_esses(esses_filename)

# Plotting ESSes as density plot
if (1 == 2) {
  ggplot2::ggplot(df_esses,  ggplot2::aes(min_ess)) +
    ggplot2::geom_density(alpha = 0.25, ggplot2::aes(y = ..density..), position = 'identity')
}


```{r}
if (1 == 2) {
df_n_taxa <- read.csv("~/n_taxa.csv")

names(df_n_taxa)
df_n_taxa$filename <- as.factor(df_n_taxa$filename)

head(df_n_taxa)
df_esses
}
```



# Profiling
if (1==2) {
  rprof_tmp_output <- "~/tmp_rprof"
  Rprof(rprof_tmp_output)
  my_filenames <- list.files(path_data, pattern="*.RDa", full.names=TRUE)
  wiritttea::collect_files_esses(filenames = my_filenames)
  Rprof(NULL)
  summaryRprof(rprof_tmp_output)
}
