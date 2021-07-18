# Created 20210127 by Diego Alburez-Gutierrez

# 0. Some useful functions ---------------

rm(list=ls())
library(tidyverse)
source("R/functions.R")

# 1. Run Socsim using Tom Theile's socsim.exe windows executable ------ 

path_dir <- getwd()
path_socsim <- paste0(path_dir, "/socsim")
path_sup <- paste0(path_dir, "/simul_Sweden_hmd_windows.sup")
path_sup_base <- paste0(path_dir, "/simul_Sweden_hmd_windows_base.sup")

# Since relative paths are not supported or don;t work for me, re-name 
# paths in sup files

old <- readLines(paste0(path_sup_base))
new <- gsub("whereami", path_dir, old)

write(new, path_sup)

print(paste("Fixed path names in sup files!"))

# Run simulation

system(paste(path_socsim, path_sup, "1234"))

# 2. Load output populaiton file -------

opop <- read_sweden_socsim(path="popfiles/output_pop.opop")

opop <- 
  opop %>% 
  select(pid, mom, pop, fem, birth_year, death_year) %>% 
  # fem = 1 for women!
  # Remove founder generation (who have no mother)
  # People can still have no dads but that's fine because
  # Children of  unmarried couples get a 0 as id for their 
  # father by default.
  filter(!is.na(mom)) %>% 
  # And let's just start from 1751, which is the first period for which 
  # we provided empiricla rates
  filter(birth_year >= 1751)

head(opop)

# 2. Get vector of children of women -------

children <- 
  opop %>% 
  group_by(mom) %>% 
  summarise(pid = paste(pid, collapse = ";"))

# and so on...