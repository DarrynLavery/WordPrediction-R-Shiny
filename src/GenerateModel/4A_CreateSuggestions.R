# Simple model variant B
# Difference is on how thresholding is achieved

library (hash)
library (reshape)
library (dplyr)
library (stringr)

source ("libs\\common.R")

# Function to load in a file

# Load in a sample piece of data

createSuggestionsFromNGram <- function (baseName, sampleRate, NGram, 
                                        threshold = TRUE,
                                        thresholdAmount = 10,
                                        removeInCompleteSuggestions = TRUE,
                                        useStopWordRemoval = FALSE,
                                        debug = FALSE, verbose= FALSE)
{
  
  fileName <- getAnalyzedNGramStemName (baseName, sampleRate, NGram, "decomposed", useStopWordRemoval = useStopWordRemoval)

  decomposed <- read.csv (fileName)
  
  if (threshold == TRUE)
  {
    decomposed <- decomposed [decomposed$LeftOccurrences >= thresholdAmount,]
  }
  
  decomposed <- decomposed [,-c (1,3)]
  
  # Assumes the data is already sorted
  
  suggestionsDF <- decomposed %>%  group_by (Left) %>% filter(row_number() <= 4) %>%  mutate (id = seq_len (n()))
  suggestionsDF$Rank <- paste ("Rank", suggestionsDF$id, sep = "")
  suggestionsDF <- suggestionsDF[, c (1,2,5)]
  
  names (suggestionsDF) <- c("Phrase", "Suggestion", "Rank")
  suggestions <- cast(suggestionsDF, formula = Phrase ~ Rank, value="Suggestion", add.missing = TRUE)
  
  suggestions$Rank1 <- as.character (suggestions$Rank1)
  suggestions$Rank2 <- as.character (suggestions$Rank2)
  suggestions$Rank3 <- as.character (suggestions$Rank3)
  suggestions$Rank4 <- as.character (suggestions$Rank4)
  
  if (debug)
  {   
    debugFileName <- paste ("debug\\", NGram, ".suggestions.raw.csv", sep = "" )
    
    write.csv (suggestions, debugFileName, row.names = FALSE)
  }
  
  if (removeInCompleteSuggestions)
  {   
    suggestions <-suggestions [complete.cases(suggestions),]
  }
  else
  {
    suggestions [is.na (suggestions) ] <- "{{{NA}}"
  }
  
  if (debug)
  {
    debugFileName <- paste ("debug\\", NGram, "suggestions.cleaned.csv", sep = "" )
    
    write.csv (suggestions, debugFileName, row.names = FALSE)
  }
  
  return (suggestions)
  
}
  

hashSuggestions <- function (myHash, collection)
{
  
  numberOfEntries <- nrow (collection)
  
  for (i in 1: nrow (collection))
  {
    .set (myHash, collection$Phrase [i], i)
  }
  
  df <- data.frame (PhraseIndex = 1: numberOfEntries,
                    suggestion1 = collection$Rank1,
                    suggestion2 = collection$Rank2,
                    suggestion3 = collection$Rank3,
                    suggestion4 = collection$Rank4)
  
  return (df)
  
}


createSuggestions <- function (baseName, sampleRate, modelName, debug = FALSE, 
                               removeInCompleteSuggestions = TRUE, 
                               verbose = FALSE, threshold = TRUE, thresholdAmount = 10)
{
  indexList <- list()

  suggestionList <- list()
  removeStopWords <- FALSE

  for (i in 1:3)
  {
    hash <- hash()
  
    
    if (verbose)
      print (paste("Creating suggestions based on ngram #", i + 1, " @ ", Sys.time(), sep= ""))

    suggestions <- createSuggestionsFromNGram  (
                            baseName, 
                            sampleRate,
                            i+1, 
                            removeInCompleteSuggestions = removeInCompleteSuggestions, 
                            threshold = threshold,
                            thresholdAmount = thresholdAmount,
                            useStopWordRemoval = removeStopWords,
                            debug = debug, 
                            verbose = verbose)
    
    if (verbose)
      print (paste ("Hashing the suggestions @ ", Sys.time(), sep = ""))
  
    hashedSuggestions <- hashSuggestions (hash, suggestions)
  
    indexList <- append (indexList, hash)
  
    suggestionList[[i]] <- hashedSuggestions
    
    if (verbose)
      print (paste("Completed creating suggestions based on ngram #", i + 1, "@ ", Sys.time(), sep= ""))
    
  }
  
  if (verbose)
    print (paste ("Saving the index file @ ", Sys.time(), sep = ""))
  
  save (indexList, suggestionList, file = paste ("Suggestions\\", modelName, sep = ""))
  
}

