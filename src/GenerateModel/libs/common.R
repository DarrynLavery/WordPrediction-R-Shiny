# common routines

getAnalyzedNGramStemName <- function (base, sampleRate, NGram, typeOfStem, useStopWordRemoval = FALSE)
{
  
  if (useStopWordRemoval == TRUE)
  {
    gramName <- "NGramWS"
  }
  else 
  {
    gramName <- "NGram"
  }
  
  fileName <- paste (
    "data\\NGram.Decomposed\\",
    base,
    ".",
    sampleRate,
    ".",
    gramName,
    NGram,
    ".",
    typeOfStem,
    ".csv",
    sep = "")
  
  return (fileName)
  
}


getSampleFilename <- function (baseName, sampleSize)
{
  return (paste ("data\\samples\\", baseName, ".", sampleSize, ".txt", sep = ""))
  
}


generateIterator <- function (myHash)
{
  return(  function (s)
  {
    val <- myHash[[s]]
    if (is.null (val))
    {
      print (paste ("Error *", s, "* could not be found in hash. Very rarely NGramTokenizer returns an n-1 length ngram", sep = ""))
      return (0);
    }
    else 
    {
      return (val);
    }
  })
}


getGramStats <- function (source, sampleRate, stopWordRemoval = FALSE)
{
    
  if (stopWordRemoval == TRUE)
  {
    directoryName <- "NGramWithOutStop"
  }
  else
  {
    directoryName <-"NGram"
  }
    
  fileName <- paste (
                  directoryName,
                  "\\EN_US\\en_US.",
                  source, 
                  ".", 
                  sampleRate,
                  ".",
                  "stats",
                  ".txt",
                  sep ="")
    
   return (read.csv (fileName))
    
}


getGramFileName <- function (source, sampleRate, NGram, stopWordRemoval = FALSE)
{
  
  if (stopWordRemoval == TRUE)
  {
    directoryName <- "Data\\NGramWithOutStop\\"
  }
  else
  {
    directoryName <-"Data\\NGram\\"
  }
  
  
  return (
    paste (
      directoryName,
      "en_US.",
     source, 
      ".", 
      sampleRate,
      ".",
      "NGram",
      NGram,
      ".txt",
      sep =""))
  
}


readPhraseCollection <- function (collectionFileName, removeRankColumn = FALSE, minOccurrences = 1)
{
  
  df <- read.csv (collectionFileName, stringsAsFactors = FALSE)
  
  if (minOccurrences > 1)
  {
    df<- subset (df, Occurrences >=minOccurrences)
  }
  
  if (removeRankColumn == TRUE)
  {
    df <- df [-c (1)]
  }
  
  
  
  return (df)
}


splitPhrase <- function (s)
{
  words <- unlist(strsplit (s," "))
  N <- length (words)
  
  # this is the slow part of the code
  # leftStr <- word (s, start = 1, end=N-1, sep = fixed(" "))
  
  leftStr <- words [1]
  if (N > 2)
  {
    for (i in 2:(N-1))
    {
      leftStr <- paste(leftStr, words[i], sep = " ")
    }
  }
  
  return (c(leftStr,words[N]))
}

lastWord <- function (s)
{
  words <- unlist(strsplit (s," "))
  N <- length (words)
  
  return (words[N])
}


