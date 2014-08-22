
# This is the server logic for a Shiny web application that predicts
# wages according to your input.
#
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#
# 

library(shiny)
library(kernlab)
library(mlr)
#library(caret)
library(stats)

# testCase 
testCase <- list(year = currentYear,
                 age = currentYear - years[91],
                 education = educationLevels[1],
                 jobclass = jobClass[1],
                 race = raceGroups[1],
                 maritl = maritalStatus[1],
                 health = healthStatus[1],
                 health_ins = healthInsStatus[1])

trainModel <- function(trainMethod = "glm") {
    #modelFile <- "wageGlm.RData"
    modelFile <- "wageLm.RData"
    if (file.exists(modelFile)) {
        # load the model previously built
        load(modelFile)
    } else {
        # there is no model, build it now
        # Exclude sex and region as these variables only 1 single value
        # Exclude logwage as this is a calculated log wage
        Wage <- subset(Wage, select = -c(sex, region, logwage))
        
        # Fit Linear Regression Model onto the data set
        wageModel <- lm(wage ~ year + age + maritl + race + education + jobclass + health + health_ins, 
                     data = Wage)
        
        # Save this model
        save(wageModel, file = modelFile)
    }
    wageModel
}

wageModel <- trainModel()

#predictedWage <- predict(wageGlm, testCase)

shinyServer(function(input, output, session) {
    
    # Calculate prediction for selected input if Calculate button is clicked
    observe({
        
        testCase$age <- currentYear - as.numeric(input$age)
        testCase$education <- input$education
        testCase$jobclass <- input$jobclass
        testCase$race <- input$race
        testCase$maritl <- input$maritl
        testCase$health <- input$health
        testCase$health_ins <- input$healthIns
        
        # Predict salary for selected input
        predictedWage <- predict(wageModel, testCase)
        output$predictedWage <- renderText({predictedWage})
        output$wagePlot <- renderPlot({
            
            # Plot histogram on wages
            # Add line for predicted wage
            g <- ggplot(Wage, aes(x = Wage$wage)) + 
                geom_histogram(binwidth = 5, colour = "darkgreen", aes(fill = ..count..)) +
                scale_fill_gradient("Polulation Count", low = "white", high = "lightskyblue1") +
                xlab("Mid-Atlantic Salary Distribution") +
                ylab("Poplulation Count") +
                ggtitle("Predicted salary compared to the population salaries\n") +
                theme(plot.title = element_text(lineheight = 1, face = "bold"))
            g <- g + geom_vline(xintercept = predictedWage, colour = "red", lwd = 1)
            g
        })
        
        # plot group
        output$wageAgeEduPlot <- renderPlot({
            g2 <- qplot(age, wage, colour = education, data = Wage)
            g2 <- g2 + 
                ggtitle("Predicted salary compared with the population age and education\n") +
                theme(plot.background = element_rect(fill = "transparent"), 
                      legend.position = c(1, 1),
                      legend.justification = c(1, 1),
                      axis.text.x = element_text(angle = 90, vjust=0.5, size = 10),
                      plot.title = element_text(lineheight = 1, face = "bold")) 
            g2 <- g2 + geom_vline(xintercept = testCase$age, colour = "darkblue", lwd = 1)
            g2 <- g2 + geom_hline(yintercept = predictedWage, colour = "red", lwd = 1)
            g2
        })
    })
    
    
})
