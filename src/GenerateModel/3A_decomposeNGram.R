# Generates an output files in Data\NGram.decomposed
# Minimal documentation sorry.
#
# Decomposed
#   Breaks down an ngram into two phases: the first n-1 words and the nth word
#   Column C - number of times column B (n-1 words) occurs
#   Column E number of times the phrase [column B]+[column D] occurs
#


suppressWarnings (library (hash))
suppressWarnings (library (dplyr))
suppressWarnings (library (stringr))


source ("libs\\common.R")


AnalyzeStartWithEndWith <- function (baseName, sampleRate, N, verbose = FALSE,useStopWordRemoval = FALSE)
{
  
  fileName <- getGramFileName (baseName,sampleRate, N, stopWordRemoval = useStopWordRemoval)
  leftPhrasefileName <- getGramFileName (baseName,sampleRate, N-1, stopWordRemoval = useStopWordRemoval)
  
  if (verbose)
  {
    print (paste("Decomposing NGram ", fileName, " @ ", Sys.time(), sep = ""))
  }
  
  collection <- readPhraseCollection (fileName)
  
  if (verbose)
    print (paste ("Step 1: Decompose the ngram @ ", Sys.time()), sep = "")
  
  decomposedPhrase <- sapply (collection$Phrase, splitPhrase)
  
  left <- as.character(decomposedPhrase[1,])
  right <- as.character (decomposedPhrase [2,])
  leftPhraseCollection <- readPhraseCollection (leftPhrasefileName)
  leftPhraseHash <- hash()
  
  for (i in 1: nrow (leftPhraseCollection))
  {
    .set (leftPhraseHash, leftPhraseCollection$Phrase[i], leftPhraseCollection$Occurrences[i])
  }
  
  
  leftPhraseOccurrence <- generateIterator (leftPhraseHash)
  leftOccurrence <- sapply (left, leftPhraseOccurrence)
  
  
  
  
  # Bug here -- had to remove anything with zero
  
  
  decomposed <- data.frame (Phrase = collection$Phrase,
                            Left = left,
                            LeftOccurrences = leftOccurrence,
                            Right=right,
                         
                            RightOccurrences = collection$Occurrences)
  
  decomposedFileName <- getAnalyzedNGramStemName (baseName, sampleRate, N, "decomposed", useStopWordRemoval = useStopWordRemoval)

  
  # Bug -- found an instance where TM returned a 2-gram during processing of 3 grams
  decomposed <- decomposed[decomposed$LeftOccurrences != 0,]
  
  
  write.csv (decomposed, file = decomposedFileName, row.names = FALSE)
  
  clear (leftPhraseHash)
  gc()
  
  
}


decomposeNGram <- function (base, sample, removeStopWords = FALSE, verbose = FALSE)
{
  
  for (i in 2:4)
  {
    AnalyzeStartWithEndWith (base, sample, i, verbose = verbose, useStopWordRemoval =  removeStopWords)
    
  }
}
