Steps:

1. Retrieve all tweets using Twitter API and form a playlist including artist and song names
2. Remove repeating tracks
3. Add tracks to Spotify using Spotify API


Things to note:
1. A complete song history can be found at the the official twitter account (Left Coast 70s); while the SomaFM website only list out songs in the past hour
2. R package "twitteR" is old; use "rtweet" instead
3. It is easy to get the playlist thanks to SomaFM's twitter history
4. After some research, the R package "spotifyr" includes functions to modify playlists, but for some reason it does not work on my end, so I decided to do it myself.
5. The R package Rspotify include functions that ONLY reads information from Spotify. Out of convenience I only write two functions in addition to this package to modify playlists. 
6. It is important to note that "Rspotify" only requires READ authorizations. As a result, I needed to override the existing authorization and add playlist-modify scopes.
