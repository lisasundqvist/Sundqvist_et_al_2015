# README

This repository contains all of the necessary information to allow readers to reproduce the simulation analyses carried out in Sundqvist et al. 2015 (link to be added when paper is published).

The following files are included in the repository:

a. __README:__ Describes the repository and its contents

b. __parMaker:__ A custom function for programatically generating .par files for use in fastsimcoal2

c. __simFun:__ A custom wrapper function, which generates .par files (using parMaker), deploys a system command to run fastsimcoal2, read and converts the generated .arp file to a genepop file, and uses this file to calculate directional relative migration using the `divMigrate` function from `diveRsity`.

d.__multiPlot:__ A function that makes it possible to create multiplots.

## Things to do before trying to reproduce the analyses

The simulations used to test the performance of the method are documented in an R notebook available [here](https://rpubs.com/lisasundqvist/SimulationsSundqvist15). The simulation used to demonstrate the use of divMigrate-online is available [here](http://rpubs.com/lisasundqvist/divMigrate-online) The R code in these notebooks are reproducible providing the instructions below have been followed.

1. Install the R distribution for your OS (http://cran.r-project.org/).

2. Download `fastsimcoal2` and make sure the executable is in your current working directory. The latest version is available [here](http://cmpg.unibe.ch/software/fastsimcoal2/)

    NOTE: The commands in the notebook refer to the linux version of fastsimcoal2 (i.e. `fscLoc = "./fastsimcoal21"`). Please make sure to adjust this argument if your version of fastsimcoal differs.

3. Download `parMarker.R`,`simFun.R` and `multiPlot.R`, and make sure they are also saved in the current working directory.

4. In R, the following packages should be installed:
    
    a. `diveRsity` (`install.packages("diveRsity")`)
    
    b. `ggplot2` (`install.packages("ggplot2")`)
    
    c. `reshape` (`install.packages("reshape")`)
    
When these instructions are followed, the code in the notebooks, mentioned above, can be executed. Note that the simulation process can take hours to complete using the parameters specified.
