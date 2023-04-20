# snakemake log
log_file <- file(snakemake@log[[1]], open = "wt")
sink(log_file, append = TRUE, type = "message")
sink(log_file, append = TRUE)

# snakemake vars
var_tables <- snakemake@input
fileout <- snakemake@output[[1]]

# test
var_tables <- list.files("results/table/", full.names = T)[-7]

# libraries
suppressMessages(library(tidyverse))
library(vroom)

# code
data <- lapply(var_tables, vroom)
time_l <- lapply(data, function(x) x$time)
time <- time_l[[1]]
for(i in 2:length(time_l))
  time <- c(time, time_l[[i]])
time_tbl <- tibble(time = unique(time)) %>% 
  arrange(time)
for(i in seq_len(length(data)))
  time_tbl <- left_join(time_tbl, data[[i]], by = "time")
vroom_write(time_tbl, file = fileout)
