#---user interface--------------------------------------------------  
ui <- dashboardPage(skin = 'blue',

                        header=dashboardHeaderPlus(title='AOS Comparisons'),
                        
  dashboardSidebar(
      selectInput("Select", "Please type and select your site:",
                  choices = c("SYCA", "ARIK","BARC","BIGC","BLDE","BLUE","BLWA","CARI","COMO","CRAM","CUPE","FLNT","GUIL","HOPB","KING","LECO","LEWI","LIRO","MART","MAYF","MCDI","MCRA","OKSR","POSE","PRIN","PRLA","PRPO","REDB","SUGG","TECR","TOMB","TOOK","WALK","WLOU"), selected = F, multiple = T),
      selectInput("Select_A", "Please select one of these Analytes [External Lab]:",
                  choices = c('ANC','Br','Ca','Cl','CO3','Conductivity'='conductivity','DIC','DOC','F','Fe','HCO3','K','Mg','Mn','Na','NH4 - N','NO2 - N','NO3+NO2 - N','Ortho - P','pH','Si','SO4','TDN','TDP','TDS','TN','TOC','TP','TPC','TPN','TSS','TSS - Dry Mass','UV Absorbance (250 nm)','UV Absorbance (280 nm)','Discharge'='Discharge-FIELD'), selected = F, multiple = F),
      selectInput("Select_B", "Please select something to compare it to:",
                  choices = c('Discharge'='Discharge-FIELD','ANC','Br','Ca','Cl','CO3','Conductivity'='conductivity','DIC','DOC','F','Fe','HCO3','K','Mg','Mn','Na','NH4 - N','NO2 - N','NO3+NO2 - N','Ortho - P','pH','Si','SO4','TDN','TDP','TDS','TN','TOC','TP','TPC','TPN','TSS','TSS - Dry Mass','UV Absorbance (250 nm)','UV Absorbance (280 nm)'), selected = F, multiple = F),
      submitButton("    Process NEON Site Selection    "),
    
    #These inputs dont work.. need if statements in server.R to work
    ## 'Domain ANC'='ANC-DOMAIN','Domain ALK'='ALK-DOMAIN'
    
    
      sidebarMenu(
        menuItem('Analyte Comaprison',tabName = 'E',icon=icon('chart-area')),
        
        menuItem('Analtye Analysis',tabName = 'D',icon=icon('laptop-code')),
        
        menuItem('Data Table',tabName = 'dtable',icon=icon('table'))
        
      
      )
    ),
    
    dashboardBody("May take up to several minutes to load all data from various NEON data products",
            tabItems(  
                #plot
                tabItem(tabName = 'E',
                        fluidRow(
                          box(title='Analyte Comparisons',
                              footer = 'Looking at analyte data on NEON portal',
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
                
                          #Pvalue plot
                          tabItem(tabName = 'D',
                                  fluidRow(
                                    box(title='Analyte Statistical Analysis',
                                        footer = 'Looking at analyte consentration relationships',
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
 
                          box(title='Analyte P-value',
                              footer = 'Summary of linear regression model (lm)',
                              status = 'info',
                              collapsible = T,
                              collapsed = F,
                              solidHeader = F,
                              height='450',
                              width='12',
                              column(12,withSpinner(verbatimTextOutput('Pvalue'), image = 'https://media.giphy.com/media/yGhIqFuOx84KY/source.gif', proxy.height = '50px'),
                                     
                                     style='height:300px;overflow-y:scroll'
                              )
                          )
                        )
                    ),
                #plot
                tabItem(tabName = 'dtable',
                        fluidRow(
                          box(title='Data Table',
                              footer = 'Looking at NEON data being analyzed in Analyte Analysis',
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
                )
            )
  )
)

