library(shiny)
library(shinydashboard)
library(tidyverse)
library(lubridate)
library(plotly)
library(glue)
library(DT)

songs <- read_csv(file = "spotify_songs.csv")


#===== plot_1 --- Characteristics of Popular Songs =====

# Range mapping some number variable to 0 to 1
# Fixing Date for further use
popular_songs <- songs %>% 
  mutate (tempo = round((tempo -  range(tempo)[1]  ) * 1/diff(range(tempo)),2) ) %>% 
  mutate (loudness = round((loudness -  range(loudness)[1]  ) * 1/diff(range(loudness)),2) ) %>% 

  mutate (track_album_release_date = case_when( str_length(track_album_release_date) == 4 ~ paste0(track_album_release_date, "-01-01"),
                                                    str_length(track_album_release_date) == 7 ~ paste0(track_album_release_date, "-01"),
                                                    TRUE ~ track_album_release_date
                                          )) %>%
  mutate(year_release = year(track_album_release_date)) %>% 
  
  distinct(track_name, .keep_all = T)



select_column <- str_to_title(
  names(popular_songs[,c("danceability", "energy", "loudness", "speechiness", "acousticness", "liveness", "tempo", "valence")])
)


#======= plot_1 END ====================

#===== plot_2 --- Popularity Prediction =====

# Artist Selection. Making sure there's enough songs data -- (>25)
artistSelect <- songs %>%
  distinct(track_name, .keep_all = T) %>% 
  filter(track_popularity > 10) %>% 
  # filter( !str_detect(track_name, "Remix|remix") | !str_detect(track_album_name, "Remix|remix")) %>% 
  group_by(track_artist) %>%
  summarise(no_rows = length(track_artist)) %>% 
  
  #song quantity threshold
  filter(no_rows > 14) %>% 
  
  #getting rid of #1 artist with weird text
  slice(-1)



pop_over_time <- songs %>% 
  
  #Date Correction
  mutate (track_album_release_date = case_when( str_length(track_album_release_date) == 4 ~ paste0(track_album_release_date, "-01-01"),
                                                str_length(track_album_release_date) == 7 ~ paste0(track_album_release_date, "-01"),
                                                TRUE ~ track_album_release_date
  )) %>%
  mutate(year_release = year(track_album_release_date)) %>% 
  
  #no remix
  # filter( !str_detect(track_name, "Remix|remix") | !str_detect(track_album_name, "Remix|remix")) %>% 
  
  #filter based on artistSelect variable selection
  filter(track_artist %in% unlist(artistSelect[1]) ) %>% 
  
  arrange(track_artist)


artist_pop_energy <- songs %>% 
  
  filter(track_artist %in% unlist(artistSelect[1]) ) %>% 
  
  group_by(track_artist) %>% 
  summarise(Danceability = round(mean(danceability), 3), 
            Energy = round(mean(energy),3),
            Positivity = round(mean(valence),3),) %>% 
  
  pivot_longer(-track_artist, names_to = "song_characters", values_to = "value")






#======= plot_2 END =========================
  