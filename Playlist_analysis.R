# Analysis of the playlist
################################################
rm(list = ls())
setwd("~/Dropbox/My_Projects/SomaFM_to_Spotify/")
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
    tally(sort = T) -> t_freq

# Customize color palette to raise contrast
pal <- brewer.pal(9,"BuGn")
pie(x = rep(1, length(pal)), col = pal) # Visualize palette
col <- rep(pal, times = table(ceiling(t_freq$n/length(pal))))

# bar plot
library(reshape2)
library(ggplot2)
p1 <- ggplot(data = t_freq, aes(x = reorder(artist, n), y = n)) + 
    geom_bar(stat = "identity", fill = col) +
    geom_text(aes(label = artist), hjust = 0) + 
    theme_bw() +
    coord_flip(ylim = c(0, 100)) +
    theme(axis.text.y=element_blank(),
          axis.ticks=element_blank(),
          axis.title.y=element_blank())
ggsave(filename = "artist_popularity_barplot.pdf", 
       plot = p1, dpi = 100, width = 8, height = 20)

# Wordcloud
library(wordcloud)
pdf(file= "artist_popularity_wordcloud.pdf", width = 8, height = 6)
wordcloud(t_freq$artist, t_freq$n, 
          scale=c(1.5,.3), 
          random.order = FALSE,
          rot.per = 0,
          colors = col)
dev.off()


################################################
# Histogram by occurance: most songs played 8 times
tlist %>% 
    group_by(artist, song) %>% 
    summarise(Occurrence = n()) -> t_occur

ggplot(data = t_occur) +
    geom_bar(aes(x = Occurrence), stat = "count", fill = "grey") +
    theme_bw() -> p3
ggsave(filename = "Occurrence_hist.pdf",
       plot = p3, dpi = 100, width = 8, height = 6)

# DJ's fav list
t_occur %>%
    filter(Occurrence >= 8)

################################################
# Song length analysis
# Note: data are the interval length between two songs, based on the assumption 
# that the songs are played continuosly without skipping etc.
# Reliable song length data can be collected from song matching on Spotify
tlist %>% 
    filter(len > 0) %>% # <- filter out songs with len = 0
    group_by(artist, song) %>% 
    summarise(freq = n(), mlen= mean(len), min= min(len), max= max(len), diff = max(len)-min(len)) %>% 
    arrange(desc(freq)) %>%
    filter(diff < 60) %>% # <- filter out songs with diff of len > 60s
    print(n=nrow(.)) %>% # <- visually check for outliers
    ungroup() -> t_len

ggplot(t_len) +
    geom_histogram(aes(x = mlen, y = ..density..), fill="grey") +
    geom_density(aes(x = mlen)) +
    theme_bw() +
    theme(axis.text.y = element_blank(),
          axis.ticks.y = element_blank(),
          axis.title.y = element_blank()) +
    xlab("Song length/s") -> p4
ggsave(filename = "Song_length_density.pdf",
       plot = p4, dpi = 100, width = 8, height = 6)


