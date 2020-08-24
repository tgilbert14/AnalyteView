server <- function(input, output, session) {
  
  #downloading data
  site_select <- reactive({
    site.pick<- input$Select #saving site selection
    site.pick<- input$Select
    req(input$Select)
    
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
    DomainLab <- list.files(path= paste0(site.pick,"-unzip"),pattern= "domain")
    ExternalLab <- list.files(path= paste0(site.pick,"-unzip"),pattern= "external")
    FieldData <- list.files(path= paste0(site.pick,"-unzip"),pattern= "fieldData")
    ParentData <- list.files(path= paste0(site.pick,"-unzip"),pattern= "Parent")
    
    Domain<-list()      #empty lists to store file data below
    Field<- list()
    Parent<- list()
    External<- list()
    #Reading all CSV's and saving to vector
    i=1
    result = vector("list", length(years))
    for(i in seq_along(years)) {
      while(i< length(years)+1){
        result[[i]] = tryCatch(External[[i]]<- read_csv(paste0(site.pick,"-unzip/",ExternalLab[i])),
                               error = function(e) paste("No data"))
        result[[i]] = tryCatch(Domain[[i]]<- read_csv(paste0(site.pick,"-unzip/",DomainLab[i])),
                               error = function(e) paste("No data"))
        result[[i]] = tryCatch(Field[[i]]<- read_csv(paste0(site.pick,"-unzip/",FieldData[i])),
                               error = function(e) paste("No data"))
        result[[i]] = tryCatch(Parent[[i]]<- read_csv(paste0(site.pick,"-unzip/",ParentData[i])),
                               error = function(e) paste("No data"))
        #print(paste("Successfully Read",years[i]))
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
    Domain.data<- Domain[[1]]       #saving data for first bout
    i=2
    while (i < length(Domain)+1) {    #Merging the rest of data
      Domain.data<- merge(Domain.data, Domain[[i]], all.x="T",all.y = "T")
      i=i+1
    }
    Field.data<- Field[[1]]       #saving data for first bout
    i=2
    while (i < length(Field)+1) {    #Merging the rest of data
      Field.data<- merge(Field.data, Field[[i]], all.x="T",all.y = "T")
      i=i+1
    }
    Parent.data<- Parent[[1]]       #saving data for first bout
    i=2
    while (i < length(Parent)+1) {    #Merging the rest of data
      Parent.data<- merge(Parent.data, Parent[[i]], all.x="T",all.y = "T")
      i=i+1
    } 
    
    write.table(Parent.data, file = paste0(site.pick,"Parent_data.csv"), sep = ",")
    write.table(Field.data, file = paste0(site.pick,"Field_data.csv"), sep = ",")
    write.table(Domain.data, file = paste0(site.pick,"Domain_data.csv"), sep = ",")
    
    setwd(D)
    External.data
  }) #end of data download
  
  dis_select <- reactive({
    site.pick<- input$Select
    #adding discharge to graph
    dpid<- "DP1.20048.001"
    data.all <- loadByProduct(dpID=dpid, site= site.pick,startdate = '2018-01', check.size=F)
    d<- data.all$dsc_fieldData
    
  })
  
  P.data<- reactive({
    site.pick<- input$Select
    Parent.data<- read.table(paste0('WaterWorld/',site.pick,'Parent_data.csv'), sep=',')
    temp_data<- Parent.data %>%
      select(waterTemp, dissolvedOxygen, dissolvedOxygenSaturation, specificConductance, collectDate) %>% 
      arrange(collectDate)
  })  
  #ANC/ALK data from domain data
  D.data<- reactive({
    site.pick<- input$Select
    Domain.data<- read.table(paste0('WaterWorld/',site.pick,'Domain_data.csv'), sep=',')
    ANC.data.do<- Domain.data %>%
      select(ancMeqPerL, alkMeqPerL, collectDate) %>% 
      arrange(collectDate)
  })
  ##Analyte selections
  Analyte_select <- reactive({
    select.analyte<- input$Select_A #saving site selection
    req(input$Select_A)
  })
  Analyte_selectB <- reactive({
    select.analyteB<- input$Select_B #saving site selection
    req(input$Select_B)
  }) #end of analyte selections
  
  #Analyte compare plots
  plotInput <- reactive({
    
    External.data <- site_select()     #pulling from NEON site selection
    select.analyte <- Analyte_select()
    select.analyteB <- Analyte_selectB()
    site.pick<- site_select()
    d<- dis_select()
    
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
    
    #Converting from 'lps' to 'cfs' so fits into graph
    dsc<- d %>%
      mutate(red_dis = totalDischarge*0.0353) %>% 
      select(red_dis,collectDate) %>% 
      arrange(collectDate)
    
    if (select.analyteB == 'Discharge-FIELD') {
      d.plot<- d.plot%>% add_trace(data=dsc, x=~collectDate,y=~red_dis, yaxis= 'y2', name = 'Discharge (CSF)',colors =  getPalette(colourCount), mode='lines+markers', inherit = F, type='scatter', text=~paste0("Collect Date: ", collectDate, '\n','Discharge- NEON: ',red_dis,'csf'), alpha=.6, 
                                   hoverinfo='text')
      d.plot+geom_jitter()+geom_smooth(se=FALSE)
      
    }
    if (select.analyte == 'Discharge-FIELD') {
      d.plot<- d.plot%>% add_trace(data=dsc, x=~collectDate,y=~red_dis, yaxis= 'y', name = 'Discharge (CSF)',colors =  getPalette(colourCount), mode='lines+markers', inherit = F, type='scatter', text=~paste0("Collect Date: ", collectDate, '\n','Discharge- NEON: ',red_dis,'csf'), alpha=.6, 
                                   hoverinfo='text')
    }
    
    ANC.data.do <- D.data()
    
    if (select.analyte == 'ALK-DOMAIN') {
      d.plot<- d.plot%>% add_trace(data=ANC.data.do, x=~collectDate,y=~alkMeqPerL,  yaxis='y', name = 'Domain ALK (MeqPerL)', colors = getPalette(colourCount), mode='lines+markers', inherit = F, type='scatter',  text=~paste0("Collect Date: ", collectDate, '\n','Domain ALK- NEON: ',alkMeqPerL,' MeqPerL'), alpha=.6, 
                                   hoverinfo='text')
    }
    if (select.analyteB == 'ALK-DOMAIN') {
      d.plot<- d.plot%>% add_trace(data=ANC.data.do, x=~collectDate,y=~alkMeqPerL,  yaxis='y2', name = 'Domain ALK (MeqPerL)', colors = getPalette(colourCount), mode='lines+markers', inherit = F, type='scatter',  text=~paste0("Collect Date: ", collectDate, '\n','Domain ALK- NEON: ',alkMeqPerL,' MeqPerL'), alpha=.6, 
                                   hoverinfo='text')
    }
    
    if (select.analyte == 'ANC-DOMAIN') {
      d.plot<- d.plot%>% add_trace(data=ANC.data.do, x=~collectDate,y=~ancMeqPerL, yaxis='y', name = 'Domain ANC (MeqPerL)', colors = getPalette(colourCount), mode='lines+markers', inherit = F, type='scatter', text=~paste0("Collect Date: ", collectDate, '\n','Domain ANC- NEON: ',ancMeqPerL,' MeqPerL'), alpha=.6, 
                                   hoverinfo='text')
    }
    if (select.analyteB == 'ANC-DOMAIN') {
      d.plot<- d.plot%>% add_trace(data=ANC.data.do, x=~collectDate,y=~ancMeqPerL, yaxis='y2', name = 'Domain ANC (MeqPerL)', colors = getPalette(colourCount), mode='lines+markers', inherit = F, type='scatter', text=~paste0("Collect Date: ", collectDate, '\n','Domain ANC- NEON: ',ancMeqPerL,' MeqPerL'), alpha=.6, 
                                   hoverinfo='text')
    }
    
    D<- ''
    if (nchar(D) == 0) { D<- getwd() }
    unlink(paste0(D,"/WaterWorld"), recursive = T)
    
    d.plot
  })
  
  
  output$Elab <- renderPlotly({
    print(plotInput())
  })
  
  output$Dlab <- renderText({
    
    select.analyte <- Analyte_select()
    select.analyteB <- Analyte_selectB()
    site.pick<- site_select()
    
    paste0('You were comparing ', select.analyte, ' with ',select.analyteB,'! Niceeeeee...')
    
    
  })

} #end of server