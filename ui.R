dashboardPage( skin = "black", title = "Songs Analysis",
    
    
                          
    dashboardHeader(
        title = "Spotify Songs Analysis"
        
    ),
    
    #=== SIDEBAR ===
    dashboardSidebar(
        
        
        sidebarMenu(
            
            #Sidebar #1 -- Characteristics
            menuItem("Characteristics", tabName = "pop", icon = icon("chart-pie")),
            
            #Sidebar #2 -- Popularity Prediction
            menuItem("Artist Comparison", tabName = "prediction", icon = icon("chart-bar")),
            
            
            #Sidebar #3 -- Raw Data
            menuItem("Raw Data", tabName = "data", icon = icon("clipboard"))
        
        )
        
        
        
    ),
    
    #=== BODY ===
    dashboardBody(
        
        
        tabItems(
            
            
            tabItem(
                
                
                
                
                #=== TAB 1 - POP ====
                
                tabName = "pop",
                
                
                # Text Introduction
                
                h2("Characteristic Spread of Various Popular Songs"),
                
                hr(),
                
                h4("Is Rock really the loudest music? Can EDM really live up its \"Dance\" middle name? Check out the characteristics of different genres of music compared to the others."),

                hr(),
                
                #== DEBUG ==       
                
                # fluidRow(
                #     box(
                #         h5("Debugging Box"),
                #         textOutput(outputId = "debug")
                #     )
                # ),
                
                #===
                
                fluidRow(
                    
                    box( width=6,
                         
                         sliderInput(inputId = "year_input",
                                     label = "Year Input",
                                     min = 1957,
                                     max = 2020,
                                     value = c(1957,2020),
                                     step = 1),
                         
                         sliderInput(inputId = "pop_x_slider",
                                     label = "Song Popularity",
                                     min = 0,
                                     max = 100,
                                     value = c(60,100),
                                     step = 1),
                         
                         
                         
                    ),
                    
                    box(width = 6,
                        selectInput(inputId = "pop_compare_y",
                                    label = "Choose Song Characteristics",
                                    choices = str_to_title(select_column),
                        ),
                        
                        sliderInput(inputId = "pop_compare_y_slider",
                                    label = "Y Scale",
                                    min = 0,
                                    max = 1,
                                    
                                    value = c(0,1),
                                    step = .01
                                    
                        ),
                    )
                    
                    
                    
                ),
                
                
                #====== MAIN PLOT DISPLAY ======
                fluidRow(    
                    box( width = 12, solidHeader = T,
                         plotlyOutput(outputId = "plot_1"),
                         hr(),
                         
                         
                         #== INFOBOX ==
                         infoBoxOutput("totalTracks", width = 4),
                         infoBoxOutput("totalArtists", width = 4),
                         infoBoxOutput("mostArtists", width = 4)
                         
                         
                         
                         ),
                    
                    
                )
                
                
                
                
                
                # ====== INPUT SLIDERS =====
                
                ),
            
                #=== END TAB 1 ====
            
            
            #===== TAB 2 - POP PREDICTION ====
            tabItem(
                
                tabName = "prediction",
                    
                    h2("Artists Comparison"),
                
                hr(),
                
                h4("Is Ariana Grande songs more dance-able than the late Avicii? Well, in this page, we can compare up to 3 musician's popularity as well as their song characteristics."),
                
                hr(),
                
                
                    
                    fluidRow(
                        box(width = 8, solidHeader = T,
                            plotlyOutput(outputId = "plot_2"),
                            
                                
                            ),
                        
                        box(width = 4, solidHeader = T,
                            selectInput(inputId = "artistName_1",
                                        label = "First Artist Name",
                                        choices = unique(pop_over_time$track_artist),
                                        selected = "Ariana Grande"
                                        ),
                            
                            selectInput(inputId = "artistName_2",
                                        label = "Second Artist Name",
                                        choices = unique(pop_over_time$track_artist),
                                        selected = "Avicii"
                            ),
                            
                            selectInput(inputId = "artistName_3",
                                        label = "Third Artist Name",
                                        choices = unique(pop_over_time$track_artist),
                                        selected = "Coldplay"
                            )
                            
                            
                            
                        ),
                        
                        box(width = 12, solidHeader = T,
                            plotlyOutput(outputId = "plot_3",
                                       height = 200))

                    ),
                    
                
                   
                
                
                
                
                ),
            
            
            tabItem(tabName = "data",
                    h2("Raw Data from Spotify"),
                    dataTableOutput(outputId = "data_raw")
                    )
            
            
            
        )
        
    )
)
