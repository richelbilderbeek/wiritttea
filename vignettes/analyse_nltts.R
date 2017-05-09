## ------------------------------------------------------------------------
library(wiritttea)
options(warn = 2)

## ------------------------------------------------------------------------
df_species_trees <- read_collected_nltts_strees()
df_posterior <- read_collected_nltts_postrs()

## ------------------------------------------------------------------------
knitr::kable(head(df_species_trees))
knitr::kable(tail(df_species_trees))

## ------------------------------------------------------------------------
knitr::kable(head(df_posterior))
knitr::kable(tail(df_posterior))

## ----fig.width = 7, fig.height = 7---------------------------------------
df_species_trees$sti <- plyr::revalue(df_species_trees$sti, c("1"="youngest", "2"="oldest"))

ggplot2::ggplot(
  data = df_species_trees,
  ggplot2::aes(
    x = df_species_trees$t,
    y = df_species_trees$nltt,
    colour = df_species_trees$filename,
    shape = df_species_trees$sti
  )
) + ggplot2::geom_point(
) + ggplot2::geom_step(direction = "vh", stat = "summary", fun.y = "mean"
) + ggplot2::scale_x_continuous(
  limits = c(0, 1), name = "Time (normalized)"
) + ggplot2::scale_y_continuous(
  limits = c(0, 1), name = "nLTT"
) + ggplot2::ggtitle("Collected species trees") + 
  ggplot2::guides(colour = FALSE)

## ----fig.width = 7, fig.height = 7---------------------------------------
df_posterior$sti <- plyr::revalue(df_posterior$sti, c("1"="youngest", "2"="oldest"))

# Only select those with non-NA values
df <- df_posterior[ !is.na(df_posterior$t), ]

ggplot2::ggplot(
  data = df,
  ggplot2::aes(
    x = df$t,
    y = df$nltt,
    color = df$sti
  )
) + ggplot2::geom_point(
) + ggplot2::geom_step(direction = "vh", stat = "summary", fun.y = "mean"
) + ggplot2::scale_x_continuous(
  limits = c(0, 1), name = "Time (normalized)"
) + ggplot2::scale_y_continuous(
  limits = c(0, 1), name = "nLTT"
) + ggplot2::ggtitle("Collected posteriors"
) + ggplot2::geom_smooth()
  

