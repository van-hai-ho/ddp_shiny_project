
# This is the user-interface definition of a Shiny Salary Estimation
# web application.
#
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(markdown)

calculationPanel <- function() {
    # Sidebar with a input on the left panel, out put on the right panel
    sidebarLayout(
        sidebarPanel(
            verticalLayout(
                wellPanel(
                    # Select box for age, education, jobclass, race, marital status and health
                    selectInput("age", "Year of Birth:", years, selected = years[91]),
                    selectInput("education", "Education Level", educationLevels),
                    selectInput("jobclass", "Job Area:", jobClass),
                    selectInput("race", "Ethnic  Background:", raceGroups),
                    selectInput("maritl", "Marital Status", maritalStatus),
                    selectInput("health", "Are you entitled for disable allowance?", 
                                healthStatus, selected = healthStatus[1]),
                    selectInput("healthIns", "Do you currently have health insurance?", 
                                healthInsStatus, selected = healthInsStatus[2])
                ),
                wellPanel(
                    # include notes to explain the output result
                    includeHTML("www/salary_estimation_notes.html")
                )
            )
        ),
        
        # Show a plot of the generated distribution and predicted wage for 
        # selected input
        mainPanel(
            wellPanel(
                span(strong("Estimated salary:"),
                     textOutput("predictedWage")
                )
            ),
            plotOutput("wagePlot"),
            plotOutput("wageAgeEduPlot")
        )
    )
}

summaryPanel <- function() {
    wellPanel(
        a(href="ddp_analysis_slides/index.html", 
          "Salary Estimation Application Summary Slides")
    )
}

documentPanel <- function() {
    wellPanel( 
        includeHTML("www/salary_estimation_manual.html")
    )
}

shinyUI(navbarPage("Salary Estimation",
    
    tabPanel("Calculation", calculationPanel()),
    tabPanel("Summary", summaryPanel()),
    tabPanel("Documentation", documentPanel())
))


