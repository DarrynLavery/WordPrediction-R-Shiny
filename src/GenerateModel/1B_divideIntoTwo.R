# Script to split a file into training and test

source ("libs\\common.R")


set.seed (200)

divideIntoTwo <- function (fileName, filename1, filename2, verbose = FALSE)
{
  
  unlink (filename1)
  unlink (filename2)
  
  # Read everything into memory
  myConn <- file(fileName, "r") 

  # use skipNul to help read bad lines in twitter file
  # did not help news

  linesRead <- readLines(myConn, n = - 1, warn = TRUE, ok = TRUE, skipNul = TRUE)
  if (verbose)
  {
    print (paste ("Dividing file into two: ", fileName, sep =""))
    print (paste ("Lines read: ", length (linesRead), sep =""))
  }
  
  close (myConn)
  
  # Create the test and training files

  conn1 <- file (filename1, "w")
  conn2 <- file (filename2, "w")

  inOutput1 <- 0
  inOutput2 <-0

  for (i in 1:length (linesRead))
  {
    if (rbinom (1,1, 0.5) == 0)
    {
      writeLines (con = conn1, linesRead[i])
      inOutput1 <- inOutput1 + 1
    }
    else
    {
      writeLines (con = conn2, linesRead[i])
      inOutput2 <- inOutput2 + 1
      
    }
  }
  if (verbose)
  {
    print (paste ("Lines in file 1: ", inOutput1, sep =""))
    print (paste ("Lines in file 2: ", inOutput2, sep =""))
  }
  
  # close the files  
  close (conn1)
  close (conn2)

}


                
                