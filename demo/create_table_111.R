# Table 111: How many parameter estimates are OK?
options(warn = 2) # Be strict
date <- "20170710"
esses_filename <- paste0("~/GitHubs/wirittte_data/esses_", date, ".csv")

args <- commandArgs(trailingOnly = TRUE)
if (length(args) > 0) esses_filename <- args[1]

#Investigations
df_esses <- wiritttea::read_collected_esses(esses_filename)


# How many NA's?
is_ok <- function(x) {
  !is.na(x)
}

`%>%` <- dplyr::`%>%`
df_esses_ok <- df_esses  %>% count(is_ok(min_ess))

names(df_esses_ok) <- c("ok", "n")
df_esses_ok[ df_esses_ok$ok == TRUE, 1] <- "OK"
df_esses_ok[ df_esses_ok$ok == FALSE, 1] <- "Fail"
names(df_esses_ok) <- c("Parameter estimate status", "Count")

write.csv(df_esses_ok, "table_111.csv")
knitr::kable(df_esses_ok)
