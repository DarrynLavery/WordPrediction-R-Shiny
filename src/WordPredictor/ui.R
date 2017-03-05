# ui.R

shinyUI (

  pageWithSidebar (
    headerPanel ("Word Predictor"),
    sidebarPanel ( 
      width = 11,
      p (
        paste ("This applications analyzes the text you type in ",
                "and provides suggestions for the next word.", 
               sep ="")),
        p (
          paste ("Enter your text below. As you type, the sytem will suggest 4 possible next words. ",
                "Click on one of them to add to your text!",
                 sep ="")),
      p ("This should not be appearing as part of an online MOOC submission!"),
          
      uiOutput ("textInputControl"),

      helpText ("Suggestions for your your text input. Click one to add to the text above!"),
      uiOutput("button1", inline = TRUE),
      uiOutput("button2", inline = TRUE),
      uiOutput("button3", inline = TRUE),
      uiOutput("button4", inline = TRUE)

    ),
    mainPanel (   )))
