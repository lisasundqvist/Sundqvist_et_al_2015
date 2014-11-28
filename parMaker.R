# define a function to format output files
# set default parameter to replicate above file
parMaker <- function(outfile = "test", npops = 2, 
                        popSizes = 1000, 
                        sampSizes = 5, 
                        popGrowth = 0,
                        numMigMat = 1, 
                        migMat = matrix(c(0, 0.0005, 0, 0), nrow = 2,
                                        ncol = 2, byrow = TRUE),
                        numHistEvents = 0,
                        histEvents = NULL,
                        numIndependentChromo = c(1, 0), 
                        numLinkBlocks = 1,
                        lociData = list(locType = "MICROSAT",
                                        numLoc = 10,
                                        recombRate = 0.0,
                                        mu = 0.0005,
                                        addPar = 0)){
  # argument descriptions
  #######################
  #
  ## outfile is a character string which will be suffixed with .par
  #
  ## npops is an integer specifiying the number of populations
  #
  ## popSizes can be an integer or a numeric vector of length npops. If a 
  #  single integer is given and npops < 1, popSizes with be replicated
  #  by npops, thus all populations with be of equal size.
  #
  ## sampSizes can be an integer or a numeric vector of length npops. If
  #  a single integer is given
  
  
  
  # carry out some checks
  # does popSizes have n = npops elements
  if(npops != 1L && length(popSizes) == 1L){
    popSizes <- rep(popSizes, npops)
  }
  # collapse popSizes to write each element on a new line
  popSizes <- paste(popSizes, collapse = "\n")
  # does sampSizes have n = npops elements
  if(npops != 1L && length(sampSizes) == 1L){
    sampSizes <- rep(sampSizes, npops)
  }
  # collapse sampSizes to write each element on a new line
  sampSizes <- paste(sampSizes, collapse = "\n")
  # does popGrowth have n = npops elements
  if(npops != 1L && length(popGrowth) == 1L){
    popGrowth <- rep(popGrowth, npops)
  }
  # collapse popGrowth to write each element on a new line
  popGrowth <- paste(popGrowth, collapse = "\n")
  # Check that migration matrices have the correct dimentions
  if(is.list(migMat)){
    if(length(migMat) != numMigMat){
      stop(paste("You must provide ", numMigMat, " migration matrices", 
                 sep = ""))
    }
    for(i in 1:length(migMat)){
      if(!all(dim(migMat[[i]]) == rep(npops, 2))){
        stop("Migration matrix of the wrong dimensions used!")
      }
    }
  } else if(is.matrix(migMat) && !all(dim(migMat) == rep(npops, 2))){
    stop("Migration matrix of the wrong dimensions used!")
  }
  if(is.list(migMat)){
    spcr <- rep("//migration matrix \n", length(migMat) - 1)
    unlistMat <- lapply(migMat, function(x){
      x <- format(x, scientific = FALSE)
      out <- apply(x, 1, paste, collapse = " ")
      return(paste(out, collapse = "\n"))
    })
    adSpcr <- lapply(2:length(unlistMat), function(i){
      comb <- paste(spcr[(i-1)], unlistMat[[i]], sep = "")
      return(comb)
    })
    migMat <- paste(c(unlistMat[[1]], "\n", unlist(adSpcr)), collapse = "")
  } else{
    migMat <- format(migMat, scientific = FALSE)
    migMat <- paste(apply(migMat, 1, paste, collapse = " "), collapse = "\n")
  }
  # check historical event fits number of events
  if(is.list(histEvents)){
    if(numHistEvents > 0L && is.null(histEvents) && length(histEvents) != numHistEvents){
      stop(paste("You nust provide ", numHistEvents, 
                 " historical events!", sep = ""))
    } else if(numHistEvents > 0L && numHistEvents == length(histEvents)){
      nhs <- lapply(histEvents, paste, collapse = " ")
      prehistEvents <- c(paste(numHistEvents, " historical event", sep = ""),
                         unlist(nhs))
      histEvents <- paste(prehistEvents, collapse = "\n")
    }
  } else if(is.vector(histEvents) && numHistEvents == 1L){
    histEvents <- paste(c(paste(1, " historical event", sep = ""),
                          paste(histEvents, collapse = " ")), collapse = "\n")
  } else if(numHistEvents == 0){
    histEvents <- paste(numHistEvents, " historical event")
  }
  # format number of independent loci
  numIndependentChromo <- paste(numIndependentChromo, collapse = " ")
  # check the number of loci matches linkage blocks
  if(numLinkBlocks != length(lociData[[1]])){
    stop(paste(numLinkBlocks,
               " pieces of linkage block information per lociData\n",
               "element expected!", sep = ""))
  } else {
    dat <- lapply(1:length(lociData[[1]]), function(i){
      sapply(lociData, "[[", i)
    })
    dat <- lapply(dat, function(x){
      out <- sapply(x, function(y){
        if(is.character(type.convert(y, as.is = TRUE))){
          return(y)
        } else {
          return(format(as.numeric(y), scientific = FALSE))
        }
      })
    })
    dat <- lapply(dat, paste, collapse = " ")
    lociData <- paste(unlist(dat), collapse = "\n")
  }
  
  # paste the arguments to the standard parameter comments
  of <- c("//Number of population samples (demes)",
          paste(npops,  " samples to simulate :", sep = ""),
          "//Population effective sizes (number of genes)",
          popSizes,
          "//Samples sizes",
          sampSizes,
          "//Growth rates  : negative growth implies population expansion",
          popGrowth,
          "//Number of migration matrices : 0 implies no migration between demes",
          numMigMat,
          "//migration matrix",
          migMat,
          "//historical event: time, source, sink, migrants, new size, new growth rate, migr. matrix ",
          histEvents,
          "//Number of independent loci [chromosome] ",
          numIndependentChromo,
          "//Per chromosome: Number of linkage blocks",
          numLinkBlocks,
          "//per Block: data type, num loci, rec. rate and mut rate + optional parameters",
          lociData)
  # write the file
  fl <- file(paste(outfile, ".par", sep = ""), "w")
  for(i in 1:length(of)){
    cat(of[i], file = fl, "\n", sep = "")
  }
  close(fl)
}