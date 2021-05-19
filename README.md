## Toy example of the output of a SOCSIM microsimulation. 


The output population file `Data\sweden_small.opop` comes from a SOCSIM simulation using historical and projected demographic data for Sweden (1751-2100) as input.
Input age-specific mortality rates (starting from 1751) come from the Human Mortality Database and fertility rates (starting from 1891) come from the Human Fertility Database. 
In all simulations, we assumed demographic stability for fertility in the 1751-1891 period.
We combined these data with official demographic projections of fertility and mortality provided by Statistics Sweden.
The simulations were implemented using the SOCSIM microsimulator and are an adaptation of an initial simulation prepared by Emilio Zagheni. 


The main difference between `sweden_small.opop` and `sweden_big.opop` (not pushed to git given that size = 250MB) is the size of the initial (and final) populations. The small file, starts with a population of 1,200 in years 0, and the big file with 8,000 initial individuals. 

## Reading in the data

I wrote a function that imports the socsim output into a standard format in R. Note that the parameters `FinalSimYear` and `EndYr` are pre-defined for this example, but should be defined carefully for other simulations depending on the specifications of the .sup file.

Diego Alburez, 20210519

MPIDR