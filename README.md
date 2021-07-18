## Toy example of the output of a SOCSIM microsimulation. 

Use the script `R/01_run_me.R` directory to (1) run a SOCSIM microsimulation for Sweden an (2) read the output into R. 
The SOCSIM simulation using historical and projected demographic data for Sweden (1751-2100) as input.
Input age-specific mortality rates (starting from year 1751) come from the Human Mortality Database and fertility rates (starting from 1891) come from the Human Fertility Database. 
In all simulations, we assumed demographic stability for fertility in the 1751-1891 period.
We combined these data with official demographic projections of fertility and mortality provided by Statistics Sweden.
The simulations were implemented using the Windows implementation of the SOCSIM microsimulator written by Tom Theiele.
They are an adaptation of an initial simulation prepared by Emilio Zagheni. 


## Reading in the data

I wrote a function that imports the socsim output into a standard format in R. Note that the parameters `FinalSimYear` and `EndYr` are pre-defined for this example, but should be defined carefully for other simulations depending on the specifications of the .sup file.

## Recovering the input mortality and fertility rates

The script `R/02_extract_rates.R` has some basic functions for recovering input fertility and mortality age-specific rates that were used to create the simulation. Extracting these rates and comparing them to the input simulation is considered good practice as it allows us to assess the accuracy of our microsimulation. Note that this is only one of multiple checks that can be performed on the `opop` population files.

Diego Alburez, 20210718

MPIDR