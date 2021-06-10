# Created 20210127 by Diego Alburez-Gutierrez

# 0. Some useful functions ---------------

library(tidyverse)

# SOCSIM ==============

asYr_hmd <-function(x,lastmo=endmo,FinalSimYear){
  ## convert sim month to a real calendar year
  ## handy for graphing mainly.
  ## requires that FinalSimYear be set in the GlobalEnv
  # stopifnot("FinalSimYear" %in% objects())
  yr<-ifelse(x==lastmo,FinalSimYear,
             FinalSimYear - trunc((lastmo -x )/12))
  return(yr)
}

read_sweden_socsim <- function(path){
  # Read Swedish simulation with 
  # historical reates as input.
  # This is the socsim simulation 
  # created by emilio and that I am
  # repurposing here
  
  opop <- read.table(file=path,header=F,as.is=T)  
  
  ## assign names to columns
  names(opop)<-c("pid","fem","group",
                 "nev","dob","mom","pop","nesibm","nesibp",
                 "lborn","marid","mstat","dod","fmult")
  
  FinalSimYear<-2160  ## check .sup file and give this careful consideration
  #endmo<-7741 ##6541  #5307  ## last month of simulation See Socsim
  ##output
  endmo<-max(opop$dob)+1
  EndYr<-endmo:(endmo-11)
  
  ##Include year of birth and year of death into the pop file
  opop$birth_year <- asYr_hmd(opop$dob,endmo,FinalSimYear)
  opop$death_year <- asYr_hmd(opop$dod,endmo,FinalSimYear)
  
  return(opop)
}

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