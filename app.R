####################################
# Coagulation-flocculation model   #
# Jose A. D. Lopez-Coronado        #
# Agriculture Victoria - 2026      #
####################################

# Load R packages
library(shiny)
library(shinythemes)
library(markdown)

# Read models
dose_mod <- readRDS(
  url(
    "https://raw.githubusercontent.com/jlopezco-wm/coagulation/main/dose_mod.rds",
    "rb"
  )
)

tanfloc_mod <- readRDS(
    url(
      "https://raw.githubusercontent.com/jlopezco-wm/coagulation/main/tanfloc_mod.rds",
      "rb"
    )
  )
    
tanfloc_rem <- readRDS(
    url(
      "https://raw.githubusercontent.com/jlopezco-wm/coagulation/main/tanfloc_rem.rds",
      "rb"
    )
  )


# Define UI
ui <- fluidPage(theme = shinytheme("cerulean"),
                navbarPage(
                  # theme = "cerulean",  # <--- To use a theme, uncomment this
                  "Tanfloc",
                  tabPanel("Calculator",
                           sidebarPanel(
                             numericInput("txt1", "Effluent volume (L):", value = NA, min = 0),
                             numericInput("txt2", "Effluent turbidity (NTU):", value = NA, min = 1000, max = 30000),
                             numericInput("txt3", "Tanfloc concentration (mg/L)", value = NA, min = 1),
                             helpText("Leave this field blank if unknown."),
                             selectInput(
                               inputId = "slc",
                               label = "Objective:",
                               choices = c("Maximum clarification","Moderate clarification")
                             ),
                             actionButton("actionButton", "Calculate", class = "btn-primary")
                           ), # sidebarPanel
                           mainPanel(
                             verbatimTextOutput("contents"),
                             verbatimTextOutput("contents_model"),
                           ) # mainPanel
                           
                  ), # Navbar 1, tabPanel
                  
                  
                  tabPanel(
                    "About",
                    uiOutput("about_md")
                  )
                ) # navbarPage
) # fluidPage

# server
# Define server function  
server <- function(input, output, session) {
  
  # Input Data
  model_output <- eventReactive(input$actionButton,{  
    
    # Validation
    validate(
      need(input$txt1 >= 0,
           "Effluent volume cannot be negative.")
    )
    
    validate(
      need(
        !is.na(input$txt2) || (input$txt2 >= 1000 && input$txt2 <= 30000),
        "Turbidity should be between 1000 and 30000 NTU."
      )
    )
    
    validate(
      need(is.na(input$txt3) || input$txt3 > 0,
           "Concentration should be higher than zero, if unknown leave blank")
    )
    
    withProgress(message = "Estimating Tanfloc dose…", value = 0, {
      
      incProgress(0.1)

    df <- data.frame(
      Name = c("effluent",
               "turbidity",
               "concentration",
               "target"),
      Value = c(as.numeric(input$txt1),
                             as.numeric(input$txt2),
                            if (is.na(input$txt3)){
                               207}
                             else{
                               as.numeric(input$txt3)
                             },
                             if(input$slc == "Maximum clarification"){
                               0}
                               else{
                                 50
                               }
                             ),
      stringsAsFactors = FALSE)
    incProgress(0.3)
    
    #Call for model
    Output2 <- tanfloc_mod(effluent = df[1,2],
                           turbidity = df[2,2],
                           concentration = df[3,2],
                           target = df[4,2])
    incProgress(1)
    Output2
    })
  })
    
    # Status/Output Text Box
  
  output$contents <- renderPrint({
    
    # BEFORE first click
    if (input$actionButton == 0) {
      return("Server is ready for calculation.")
    }
    
    # AFTER click
    result <- try(model_output(), silent = TRUE)
    
    if (inherits(result, "try-error")) {
      "Error!"
    } else {
      "Calculation complete."
    }
  })

    # Model text output
    output$contents_model <- renderText({
      req(input$actionButton)
      model_output()
    })
    
    output$about_md <- renderUI({
      
      about_url <- "https://raw.githubusercontent.com/jlopezco-wm/coagulation/main/About.md"
      
      tmp <- file.path(tempdir(), "About.md")
      
      if (!file.exists(tmp)) {
        download.file(
          about_url,
          tmp,
          mode = "wb",
          quiet = TRUE
        )
      }
      
      div(
        includeMarkdown(tmp),
        align = "justify"
      )
    })
} 

# Create Shiny object
shinyApp(ui = ui, server = server)


