

getFileLength <- function (fileName)
{
  

  myConn <- file(fileName, "r") 
  
  linesRead <- readLines(myConn, n = - 1, warn = TRUE, ok = TRUE, skipNul = TRUE)

  close (myConn)

  return (length (linesRead))
}

checkFileLengths <- function()
{

  if (getFileLength("2A_createNGram.R") != 316)
    print ("2A_createNGram.R is not complete");
  
  if (getFileLength("libs\\generateSuggest.R") != 200)
    print ("libs\\generateSuggest.R is not complete");
  
  
}


checkFiles <- function()
{

  
  files <- c ("resources\\profanities.txt", "data\\raw\\en_US.blogs.txt", "data\\raw\\en_US.news.txt", "data\\raw\\en_US.twitter.txt")
  
  for (f in files)
  {
    
    if (!file.exists(f))
    {
      print (paste ("Unable to locate file: ", f), sep = "")
    }  
  }
  
}

checkDirectories <- function (dirName)
{
  dirs <-c ("data\\NGram", "data\\samples", "data\\NGramWithoutStop","data\\NGram.Decomposed", "data\\raw", "debug")
  
  for (d in dirs)
  {
     
    if (!file.exists(d))
    {
      print (paste ("Unable to locate directory: ", d), sep = "")
    }  
  }
  
}

checkLibraries <- function()
{
  
  installed <- installed.packages();
  
  libraries <- c ("tm", "hash", "stringr", "dplyr", "RWeka", "reshape")
                  
  for (l in libraries)
    if (l %in% installed == FALSE)
      print (paste ("Library not installed: ", l, sep = ""))

}


checkDependencies <- function()
{

  # TODO: display a message if there were no errors
    
  checkLibraries();
  checkFiles();
  checkDirectories();
  checkFileLengths();
  
}

checkDependencies()
