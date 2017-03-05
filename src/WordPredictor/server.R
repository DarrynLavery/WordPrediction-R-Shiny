# server.R


library (tm)
library (hash)
library (stringr)

load ("Model")

source ("generateSuggest.R", local = TRUE)

getSuggestions <- generateSuggester (capitalizeWords = TRUE, cleanPhrase = TRUE)

requireSpacePadding <- function (s)
{
  
  if (nchar (s) == 0)
  {
    return (FALSE)
  }
  
  if (substr (s, nchar(s), nchar(s)) != " ")
  {
    return (TRUE)
  }
  
  return (FALSE)
}

word1 <- ""
word2 <- ""
word3 <- ""
word4 <- ""

textInput <- ""

lastRun <- NULL

makeWord <- function (text, i)
{
  return (paste (text,".",i,sep="" ))
  
}

refreshWordSuggestions <- function()
{
  suggestions <- getSuggestions (textInput)
  
  word1 <<- suggestions[1]
  word2 <<- suggestions[2]
  word3 <<- suggestions[3]
  word4 <<- suggestions[4]
 
}

refreshWordSuggestions()

shinyServer(
  function(input, output, session) {

    insertWordIntoInput <- function (text)
    {
      if (requireSpacePadding (textInput))
      {
        separator <- " "
      }
      else
      {
        separator <- ""
      }
      
      newText <- paste (input$textInput, text, sep = separator)
      refreshTextInput (newText)
    }
    
    
    refreshButtons <- function()
    {
      
      output$button1 <- renderUI({
        actionButton("word1", label = word1)})
      
      output$button2 <- renderUI({
        actionButton("word2", label = word2)})
      
      output$button3 <- renderUI({
        actionButton("word3", label = word3)})
      
      output$button4 <- renderUI({
        actionButton("word4", label = word4)})
      
    }
    
    
    refreshTextInput <- function(text)
    {
      output$textInputControl <- 
      renderUI ({textInput('textInput', "Text input:", value = text)})
    }
    
    refreshButtons()
    refreshTextInput("")
    
    observeEvent(input$word1, { insertWordIntoInput (word1) })
    observeEvent(input$word2, { insertWordIntoInput (word2) })
    observeEvent(input$word3, { insertWordIntoInput (word3) })
    observeEvent(input$word4, { insertWordIntoInput (word4) })

    observeEvent( input$textInput, {
      textInput <<- input$textInput
      refreshWordSuggestions()
      refreshButtons()
      })
  
})
