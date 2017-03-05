
checkFiles <- function()
{

  
  files <- c ("Model", "generateSuggestions.R")
  
  for (f in files)
  {
    
    if (!file.exists(f))
    {
      print (paste ("Unable to locate file: ", f), sep = "")
    }  
  }
  
}

checkLibraries <- function()
{
  
  installed <- installed.packages();
  
  libraries <- c ("hash", "shiny", "stringr", "tm")
                  
  for (l in libraries)
    if (l %in% installed == FALSE)
      print (paste ("Library not installed: ", l, sep = ""))

}


checkDependencies <- function()
{

  # TODO: display a message if there were no errors
    
  checkLibraries();
  checkFiles();
  
  
}
