#-------------------------------------------------------------------------------
#
# 00_start_here.R
#
# Loading in the data and required packages
#
# M. Brinkerhoff  * UCSC  * 2024-08-16 (F)
#
#-------------------------------------------------------------------------------

### install packages if not yet installed
packages <- c("lme4","tidyverse","viridis", "rsample", "caret", "rpart", 
              "ipred", "here", "reshape2")
if (length(setdiff(packages, rownames(installed.packages()))) > 0) {
  install.packages(setdiff(packages, rownames(installed.packages())))  
}

# Helper packages
library(tidyverse) # for data manipulation, graphic, and data wrangling
library(viridis) # for colorblind friendly colors in ggplot
library(here)   # for creating pathways relative to the top-level directory
library(reshape2) # for data manipulation

# Modeling process packages
library(lme4)   # for creating residual H1*     
library(rsample)   # for resampling procedures
library(caret)     # for resampling and model training
library(rpart)       # for fitting decision trees
library(ipred)       # for fitting bagged decision trees

# Loading the data

slz <- read.csv(here("data/raw/", "Voice_Master_Split.csv"))

# Create a variable for colorblind palette

colorblind <- palette.colors(palette = "Okabe-Ito")
