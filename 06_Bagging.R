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
  formula = Sale_Price ~ .,
  data    = ames_train,
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