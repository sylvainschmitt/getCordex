# snakemake log
log_file <- file(snakemake@log[[1]], open = "wt")
sink(log_file, append = TRUE, type = "message")
sink(log_file, append = TRUE)

# snakemake vars
var_tables <- snakemake@input
fileout <- snakemake@output[[1]]

# libraries
suppressMessages(library(tidyverse))
library(vroom)
library(plyr)

# code
lapply(var_tables, vroom) %>% 
  join_all(by = "time", type = "left") %>% 
  vroom_write(file = fileout)
