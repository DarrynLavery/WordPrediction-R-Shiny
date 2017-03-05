

set.seed (200)


sampleData <- function (fileName, sampleRatio, verbose = FALSE)
{
  if (verbose)
      print (paste ("Sampling: ", fileName, " @ ", 100 * sampleRatio, "%", sep= ""))
 
  base <-gsub ("raw", "samples", fileName)
  
  sampleName <- gsub ("\\.txt",
                    paste (".",toString (100 * sampleRatio), ".txt",sep=""),
                    base)
  
  holdOutName <- gsub ("\\.txt",
                     paste (".",toString (100 * (1 - sampleRatio) ), ".txt",sep=""),
                     base)
  unlink (sampleName)
  
  unlink (holdOutName)
  
  # Read everything into memory
  myConn <- file(fileName, "r") 
  
  # use skipNul to help read bad lines in twitter file
  # did not help news
  
  linesRead <- readLines(myConn, n = - 1, warn = TRUE, ok = TRUE, skipNul = TRUE)
  
  if (verbose)
    print (paste("Lines read: ", length (linesRead),sep =""))
  
  close (myConn)

  # Create the sample and holdout files

  sampleConn <- file (sampleName, "w")
  holdOutConn <- file (holdOutName, "w")
  
  inSample <- 0
  
  for (i in 1:length (linesRead))
  {
    if (rbinom (1,1, sampleRatio) == 0)
    {
      writeLines (con = holdOutConn, linesRead[i])
      
    }
    else
    {
      writeLines (con = sampleConn, linesRead[i])
      inSample <- inSample+1
    }
  }
  
  if (verbose)
    print (paste ("Lines in sample set: ", inSample, sep =""))

  # close the files  
  close (sampleConn)
  close (holdOutConn)

}


