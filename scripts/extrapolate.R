# snakemake log
log_file <- file(snakemake@log[[1]], open = "wt")
sink(log_file, append = TRUE, type = "message")
sink(log_file, append = TRUE)

# snakemake vars
filein <- snakemake@input[[1]]
fileout <- snakemake@output[[1]]
time_freq <- as.numeric(snakemake@params$time_freq)

# test
# filein <- "results/table/MPI-M-MPI-ESM-MR_ICTP-RegCM4-7_rcp26.joined.tsv"
# time_freq <- 30

# libraries
suppressMessages(library(tidyverse))
library(vroom)

# code

data <- vroom(filein)
time <- data$time
data0 <- data %>% 
  gather(variable, value, -time) %>% 
  na.omit() %>% 
  separate(variable, c("variable", "table")) %>% 
  select(-table) %>% 
  group_by(time, variable) %>% 
  summarise_all(mean) %>% 
  pivot_wider(names_from = "variable", values_from = "value")
data0 <- tibble(time = time) %>% 
  left_join(data0)

start <- as_datetime(as_date(min(data0$time)))+60*30 # to start from 00:30
stop <- max(data0$time) # to stop at 00:00
time <- seq(start, stop, by= 60*60*time_freq)
data <- left_join(tibble(time = time), 
                  data0, by = "time") %>% 
  mutate_at(c("hurs", "rsds", "rsus", "sfcWind", "tas"),
            zoo::na.spline, .$time, na.rm = F) %>% 
  mutate(rsus = ifelse(rsus < 0, 0, rsus), 
         rsds = ifelse(rsds < 0, 0, rsds))
vroom_write(data, file = fileout)

# data %>% 
#   filter(time < min(as_date(time))+11) %>% 
#   gather(variable, value, -time, -nature) %>% 
#   ggplot(aes(time, value)) +
#   geom_line() +
#   geom_point(aes(col = nature)) +
#   facet_wrap(~variable, scales = "free") +
#   theme_bw()
