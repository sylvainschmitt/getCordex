# snakemake log
log_file <- file(snakemake@log[[1]], open = "wt")
sink(log_file, append = TRUE, type = "message")
sink(log_file, append = TRUE)

# snakemake vars
folder <- snakemake@input[[1]]
fileout <- snakemake@output[[1]]
var <- as.character(snakemake@params$var)
xutm <- as.numeric(snakemake@params$xutm)
yutm <- as.numeric(snakemake@params$yutm)
cores <- as.numeric(snakemake@threads)

# test
# folder <- "results/MPI-M-MPI-ESM-MR_ICTP-RegCM4-7/rcp85"
# fileout <- "results/tables/MPI-M-MPI-ESM-MR_ICTP-RegCM4-7_rcp85_hurs.tsv"
# var <- "hurs"
# xutm <- 5.267241344232334
# yutm <- -52.92436802555797
# cores <- 10

# libraries
suppressMessages(library(tidyverse))
library(vroom)
library(terra)
library(foreach)

# function
get_cordex_data <- function(file,
                            xutm = 5.267241344232334, 
                            yutm = -52.92436802555797){
  suppressMessages(library(tidyverse))
  loc <- paracou <- c(xutm, yutm)
  var_r <- terra::rast(file)
  var_t <- terra::extract(var_r, loc) %>% 
    gather() %>% 
    na.omit() %>% 
    mutate(time = as_datetime(terra::time(var_r))) %>% 
    select(time, value)
  return(var_t)
}

# code
files <- list.files(folder, pattern = var, full.names = TRUE)
if(length(files) < cores)
  cores <- length(files)
file <- NULL
cl <- parallel::makeCluster(cores, outfile = "")
doSNOW::registerDoSNOW(cl)
pb <- txtProgressBar(max = length(files), style = 3)
progress <- function(n) setTxtProgressBar(pb, n)
opts <- list(progress = progress)
var_t <- foreach(
  file = iterators::iter(files), 
  .options.snow = opts
) %dopar% get_cordex_data(file)
close(pb)
parallel::stopCluster(cl)
var_t <- bind_rows(var_t)
colnames(var_t) <- c("time", var)
vroom_write(x = var_t, file = fileout)
