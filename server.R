
server <- function(input, output, session) {

    
    #== FOR DEBUGGING STUFF == 
    # output$debug <- renderText(
    # 
    #     unique(pop_over_time$track_artist)
    #     
    # )
    
    
    #plot_1 --- Characteristics of Popular Songs
    
    output$plot_1 <- renderPlotly({
        
        
        # column_y <- eval(parse(text = str_to_lower(input$pop_compare_y)))
        
        
        
        
        # Data Transformation
        data_agg_1 <- popular_songs %>% 
            filter(track_popularity >= input$pop_x_slider[1] &
                       track_popularity <= input$pop_x_slider[2] &
                       
                       eval(parse(text = str_to_lower(input$pop_compare_y))) >= input$pop_compare_y_slider[1] &
                       eval(parse(text = str_to_lower(input$pop_compare_y))) <= input$pop_compare_y_slider[2] &
                       
                       year(track_album_release_date) >= input$year_input[1] &
                       year(track_album_release_date) <= input$year_input[2] 
                      ) %>% 
                
             distinct(track_name, .keep_all = T)
        


        # Comparison Plot
        plot_popular <- ggplot(data_agg_1, aes(x = track_popularity,
                                               y = eval(parse(text = str_to_lower(input$pop_compare_y))),
                                               text = glue("Track Name : {track_name} <br>Artist : {track_artist} <br>Album : {track_album_name}
                                      "))) +
                    
            geom_jitter(aes(color = playlist_genre), size = 1, alpha=.6) +
            
            
            scale_size(guide = "none") +
            
            #ORIGINAL COLOR
            # scale_color_manual(values = c("#2D5D80", "#59B9FF", "#A6DAFF", "#AD6857", "#FAA995", "#45AD8B")) +
            
            scale_color_manual(values = c("#EC5564", "#8AC054", "#5E9CEA", "#B574FF", "#F0C8A5", "#626369")) +
            
            labs(color = "Genre",
                 size = "Song Duration",
                 x = "Song Popularity",
                 y = str_to_title(input$pop_compare_y)) +
            
            theme(
                  panel.grid = element_blank(),
                  axis.line = element_blank(),
                  # axis.text = element_blank(),
                  axis.ticks = element_blank(),
                  plot.background = element_rect(fill = "#FFFFFF"),
                  panel.background = element_rect(fill = "#FFFFFF"),
                  legend.background = element_rect(fill = "#FFFFFF")
                  
            ) 
        
        ggplotly(plot_popular, tooltip = "text")
    


    })
    
    
    output$totalTracks <- renderInfoBox({
        
        totalTracksVar <- popular_songs %>% 
            filter( track_popularity >= input$pop_x_slider[1] & 
                    track_popularity <= input$pop_x_slider[2] &
                    
                        eval(parse(text = str_to_lower(input$pop_compare_y))) >= input$pop_compare_y_slider[1] &
                        eval(parse(text = str_to_lower(input$pop_compare_y))) <= input$pop_compare_y_slider[2] &    
                        
                    track_album_release_date >= input$year_input[1] &
                    track_album_release_date <= input$year_input[2]

                    ) %>% 
            distinct(track_name, .keep_all = T)
        
        infoBox("Total Tracks Displayed", paste0(nrow( totalTracksVar ) , "Tracks"), 
            icon = icon("music"), 
            color = "blue",
            fill = T
        )
    })
    
    output$totalArtists <- renderInfoBox({
        
        totalMusician <- popular_songs %>% 
            filter( track_popularity >= input$pop_x_slider[1] & 
                    track_popularity <= input$pop_x_slider[2] &
                        
                        eval(parse(text = str_to_lower(input$pop_compare_y))) >= input$pop_compare_y_slider[1] &
                        eval(parse(text = str_to_lower(input$pop_compare_y))) <= input$pop_compare_y_slider[2] &
                    
                    track_album_release_date >= input$year_input[1] &
                    track_album_release_date <= input$year_input[2]
                    
            ) %>% 
            
            distinct(track_artist, .keep_all = T)
            
            
        
        infoBox("Total Artists Displayed", paste0(nrow( totalMusician ) ), 
                icon = icon("users"), 
                color = "purple",
                fill = T
        )
    })
    
    
    output$mostArtists <- renderInfoBox({
        
        mostCommonArtist <- popular_songs %>% 
            filter( track_popularity >= input$pop_x_slider[1] & 
                        track_popularity <= input$pop_x_slider[2] &
                        
                        eval(parse(text = str_to_lower(input$pop_compare_y))) >= input$pop_compare_y_slider[1] &
                        eval(parse(text = str_to_lower(input$pop_compare_y))) <= input$pop_compare_y_slider[2] &
                        
                        track_album_release_date >= input$year_input[1] &
                        track_album_release_date <= input$year_input[2]
                    
            ) %>% 
            distinct(track_name, .keep_all = T)
        
        
        
        infoBox("Musician with the Most Songs", paste0( names(table(mostCommonArtist$track_artist))[table(mostCommonArtist$track_artist) == max(table(mostCommonArtist$track_artist))][1] ), 
                icon = icon("user"), 
                color = "light-blue",
                fill = T
        )
    })
    
    
    #plot_2 --- Artist popularity Over Time
    
    
    output$plot_2 <- renderPlotly({
        
        
        data_agg_2 <- pop_over_time %>% 
            filter(track_artist == input$artistName_1 | track_artist == input$artistName_2 | track_artist == input$artistName_3) 
            
            
        
        
        plot_pop_over_time <- ggplot(data_agg_2, aes(x = as.integer(year_release),
                                                    y = track_popularity,
                                                    text = glue("Track Name : {track_name} <br>Release Date : {track_album_release_date} <br>Popularity : {track_popularity}"))) +
            
            
            # geom_jitter(shape = 2, color = "#2D5D80", show.legend = F) +
            
            geom_jitter(aes(shape = track_artist, color = track_artist)) +
            
            
            
            labs(
                color = "Artists",
                shape = "Artists",

                 x = "Release Time",
                 y = "Popularity") +

            theme_minimal()
        
        
        ggplotly(plot_pop_over_time, tooltip = "text")
        
    })
    
    
    output$plot_3 <-  renderPlotly({
        
        data_agg_3 <- artist_pop_energy %>% 
            # filter(track_artist %in% unlist(artistSelect[1]) ) %>% 
            filter(track_artist == input$artistName_1 | track_artist == input$artistName_2 | track_artist == input$artistName_3) 
            
        
        plot_artist_comparison <- ggplot( data_agg_3,aes(x = track_artist,
                                y = value,
                                text = glue("{song_characters} : {value}")
                                                                                         )) +
            geom_col(position = "dodge", aes(fill = song_characters)) +
            coord_flip() +
            
            # scale_fill_discrete(labels = c("Danceability", "Energy", "Positivity")) +
            
            scale_fill_manual(values = c("#2D5D80", "#59B9FF", "#A6DFFF")) +
            
            labs(
                fill =NULL,
                
                x = NULL,
                y = NULL) +
            
            theme_minimal() +
            theme(axis.text.x = element_blank(),
                  panel.grid = element_blank()) 
            
        
       
        ggplotly(plot_artist_comparison, tooltip = "text")
            
        
    })
    
    
   
    
    #data_raw --- Display RAW Data
    
    output$data_raw <- renderDataTable({
        
        datatable(popular_songs, options = list(scrollX = T))
        
    })

}
