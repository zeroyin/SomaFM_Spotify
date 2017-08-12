rm(list = ls())
setwd("~/Dropbox/My_Projects/SomaFM_to_Spotify/")
library(rtweet)

# Create Twitter access token
twitter_token <- create_token(app = "rtweet_token",
                              consumer_key = "52ENnZ26VFEOUJHf3IM6yx0gw",
                              consumer_secret = "StIWKUPPz2VieGgmrrzWEXStIlpxMrtozYlyvvNkjRmqM84iQl")

# Retrieve from Twitter user timeline
rt <- get_timeline(user = "LeftCoast70s", n = 100, token = twitter_token)

# Extract the list of artists/songs
tlist <- gsub(x = rt$text, pattern = '♬ *(.*?) ♬.*', replacement = "\\1") 
tlist.artist <- sub(x=tlist, pattern = '(.*?) - .*', replacement = "\\1")
tlist.song  <- sub(x=tlist, pattern = '.* - (.*?)', replacement = "\\1")

