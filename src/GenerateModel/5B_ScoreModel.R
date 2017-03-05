# Scoring module


library (stringr)
library (hash)
library (tm)


source ("libs\\common.R")
source ("libs\\generateSuggest.R")


getSuggestions <- generateSuggester(cleanPhrase = FALSE, capitalizeWords = FALSE)

scorePhrase <- function (phrase, nextWord)
{
  prediction <- getSuggestions (phrase)
  
  simpleScore <- 0.0
  complexScore <- 0.0
  
  if (nextWord == prediction [1])
  {
    simpleScore <- 1.0
    complexScore <- 1.0
    }
  else
  {
    if (nextWord == prediction [2])
    {
      complexScore <- 0.75
    }
    else
    {
      if (nextWord == prediction [3])
      {
        complexScore <- 0.5
      }
      else
      {
        if (nextWord == prediction [4])
        {
          complexScore <- 0.25
        }
      }
    }
    
  }
  return (c (simpleScore,complexScore))
}


scoreTestFile <- function (base, sampleRate, N, useStopWordRemoval = FALSE, debug = FALSE)
{

  fileName <- getGramFileName (base, sampleRate, N, stopWordRemoval = useStopWordRemoval)
  
  testData <- readPhraseCollection (fileName)

  decomposedPhrase <- sapply (testData$Phrase, splitPhrase)

  left <- as.character(decomposedPhrase[1,])

  right <- as.character (decomposedPhrase [2,])


  simpleScore <- vector (mode = "numeric", length (left))
  complexScore <- vector (mode = "numeric", length (left))
  
  
  for (i in 1: length (left))
  {
    scores <- scorePhrase (left[i], right[i])
    simpleScore [i] <- scores[1]
    complexScore [i] <- scores [2]
    
  }

  if (debug == TRUE)
  {
    testDF <- data.frame (Phrase = testData$Phrase, Occurrences = testData$Occurrences, 
                      simpleScore = simpleScore, complexScore = complexScore)
    write.csv(testDF, 
             file = paste ("debug\\Score.",N-1,".csv", sep  = ""),
             row.names = FALSE)
  }

  weightedSimpleScore = testData$Occurrences * simpleScore 
  overallSimpleScore <- sum(weightedSimpleScore) / sum (testData$Occurrences)

  weightedComplexScore = testData$Occurrences * complexScore 
  overallComplexScore <- sum(weightedComplexScore) / sum (testData$Occurrences)
  
  
  return (c(overallSimpleScore, overallComplexScore))


  }


scoreModel <- function(baseName, sampleRate, verbose = FALSE, useStopWordRemoval = FALSE)
{

  scores <- data.frame (phraseLength = c ("1", "2", "3", "Average"), FirstWordAccuracy  = rep (0.0,4), OverallAccuracy = rep (0.0,4))
  

  for (i in 1:3)
  {
    if (verbose)
      print (paste("Making predictions for phrases of length",i))
  
    s <- scoreTestFile (baseName, sampleRate, i+1, debug = TRUE, useStopWordRemoval = useStopWordRemoval)

    
    scores$FirstWordAccuracy[i] = s[1]
    scores$OverallAccuracy[i] = s[2]
    
      
  }
  
  # no easy way to append to a data frame
  # pretty messy solution
  
  scores$FirstWordAccuracy[4] <- sum (scores$FirstWordAccuracy) /3
  scores$OverallAccuracy[4] <- sum (scores$OverallAccuracy) /3
  
  meanOverallAccuracy <- mean (scores$OverallAccuracy)
  
  
  return (scores)
  
}


