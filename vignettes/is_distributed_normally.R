## ------------------------------------------------------------------------
library(wiritttea)

## ----fig.width = 7, fig.height = 7---------------------------------------
nd <- rnorm(n = 1000, mean = 0.0, sd = 1.0)
plot(nd)

## ------------------------------------------------------------------------
testit::assert(is_distributed_normally(nd))

## ----fig.width = 7, fig.height = 7---------------------------------------
nnd <- runif(n = 1000, min = 0.0, max = 1.0)
plot(nnd)

## ------------------------------------------------------------------------
testit::assert(!is_distributed_normally(nnd))

## ------------------------------------------------------------------------
df_nd  <- data.frame(
  method = rep("nd", times = length(nd)), x = nd
)

df_nnd <- data.frame(
  method = rep("nnd", times = length(nnd)), x = nnd
)
df <- rbind(df_nd, df_nnd)
df$method <- as.factor(df$method)

library(dplyr)
df_new <- df %>% 
  group_by(method) %>% 
  summarise(is_distributed_normally(x))

knitr::kable(df_new)

