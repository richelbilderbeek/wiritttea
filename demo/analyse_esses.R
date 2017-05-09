---
title: "Analyse the files' ESSes"
author: "Richel Bilderbeek"
date: "`r Sys.Date()`"
output: rmarkdown::html_vignette
vignette: >
  %\VignetteIndexEntry{Analyse the files' ESSes}
  %\VignetteEngine{knitr::rmarkdown}
  %\VignetteEncoding{UTF-8}
---

```{r}
library(wiritttea)
my_filenames <- list.files("~/Peregrine20170208", pattern="*.RDa", full.names=TRUE)
sub_filenames <- my_filenames
write.csv(wiritttea::collect_files_esses(filenames = sub_filenames), "~/esses.csv")
```

Profiling:

```{r}
if (1==2) {
rprof_tmp_output <- "~/tmp_rprof"
Rprof(rprof_tmp_output)
wiritttea::collect_files_esses(filenames = sub_filenames)
Rprof(NULL)
summaryRprof(rprof_tmp_output)
}
```

Investigations:

```{r}
if (1 == 2) {
df_esses <- read.csv("~/esses.csv")
names(df_esses)
df_esses <- df_esses[,-1] # Remove 'X' column
df_esses$filename <- as.factor(df_esses$filename)
df_esses$sti <- as.factor(df_esses$sti)
df_esses$ai <- as.factor(df_esses$ai)
df_esses$pi <- as.factor(df_esses$pi)
names(df_esses)

if (1 == 2) {
ggplot2::ggplot(
  df_esses, 
  ggplot2::aes(min_ess)
) + ggplot2::geom_density(
    alpha = 0.25, ggplot2::aes(y = ..density..), 
    position = 'identity'
)
}

}

```

Combine with n_taxa:

```{r}
if (1 == 2) {
df_n_taxa <- read.csv("~/n_taxa.csv")

names(df_n_taxa)
df_n_taxa$filename <- as.factor(df_n_taxa$filename)

head(df_n_taxa)
df_esses
}
```



