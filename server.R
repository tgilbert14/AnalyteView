server <- function(input, output, session) {
  
  #downloading data
  site_select <- reactive({
    site.pick<- input$Select #saving site selection
    site.pick<- input$Select
    req(input$Select)
    
    #Testing
    #site.pick<- 'SYCA'
    
    ##Pulling data form 2018-01 to 2020-04
    D<- ''
    if (nchar(D) == 0) { D<- getwd() }
    unlink(paste0(D,"/WaterWorld"), recursive = T)
    ifelse(!dir.exists(file.path(D,'WaterWorld')), dir.create(file.path(D,'WaterWorld')), FALSE)
    setwd(file.path(D,'WaterWorld'))
    y2017<-c()
    y2017 <- c("2017-01","2017-02","2017-03","2017-04","2017-05","2017-06","2017-07","2017-08","2017-09","2017-10","2017-11","2017-12")
    y2018 <- c("2018-01","2018-02","2018-03","2018-04","2018-05","2018-06","2018-07","2018-08","2018-09","2018-10","2018-11","2018-12")
    y2019 <- c("2019-01","2019-02","2019-03","2019-04","2019-05","2019-06","2019-07","2019-08","2019-09","2019-10","2019-11","2019-12")
    y2020 <- c("2020-01","2020-02","2020-03","2020-04")
    y<- c(y2017,y2018)
    y2<- c(y,y2019)
    years<- c(y2,y2020)
    dpid <- "DP1.20093.001"   #Surface Water Chemistry DPID
    
    i=1
    result = vector("list", length(years))
    for(i in seq_along(years)){   #sequencing along dates 2018-01 to 2019-12 for NEON portal data
      result[[i]] = tryCatch(getPackage(dpid, site_code = site.pick ,year_month = years[i], package = "basic")(years[[i]]), 
                             error = function(e) paste("No data"))
      zipF <- list.files(pattern= site.pick, full.names = T); sapply(zipF, unzip, exdir = paste0(site.pick,"-unzip"))
    }
    
    #putting unzipped files together by type as list
    ExternalLab <- list.files(path= paste0(site.pick,"-unzip"),pattern= "external")

    External<- list()
    #Reading all CSV's and saving to vector
    i=1
    result = vector("list", length(years))
    for(i in seq_along(years)) {
      while(i< length(years)+1){
        result[[i]] = tryCatch(External[[i]]<- read_csv(paste0(site.pick,"-unzip/",ExternalLab[i])),
                               error = function(e) paste("No data"))
        i=i+1
      }
    }
    #Merging data by type/origin [ExternalLab/DomainLab/Field/Parent Data]
    External.data<- External[[1]]       #saving data for first bout
    i=2
    while (i < length(External)+1) {    #Merging the rest of data
      External.data<- merge(External.data, External[[i]], all.x="T",all.y = "T")
      i=i+1
    }
    
    setwd(D)
    External.data
  }) #end of data download
  
  ##Analyte selections
  Analyte_select <- reactive({
    select.analyte<- input$Select_A #saving site selection
    req(input$Select_A)
  })
  Analyte_selectB <- reactive({
    select.analyteB<- input$Select_B #saving site selection
    req(input$Select_B)
  }) #end of analyte selections

  #for testing
  #select.analyte<- 'K'
  #select.analyteB<- 'Mg'
  
  #Analyte compare plot1
  plotInput <- reactive({
    
    External.data <- site_select()     #pulling from NEON site selection
    select.analyte <- Analyte_select()
    select.analyteB <- Analyte_selectB()
    site.pick<- site_select()

    #External Lab data
    analyte_data<- External.data %>%
      filter(analyte == select.analyte) %>%
      select(analyte, analyteConcentration, analyteUnits, collectDate) %>% 
      arrange(collectDate)
    
    colourCount = length(unique(analyte_data$analyte))
    getPalette = colorRampPalette(brewer.pal(9, "Set3"))
    
    d.plot<- plot_ly()
    d.plot<- d.plot %>% add_trace(data=analyte_data,
                                  type='scatter',
                                  mode='markers+lines',
                                  x=~collectDate,
                                  y=~analyteConcentration,
                                  name =~analyte,
                                  color=I("blue"),
                                  alpha = .9,
                                  #create custom hovertext
                                  text=~paste0("Analyte: ",analyte, '\n',"Analyte Concentration: ",analyteConcentration,' ',analyteUnits, '\n'," Collect Date: ",collectDate, '\n', "From Extrernal Lab Analysis"), 
                                  hoverinfo='text'
    )%>%
      layout(title='External Lab Analyte Concentrations',yaxis=list(title='Concentration'),xaxis=list(title='Collect Date'))
    
    #colourCount = length(unique(analyte_data$analyte))
    #getPalette = colorRampPalette(brewer.pal(9, "Set1"))
    
    analyte_dataB<- External.data %>%
      filter(analyte == select.analyteB) %>%
      select(analyte, analyteConcentration, analyteUnits, collectDate) %>% 
      arrange(collectDate)
    ay <- list(
      tickfont = list(color = "black"),
      overlaying = "y",
      side = "right",
      title = "Concentration"
    )
    
    d.plot<- d.plot%>% add_trace(data=analyte_dataB, x=~collectDate,y=~analyteConcentration,yaxis = 'y2',name=~analyte, mode='lines+markers', inherit = F, type='scatter', text=~paste0("Analyte: ",analyte, '\n',"Collect Date: ", collectDate, '\n','Analyte Concentration: ', analyteConcentration,' ',analyteUnits), alpha=.5, 
                                 hoverinfo='text', colors =  getPalette(colourCount))
    
    d.plot<- d.plot%>% layout(
      title = "External Lab Analyte Concentrations", yaxis2 = ay,
      xaxis = list(title="Collect Date"))
    
    D<- ''
    if (nchar(D) == 0) { D<- getwd() }
    unlink(paste0(D,"/WaterWorld"), recursive = T)
    
    d.plot
    
  })
  
  
  output$Elab <- renderPlotly({
    print(plotInput())
  })
  

  #Analyte compare plot2
  plotInput2 <- reactive({
    
    External.data <- site_select()     #pulling from NEON site selection
    select.analyte <- Analyte_select()
    select.analyteB <- Analyte_selectB()
    site.pick<- site_select()

    #External Lab data
    analyte_data<- External.data %>%
      filter(analyte == select.analyte) %>%
      select(analyte, analyteConcentration, analyteUnits, collectDate) %>% 
      mutate(collectDate = substr(collectDate,1,10)) %>% 
      arrange(collectDate)
    
    analyte_dataB<- External.data %>%
      filter(analyte == select.analyteB) %>%
      select(analyte, analyteConcentration, analyteUnits, collectDate) %>% 
      mutate(collectDate = substr(collectDate,1,10)) %>% 
      arrange(collectDate)
    
    analytes<- left_join(analyte_data, analyte_dataB, by= 'collectDate')

    sct_base<-ggplot(analytes,aes(y = analyteConcentration.y,x = analyteConcentration.x))
    d.plot<- sct_base+geom_point()+
      geom_smooth(method = "lm",se = F, color = "Red", show.legend = T, formula = 'y ~ x', na.rm = F)+
      geom_smooth(color = "Grey", show.legend = T, inherit.aes = T)+
      theme_classic()+
      ggtitle(paste0(analytes$analyte.y[1],' vs ',analytes$analyte.x[1]))+
      xlab(analytes$analyte.x[1])+
      ylab(analytes$analyte.y[1])
    
    #anova()
    #t.test(analytes$analyteConcentration.y,analytes$analyteConcentration.x)
    
    d.plot
    
  })
  
  output$Dlab <- renderPlotly({
    print(plotInput2())
  })
  
#  output$Pvalue <- renderPrint({
    
#    External.data <- site_select()
#    select.analyte <- Analyte_select()
#    select.analyteB <- Analyte_selectB()
#    site.pick<- site_select()

#    analyte_data<- External.data %>%
#      filter(analyte == select.analyte) %>%
#      select(analyte, analyteConcentration, analyteUnits, collectDate) %>% 
#      mutate(collectDate = substr(collectDate,1,10)) %>% 
#      arrange(collectDate)
    
#    analyte_dataB<- External.data %>%
#      filter(analyte == select.analyteB) %>%
#      select(analyte, analyteConcentration, analyteUnits, collectDate) %>% 
#      mutate(collectDate = substr(collectDate,1,10)) %>% 
#      arrange(collectDate)
    
#    analyte_union<- union(analyte_data, analyte_dataB, by= 'collectDate')
#    analytes1<- analyte_union %>% 
#      select(analyte, analyteConcentration)
    
#    t.test(data= analytes1, analyteConcentration ~ analyte)

#  })
  
  output$PvalueSUM <- renderPrint({
    
    External.data <- site_select()
    select.analyte <- Analyte_select()
    select.analyteB <- Analyte_selectB()
    site.pick<- site_select()
    
    analyte_data<- External.data %>%
      filter(analyte == select.analyte) %>%
      select(analyte, analyteConcentration, analyteUnits, collectDate) %>% 
      mutate(collectDate = substr(collectDate,1,10)) %>% 
      arrange(collectDate)
    
    analyte_dataB<- External.data %>%
      filter(analyte == select.analyteB) %>%
      select(analyte, analyteConcentration, analyteUnits, collectDate) %>% 
      mutate(collectDate = substr(collectDate,1,10)) %>% 
      arrange(collectDate)
    
    analytes<- left_join(analyte_data, analyte_dataB, by= 'collectDate')
    
    #analyte_union<- union(analyte_data, analyte_dataB, by= 'collectDate')
    #analytes1<- analyte_union %>% 
    #  select(analyte, analyteConcentration)
    
    mdl_1<-lm(analyteConcentration.y ~ analyteConcentration.x,data = analytes)
    
    #t.test(data= analytes1, analyteConcentration ~ analyte)
    summary(mdl_1)
    
  })
  
  output$table <- renderDataTable({
  
    External.data <- site_select()
    select.analyte <- Analyte_select()
    select.analyteB <- Analyte_selectB()
    site.pick<- site_select()

    analyte_data<- External.data %>%
      filter(analyte == select.analyte) %>%
      select(analyte, analyteConcentration, analyteUnits, collectDate) %>% 
      mutate(collectDate = substr(collectDate,1,10)) %>% 
      arrange(collectDate)
    
    analyte_dataB<- External.data %>%
      filter(analyte == select.analyteB) %>%
      select(analyte, analyteConcentration, analyteUnits, collectDate) %>% 
      mutate(collectDate = substr(collectDate,1,10)) %>% 
      arrange(collectDate)

    
    analytes<- left_join(analyte_data, analyte_dataB, by= 'collectDate')
    
analytes
      
})
  
  c_check<- reactive({
    
    External.data <- site_select()
    select.analyte <- Analyte_select()
    select.analyteB <- Analyte_selectB()
    site.pick<- site_select()
    
    alist<- c('ANC','Br','Ca','Cl','CO3','conductivity','DIC','DOC','F','Fe','HCO3','K','Mg','Mn','Na','NH4 - N','NO2 - N','NO3+NO2 - N','Ortho - P','pH','Si','SO4','TDN','TDP','TDS','TN','TOC','TP','TPC','TPN','TSS','TSS - Dry Mass','UV Absorbance (250 nm)','UV Absorbance (280 nm)')
  
  correlation <- data.table(Analyte=character(),Correlation=numeric())
  #View(correlation)

  ##checking first analyte
  analyte_data<- External.data %>%
    filter(analyte == select.analyte) %>%
    select(analyte, analyteConcentration, collectDate) %>%
    mutate(collectDate = substr(collectDate,1,10)) %>% 
    arrange(collectDate)
  #head(analyte_data)
  i=1
  while (i < length(alist)+1 ) {
    
  analyte_dataB<- External.data %>%
    filter(analyte == alist[i]) %>%
    select(analyte, analyteConcentration, collectDate) %>% 
    mutate(collectDate = substr(collectDate,1,10)) %>% 
    arrange(collectDate)
  
  analytes<- left_join(analyte_data, analyte_dataB, by= 'collectDate')
  
  correlation[[i,2]]<- cor(analytes$analyteConcentration.x, analytes$analyteConcentration.y)
  correlation[[i,1]]<- paste0(analytes$analyte.y[1])

  i=i+1
  }

    correlationA<- correlation %>%
    filter(Analyte != select.analyte) %>% 
    filter(!is.na(Correlation)) %>% 
    arrange(desc(Correlation))
  
  correlationA
    
  })
  
  output$patterns<- renderDataTable({
  
    print(c_check())
    
    })
    
  #Readme - make into HTML
  output$appreadme<-renderUI({includeHTML('AppReadme.html')})
  
} #end of server