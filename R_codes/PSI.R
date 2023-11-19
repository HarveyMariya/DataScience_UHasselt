# Homework 1
# Since it is from a binomial distribution

# n = 10, p = (0, 1) , 15 independent observations
sample <- c(7, 1, 5, 1, 3, 3, 3, 3, 6, 5, 4, 5, 3, 2, 4)

# Question 1
# calculating the mean
np <- mean(sample)
n <- 10
np

# calculating the probability
p <- (np / n)


# Question 2

set.seed(1111)

n_sim <- 1000
np_Mom <- as.vector(n_sim)

for (i in 1:n_sim) {
  sample_sim <- rbinom(n_sim, n, p)
  np_Mom[i] <- mean(sample_sim)
}

mean_Mom <- mean(np_Mom)
mean_Mom

# Standard Error for the Method of Moment
SE_Mom <- sd(np_Mom)
SE_Mom


# Question 3
# Plot the log-likelihood as a product of p

# likelihood function
log_lk <- function(prob, sample, n) {
  sum(dbinom(sample, size = n, prob = prob, log = TRUE))
}

# probability values
prob_values <- seq(0, 1, 0.01)
count_values <- length(prob_values)

ll_values <- as.vector(count_values)

for (i in 1:count_values) {
  ll_values[i] <- log_lk(prob_values[i], sample, n)
}

par(mfrow = c(1, 1))
plot(prob_values, ll_values,
  xlab = "Probability of Success", ylab = "Log-likelihood",
  main = "Log-likelihood of a Binomial Distribution", type = "l", lwd = 3
)


# Find the MLE for the parameter P and mark it on the plot
prob_MLE <- prob_values[which.max(ll_values)]
abline(v = prob_MLE, col = "blue", lty = 2)
# text(prob_MLE, max(ll_values), sprintf("MLE = %.3f", prob_MLE), pos = 3, col = "red")

# Question 4
# Find the MLE of p

library(stats4)

set.seed(1111)

n_sim <- 1000

n <- 10

np_MLE <- as.vector(n_sim)

# Define the likelihood function
nLL <- function(p_new) {
  -sum(dbinom(sample_sim, size = n, prob = p_new, log = TRUE))
}


for (i in 1:n_sim) {
  # Generate a random sample of size 'n' for each iteration
  sample_sim <- rbinom(n, size = n, prob = p)

  # Fit the model and estimate p
  fit <- mle(nLL, start = list(p_new = 0.5))

  # Extract the parameter estimate
  np_MLE[i] <- coef(fit)["p_new"]
}

# Calculate the mean of the MLE estimates
mean_MLE <- mean(np_MLE)
mean_MLE


# Question 5
# Find an (approximate) standard error for the maximum
# likelihood estimate using the Fisher information.

np_MLE_sd <- sd(np_MLE)
np_MLE_sd

# Question 6
# Give a bootstrap confidence interval for the maximum likelihood estimate.

np_MLE_CI <- c(quantile(np_MLE, 0.025), quantile(np_MLE, 0.975))
np_MLE_CI



# ----------------------------------------------------------------------------+
#                                 CHAPTER 8
# ----------------------------------------------------------------------------+

n <- 100
p <- seq(0.05, 0.95, 0.01)

power <- 1 - pnorm((60 - n * p) / sqrt(n * p * (1 - p))) +
  pnorm((40 - n * p) / sqrt(n * p * (1 - p)))

plot(p, power, type = "l")



# Homework II
