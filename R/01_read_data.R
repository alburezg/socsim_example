# Created 20210127 by Diego Alburez-Gutierrez

# 1. Load data -------

library(tidyverse)

source("R/functions.R")

# opop <- read_sweden_socsim(path="Data/sweden_big.opop")
opop <- read_sweden_socsim(path="Data/sweden_small.opop")

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