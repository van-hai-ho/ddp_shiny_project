# Global variables
library(ISLR)
library(ggplot2)
data(Wage)

# Get current year
currentYear <- as.numeric(format(Sys.Date(), "%Y"))
years <- c(1900:currentYear)
educationLevels <- as.character(sort(unique(Wage$education)))
jobClass <- as.character(sort(unique(Wage$jobclass)))
raceGroups <- as.character(sort(unique(Wage$race)))
maritalStatus <- as.character(sort(unique(Wage$maritl)))
Wage$health <- factor(Wage$health, labels = c("1. Yes", "2. No"))
healthStatus <- as.character(sort(unique(Wage$health)))
healthInsStatus <- as.character(sort(unique(Wage$health_ins)))

summary(Wage)
dim(Wage)
