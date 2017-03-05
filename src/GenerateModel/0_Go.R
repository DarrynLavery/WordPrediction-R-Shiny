

# Step 1: Prepare the data

sampleSize <-1

print (paste ("Creating and testing the model using ", sampleSize, "% of the data", sep = ""))

print ("Step 1: sample the data ")
source ("1A_Sample.R")
sampleData ("data\\raw\\en_US.blogs.txt", (sampleSize * 2)/100);
sampleData ("data\\raw\\en_US.news.txt", (sampleSize * 2)/100);
sampleData ("data\\raw\\en_US.twitter.txt", (sampleSize * 2)/100);

source ("1B_DivideIntoTwo.R")

divideIntoTwo (
  getSampleFilename ("en_US.blogs", 2*sampleSize),
  getSampleFilename ("en_US.blogs.train", sampleSize),
  getSampleFilename ("en_US.blogs.test", sampleSize))

divideIntoTwo (
  getSampleFilename ("en_US.news", 2*sampleSize),
  getSampleFilename ("en_US.news.train", sampleSize),
  getSampleFilename ("en_US.news.test", sampleSize))


divideIntoTwo (
  getSampleFilename ("en_US.twitter", 2*sampleSize),
  getSampleFilename ("en_US.twitter.train",sampleSize),
  getSampleFilename ("en_US.twitter.test", sampleSize))


source ("1C_merge.R")

merge (
  getSampleFilename ("en_US.blogs.train",sampleSize),
  getSampleFilename ("en_US.news.train", sampleSize),
  getSampleFilename ("en_US.twitter.train", sampleSize),
  getSampleFilename ("en_US.train", sampleSize))

merge (
  getSampleFilename ("en_US.blogs.test", sampleSize),
  getSampleFilename ("en_US.news.test", sampleSize),
  getSampleFilename ("en_US.twitter.test", sampleSize),
  getSampleFilename ("en_US.test", sampleSize))


print ("Step 2: Create the N grams")

source ("2A_createNGram.R")

createNGrams (getSampleFilename ("en_US.test", sampleSize), removeStopWords = FALSE, verbose  = FALSE )
createNGrams (getSampleFilename ("en_US.train", sampleSize), removeStopWords = FALSE, verbose  = FALSE )
  

print ("Step 3: Analyze the N grams")

source ("3A_decomposeNGram.R")
decomposeNGram ("train", sampleSize, removeStopWords = FALSE, verbose = FALSE)

# Step 4: "Create the suggestions"

print ("Step 4: Create the suggestions")

source ("4A_CreateSuggestions.R")

createSuggestions ("train", sampleSize, "Model", debug = FALSE, verbose = FALSE, thresholdAmount = 10)

print ("Try a few suggestions...")

# Not the most elegant piece of code
# Load into memory two global variables: indexList and suggestionList.
load ("Suggestions\\Model")

source ("libs\\generateSuggest.R")

getSuggestions <- generateSuggester(cleanPhrase = TRUE, capitalizeWords = FALSE)
getSuggestions ("out of the")
getSuggestions ("the")
getSuggestions ("jJKjkjfdkfjdkfjskd the") # should fallback to "the"


# step 5: Score the model
print ("Step 5: Scoring the model")

source ("5A_CreateTestCases.R")

sampleNGram ("test", sampleSize, 25000, removeStopWords = FALSE)

# Not the most elegant piece of code
# Load into memory two global variables: indexList and suggestionList.

load ("Suggestions\\Model")
source ("5B_ScoreModel.R")

myScores <- scoreModel("test", "S25000", verbose = FALSE)
myScores



