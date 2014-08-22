# Developing Data Products Project
### Note: Need to run deployApp() from local drive on Windows. 
### Get file not readable error if run deployApp() from shared drive on Windows.

library(shiny)
library(shinyapps)
#library(ISLR)
#library(caret)
#library(Hmisc)
#library(ggplot2)

getwd()
tempfile()

ddpAppDir = getwd()
ddpAppName = "ddp_shiny_project"
ddpAppAccount = "vanhaiho"

configureApp(appName = ddpAppName,
             appDir = ddpAppDir,
             account = ddpAppAccount)

runApp()
deployApp()
deployApp(appDir = ddpAppDir, appName = ddpAppName, account = ddpAppAccount)
terminateApp(ddpAppName)

