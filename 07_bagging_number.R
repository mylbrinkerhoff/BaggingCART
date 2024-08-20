#-------------------------------------------------------------------------------
#
# 07_bagging_number.R
#
# Generating a Bagging decission tree
#
# M. Brinkerhoff  * UCSC  * 2024-08-16 (F)
#
#-------------------------------------------------------------------------------

# include for background job
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

# Loading Data
slz.clean <- read.csv("data/processed/slz_cleaned.csv", header = TRUE)

### convert certain columns into factors.
slz.clean$Phonation <- factor(slz.clean$Phonation, levels = c("modal", 
                                                              "breathy", 
                                                              "checked", 
                                                              "laryngealized"))
slz.clean$Speaker <- slz.clean$Speaker %>% factor()
slz.clean$Word <- slz.clean$Word %>% factor()
slz.clean$Vowel <- slz.clean$Vowel %>% factor()
slz.clean$Tone <- slz.clean$Tone %>% factor()

# stratified sampling so the training and test sets have similar distributions
table(slz.clean$Phonation) %>% prop.table() # initial distributions of VQ

# stratified sampling with the rsample package
set.seed(123) # needed for reproducibility

split_strat  <- initial_split(slz.clean, prop = 0.7, 
                              strata = "Phonation")
slz_train  <- training(split_strat)
slz_test   <- testing(split_strat)

# consistent response ratio between train & test
table(slz_train$Phonation) %>% prop.table()
table(slz_test$Phonation) %>% prop.table()

# Determining the number of trees
# assess 10-200 bagged trees
ntree <- seq(10, 200, by = 2)

# create empty vector to store OOB RMSE values
rmse <- vector(mode = "numeric", length = length(ntree))

for (i in seq_along(ntree)) {
  # reproducibility
  set.seed(123)
  # perform bagged model
  model <- bagging(
    formula = Phonation ~ H1c.resid + h1h2c + h2h4c + h1a1c + h1a2c + h1a3c +
      h42Kc + h2Kh5Kc + cpp + energy + hnr05 + hnr15 + hnr25 + hnr35 + shr +
      f0 + f1 + f2 + b1 + b2 + epoch + soe,
    data    = slz_train,
    coob    = TRUE,
    control = rpart.control(minsplit = 2, cp = 0),
    nbagg   = ntree[i]
  )
  # get OOB error
  rmse[i] <- model$err
}

bagging_errors <- data.frame(ntree, rmse)

ggplot(bagging_errors, aes(ntree, rmse)) +
  geom_line() +
  geom_hline(yintercept = 41019, lty = "dashed", color = "grey50") +
  annotate("text", x = 100, y = 41385, label = "Best individual pruned tree", vjust = 0, hjust = 0, color = "grey50") +
  annotate("text", x = 100, y = 26750, label = "Bagged trees", vjust = 0, hjust = 0) +
  ylab("RMSE") +
  xlab("Number of trees")



