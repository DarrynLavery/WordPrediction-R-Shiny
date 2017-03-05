# Utilities to merge file
# Used to merge the twitter, blogs and news articles

source ("libs\\common.R")

readFile <- function (fileName)
{
  myConn <- file(fileName, "r") 
  
  myLines <- readLines(myConn, n = - 1, warn = TRUE, ok = TRUE, skipNul = TRUE)
  
  
  close (myConn)
  
  return (myLines)  
}


merge <- function(fileName1, fileName2, fileName3, outputName)
{
  lines1 <- readFile (fileName1)
  lines2 <- readFile (fileName2)
  lines3 <- readFile (fileName3)
  
  outputLines <-c (lines1,lines2,lines3)
  
 
   myConn <- file (outputName, "w")
  
  for (i in 1: length (outputLines))
  {
 
    writeLines (con = myConn, outputLines[i])
  }
  close (myConn)
  
}

  