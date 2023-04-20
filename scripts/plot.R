# snakemake log
log_file <- file(snakemake@log[[1]], open = "wt")
sink(log_file, append = TRUE, type = "message")
sink(log_file, append = TRUE)

# snakemake vars
filein <- snakemake@input[[1]]
fileout <- snakemake@output[[1]]
var <-  as.character(snakemake@params$var)
cordex <-  as.character(snakemake@params$cordex)

# test
# filein <- "results/table/MPI-M-MPI-ESM-MR_ICTP-RegCM4-7_rcp85.formatted.tsv"
# var <-  "vpd"
# cordex <- "MPI-M-MPI-ESM-MR_ICTP-RegCM4-7_rcp85"

# libraries
suppressMessages(library(tidyverse))
library(vroom)
library(patchwork)

# functions
summarise_tab <- function(tab, level, fun)
  tab %>% 
  group_by(time = floor_date(time, level)) %>% 
  summarise_all(fun, na.rm = TRUE)
plot_tab <- function(tab)
  ggplot(tab, aes(time, .data[[var]])) +
  theme_bw() +
  xlab("")

# code
data <- vroom(filein) %>% 
  filter(year(time) < max(year(time)))
data <- data %>% 
  select(time, {var}) %>% 
  na.omit()
if(var == "rainfall") {
  fun <- sum
} else {
  fun <- mean
}
if(var == "rainfall") {
  geom <- geom_col
} else {
  geom <- geom_line
}
lab <- switch (var,
  "rainfall" = "Rainfall (mm)",
  "snet" = "Absorbed short-wave radiation (w/m2)",
  "temperature" = "Temperature (degree C)",
  "vpd" = "Vapour pressure deficit (Pa)",
  "ws" = "wind speed (m/s)"
)
g <- list("day", "month", "year") %>% 
  lapply(function(x) summarise_tab(data, x, fun)) %>% 
  lapply(plot_tab)
names(g) <- c("day", "month", "year") 
g$hour <- filter(data, year(time) == max(year(data$time))) %>% 
  plot_tab()

g_tot <- (
  (g$hour + geom() + ggtitle("Hourly in last year") + ylab(lab)) +
    (g$day + geom() + ggtitle("Daily") + ylab(lab))
) / (
  (g$month + geom() + ggtitle("Monthly") + ylab(lab)) +
  (g$year + geom() + ggtitle("Yearly") + ylab(lab))
) +
  plot_annotation(cordex)

ggsave(g_tot, filename = fileout)
