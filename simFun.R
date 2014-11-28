# A wrapper function for simplifying the simulation and analysis of data
# used to validate the directional migration method of Sundqvist et al 2015.

# Kevin Keenan 2014

# Arguments

# fst = divergence between populations
# samp_size =  the size of samples taken at t0
# nloci =  the number of independent microsatellite loci to be simulated
# nsim = the number of simulation replications
# mu = the mutation rate of loci
# pop_size =  the size of the base popultions in the simulation
# outname =  the directory and file prefix name to be used

simFun <- function(fscLoc = "./fastsimcoal21", fst = 0.05, 
                   samp_size = 50, nloci = 50, nsim = 100, 
                   mu = 0.0005, pop_size = 1000, outname = "test",
                   para = TRUE, mig_mod = "uni"){
  
  # calculate migration rate
  mig_rate <- (((1/fst) - 1)/4)/pop_size
  if(mig_mod == "uni"){
    mig_mat <- matrix(c(0, mig_rate, 0, 0), nrow = 2, ncol = 2, byrow = TRUE)
  }
  if(mig_mod == "bi"){
    mig_mat <- matrix(c(0, mig_rate/2, mig_rate/2, 0), nrow = 2, 
                      ncol = 2, byrow = TRUE)
  }
  if(mig_mod == "none"){
    mig_mat <- matrix(0, nrow = 2, ncol = 2)
  }
  # run generate the fastsimcoal parameter file
  if(file.exists(outname)){
    stop(paste(outname, " already exists!"))
  } else {
    source("parMaker.R")
    parMaker(outfile = outname, popSizes = pop_size*2, 
             sampSizes = samp_size*2, numMigMat = 2, 
             migMat = list(mig_mat, matrix(0, nrow = 2, ncol = 2)),
             numHistEvents = 1, histEvents = c(1000, 0, 1, 1, 1, 0, 1),
             numIndependentChromo = c(nloci, 0),
             lociData = list(locType = "MICROSAT",
                             numLoc = 1,
                             recombRate = 0,
                             mu = mu,
                             addPar = 0))
 }
 # run fastsimcoal
 parfl <- paste(outname, ".par", sep = "")
 cmd_line <- paste(fscLoc, " -i ", parfl, " -n ", nsim, " -g", 
                   sep = "")
 system(cmd_line)
 
 # convert arlequin files to genepop
 library(diveRsity)
 arpfl <- list.files(outname, pattern = ".arp", full.names = TRUE,
                     include.dirs = TRUE)
 if(para){
   library(parallel)
   cl <- makeCluster(detectCores())
   conv <- parSapply(cl, arpfl, arp2gen)
 } else {
   conv <- sapply(arpfl, arp2gen)
 }
 # list genepop files
 genfl <- list.files(outname, pattern = ".gen", full.names = TRUE,
                     include.dirs = TRUE)
 # calculation directional migration
 if(para){
   mig <- parLapply(cl, genfl, divMigrate)
   stopCluster(cl)
 } else{
   mig <- lapply(genfl, divMigrate)
 }
 # calculate power
 pwrCalc <- function(x){
   nms <- names(x[[1]])
   sts <- substr(nms, 1, 1)
   out <- lapply(nms, function(y){
     sapply(x, "[[", y, simplify = "array")
   })
   names(out) <- sts
   return(out)
 }
 migDat <- pwrCalc(mig)
 pwr <- sapply(migDat, function(x){
     return(sum(apply(x, 3, function(y){
       y[1,2] < y[2,1]
     })))
  })/nsim
 return(pwr) 
}