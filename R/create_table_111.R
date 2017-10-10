#' Table 111: How many parameter estimates are OK?
#' @param esses the ESSes, as returned from read_collected_esses
#' @param filename name of the file the table will be saved to
create_table_111 <- function(
  df_esses,
  filename
) {

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

  write.csv(df_esses_ok, filename)
}