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
