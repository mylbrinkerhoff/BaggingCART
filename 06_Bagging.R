#-------------------------------------------------------------------------------
#
# 06_Bagging.R
#
# Generating a Bagging decission tree
#
# M. Brinkerhoff  * UCSC  * 2024-08-16 (F)
#
#-------------------------------------------------------------------------------

# make bootstrapping reproducible
set.seed(123)

# train bagged model
slz_bag1 <- bagging(
  formula = Phonation ~ H1c.resid + h1h2c + h2h4c + h1a1c + h1a2c + h1a3c +
    h42Kc + h2Kh5Kc + cpp + energy + hnr05 + hnr15 + hnr25 + hnr35 + shr +
    f0 + f1 + f2 + b1 + b2 + epoch + soe,
  data = slz_train,
  nbagg = 100, 
  coob = T, 
  control = rpart.control(minsplit = 2, cp = 0)
)

slz_bag1

# Applying with caret to use 10-fold CV to see how well it performs
slz_bag2 <- train(
  Phonation ~ H1c.resid + h1h2c + h2h4c + h1a1c + h1a2c + h1a3c +
    h42Kc + h2Kh5Kc + cpp + energy + hnr05 + hnr15 + hnr25 + hnr35 + shr +
    f0 + f1 + f2 + b1 + b2 + epoch + soe,
  data = slz_train,
  method = "treebag",
  trControl = trainControl(method = "cv", number = 10),
  nbagg = 200,  
  control = rpart.control(minsplit = 2, cp = 0)
)

slz_bag2

