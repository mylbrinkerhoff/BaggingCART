# Install and load the bartMachine package
install.packages("bartMachine")
library(bartMachine)
library(ggplot2)

# Example data
data <- data.frame(
  y = rnorm(100),
  x1 = rnorm(100),
  x2 = rnorm(100),
  x3 = rnorm(100)
)

# Fit the BART model
bart_model <- bartMachine(data[, -1], data$y)

# Get variable importance
var_importance <- investigate_var_importance(bart_model)
print(var_importance)

# Convert to data frame for plotting
var_importance_df <- data.frame(
  Variable = names(var_importance$avg_var_props),
  Importance = var_importance$avg_var_props
)

# Plot variable importance
ggplot(var_importance_df, aes(x = reorder(Variable, Importance), y = Importance)) +
  geom_point(stat = "identity") +
  coord_flip() +
  xlab("Variable") +
  ylab("Importance") +
  ggtitle("Variable Importance in BART Model")


# Example data
data <- data.frame(
  y = rnorm(100),
  x1 = rnorm(100),
  x2 = rnorm(100),
  x3 = rnorm(100)
)

# Separate predictors and response variable
X <- data[, c("x1", "x2", "x3")]
y <- data$y

# Fit the BART model
bart_model <- bartMachine(X, y)

# Perform k-fold cross-validation
cv_results <- k_fold_cv(X, y, k_folds = 5)
print(cv_results)

# Fit models with different numbers of trees
num_trees_seq <- seq(25, 1000, by = 25)
errors <- sapply(num_trees_seq, function(nt) {
  model <- bartMachine(X, y, num_trees = nt)
  cv_results <- k_fold_cv(X, y, k_folds = 5)
  return(mean(cv_results$rmse))
})

# Plot the errors
plot(num_trees_seq, errors, type = "b", xlab = "Number of Trees", ylab = "RMSE",
     main = "Error vs. Number of Trees")
