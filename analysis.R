# Analysis of the playlist
################################################
rm(list = ls())
setwd("~/Dropbox/My_Projects/SomaFM_to_Spotify/")
library(reshape2)
library(ggplot2)
library(dplyr)

# Load data
load("history_2017-08-19.RData")

# Parse history: artist and song and song length
text <- gsub(x = rt$text, pattern = '♬ *(.*?) ♬.*', replacement = "\\1") 
artist <- sub(x=text, pattern = '(.*?) - .*', replacement = "\\1")
song  <- sub(x=text, pattern = '.* - (.*?)', replacement = "\\1")
len <- as.numeric(-diff(rt$created_at))

# Store data in a list
tlist <- data.frame("artist" = artist[-1], "song" = song[-1], "len" = len)

################################################
# Plot: popularity of artists
tlist %>% 
    group_by(artist) %>%
    tally(sort = T) %>%
    ggplot(aes(x = reorder(artist, n), y = n)) + 
        geom_bar(stat = "identity") +
        geom_text(aes(label = artist), hjust = 0) + 
        theme_bw() +
        coord_flip(ylim = c(0, 100)) +
        theme(axis.text.y=element_blank(),
              axis.ticks=element_blank(),
              axis.title.y=element_blank()) -> p1
ggsave(filename = "artist_popularity.eps", 
       plot = p1, dpi = 100, width = 8, height = 20)
    
    


