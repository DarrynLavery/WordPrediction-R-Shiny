# Take a set of n-grams and sample N records


source ("libs\\common.R")


set.seed (200)

sampleNGram <- function (baseName, sampleRate, sampleSize, removeStopWords = false  )
{

  for (i in 1:4)
  {
    sourceName <- getGramFileName (baseName, sampleRate, i, stopWordRemoval =  removeStopWords)
    
    destName <- gsub (
              paste ("\\.",sampleRate,"\\.", sep = ""),
              paste (".S", toString(sampleSize), ".", sep = ""),
              sourceName)
  
    df <- read.csv (sourceName, stringsAsFactors = FALSE)
    
    s <-sample (1: nrow (df), sampleSize, replace = FALSE)
    
    df <- df [s,]
    
    write.csv (df,destName, row.names = FALSE)
    
  }

}



