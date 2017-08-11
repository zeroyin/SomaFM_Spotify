rm(list = ls())
setwd("~/Dropbox/My_Projects/SomaFM_to_Spotify/")
library("rtweet")
library("ROAuth")

# Create access token
my_token <- create_token(app = "rtweet_token",
                         consumer_key = "52ENnZ26VFEOUJHf3IM6yx0gw",
                         consumer_secret = "StIWKUPPz2VieGgmrrzWEXStIlpxMrtozYlyvvNkjRmqM84iQl")

# Retrieve from user timeline
rt <- get_timeline(user = "LeftCoast70s", n = 100, token = my_token)
# Form a list of artist/song names
tlist.artist %>% gsub()
tlist.song %>% gsub()


