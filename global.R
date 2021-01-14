

##global
#Loading Libraries
# load.pkg <- function(p) {  #load packages with require(), install any that are not installed
#   if (!is.element(p, installed.packages()[,1]))
#     install.packages(p, dep = TRUE)
#   suppressMessages(require(p, character.only = TRUE))
# }

# load.pkg('shiny')
# load.pkg('neonUtilities')  ##Loading Libraries##
# load.pkg('dplyr')
# load.pkg('tidyverse')       
# load.pkg('readr')
# load.pkg('tidyr')
# load.pkg('plotly')
# load.pkg('shinycssloaders')
# load.pkg('RColorBrewer')
# load.pkg('shinydashboard')
# load.pkg('shinydashboardPlus')
# load.pkg('shinycssloaders')
# load.pkg('mlr')    
# load.pkg('data.table')

library(devtools)
#library(Rtools)
library(shiny)
library(neonUtilities, lib.loc = "C:/Users/tsgil/Documents/R/win-library/4.0")  ##Loading Libraries##
library(dplyr)
library(tidyverse)       
library(readr)
library(tidyr)
library(plotly)
library(shinycssloaders)
library(RColorBrewer)
library(shinydashboard)
library(shinydashboardPlus)
library(shinycssloaders)
library(mlr)    
library(data.table) 
library(gganimate)
library(gifski)


## data up to early 2020- need to update??
fit_data<- read_csv("all_water_chemData.csv")

