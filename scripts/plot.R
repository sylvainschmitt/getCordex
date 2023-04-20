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
# var <-  "temperature"
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
data <- vroom(filein, col_types = list(rainfall = col_double())) %>% 
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

g_hour <- data %>%
  filter(time > max(date(time))-31) %>% 
  plot_tab() +
  geom() + 
  # geom_point() +
  ggtitle("Half-hourly in the last month") + 
  ylab(lab)

g_day <- data %>%
  filter(year(time) > max(year(time))-10) %>% 
  group_by(time = floor_date(time, "day")) %>% 
  summarise_all(fun, na.rm = TRUE) %>% 
  plot_tab() +
  geom() + 
  # geom_point() +
  ggtitle("Daily in the last decade") + 
  ylab(lab)

g_month <- data %>%
  filter(year(time) > max(year(time))-100) %>% 
  group_by(time = floor_date(time, "month")) %>% 
  summarise_all(fun, na.rm = TRUE) %>% 
  plot_tab() +
  geom_smooth(col = "red", se = F) +
  geom() + 
  # geom_point() +
  ggtitle("Monthly in the last century") + 
  ylab(lab)

g_year <- data %>%
  group_by(time = floor_date(time, "year")) %>% 
  summarise_all(fun, na.rm = TRUE) %>% 
  plot_tab() +
  geom_smooth(col = "red", se = F) +
  geom() + 
  # geom_point() +
  ggtitle("Yearly") + 
  ylab(lab)

g_tot <- (g_hour + g_day) / (g_month + g_year) + plot_annotation(cordex)

ggsave(g_tot, filename = fileout)
