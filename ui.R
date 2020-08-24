#---user interface--------------------------------------------------  
ui <- fluidPage(
  titlePanel("AOS Comparison"),
  sidebarLayout(
    sidebarPanel(
      selectInput("Select", "Please type and select your site:",
                  choices = c("SYCA", "ARIK","BARC","BIGC","BLDE","BLUE","BLWA","CARI","COMO","CRAM","CUPE","FLNT","GUIL","HOPB","KING","LECO","LEWI","LIRO","MART","MAYF","MCDI","MCRA","OKSR","POSE","PRIN","PRLA","PRPO","REDB","SUGG","TECR","TOMB","TOOK","WALK","WLOU"), selected = F, multiple = T),
      selectInput("Select_A", "Please select one of these Analytes [External Lab]:",
                  choices = c('ANC','ANC-DOMAIN','ALK-DOMAIN','Br','Ca','Cl','CO3','conductivity','DIC','Discharge-FIELD','DOC','F','Fe','HCO3','K','Mg','Mn','Na','NH4 - N','NO2 - N','NO3+NO2 - N','Ortho - P','pH','Si','SO4','TDN','TDP','TDS','TN','TOC','TP','TPC','TPN','TSS','TSS - Dry Mass','UV Absorbance (250 nm)','UV Absorbance (280 nm)'), selected = F, multiple = F),
      selectInput("Select_B", "Please select something to compare it to:",
                  choices = c('ANC','ANC-DOMAIN','ALK-DOMAIN','Br','Ca','Cl','CO3','conductivity','DIC','Discharge-FIELD','DOC','F','Fe','HCO3','K','Mg','Mn','Na','NH4 - N','NO2 - N','NO3+NO2 - N','Ortho - P','pH','Si','SO4','TDN','TDP','TDS','TN','TOC','TP','TPC','TPN','TSS','TSS - Dry Mass','UV Absorbance (250 nm)','UV Absorbance (280 nm)'), selected = F, multiple = F),
      submitButton("    Process NEON Site Selection    "),
    ),
    
    mainPanel("May take up to several minutes to load all data from various NEON data products",
              tabsetPanel(
                tabPanel("Analyte Comparisons",
                         withSpinner(plotlyOutput("Elab"))),
                tabPanel("Analyte Selection",
                         withSpinner(tableOutput("Dlab")))
                #  downloadButton('down', 'Download Plot')
              )
    )
  )
)