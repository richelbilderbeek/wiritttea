## ------------------------------------------------------------------------
library(wiritttea)
options(warn = 2)

## ------------------------------------------------------------------------
df <- read_collected_parameters()

## ------------------------------------------------------------------------
knitr::kable(t(head(df)))

## ------------------------------------------------------------------------
str(df)
names(df)

## ------------------------------------------------------------------------
ggplot2::ggplot(data = df, ggplot2::aes(df$age)) + ggplot2::geom_histogram(binwidth = 1)

## ------------------------------------------------------------------------
ggplot2::ggplot(data = df, ggplot2::aes(df$sequence_length)) + ggplot2::geom_histogram(binwidth = 1)

## ------------------------------------------------------------------------
ggplot2::ggplot(data = df, ggplot2::aes(df$sequence_length)) + ggplot2::geom_histogram(binwidth = 1) + ggplot2::scale_x_log10()

## ------------------------------------------------------------------------
ggplot2::ggplot(data = df, ggplot2::aes(df$sequence_length)) + ggplot2::geom_freqpoly(binwidth = 1) + ggplot2::scale_x_log10()

