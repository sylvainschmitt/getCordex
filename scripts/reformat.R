# snakemake log
log_file <- file(snakemake@log[[1]], open = "wt")
sink(log_file, append = TRUE, type = "message")
sink(log_file, append = TRUE)

# snakemake vars
filein <- snakemake@input[[1]]
fileout <- snakemake@output[[1]]
time_freq_hr <-  as.numeric(snakemake@params$time_freq_hr)

# test
# filein <- "results/table/MPI-M-MPI-ESM-MR_ICTP-RegCM4-7_rcp85.joined.tsv"
# time_freq_hr <-  3

# libraries
suppressMessages(library(tidyverse))
library(vroom)

# code

# CORDEX
# hurs: Near-Surface Relative Humidity in %
# pr: Precipitation in kg/m/s
# rsds: Surface Downwelling Shortwave Radiation in W/m2
# rsus: Surface Upwelling Shortwave Radiation in W/m2
# sfcWind: Near-Surface Wind Speed in m/s
# tas: Near-Surface Air Temperature in Kelvin

# TROLL
# rainfall: rainfall in mm
# snet: absorbed short-wave radiation w/m2
# temperature: temperature in degrees C
# vpd: vapour pressure deficit in Pa
# ws: wind speed in m/s

# Transformations
# rainfall = 60*60*time_freq_hr*pr
# snet = rsds - rsus
# temperature  = tassfcWind - 273.15
# vpd = rh_to_vpd(hurs, temperature)
# ws = sfcWind

# functions
rh_to_vpd <- function(rh, 
                      temp, 
                      pa=101){
  esatval <- esat(temp, pa)
  e <- (rh/100) * esatval
  vpd <- (esatval - e)/1000
  return(vpd)
}
esat <- function(temp, 
                 pa = 101){  
  a <- 611.21
  b <- 17.502
  c <- 240.97
  f <- 1.0007 + 3.46 * 10^-8 * pa * 1000
  esatval <- f * a * (exp(b * temp/(c + temp)))
  return(esatval)
}

data <- vroom(filein)
data <- data %>% 
  mutate(rainfall = 60*60*time_freq_hr*pr) %>% 
  mutate(snet = rsds - rsus) %>% 
  mutate(temperature = tas-273.15) %>% 
  mutate(vpd = rh_to_vpd(hurs, temperature)) %>% 
  mutate(ws = sfcWind) %>% 
  select(time, rainfall, snet, temperature, vpd, ws)
vroom_write(data, file = fileout)
