# This script has some basic functions for recovering
# input fertility and mortality age-specific rates that were
# used to create the simulation. Extracting these rates and
# comparing them to the input simulation is considered good practice
# as it allows us to assess the accuracy of our microsimulation.
# Note that this is only one of multiple checks that can be performed
# on the opop population files.



# 1. Load functions and data --------
rm(list=ls())

library(tidyverse)
source("R/functions.R")

opop <- 
  read_sweden_socsim(path="popfiles/output_pop.opop") %>% 
  select(pid, mom, pop, fem, birth_year, death_year, dob, dod) %>% 
  # fem = 1 for women!
  # Remove founder generation (who have no mother)
  # People can still have no dads but that's fine because
  # Children of  unmarried couples get a 0 as id for their 
  # father by default.
  filter(!is.na(mom)) %>% 
  # And let's just start from 1751, which is the first period for which 
  # we provided empiricla rates
  filter(birth_year >= 1751)

# 2. Define some parameters ========


y_min <- 1950
y_max <- 2000
y_range <- y_min:y_max

y_breaks <- seq(y_min, y_max, 5)

# lower age bounds of age categories of mortality rates
age_breaks_mort <- c(0, 1, seq(5, 100, by = 5))
age_labels_mort <- age_breaks_mort[-length(age_breaks_mort)]

age_group_size <-  5
min_age <-  15
max_age <-  50

# For fertility rates

age_group_size <-  5
min_age <-  15
max_age <-  50

age_breaks_fert <- seq(min_age, max_age, by = age_group_size)
age_labels_fert <- age_breaks_fert[-length(age_breaks_fert)]

# 3. Extract mortality and fertility rates ------

asmr <- 
  get_asmr_socsim_period(
  df = opop
  , age_breaks = age_breaks_mort
  , age_labels = age_labels_mort
  , y_breaks = y_breaks
  , un_y_labs = NA
  , y_range = y_range
  , compare_to_un = F
  , only_women = F
)

asfr <- 
  get_asfr_socsim(
    df = opop
    , sex_keep = "female"
    , y_range = y_range
    , age_breaks = age_breaks_fert
    , age_labels = age_labels_fert
  )

# 3. Plot recovered SOCSIM -------

bind_rows(
  asmr %>% 
    mutate(name = "asmr") %>% 
    filter(gender == "female")
  , asfr %>% 
    mutate(
      name = "asfr"
      , age = as.numeric(as.character(age))
      )
) %>% 
  ggplot(aes(x = age, y = socsim, colour = year)) +
  geom_line() +
  facet_wrap(. ~ name) + 
  theme_bw()
