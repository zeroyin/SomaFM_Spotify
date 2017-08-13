# Get playlist from Left Coast 70s twitter history
################################################
rm(list = ls())
setwd("~/Dropbox/My_Projects/SomaFM_to_Spotify/")
library(rtweet)

# Create Twitter access token
consumer_key = "52ENnZ26VFEOUJHf3IM6yx0gw"
consumer_secret = "StIWKUPPz2VieGgmrrzWEXStIlpxMrtozYlyvvNkjRmqM84iQl"
T_token <- create_token(app = "rtweet_token",
                        consumer_key = consumer_key,
                        consumer_secret = consumer_secret)

# Get tweets from user timeline
rt <- get_timeline(user = "LeftCoast70s", n = 10000, token = T_token)

# Parse tweets to get playlist (duplicates are removed)
tlist <- gsub(x = rt$text, pattern = '♬ *(.*?) ♬.*', replacement = "\\1") 
tlist <- unique(tlist)
tlist.artist <- sub(x=tlist, pattern = '(.*?) - .*', replacement = "\\1")
tlist.song  <- sub(x=tlist, pattern = '.* - (.*?)', replacement = "\\1")

# Save playlist as data list
playlist <- list(artist = tlist.artist, song = tlist.song)
save(playlist, file = "playlist.RData")
