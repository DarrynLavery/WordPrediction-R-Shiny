# Script to create NGrams from a text file
# Features
#   - Read the document into a corpus
#   - Clean the documents
#   - Build word list and ngrams of various lengths
#


library (RWeka)
library (tm)

source ("libs\\common.R")

# Wrap up code to read text file into a vector of strings

readFile <- function (fileName)
{
  myConn <- file(fileName, "r") 
  
  myLines <- readLines(myConn, n = - 1)
  
  close (myConn)
  
  return (myLines)  
}

# Read the profanities list.
# Added my own and appended common stems
# Needs work

readProafanities <- function ()
{
  
  words <- readFile ("resources\\profanities.txt")
  
  return (sapply (words,tolower))
  
}


# Given a particular document corpus, build an <n> gram
# and return it

buildNGram <- function (corpus, n)
{
  
  print ("No implementation")
  return (null)
}

#
# Helper functions to clean up the text
# They could be made inline to tm_map but I prefer this for readability 
# and much easier to test if they are separate functions


# Removal of boiler plate text

removeBoilerPlateExample1 <- function (line)
{
  # Implementation does not fill me with a lot of joy
  # Exact match to be done after all cleaning
  # Will not work if there is a small change in the boiler plate text
  # Better implementation may be to search for the start and end tags
  
  
  example1 <-  paste ("is a participant in the amazon services llc and amazon eu associates programmes ",
                      "designed to provide a means for sites to earn advertising fees by advertising ",
                      "and linking to amazoncom amazonca amazoncouk amazonde amazonfr amazonit and ",
                      "amazones certain content that appears on this website comes from amazon ",
                      "services llc andor amazon eu this content is provided as is and is subject ",
                      "to change or removal at any time",
                      sep = "")
  
  return (gsub (example1, "", line))
}


# Removal of HTML tags
#
# Better would be to look for a sequence of word = " "
#

removeHTMLTags <- function (line)
{
  
  pattern1 <- "class=(.*)\""
  pattern2 <- "style=(.*)\""
  
  s1 <- gsub (pattern1, " ", line)
  s2 <- gsub (pattern2, " ", s1)
  
  return (s2)  
}

# Removal of non ASCII characters
#    http://stackoverflow.com/questions/9934856/removing-non-ascii-characters-from-data-files


removeNonAsciiCharacters <- function (line)
{
  return (iconv(line, "latin1", "ASCII", sub=""))
}


# Clean the documents up
# Intentionally do not perf stemmng

generateCleaner <- function (removeStopWords = FALSE)
{

  
  return (
      function (docSet)
    {
  
      profanities <- readProafanities()
  
      docSet <- tm_map (docSet, PlainTextDocument) 
  
      docSet <- tm_map (docSet, content_transformer(tolower)) # move to lower case
  
      docSet <- tm_map (docSet, content_transformer (removeNonAsciiCharacters)) # Despite being in plain text there is still junk
  
      docSet <- tm_map (docSet, content_transformer (removeHTMLTags))  
  
      if (removeStopWords)
      {
          docSet <- tm_map (docSet, removeWords, stopwords('english'))
      }
    
      docSet <- tm_map (docSet, removeNumbers)
      docSet <- tm_map (docSet, removePunctuation)
 
    docSet <- tm_map (docSet, removeWords, profanities)

    # Below needs to go here. Do not move
  
    docSet <- tm_map (docSet, content_transformer (removeBoilerPlateExample1)) # should go here
    
    if (removeStopWords)
    {
      docSet <- tm_map (docSet, removeWords, stopwords('english'))
    }
    
    
    # this must be done last. Found that many of the above leave stray space
  
    docSet <- tm_map (docSet, stripWhitespace)
  
    return (docSet)
      }
  )
  
}


writePhraseCollection <- function (collection, fileName)
{
  collection <- sort (collection, decreasing = TRUE)

  df <- data.frame (Rank = 1:length (collection), Phrase = names (collection), Occurrences = collection)
  

  # code to add statistics commented out
  
  # df$OccurrencesPercentage <- df$Occurrences / sum (df$Occurrences)
  
  # numberOfRows <-nrow (df)
    
  # cummulativeOccurrences <- vector (mode = "integer", length = numberOfRows )
    
  # cummulativeOccurrences[1] <- collection[1]
    
  #  for (i in 2: numberOfRows)
  # {
    
  # cummulativeOccurrences [i] <- cummulativeOccurrences[i-1] + collection[i]
  
  #}
  
  # df$CummulativeOccurrences <- cummulativeOccurrences
      
  # df$CummulativePercentage <- df$CummulativeOccurrences / sum (df$Occurrences)
      
  write.csv (df, fileName, row.names = FALSE)
  
}

createNGrams <- function (fileName, removeStopWords = FALSE, verbose = FALSE)
{
  if (verbose)
    print (paste ("Creating NGrams for: ", fileName, " @ ", Sys.time(), sep = ""))

  if (removeStopWords == FALSE)
  {
    directoryName <- "NGram"
    
    documentCleaner <-generateCleaner()
  }
  else
  {
    directoryName <- "NGramWithoutStop"
    documentCleaner <-generateCleaner(removeStopWords =  TRUE)
  }
  
  base <- gsub ("samples", directoryName, fileName)

  NGrams5FileName <- gsub ("\\.txt", ".NGram5.txt", base)
  
  NGrams4FileName <- gsub ("\\.txt", ".NGram4.txt", base)
  NGrams3FileName <- gsub ("\\.txt", ".NGram3.txt", base)
  NGrams2FileName <- gsub ("\\.txt", ".NGram2.txt", base)
  NGrams1FileName <- gsub ("\\.txt", ".NGram1.txt", base)
  WordsFileName <- gsub ("\\.txt", ".words.txt", base)
  WordsWithOutStopsFileName <- gsub ("\\.txt", ".wordsWithoutStop.txt", base)
  
  if (verbose)
      print ("Deleting old NGram files")
  
  unlink (NGrams5FileName)
  unlink (NGrams4FileName)
  unlink (NGrams3FileName)
  unlink (NGrams2FileName)
  unlink (NGrams1FileName)
  unlink (WordsFileName)
  unlink (WordsWithOutStopsFileName)

  if (verbose)
    print ("Loading file")

  linesRead <- readFile (fileName)
  
  if (verbose)
  {
    print (paste ("Lines read: ",length (linesRead), sep = ""))
    print (paste ("Creating document corpus @ ", Sys.time(), sep = "" ))
  }
  
  myCorpus <- Corpus (VectorSource(linesRead))
  rm (linesRead)
 
  if (verbose)
    print (paste ("Cleaning document corpus @ ", Sys.time(), sep = ""))
         
  myCorpus <- documentCleaner (myCorpus)
  
  if (verbose)
  {
    print (paste ("Creating term document matrix @ ", Sys.time(), sep = ""))
    print (paste ("Creating word list @ ", Sys.time(), sep = ""))
  }
  
  # Default is (3,Inf)       
  
  tdm <- TermDocumentMatrix(myCorpus, control = list( wordLengths = c (1,Inf)))
  
  
  # As per earlier comment running a report off a matrix did not scale 
  # Instead using slam
  # Rather than cast to a matrix which will not work due to data volume, use slam
  # http://stackoverflow.com/questions/21921422/row-sum-for-large-term-document-matrix-simple-triplet-matrix-tm-package  

  words <- slam::row_sums(tdm, na.rm = TRUE)
  words <- sort (words, decreasing = TRUE)
  writePhraseCollection (words, NGrams1FileName)
  rm (words, NGrams1FileName, tdm)
  gc()


  if (verbose)
    print (paste ("Creating 4 gram @ ", Sys.time(), sep = ""))
  
  ngrams4 <- buildNGram (myCorpus,4)
  writePhraseCollection (ngrams4, NGrams4FileName)
  rm (ngrams4,NGrams4FileName )
  gc()
  
  if (verbose)
    print (paste ("Creating 3 gram @ ", Sys.time(), sep = ""))
  
  ngrams3 <- buildNGram (myCorpus,3)
  writePhraseCollection (ngrams3, NGrams3FileName)
  rm (ngrams3,NGrams3FileName )
  gc()
  
  if (verbose)
    print (paste ("Creating 2 gram @ ", Sys.time(), sep = ""))
  
  ngrams2 <- buildNGram (myCorpus,2)
  writePhraseCollection (ngrams2, NGrams2FileName)
  rm (ngrams2,NGrams2FileName )
  
}


