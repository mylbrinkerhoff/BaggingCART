#-------------------------------------------------------------------------------
#
# 05_Training_Test.R
#
# Creating stratified training and test data
#
# M. Brinkerhoff  * UCSC  * 2024-08-16 (F)
#
#-------------------------------------------------------------------------------

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
table(train_strat$Phonation) %>% prop.table()
table(test_strat$Phonation) %>% prop.table()
