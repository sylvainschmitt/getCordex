# snakemake log
log_file <- file(snakemake@log[[1]], open = "wt")
sink(log_file, append = TRUE, type = "message")
sink(log_file, append = TRUE)

# snakemake vars
var_tables <- snakemake@input
fileout <- snakemake@output[[1]]

# test
# var_tables <- list.files("results/table/", full.names = T)[-7]
# var_tables <- c(
#   "results/table/MPI-M-MPI-ESM_REMO2015_rcp26_hurs.tsv", 
#   "results/table/MPI-M-MPI-ESM_REMO2015_rcp26_pr.tsv", 
#   "results/table/MPI-M-MPI-ESM_REMO2015_rcp26_rsds.tsv", 
#   "results/table/MPI-M-MPI-ESM_REMO2015_rcp26_rsus.tsv", 
#   "results/table/MPI-M-MPI-ESM_REMO2015_rcp26_sfcWind.tsv", 
#   "results/table/MPI-M-MPI-ESM_REMO2015_rcp26_tas.tsv"
# )
# fileout <- "results/table/MPI-M-MPI-ESM_REMO2015_rcp26.joined.tsv"

# libraries
library(tidyverse)
library(vroom)
library(dtplyr)

# function
load_var <- function(file) {
  data <- vroom(file) %>% 
    arrange(time)
  if(data$time[1] == data$time[2]) {
    warning("hour is missing, using the ones from NCC-NorESM1-M_REMO2015.historical.")
    if(names(data)[2] %in% c("hurs", "sfcWind", "tas")) {
      # 1:00, 4:00, 7:00, 10:00, 13:00, 16:00, 19:00, 22:00
      data <- data %>% 
        group_by(date = date(time)) %>% 
        mutate(time = time + c(1, 4, 7, 10, 13, 16, 19, 22)*60*60) %>% 
        ungroup() %>% 
        select(-date)
    }
    if(names(data)[2] %in% c("pr", "rsds", "rsus")) {
      # 1:30, 4:30, 7:30, 10:30, 13:30, 16:30, 19:30, 22:30
      data <- data %>% 
        group_by(date = date(time)) %>% 
        mutate(time = time + c(1, 4, 7, 10, 13, 16, 19, 22)*60*60+30*60) %>% 
        ungroup() %>% 
        select(-date)
    }
  }
  return(data)
}
  
# code
data <- lapply(var_tables, load_var)
time_l <- lapply(data, function(x) x$time)
time <- time_l[[1]]
for(i in 2:length(time_l))
  time <- c(time, time_l[[i]])
time_tbl <- tibble(time = unique(time)) %>% 
  arrange(time)
for(i in seq_len(length(data)))
  time_tbl <- left_join(time_tbl, data[[i]], by = "time")
vroom_write(time_tbl, file = fileout)
