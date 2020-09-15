server <- function(input, output, session) {
  
  # downloading data
  site_select <- reactive({
    site.pick<- input$Select # saving site selection
    site.pick<- input$Select
    req(input$Select)
    
    dpid <- "DP1.20093.001"   # surface Water Chemistry DPID
    data.swc<- loadByProduct(dpid, site = site.pick, startdate = '2017-01', check.size = F)

    External.data<- data.swc$swc_externalLabDataByAnalyte
    
  }) # end of data download


  # analyte selections
  Analyte_select <- reactive({
    select.analyte<- input$Select_A # saving site selection
    req(input$Select_A)
  })
  Analyte_selectB <- reactive({
    select.analyteB<- input$Select_B # saving site selection
    req(input$Select_B)
  }) # end of analyte selections
  
  mlr<- reactive({
  f_data <- fit_data
  })
  
  # analyte compare plot1
  plotInput <- reactive({
    
    External.data <- site_select()     # pulling from NEON site selection
    select.analyte <- Analyte_select()
    select.analyteB <- Analyte_selectB()
    site.pick<- site_select()
 
    # External Lab data
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
  })
  
  
  output$Elab <- renderPlotly({
    print(plotInput())
  })
  
  
  # analyte compare plot2
  plotInput2 <- reactive({
    
    External.data <- site_select()     # pulling from NEON site selection
    select.analyte <- Analyte_select()
    select.analyteB <- Analyte_selectB()
    site.pick<- site_select()
    
    # External Lab data
    analyte_data<- External.data %>%
      filter(analyte == select.analyte) %>%
      select(analyte, analyteConcentration, analyteUnits, collectDate) %>% 
      # mutate(collectDate = substr(collectDate,1,10)) %>% 
      arrange(collectDate)
    
    analyte_dataB<- External.data %>%
      filter(analyte == select.analyteB) %>%
      select(analyte, analyteConcentration, analyteUnits, collectDate) %>% 
      # mutate(collectDate = substr(collectDate,1,10)) %>% 
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
    
    # anova()
    # t.test(analytes$analyteConcentration.y,analytes$analyteConcentration.x)
    

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
      # mutate(collectDate = substr(collectDate,1,10)) %>% 
      arrange(collectDate)
    
    analyte_dataB<- External.data %>%
      filter(analyte == select.analyteB) %>%
      select(analyte, analyteConcentration, analyteUnits, collectDate) %>% 
      # mutate(collectDate = substr(collectDate,1,10)) %>% 
      arrange(collectDate)
    
    analytes<- left_join(analyte_data, analyte_dataB, by= 'collectDate')
    
    # analyte_union<- union(analyte_data, analyte_dataB, by= 'collectDate')
    # analytes1<- analyte_union %>% 
    #   select(analyte, analyteConcentration)
     
    mdl_1<-lm(analyteConcentration.y ~ analyteConcentration.x,data = analytes)
    
    # t.test(data= analytes1, analyteConcentration ~ analyte)
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
      # mutate(collectDate = substr(collectDate,1,10)) %>% 
      arrange(collectDate)
    
    analyte_dataB<- External.data %>%
      filter(analyte == select.analyteB) %>%
      select(analyte, analyteConcentration, analyteUnits, collectDate) %>% 
      # mutate(collectDate = substr(collectDate,1,10)) %>% 
      arrange(collectDate)
    
    
    analytes<- left_join(analyte_data, analyte_dataB, by= 'collectDate')
    
  })
  
  output$predict <- renderText({
    
    #External.data <- site_select()
    select.analyte <- Analyte_select()
    f_data<- mlr()
    
    # define a task (what want to achieve) - Target is variable trying to predict
    ANCTask <- makeRegrTask(data = f_data, target = select.analyte)
    
    # choose a Learner for model- listLearners("regr")$class
    lm <- makeLearner('regr.glm', predict.type = 'response')

    # must define task, learner, and train model
    lmModel<- train(lm, ANCTask)
    
    # testing
    # cross validation w/ 10 fold and 50 reps
    
    kFold<- makeResampleDesc("RepCV", fold = 10, reps = 40) # repeat cross validation ('RepCV')
    kFoldCV<- resample(learner = lm, task = ANCTask, resampling = kFold)
    
    mse.test.mean<- kFoldCV$aggr
    mse<- (1-mse.test.mean)*100
    
    if (mse > 0) {
    result<- print(paste0(select.analyte, " can be predicted with present analyte data present within ~", round(mse, 2), "% of the time (data from all sites)"))
    }
    
    if (mse < 0) {
    result<- print(paste0(select.analyte, " CANNOT be predicted with present analyte data: ~", round(mse, 2), "% value returned"))
    }
    
    result
    #pred<- predictLearner(.learner = lm, .model = lmModel, .newdata = new.d)
    #as_tibble(pred)  
  
  })
  
  
  c_check<- reactive({
    
    External.data <- site_select()
    select.analyte <- Analyte_select()
    select.analyteB <- Analyte_selectB()
    site.pick<- site_select()
    
    alist<- c('ANC','Br','Ca','Cl','CO3','conductivity','DIC','DOC','F','Fe','HCO3','K','Mg','Mn','Na','NH4 - N','NO2 - N','NO3+NO2 - N','Ortho - P','pH','Si','SO4','TDN','TDP','TDS','TN','TOC','TP','TPC','TPN','TSS','TSS - Dry Mass','UV Absorbance (250 nm)','UV Absorbance (280 nm)')
    
    correlation <- data.table(Analyte=character(),Correlation=numeric())

    ## checking first analyte
    analyte_data<- External.data %>%
      filter(analyte == select.analyte) %>%
      select(analyte, analyteConcentration, collectDate) %>%
      # mutate(collectDate = substr(collectDate,1,10)) %>% 
      arrange(collectDate)
    # head(analyte_data)
    i=1
    while (i < length(alist)+1 ) {
      
      analyte_dataB<- External.data %>%
        filter(analyte == alist[i]) %>%
        select(analyte, analyteConcentration, collectDate) %>% 
        # mutate(collectDate = substr(collectDate,1,10)) %>% 
        arrange(collectDate)
      
      analytes<- left_join(analyte_data, analyte_dataB, by= 'collectDate')
      
      correlation[[i,2]]<- cor(analytes$analyteConcentration.x, analytes$analyteConcentration.y)
      correlation[[i,1]]<- paste0(analytes$analyte.y[1])
      
      i=i+1
    }
    
    correlation<- correlation %>%
      arrange(desc(Correlation))
    
    i=1
    while (i < length(alist)+1 ) {
    if(is.na(correlation[[i,2]])) {
      correlation[[i,2]]<- ('Not enough data')
    }
      i=i+1
    }
    
    correlationA<- correlation %>%
      filter(Analyte != select.analyte)
    
  })
  
  output$patterns<- renderDataTable({
    
    print(c_check())
    
  })
  
  #Readme - make into HTML
  output$appreadme<-renderUI({includeHTML('AppReadme.html')})
  
} #end of server