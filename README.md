# README

This repository contains all of the necessary information to allow readers to reproduce the simulation analyses carried out in Sundqvist et al, 2015.

The following files are included in the repository:

a. __README:__ Describes the repository and its contents

b. __parMaker:__ A custom function for programatically generating .par files for use in fastsimcoal2

c. __simFun:__ A custom wrapper function, which generates .par files (using parMaker), deploys a system command to run fastsimcoal2, read and converts the generated .arp file to a genepop file, and uses this file to calculate directional migration using the `divMigrate` function from `diveRsity`.

## Things to do before trying to reproduce the analyses

The analyses are documented in an R notebook available [here](http://rpubs.com/kkeenan02/SundqvistSim). The R code in this notebook is reproducible providing the instructions below have been followed.

1. Install the R distribution for your OS (http://cran.r-project.org/).

2. Download `fastsimcoal2` and make sure the executable is in your current working directory. The latest version is available [here](http://cmpg.unibe.ch/software/fastsimcoal2/)

NOTE: The commands in the notebook refer to the linux version of fastsimcoal2 (i.e. `fscLoc = "./fastsimcoal21"`). Please make sure to adjust this argument if your version of fastsimcoal differs.

3. Download `parMarker.R` and `simFun.R`, and make sure they are also saved in the current working directory.

4. In R, the following packages should be installed:
    
    a. `diveRsity` (`install.packages("diveRsity")`)
    
    b. `ggplot2` (`install.packages("ggplot2")`)
    
    c. `devtools` (`install.packages("devtools")`)
    
    d. `wesanderson` (`devtools::install_github("karthik/wesanderson")`)


