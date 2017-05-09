# Analyse the number of taxa
options(warn = 2) # Be strict
path_data <- "~/Peregrine20170509"
n_taxa_filename <- "~/n_taxa.csv"

# Create file if absent
if (!file.exists(n_taxa_filename)) {
  my_filenames <- list.files(path_data, pattern = "*.RDa", full.names = TRUE)
  #my_filenames <- c(
  #  "/home/p230198/Peregrine20170509/article_1_3_0_3_0_958.RDa",
  #  "/home/p230198/Peregrine20170509/article_1_3_0_3_1_972.RDa",
  #  "/home/p230198/Peregrine20170509/article_1_3_0_3_1_976.RDa"
  #)
  write.csv(wiritttea::collect_files_n_taxa(filenames = my_filenames), n_taxa_filename)
}

# Investigations
df_n_taxa <- wiritttea::read_collected_n_taxa(n_taxa_filename)

# The success rate
df_n_taxa_na <- df_n_taxa[is.na(df_n_taxa$n_taxa), ]

n_fail <- sum(df_n_taxa_na)
n_success <- nrow(df_n_taxa) - n_fail
df_success <- data.frame(
  name = c("success", "fail"), n = c(n_success, n_fail)
)
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

# How do the failed PBD sims look like?
for (i in 1:nrow(df_n_taxa_na)) {
  filename <- paste(path_data,"/",df_n_taxa_na$filename[i], sep = "")
  file <- wiritttes::read_file(filename)
  print(file$pbd_output)
}




















# What is the global distribution of number of taxa?

if (1 == 2) {
  #Plot the distribution of number of taxa (in the reconstructed incipient species tree) over all runs
  df <- df_n_taxa[ !is.na(df_n_taxa$n_taxa), ]
  df_na <- df_n_taxa[ is.na(df_n_taxa$n_taxa), ]

  n_missing <- sum(is.na(df_n_taxa$n_taxa))

  ggplot2::ggplot(
    data = df, ggplot2::aes(df$n_taxa)
  ) +
  ggplot2::geom_histogram(bins = 30) +
  ggplot2::ggtitle(
    paste0(
      "Number of taxa for ", n_success, "/",
      nrow(df_n_taxa) ," runs"
    )
  )
}

## Which parameters?

Now we create a data frame of both parameters and number of
taxa:

```{r}
# Create a 'filename' column needed for merge
df_parameters$filename <- rownames(df_parameters)
# Outer join on the filename
df <- merge(df_parameters, df_n_taxa, by = "filename")
# Either remove the NA's...
df <- df[ !is.na(df_n_taxa$n_taxa), ]
# Or keep the failed ones
df_fail <- df[ is.na(df_n_taxa$n_taxa), ]
```

Here we plot both successes and fails. The latter are only plot if present.

```{r fig.width = 7, fig.height = 7}
if (1==2) {
if (nrow(df_fail) == 0) {
  ggplot2::ggplot(data = df, ggplot2::aes(x = df$sirg, y = df$n_taxa, color = as.factor(df$erg))) +
  ggplot2::geom_point(shape = 16) +
  ggplot2::ggtitle("Effect of speciation and extinction rates on #taxa")
} else {
  ggplot2::ggplot(data = df, ggplot2::aes(x = df$sirg, y = df$n_taxa, color = as.factor(df$erg))) +
  ggplot2::geom_point(shape = 16) +
  ggplot2::geom_jitter(data = df_fail, shape = 3, width = 0.02, height = 0.02, ggplot2::aes(x = df_fail$sirg, y = 0,   color = as.factor(df_fail$erg))) +
  ggplot2::ggtitle("Effect of speciation and extinction rates on #taxa (crosses denote NA)")
}
}
```




# Profiling

if (1==2){
  rprof_tmp_output <- "~/tmp_rprof"
  my_filenames <- list.files(path_data, pattern="*.RDa", full.names = TRUE)
  Rprof(rprof_tmp_output)
  wiritttea::collect_files_n_taxa(filenames = my_filenames)
  Rprof(NULL)
  summaryRprof(rprof_tmp_output)
}
