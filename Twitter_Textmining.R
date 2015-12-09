#created a Twitter application. Go to https: twitter.com/apps/new and log in.
#Authentication
#install packages once
Needed <- c("httr","twitteR","NLP", "tm", "SnowballCC", "RColorBrewer", "ggplot2", "wordcloud", "biclust", "cluster", "igraph", "fpc")   
install.packages(Needed, dependencies=TRUE) 
library(httr)
library(twitteR)
#homeTL = GET("http://api.twitter.com/1.1/atatuses/home_timeline.json", sig)

# retrieve the first 100 tweets (or all tweets if fewer than 100)
# from the user timeline of @rdatammining
setup_twitter_oauth( "tyephr0eO4jlZhw25cDA5bLOY", "BQYy7wK5GMnE3P2iflaV1tmBqOj4jbzY4nydFA1sAD3md6UAny", "4448661506-lm36O4uLeFgik741vHsvJRUCDu0WefWbipgVqV9", "8KSjvDM31q4r0h1iM5OFwNvxOc92CCFLuEYgt6VcYidY4")
#tweets <- searchTwitter('#rstats', n = 50)
rdmTweets <- userTimeline("rdatamining", n=100)
n <- length(rdmTweets)
rdmTweets[1:3]

#  Transforming Text
#The tweets are first converted to a data frame and then to a corpus.
df <- do.call("rbind", lapply(rdmTweets, as.data.frame))
dim(df)
#Combining all the reviews togrther
review_text <- paste(df$text, collapse = " ")

#Setting up sources and corpus, using tm package
library("tm")
review_source <- VectorSource(review_text)
corpus <- Corpus(review_source)

#use tm_map to cleaning text
corpus <- tm_map(corpus, content_transformer(tolower))
corpus <- tm_map(corpus, removePunctuation)
corpus <- tm_map(corpus, stripWhitespace)
corpus <- tm_map(corpus, removeWords, stopwords("english"))

#Making a document_term matrix
dtm <- DocumentTermMatrix(corpus)
dtm2 <- as.matrix(dtm)

# Finding the most frequent terms
frequency <- colSums(dtm2)
frequency <- sort(frequency, decreasing = TRUE)

# Word clouding
library("wordcloud", "RcolorBrewer")
words <- names(frequency)
wordcloud(words[1:100], frequency[1:100], colors=brewer.pal(6, "Dark2"))  



