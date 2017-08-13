I am a fan of Spotify but to be honest, it is hard for me to discover new songs on it as its recommendation algorithm never gets to understand my taste. Lately I have been listening to soma fm and really fell in love with the channel Left Coast 70s. Here is their website: https://somafm.com/ if you are interested. I play this channel while driving which eventually consumes a lot of data, so I tried to find the tracks on Spotify where I can download them on Wi-Fi. It is not easy considering the number of songs played in this channel.

At first, I searched on Google and found some existing playlists on Spotify which was added by other soma fm fans, but no luck with the playlist I like. Then I found someone using python to do the work by scraping the playlist from soma fm website where tracks played in the past hour were listed. See here if you use python as well: https://www.andreagrandi.it/2015/07/12/soma-fm-spotify-import-io-python-mashup/. So I decided to do the work in R. While doing the research, I found the official twitter account of the playlist (@LeftCoast70s) where they released and so preserved all the track histories! This makes things so much easier because scraping Twitter is almost effortless with so many great R packages (I am using mkearney/rtweet).

Yep I got a playlist of thousands of songs from their twitter timeline. Now I just need to add them to my Spotify playlist. It should be easy, too, as there are a few existing R packages for Spotify's API. However, in trying these packages, the one that is supposed to work, rweyant/spotifyr, for some reason does not work on my end, and another one, tiagomendesdantas/Rspotify, turned out to be only able to read information rather than modify. As a result, I based my script on tiagomendesdantas/Rspotify while I wrote a few functions to modify the playlist. Note that you also need to override the scope of the original package to include authorizations to modify stuff. References for authorization and queries can be found on https://developer.spotify.com/web-api/.

Anyway you can find my code on github: https://github.com/zeroyin/SomaFM_Spotify and you can modify it to download other playlists you like! Note that you also need your own Twitter and Spotify API keys to do the job.


--------------------------------
Steps:
1. Retrieve tweets using Twitter API and form a playlist including artist and song names
2. Add tracks to Spotify using Spotify API

--------------------------------
Notes for myself while coding:
1. A complete song history can be found at the the official twitter account (Left Coast 70s); while the SomaFM website only list out songs in the past hour
2. R package "twitteR" is old; use "rtweet" instead
3. It is easy to get the playlist thanks to SomaFM's twitter history
4. After some research, the R package "spotifyr" includes functions to modify playlists, but for some reason it does not work; I decided to write it myself
5. The R package Rspotify include functions that ONLY reads information from Spotify. Still it makes some things easy as I only have to write three functions myself that modifies playlists. 
6. It is important to note that "Rspotify" only have READ authorizations. I needed to override the existing authorization and add playlist-modify scopes.
7. Search by song name first and match with artist then. If no match, try removing strange symbols and removing contents within parenthesis such as (LP Version). If still no match, skip it.
8. With the Twitter API I can only get 3200 tweets which ended up around 570 tracks after removing duplicates and around 500 can be found on Spotify.
