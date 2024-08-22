#-------------------------------------------------------------------------------
#
# 07_bagging_number.R
#
# Generating a Bagging decission tree
#
# M. Brinkerhoff  * UCSC  * 2024-08-16 (F)
#
#-------------------------------------------------------------------------------


# Determining the number of trees
# assess 10-200 bagged trees
ntree <- seq(50, 1000, by = 50)

# create empty vector to store OOB RMSE values
rmse <- vector(mode = "numeric", length = length(ntree))

for (i in seq_along(ntree)) {
  # reproducibility
  set.seed(123)
  # perform bagged model
  model <- bagging(
    formula = formula,
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
  # geom_hline(yintercept = 0.45, lty = "dashed", color = "grey50") +
  # annotate("text", x = 200, y = 1, label = "Best individual pruned tree", vjust = 0, hjust = 0, color = "grey50") +
  # annotate("text", x = 200, y = 1, label = "Bagged trees", vjust = 0, hjust = 0) +
  ylab("RMSE") +
  xlab("Number of trees")



