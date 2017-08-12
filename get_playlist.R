rm(list = ls())
setwd("~/Dropbox/My_Projects/SomaFM_to_Spotify/")
library(rtweet)
library(Rspotify)
library(ROAuth)

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

# Spotify access token:
# POST query to create playlist: https://developer.spotify.com/web-api/create-playlist/
# Note: Need to authorize 'playlist-modify' in scope!
Spotify_token = oauth2.0_token(oauth_endpoint(authorize = "https://accounts.spotify.com/authorize", 
                                              access = "https://accounts.spotify.com/api/token"), 
                               oauth_app(appname = "rspotify_token", 
                                         key = "f885778620984715aaa0eaf0ea6fbfec",
                                         secret = "995d5968e40b4686a3ffcaf4111a5dd1"),
                               scope = 'playlist-read-private playlist-read-collaborative playlist-modify-public playlist-modify-private')

# Create playlist if not exist: e.g. "Left Coast 70s by SomaFM"
user_id <- "zeroyin"
playlist_name <- "Left Coast 70s by SomaFM"

req <- POST(url = paste0("https://api.spotify.com/v1/users/",user_id,"/playlists"), 
     config = add_headers(Authorization= paste('Bearer',Spotify_token$credentials$access_token), 'Content-Type' = "application/json"), 
     body=list(name=playlist_name),
     encode='json')

json1 <- httr::content(req)




