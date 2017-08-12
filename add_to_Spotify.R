rm(list = ls())
setwd("~/Dropbox/My_Projects/SomaFM_to_Spotify/")
library(Rspotify)


# Spotify access token:
# POST query to create playlist: https://developer.spotify.com/web-api/create-playlist/
# Note: Need to authorize 'playlist-modify' in scope!
Spotify_token = oauth2.0_token(oauth_endpoint(authorize = "https://accounts.spotify.com/authorize", 
                                              access = "https://accounts.spotify.com/api/token"), 
                               oauth_app(appname = "rspotify_token", 
                                         key = "f885778620984715aaa0eaf0ea6fbfec",
                                         secret = "995d5968e40b4686a3ffcaf4111a5dd1"),
                               scope = 'playlist-read-private playlist-read-collaborative playlist-modify-public playlist-modify-private')

create_playlist <- function(playlist_url,playlist_name){
    # Function to create a new playlist
    query <- POST(url = playlist_url,
                  config = add_headers(Authorization= paste('Bearer',Spotify_token$credentials$access_token), 
                                       'Content-Type' = "application/json"), 
                  body=list(name=playlist_name),
                  encode='json')
    return(content(query))
}

add_tracks <- function(user_id, playlist_id, track_url, track_id){
    # Function to add tracks to a playlist (track_id is the spotify URI)
    query <- POST(url = track_url,
                  config = add_headers(Authorization= paste('Bearer',Spotify_token$credentials$access_token), 
                                       'Content-Type' = "application/json"), 
                  body=list(track_id),
                  encode='json')
    return(content(query))
}




user_id <- "zeroyin"
playlist_name <- "Left Coast 70s by SomaFM"
playlist_url <- paste0("https://api.spotify.com/v1/users/",user_id,"/playlists")
all_list <- getPlaylist(name = user_id, token = Spotify_token)
# Create playlist if not exist: e.g. "Left Coast 70s by SomaFM"
if (!is.element(playlist_name, all_list$name)){ 
    create_playlist(playlist_url, playlist_name)
}

playlist_id <- all_list$id[match(playlist_name, all_list$name)]
track_url <- paste0("https://api.spotify.com/v1/users/", user_id, "/playlists/", playlist_id, "/tracks")
all_track <- getPlaylistSongs(ownerid = user_id, playlistid = playlist_id, token = Spotify_token)

# Remove repeating tracks
#
#   TO BE ADDED
#
#

# Transform track list to track id list
track_id <- "spotify:track:4iV5W9uYEdYUVa79Axb7Rh, spotify:track:1301WleyT98MSxVHPZCA6M"
# Add tracks to the playlist
add_tracks(user_id, playlist_id, track_url, track_id)
