
removeHTMLTags <- function (line)
{
  
  pattern1 <- "class=(.*)\""
  pattern2 <- "style=(.*)\""
  
  s1 <- gsub (pattern1, " ", line)
  s2 <- gsub (pattern2, " ", s1)
  
  return (s2)  
}

removeNonAsciiCharacters <- function (line)
{
  return (iconv(line, "latin1", "ASCII", sub=""))
}


# Text to clean the input text

cleanDocumentCorpus <- function (docSet)
{
  
  docSet <- tm_map (docSet, PlainTextDocument) # paranaoi in case not in plain text
  
  docSet <- tm_map (docSet, content_transformer(tolower)) # move to lower case
  
  docSet <- tm_map (docSet, content_transformer (removeNonAsciiCharacters)) # Despite being in plain text there is still junk
  
  docSet <- tm_map (docSet, content_transformer (removeHTMLTags))  
  
  docSet <- tm_map (docSet, removeNumbers)
  
  docSet <- tm_map (docSet, removePunctuation)

  docSet <- tm_map (docSet, stripWhitespace)
  
  return (docSet)
  
}

# Not the cleanest way

cleanPhrase <- function (s)
{
  
  if (s == "" || is.null(s))
  {
    
    return ("")
  }
  else
  {
    myCorpus <- Corpus (VectorSource(c(s)))
    
    myCorpus <- cleanDocumentCorpus (myCorpus)
    
    return (as.character(myCorpus [[1]]))
  }
  
}

# Function to return a function to suggest next words for a supplied phrase
# cleanPhrase is used by the web to take any white space, punctuation etc
# capitalizewords used by UI to capitalize the suggestions if needed

generateSuggester <- function (cleanPhrase = FALSE, capitalizeWords = FALSE)
{
  print ("No implementation")
  return (null)  
}


