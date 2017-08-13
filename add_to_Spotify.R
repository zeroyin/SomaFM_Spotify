# Add tracks to playlist on Spotify
# Reference for queries: https://developer.spotify.com/web-api/
# Based on Rspotify package
# Some self-defined functions to modify playlists
################################################
rm(list = ls())
setwd("~/Dropbox/My_Projects/SomaFM_to_Spotify/")
library(Rspotify)
library(httr)
options(stringsAsFactors = F)

################################################
# Utility functions
################################################
#' Function to create a new playlist
create_playlist <- function(user_id, playlist_name, token){
    endpoint <-  "https://api.spotify.com/v1/users/"
    url <- paste0(endpoint, user_id,"/playlists")
    query <- POST(url = url,
                  config = add_headers(Authorization= paste('Bearer',token), 
                                       'Content-Type' = "application/json"), 
                  body=list(name=playlist_name),
                  encode='json')
    return(content(query))
}

#' Function to add a track to a playlist 
add_tracks <- function(user_id, playlist_id, track_id, token){
    endpoint <- "https://api.spotify.com/v1/users/"
    url <- paste0(endpoint, user_id, "/playlists/", playlist_id, "/tracks")
    query <- POST(url = url,
                  config = add_headers(Authorization = paste('Bearer',token), 
                                       'Content-Type' = "application/json"), 
                  body=list(paste0("spotify:track:",track_id)),
                  encode='json')
    return(content(query))
}

#' Function to search for a track using artist and song names
#' returns track_id of the most relevant search result
#' uri = spotify:track:track_id
search_track <- function(artist, song, token){
    endpoint <- "https://api.spotify.com/v1/search?q="
    url <- paste0(endpoint, gsub(' ', '+', paste(song, artist)), "&type=track")
    match_song <- url %>% 
        GET(config = add_headers(Authorization = paste('Bearer',token))) %>%
        content %>% 
        with(tracks$items) 
    match_artist <- match_song %>%
        sapply(FUN = function(x){with(x$artists[[1]],name)}) %>%
        pmatch(artist,.)
    track_id <- match_song[[match_artist]]$id
    if(length(track_id)>1){track_id = track_id[1]}
    return(track_id)
}


################################################
# Main
################################################

# Spotify access token:
# Note: Need authorization of 'playlist-modify' in scope;
# default in Rspotify package is 'playlist-read'
S_token = oauth2.0_token(oauth_endpoint(authorize = "https://accounts.spotify.com/authorize",
                                        access = "https://accounts.spotify.com/api/token"),
                         oauth_app(appname = "rspotify_token", 
                                   key = "f885778620984715aaa0eaf0ea6fbfec",
                                   secret = "995d5968e40b4686a3ffcaf4111a5dd1"),
                         scope = paste("playlist-read-private",
                                       "playlist-read-collaborative",
                                       "playlist-modify-public",
                                       "playlist-modify-private"))
# S_token$refresh() # Refresh token if expired

# Playlist to be created
user_id <- "zeroyin"
playlist_name <- "Left Coast 70s by SomaFM"

# Create playlist if not existent
if (!is.element(playlist_name, getPlaylist(user_id, token = S_token)$name)){ 
    create_playlist(user_id, playlist_name, S_token$credentials$access_token)
}
all_lists <- getPlaylist(user_id, token = S_token)
playlist_id <- all_lists$id[match(playlist_name, all_lists$name)]

# Import playlist data
load(file = "playlist.RData")

# Keep track of process
status <- rep(NA, length(playlist$song))

# Add tracks to the playlist
for(itrack in 1:length(playlist$song)){
    # Search by artist and song name
    artist <- playlist$artist[itrack]
    song <- playlist$song[itrack]
    track_id <- search_track(artist, song, S_token$credentials$access_token)
    # If search returns NULL, try this:
    if(is.null(track_id)){
        artist <-  sub("&amp;", "&", x = playlist$artist[itrack])
        song <- sub(' \\(.*\\)', '', x = playlist$song[itrack])
        track_id <- search_track(artist, song, S_token$credentials$access_token)
    }
    # Add tracks to the playlist if search successful
    if(is.null(track_id)){
        status[itrack] <- "Not Found"
        cat(paste("Not found on Spotify:", artist, "-", song, "\n"))
        next
    }else if(is.element(track_id, getPlaylistSongs(user_id, playlist_id, token = S_token)$id)){ 
        status[itrack] <- "Duplicate"
        cat(paste("Already in playlist:", artist, "-", song, "\n"))
        next
    }else{
        status[itrack] <- "Success"
        cat(paste("Added to playlist:", artist, "-", song, "\n"))
        add_tracks(user_id, playlist_id, track_id, S_token$credentials$access_token)
    }
}

table(status)



