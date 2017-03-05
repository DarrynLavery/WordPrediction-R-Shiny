# Test UI


library (tm)
library (hash)
library (stringr)

load ("Suggestions\\Model")

source ("libs\\generateSuggest.R")

getSuggestions <- generateSuggester(cleanPhrase = TRUE, capitalizeWords = FALSE)
getSuggestions ("out of the")
getSuggestions ("the")
getSuggestions ("jJKjkjfdkfjdkfjskd the") # should fallback to "the"
