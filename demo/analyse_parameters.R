---
title: "Analyse parameters"
author: "Richel Bilderbeek"
date: "`r Sys.Date()`"
output: rmarkdown::html_vignette
vignette: >
  %\VignetteIndexEntry{Analyse parameters}
  %\VignetteEngine{knitr::rmarkdown}
  %\VignetteEncoding{UTF-8}
---

Loading this package

```{r}
library(wiritttea)
options(warn = 2)
```

Loading the parameters:

```{r}
my_filenames <- list.files("~/Peregrine20170208", pattern="*.RDa", full.names = TRUE)
sub_filenames <- my_filenames
df_parameters <- wiritttea::collect_files_parameters(filenames = sub_filenames)
write.csv(df_parameters, "~/parameters.csv")
```

Profiling:

```{r}
if (1==2){
rprof_tmp_output <- "~/tmp_rprof"
Rprof(rprof_tmp_output)
wiritttea::collect_files_parameters(filenames = sub_filenames)
Rprof(NULL)
summaryRprof(rprof_tmp_output)
}
```


Extracting all file parameters is easy:

```{r}
df <- read_collected_parameters()
```

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
