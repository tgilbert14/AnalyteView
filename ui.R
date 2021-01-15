#---user interface--------------------------------------------------  
ui <- dashboardPage(skin = 'purple',
                        header=dashboardHeaderPlus(title='Analyte Compare (SWC)'),
                        
  dashboardSidebar(
      selectInput("Select", "Please type and select your site:",
                  choices = c("SYCA - Sycamore Creek, AZ [Desert Southwest]" = 'SYCA', "ARIK - Arikaree, CO [Central Plains]"="ARIK",
                              "BARC - Barco Lake, FL [Southeast]"="BARC","BIGC - Upper Big Creek, CA [Pacific Southwest]"='BICG',
                              "BLDE - Blacktail Deer Creek, WY [Northern Rockies]"="BLDE","BLUE - Blue River, OK [Southern Plains]"="BLUE",
                              "BLWA - Black Warrior River, AL [Ozarks Complex]"="BLWA","CARI - Caribou Creek, AK [Taiga]"="CARI",
                              "COMO - Como Creek, CO [Southern Rockies and Coloado Plateau]"="COMO","CRAM - Cramton Lake, WI [Great Lakes]"="CRAM",
                              "CUPE - Rio Cupeyes, PR [Atlantic Neotropical]"="CUPE","FLNT - Flint River, GA [Southeast]"="FLNT",
                              "GUIL - Rio Guilarte, PR [Atlantic Neotropical]"="GUIL","HOPB - Hop Brook, MA [Northeast]"="HOPB",
                              "KING - Kings Creek, KA [Prairie Peninsula]"="KING","LECO - LeConte Creek, TN [Appalachians and Cumberland Plateau]"="LECO",
                              "LEWI - Lewis Run, VA [Mid-Atlantic]"="LEWI","LIRO - Little Rock Lake, WI [Great Lakes]"="LIRO",
                              "MART - Martha Creek, WA [Pacific Northwest]"="MART","MAYF - Mayfield Creek, AL [Ozarks Complex]"="MAYF",
                              "MCDI - McDiffett Creek, KA [Prairie Peninsula]"="MCDI","MCRA - McRae Creek, OR [Pacific Northwest]"="MCRA","OKSR - Oksrukuyik, AK [Tundra]"="OKSR",
                              "POSE - Posey Creek, VA [Mid-Atlantic]"="POSE","PRIN - Pringle Creek, TX [Southern Plains]"="PRIN",
                              "PRLA - Prairie Lake, ND [Northern Plains]"="PRLA","PRPO - Prairie Pothole, ND [Northern Plains]"="PRPO",
                              "REDB - Red Butte Creek, UT [Great Baisn]"="REDB","SUGG - Suggs Lake, FL [Southeast]"="SUGG",
                              "TECR - Teakettle 2 Creek, CA [Pacific Southwest]"="TECR","TOMB - Tombigbee River, AL [Ozarks Complex]"="TOMB",
                              "TOOK - Toolik Lake, AK [Tundra]"="TOOK","WALK - Walker Branch, TN [Appalachians and Cumberland Plateau]"="WALK",
                              "WLOU - West St Louis Creek, CO [Rockies and Colorado Plateau]"="WLOU"),
                  selected = F, multiple = T),
      
      dateRangeInput('dateRange',label='Select Date Range',start=Sys.Date()-21,end=Sys.Date()),
      
      selectInput("Select_A", "Please select main analyte:",
                  choices = c('Acid Neutralizing Capacity(ANC)'='ANC','Bicarbonate Concentration(Br)'='Br','Calcium Concentration(Ca)'='Ca','Chlorine Concentration(Cl)'='Cl','Carbonate Concentration(C)'='CO3','Conductivity'='specificConductance','Dissolved Inorganic Carbon(DIC)'='DIC','Dissolved Organic Carbon(DOC)'='DOC','Fluorine Concentration(F)'='F','Iron Concentration(Fe)'='Fe','Bicarbonate Concentration(HCO3)'='HCO3','Potassium Concentration(K)'='K','Magnesium Concentration(Mg)'='Mg','Manganese Concentration(Mn)'='Mn','Sodium Concentration(Na)'='Na','Ammonium Concentration(NH4)'='NH4 - N','Nitrogen Dioxide(NO2-N)'='NO2 - N','Nitrate(NO3+NO2-N)'='NO3+NO2 - N','Orthophosphate Concentration(Ortho-P)'='Ortho - P','pH(pH)'='pH','Silica Concentration(Si)'='Si','Sulfate Concentrations(SO4)'='SO4','Total Dissolved Nitrogen(TDN)'='TDN','Total Dissolved Phosphorus(TDP)'='TDP','Total Dissolved Solids(TDS)'='TDS','Total Nitrogen(TN)'='TN','Total Organic Carbon(TOC)'='TOC','Total Phosphorus(TP)'='TP','Total Particulate Carbon(TPC)'='TPC','Total Particulate Nitrogen(TPN)'='TPN','Total Suspended Solids(TSS)'='TSS','Dry Mass Suspended Solids(TSS-D)'='TSS - Dry Mass','UV Absorbance (250 nm)','UV Absorbance (280 nm)'), selected = F, multiple = F),
      selectInput("Select_B", "Please select secondary analyte:",
                  choices = c('Acid Neutralizing Capacity(ANC)'='ANC','Bicarbonate Concentration(Br)'='Br','Calcium Concentration(Ca)'='Ca','Chlorine Concentration(Cl)'='Cl','Carbonate Concentration(C)'='CO3','Conductivity'='specificConductance','Dissolved Inorganic Carbon(DIC)'='DIC','Dissolved Organic Carbon(DOC)'='DOC','Fluorine Concentration(F)'='F','Iron Concentration(Fe)'='Fe','Bicarbonate Concentration(HCO3)'='HCO3','Potassium Concentration(K)'='K','Magnesium Concentration(Mg)'='Mg','Manganese Concentration(Mn)'='Mn','Sodium Concentration(Na)'='Na','Ammonium Concentration(NH4)'='NH4 - N','Nitrogen Dioxide(NO2-N)'='NO2 - N','Nitrate(NO3+NO2-N)'='NO3+NO2 - N','Orthophosphate Concentration(Ortho-P)'='Ortho - P','pH(pH)'='pH','Silica Concentration(Si)'='Si','Sulfate Concentrations(SO4)'='SO4','Total Dissolved Nitrogen(TDN)'='TDN','Total Dissolved Phosphorus(TDP)'='TDP','Total Dissolved Solids(TDS)'='TDS','Total Nitrogen(TN)'='TN','Total Organic Carbon(TOC)'='TOC','Total Phosphorus(TP)'='TP','Total Particulate Carbon(TPC)'='TPC','Total Particulate Nitrogen(TPN)'='TPN','Total Suspended Solids(TSS)'='TSS','Dry Mass Suspended Solids(TSS-D)'='TSS - Dry Mass','UV Absorbance (250 nm)','UV Absorbance (280 nm)'), selected = F, multiple = F),
      submitButton("Process Selection(s)"),
    
      sidebarMenu(
        menuItem('Comparison Plot',tabName = 'E',icon=icon('chart-area')),
        menuItem('Correlation Report',tabName = 'C',icon=icon('newspaper')),
        menuItem('Regression Analysis',tabName = 'D',icon=icon('laptop-code')),
        menuItem('Data Table',tabName = 'dtable',icon=icon('table')),
        menuItem('MLR Model',tabName = 'model', icon=icon('robot')),
        menuItem('About',tabName='readme',icon=icon('info-circle'))
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

