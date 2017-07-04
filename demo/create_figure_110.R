# Analyse the nLTT stats
library(wiritttea)
options(warn = 2) # Be strict
path_data <- "~/GitHubs/Peregrine20170710"
nltt_stats_filename <- "~/wirittte_data/nltt_stats_20170710.csv"
parameters_filename <- "~/GitHubs/wirittte_data/parameters_20170710.csv"

args <- commandArgs(trailingOnly = TRUE)
if (length(args) > 0) path_data <- args[1]
if (length(args) > 1) nltt_stats_filename <- args[2]
if (length(args) > 2) parameters_filename <- args[3]

print(paste("path_data:", path_data))
print(paste("nltt_stats_filename:", nltt_stats_filename))

if (!file.exists(parameters_filename)) {
  stop(
    "File '", parameters_filename, "' not found, ",
    "please run analyse_parameters"
  )
}

if (!file.exists(nltt_stats_filename)) {
  stop("File '", nltt_stats_filename, "' not found, ",
    "please run analyse_nltt_stats")
}

print("Read parameters and nLTT stats")
parameters <- wiritttea::read_collected_parameters(parameters_filename)
nltt_stats <- wiritttea::read_collected_nltt_stats(nltt_stats_filename)

print("Take the mean of the nLTT stats")
library(dplyr)
nltt_stat_means <- nltt_stats %>% group_by(filename, sti, ai, pi) %>%
       summarise(mean=mean(nltt_stat), sd=sd(nltt_stat))
testit::assert(all(names(nltt_stat_means)
  == c("filename", "sti", "ai", "pi", "mean", "sd")))
head(nltt_stat_means, n = 10)
nrow(nltt_stat_means)

print("Prepare parameters for merge")
parameters$filename <- row.names(parameters)
parameters$filename <- as.factor(parameters$filename)

print("Connect the mean nLTT stats and parameters")
testit::assert("filename" %in% names(parameters))
testit::assert("filename" %in% names(nltt_stat_means))
df <- merge(x = parameters, y = nltt_stat_means, by = "filename", all = TRUE)
names(df)
head(df, n = 10)

print("Only keep rows with a SCR > 10e6")
print(paste0("Rows before: ", nrow(df)))
dplyr::count(df, scr)
scr_bd <- max(na.omit(df$scr))
df <- df[ df$scr == scr_bd, ]
print(paste0("Rows after: ", nrow(df)))

write.csv(df, "~/tmp.csv")

# Warm
ggplot2::ggplot(
  na.omit(df),
  ggplot2::aes(x = as.factor(sirg), y = erg, color = mean)
) + ggplot2::geom_jitter()


ggplot2::ggplot(
  na.omit(df), na.rm = TRUE,
  ggplot2::aes(y = mean)
) + ggplot2::geom_boxplot() + ggplot2::facet_grid(erg ~ scr)

#print("Clean df")
#df_clean <- na.omit(df)

print("Create figure 110")
s <- akima::interp(
  x = df$scr,
  y = df$erg,
  z = df$mean,
  nx = 20, ny = 20
)

png("~/110_1.png")
image(s,
  xlab = "Mean duration of speciation",
  ylab = "Extinction rate",
  main = "Mean nLTT statistic"
)
dev.off()

png("~/110_2.png")
contour(s,
  xlab = "Mean duration of speciation",
  ylab = "Extinction rate",
  main = "Mean nLTT statistic",
  add = TRUE
)
dev.off()

png("~/110_3.png")
persp(s,
  xlab = "Mean duration of speciation",
  ylab = "Extinction rate",
  zlab = "Mean nLTT statistic"
)
dev.off()

png("~/110_4.png")
rgl::persp3d(
  x = s$x,
  y = s$y,
  z = s$z,
  col = s$z,
  xlab = "Mean duration of speciation",
  ylab = "Extinction rate",
  zlab = "Mean nLTT statistic"
)
dev.off()

png("~/110_5.png")
rgl::surface3d(s$x,s$y,s$z)
dev.off()

png("~/110_6.png")
plotly::plot_ly(
  data = nltt_stat_per_spec_dur,
  x = ~mean_durspec,
  y = ~erg,
  z = ~mean,
  type = "scatter3d",
  mode = "markers"
)
dev.off()

png("~/110_7.png")
plot3D::scatter3D(
  x = df$scr, xlab = "Speciation completion rate",
  #x = df$mean_durspec, xlab = "Mean duration of speciation",
  #y = df$erg, ylab = "Extinction rate",
  #y = df$scr, ylab = "Speciation completion rate",
  y = df$siri, ylab = "Speciation initiation rate",
  z = df$mean, zlab = "Mean nLTT statistic"
)
dev.off()
