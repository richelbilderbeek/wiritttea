# Analyse the parametes
library(wiritttea)
options(warn = 2)
path_data <- "~/Peregrine20170509"
parameters_filename <- "~/parameters.csv"

# Collect all parameters in a single file if absent, slow
if (!file.exists(parameters_filename)) {
  my_filenames <- list.files("~/Peregrine20170208", pattern = "*.RDa", full.names = TRUE)
  write.csv(wiritttea::collect_files_parameters(filenames = my_filenames), parameters_filename)
}

# Read the collected parameters
df_parameters <- wirittea::read_collected_parameters(parameters_filename)











Number of filenames: `r nrow(df)`

Putting the head of the data frame in a table:

```{r}
knitr::kable(t(head(df)))
```

What kind of data is `df`?

```{r}
str(df)
names(df)
```

If an incipient species tree is simulated for a
longer time, I expect it to have more branches, thus
making the next steps harder, thus causing a
BEAST2 run to take too long.

Let's check this:

```{r}
ggplot2::ggplot(data = df, ggplot2::aes(df$age)) + ggplot2::geom_histogram(binwidth = 1)
```

Age appears not to be very predictive if a simulation will succeed.

If an alignment is simulated for more nucleotides,
I expect a BEAST2 run to take longer, thus likelier
to crash.

Let's check this:

```{r}
ggplot2::ggplot(data = df, ggplot2::aes(df$sequence_length)) + ggplot2::geom_histogram(binwidth = 1)
```

Now on a log scale:

```{r}
ggplot2::ggplot(data = df, ggplot2::aes(df$sequence_length)) + ggplot2::geom_histogram(binwidth = 1) + ggplot2::scale_x_log10()
```

Now as a `freq_poly` on a log scale:

```{r}
ggplot2::ggplot(data = df, ggplot2::aes(df$sequence_length)) + ggplot2::geom_freqpoly(binwidth = 1) + ggplot2::scale_x_log10()
```


# Profiling
if (1==2){
  rprof_tmp_output <- "~/tmp_rprof"
  Rprof(rprof_tmp_output)
  wiritttea::collect_files_parameters(filenames = sub_filenames)
  Rprof(NULL)
  summaryRprof(rprof_tmp_output)
}
