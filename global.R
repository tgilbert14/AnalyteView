##global
#Loading Libraries
load.pkg <- function(p) {  #load packages with require(), install any that are not installed
  if (!is.element(p, installed.packages()[,1]))
    install.packages(p, dep = TRUE)
  suppressMessages(require(p, character.only = TRUE))
}

load.pkg('neonUtilities')  ##Loading Libraries##
load.pkg('dplyr')
load.pkg('tidyverse')       
load.pkg('readr')
load.pkg('tidyr')
load.pkg('plotly')
load.pkg('shiny')
load.pkg('shinycssloaders')
load.pkg('RColorBrewer')
load.pkg('shinydashboard')
load.pkg('shinydashboardPlus')
load.pkg('shinycssloaders')
load.pkg('mlr')    
#load.pkg('shinyjs')
load.pkg('data.table')    

fit_data<- read_csv("all_water_chemData.csv")
