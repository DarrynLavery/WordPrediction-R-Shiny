source ("libs\\common.R")



getOccurrences <- function (collection,name)
{
  x <- collection[collection$Phrase == name, c(2)]
  
  
  return (x[1])
  
}





baseName <- "train"
sampleRate <-1

Gram1 <- readPhraseCollection (getGramFileName (baseName,sampleRate,1), removeRankColum  = TRUE)

Gram4 <- readPhraseCollection (getGramFileName (baseName,sampleRate,4), removeRankColumn = TRUE)
Gram5 <- readPhraseCollection (getGramFileName (baseName,sampleRate,5), removeRankColumn = TRUE)

#How many occurrences are there of "the" (single word)

getOccurrences (Gram1, "the") #48198

#How many occurrences are there of 3-gram "be able to" 

getOccurrences (Gram3, "be able to") #146


gc()

# How many unique 3 grams end with "ability"?

filename <- getAnalyzedNGramStemName (baseName, sampleRate, 3, "EndingWith", useStopWordRemoval = FALSE)


EndingWith3 <- readPhraseCollection (filename)

getOccurrences (EndingWith3, "ability")

gc()

# How many unique 3 grams start with "they are"?

filename <- getAnalyzedNGramStemName (baseName, sampleRate, 3, "StartingWith", useStopWordRemoval = FALSE)

StartingWith3 <- readPhraseCollection (filename)

getOccurrences (StartingWith3, "they are")

gc()


