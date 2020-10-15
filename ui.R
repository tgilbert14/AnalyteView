#---user interface--------------------------------------------------  
ui <- dashboardPage(skin = 'purple',
                        header=dashboardHeaderPlus(title='Analyte Compare (SWC)'),
                        
  dashboardSidebar(
      selectInput("Select", "Please type and select your site:",
                  choices = c("SYCA", "ARIK","BARC","BIGC","BLDE","BLUE","BLWA","CARI","COMO","CRAM","CUPE","FLNT","GUIL","HOPB","KING","LECO","LEWI","LIRO","MART","MAYF","MCDI","MCRA","OKSR","POSE","PRIN","PRLA","PRPO","REDB","SUGG","TECR","TOMB","TOOK","WALK","WLOU"), selected = F, multiple = T),
      selectInput("Select_A", "Please select main analyte:",
                  choices = c('Acid Neutralizing Capacity(ANC)'='ANC','Bicarbonate Concentration(Br)'='Br','Calcium Concentration(Ca)'='Ca','Chlorine Concentration(Cl)'='Cl','Carbonate Concentration(C)'='CO3','Conductivity'='conductivity','Dissolved Inorganic Carbon(DIC)'='DIC','Dissolved Organic Carbon(DOC)'='DOC','Fluorine Concentration(F)'='F','Iron Concentration(Fe)'='Fe','Bicarbonate Concentration(HCO3)'='HCO3','Potassium Concentration(K)'='K','Magnesium Concentration(Mg)'='Mg','Manganese Concentration(Mn)'='Mn','Sodium Concentration(Na)'='Na','Ammonium Concentration(NH4)'='NH4 - N','Nitrogen Dioxide(NO2-N)'='NO2 - N','Nitrate(NO3+NO2-N)'='NO3+NO2 - N','Orthophosphate Concentration(Ortho-P)'='Ortho - P','pH(pH)'='pH','Silica Concentration(Si)'='Si','Sulfate Concentrations(SO4)'='SO4','Total Dissolved Nitrogen(TDN)'='TDN','Total Dissolved Phosphorus(TDP)'='TDP','Total Dissolved Solids(TDS)'='TDS','Total Nitrogen(TN)'='TN','Total Organic Carbon(TOC)'='TOC','Total Phosphorus(TP)'='TP','Total Particulate Carbon(TPC)'='TPC','Total Particulate Nitrogen(TPN)'='TPN','Total Suspended Solids(TSS)'='TSS','Dry Mass Suspended Solids(TSS-D)'='TSS - Dry Mass','UV Absorbance (250 nm)','UV Absorbance (280 nm)'), selected = F, multiple = F),
      selectInput("Select_B", "Please select secondary analyte:",
                  choices = c('Acid Neutralizing Capacity(ANC)'='ANC','Bicarbonate Concentration(Br)'='Br','Calcium Concentration(Ca)'='Ca','Chlorine Concentration(Cl)'='Cl','Carbonate Concentration(C)'='CO3','Conductivity'='conductivity','Dissolved Inorganic Carbon(DIC)'='DIC','Dissolved Organic Carbon(DOC)'='DOC','Fluorine Concentration(F)'='F','Iron Concentration(Fe)'='Fe','Bicarbonate Concentration(HCO3)'='HCO3','Potassium Concentration(K)'='K','Magnesium Concentration(Mg)'='Mg','Manganese Concentration(Mn)'='Mn','Sodium Concentration(Na)'='Na','Ammonium Concentration(NH4)'='NH4 - N','Nitrogen Dioxide(NO2-N)'='NO2 - N','Nitrate(NO3+NO2-N)'='NO3+NO2 - N','Orthophosphate Concentration(Ortho-P)'='Ortho - P','pH(pH)'='pH','Silica Concentration(Si)'='Si','Sulfate Concentrations(SO4)'='SO4','Total Dissolved Nitrogen(TDN)'='TDN','Total Dissolved Phosphorus(TDP)'='TDP','Total Dissolved Solids(TDS)'='TDS','Total Nitrogen(TN)'='TN','Total Organic Carbon(TOC)'='TOC','Total Phosphorus(TP)'='TP','Total Particulate Carbon(TPC)'='TPC','Total Particulate Nitrogen(TPN)'='TPN','Total Suspended Solids(TSS)'='TSS','Dry Mass Suspended Solids(TSS-D)'='TSS - Dry Mass','UV Absorbance (250 nm)','UV Absorbance (280 nm)'), selected = F, multiple = F),
      submitButton("Process Selection(s)"),
    
      sidebarMenu(
        menuItem('About',tabName='readme',icon=icon('info-circle')),
        menuItem('Correlation Report',tabName = 'C',icon=icon('newspaper')),
        menuItem('Comparison Plot',tabName = 'E',icon=icon('chart-area')),
        menuItem('Regression Analysis',tabName = 'D',icon=icon('laptop-code')),
        menuItem('Data Table',tabName = 'dtable',icon=icon('table')),
        menuItem('MLR Model',tabName = 'model', icon=icon('robot'))
      )
    ),
    
    dashboardBody("May take up to several minutes to load all data from various NEON data products",
            tabItems(  
                #plot
                tabItem(tabName = 'E',
                        fluidRow(
                          box(title='Analyte Comparisons',
                              footer = 'Relationship through time between analytes taken from Water Chemistry Samples',
                              status = 'info',
                              collapsible = T,
                              collapsed = F,
                              solidHeader = F,
                              height='650',
                              width='12',
                              column(12,withSpinner(plotlyOutput('Elab'), image = 'https://i.pinimg.com/originals/52/16/80/5216809ff35e0daf8bcada59fa04f3c4.gif',  image.height = '750px', image.width = '1000px', proxy.height = '500px'),
                                     
                                     style='height:500px;overflow-y:scroll'
                                )
                              )
                            )
                          ),
                #correlations
                tabItem(tabName = 'C',
                        fluidRow(
                          box(title='Correlation Report',
                              footer = 'Calculating correlations between main analyte to the others',
                              status = 'info',
                              collapsible = T,
                              collapsed = F,
                              solidHeader = F,
                              height='650',
                              width='12',
                              column(12,withSpinner(dataTableOutput('patterns'), image = 'https://i.pinimg.com/originals/52/16/80/5216809ff35e0daf8bcada59fa04f3c4.gif',  image.height = '750px', image.width = '1000px', proxy.height = '500px'),
                                     
                                     style='height:500px;overflow-y:scroll'
                              )
                          )
                        )
                ),
                
                          #Pvalue plot
                          tabItem(tabName = 'D',
                                  fluidRow(
                                    box(title='Analyte Statistical Analysis',
                                        footer = 'Linear Regression Plot',
                                        status = 'info',
                                        collapsible = T,
                                        collapsed = F,
                                        solidHeader = F,
                                        height='550',
                                        width='12',
                                        column(12,withSpinner(plotlyOutput('Dlab'), image = 'https://i.pinimg.com/originals/52/53/35/52533552584f2c81e63ee15a2f4ee468.gif', image.height = '800px', image.width = '1200px'),
                                               
                                               style='height:400px;overflow-y:scroll'
                                        )
                                    ),
                                    
                                    box(title='Analyte P-value summary',
                                        footer = 'Summary of P-value by Analyte Concentrations by Date',
                                        status = 'info',
                                        collapsible = T,
                                        collapsed = F,
                                        solidHeader = F,
                                        height='500',
                                        width='12',
                                        column(12,withSpinner(verbatimTextOutput('PvalueSUM'), image = 'https://media.giphy.com/media/yGhIqFuOx84KY/source.gif', image.height = '600px', image.width = '1200px', proxy.height = '300px'),
                                               
                                               style='height:400px;overflow-y:scroll'
                                        )
                                    ),
                        )
                    ),
                #plot
                tabItem(tabName = 'dtable',
                        fluidRow(
                          box(title='Data Table',
                              footer = 'Data table of relationship being plotted for Analyte Analysis',
                              status = 'info',
                              collapsible = T,
                              collapsed = F,
                              solidHeader = F,
                              height='650',
                              width='12',
                              column(12,withSpinner(dataTableOutput('table'), image = 'https://media.giphy.com/media/yGhIqFuOx84KY/source.gif',  image.height = '600px', image.width = '1000px', proxy.height = '1000px'),
                                     
                                     style='height:500px;overflow-y:scroll'
                              )
                          )
                        )
                ),

tabItem(tabName = 'model',
        fluidRow(
          box(title='Predictive model results',
              footer = 'Machine Learning model using mlr package for choosen "main" analyte: Model = "regr.glm" [percent based on CrossValidation w/10 fold, 40 reps]',
              status = 'info',
              collapsible = T,
              collapsed = F,
              solidHeader = F,
              height='650',
              width='12',
              column(12,withSpinner(plotOutput('predict'), image = 'https://media.giphy.com/media/yGhIqFuOx84KY/source.gif',  image.height = '600px', image.width = '1000px', proxy.height = '1000px'),
                     
                     style='height:500px;overflow-y:scroll'
              )
          )
        )
),

#readme
tabItem(tabName='readme',
        htmlOutput('appreadme')
)

            )
  )
)

