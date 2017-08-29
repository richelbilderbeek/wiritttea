# Create figure_exit_statuses_posteriors: How many parameter estimates are OK?
options(warn = 2) # Be strict
date <- "20170710"
esses_filename <- paste0("~/GitHubs/wirittte_data/esses_", date, ".csv")

args <- commandArgs(trailingOnly = TRUE)
if (length(args) > 0) esses_filename <- args[1]

#Investigations
df_esses <- wiritttea::read_collected_esses(esses_filename)

head(df_esses)

# How many NA's?
library(dplyr)

is_ok <- function(x) {
  !is.na(x)
}

df_esses_ok <- df_esses  %>% count(is_ok(posterior))

names(df_esses_ok) <- c("ok", "n")
df_esses_ok[ df_esses_ok$ok == TRUE, 1] <- "OK"
df_esses_ok[ df_esses_ok$ok == FALSE, 1] <- "Fail"
names(df_esses_ok) <- c("status", "n")
df_esses_ok$status <- as.factor(df_esses_ok$status)

svg("~/figure_exit_statuses_posteriors.svg")
ggplot2::ggplot(
  data = df_esses_ok,
  ggplot2::aes(x = status, y = n, fill = status)
) + ggplot2::geom_col() +
    ggplot2::ylab(label = "count") +
    ggplot2::labs(
    fill = "Exit status",
    title = "Posterior exit statuses",
    caption  = "figure_exit_statuses_posteriors"
  ) +
  ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0.5))
dev.off()

