
 mean(x)
 
# Non-parametric bootstrap
x <- c(11.201, 10.035, 11.118, 9.055, 9.434, 9.663, 10.403, 11.662, 9.285, 8.84)

n <- length(x)
B <- 1000
mx <- c(1:B)
for (i in 1:B){
  # cat(i)
  boot.i <- sample(x, n, replace = T)
  # print(boot.i)
  mx[i] <- mean(boot.i)
}
mx

# Parametric bootstrap

B <- 1000
MLx <- mean(x)
Varx <- var(x)

mx <- c(1:B)
for (i in 1:B){
  boot.i <- rnorm(n, mean = MLx, sd = sqrt(Varx))
  mx[i] <- mean(boot.i)
}

# standard error of the mean
std <- function(x) sd(x)/sqrt(n)
std(mx)

# Correlation coefficient
x <- c(29, 435, 86, 1090, 219, 503, 47, 3524, 185, 98, 952, 89)
y <- c(127, 214, 133, 208, 153, 184, 130, 217, 141, 154, 194, 103)
plot(x,y)

cor.obs <- cor(x,y)
n <- length(x)
B <- 1000

cor.xy <- c(1:B)
index <- c(1:n)
for (i in 1:B){
  boot.i <- sample(index, n, replace = T)
  print(boot.i)
  x.b <- x[boot.i]
  y.b <- y[boot.i]
  
  cor.xy[i] <- cor(x.b, y.b)
}
cor.xy

# Example: The air quality data
# Using non-parametric bootstrap

data_airquality <- na.omit(airquality)
n_ozone <- length(data_airquality$Ozone)
Ozone <- data_airquality$Ozone

hist(Ozone)
boxplot(Ozone)

B <- 1000

q.boot <- matrix(0, B, 3)
for (b in 1:B){
  Ozone.boot <- sample(Ozone, size = n_ozone, replace = T)
  q.boot[b,] <- quantile(Ozone.boot, probs = c(0.25, 0.5, 0.75))
}

par(mfrow = c(2,2))

# Distribution of the bootstrap replicates for q25, q50 and q75
hist(q.boot[,1], nclass = 50)
hist(q.boot[,2], nclass = 50)
hist(q.boot[,3], nclass = 50)
boxplot(q.boot[,1], q.boot[,], q.boot[,3])

par(mfrow = c(1,1))

# Estimation of the S.E of q25, q50 and q75
sd(q.boot[,1])
sd(q.boot[,2])
sd(q.boot[,3])


# Confidence Interval

z <- c(94, 197, 16, 38, 99, 141, 23)
y <- c(52, 104, 146, 10, 51, 30, 40, 27, 46)

z_length <- length(z)
y_length <- length(y)

# Bootstrap Normal Interval
t.hat <- mean(z)
se.hat <- sqrt(var(z)/7)

B <- 1000
t.boot <- c(1:B)
for (b in 1:B){
  t.boot[b] <- rnorm(1, t.hat, se.hat)
}

quantile(t.boot, probs = c(0.05, 0.95))


# Bootstrap t-interval
B <- 1000

t.boot <- c(1:B)
for (i in 1:B){
  x.boot <- sample(z, size = z_length, replace = T)
  se.boot <- sqrt(var(x.boot)/z_length)
  t.boot[i] <- (mean(x.boot) - t.hat)/se.boot
}

quantile(t.boot, probs = c(0.05, 0.95))

# Student t-distribution to find the critical values for a given level of confidence & degree of freedom
qt(0.95, 6)
qt(0.05, 6)


########################## Bootstrap test ################################
# 2-sided Non-parametric BS t-test
# Example 1

z <- c(94, 197, 16, 38, 99, 141, 23)

mz <- mean(z)

z.tilde <- z - mz + 129

mean(z.tilde)

nz <- length(z)

t.obs <- t.test(z, mu = 129)$statistic

B <- 1000

t.boot <- c(1:B)

for (b in 1:B) {
  z.b <- sample(z.tilde, size = nz, replace = T)
  t.boot[b] <- t.test(z.b, mu = 129)$statistic
}

Pmc <- (1 + sum(abs(t.boot) > abs(t.obs)))/(B + 1)
Pmc

# 2-sided parametric BS t-test

theta.0 <- 129
sig.0 <- sqrt(var(z))
nz <- length(z)
t.obs <- t.test(z, mu = 129)$statistic
B <- 1000
t.boot <- c(1:B)
for(b in 1:B){
  
  z.b <- rnorm(nz, theta.0, sig.0)
  t.boot[b] <- t.test(z.b, mu = 129)$statistic
  
}

Pmc1 <- (1 + sum(abs(t.boot) > abs(t.obs)))/(B + 1)
Pmc1

# Example 2
# Hypothesis:
# H0: mu1 = mu2
# H1: mu1 > mu2
y <- c(10, 27, 31, 40, 46, 50, 52, 104, 146)

x <- c(16, 23, 38, 94, 99, 141, 197)

mean(y)

mean(x)

t.test(x, y, alternative = "greater", var.equal = T)

# 2-sample BS t-test (one sided hypothesis) -----------> Algorithm 1

z <- c(x, y)
m <- length(x)
n <- length(y)

mn <- m + n
t.obs <- mean(x) - mean(y)
t.obs

B <- 1000

t.boot <- c(1:B)
for(b in 1:B){
  z.b <- sample(z, size = mn, replace = T)
  y.b <- z.b[1:n]
  x.b <- z.b[(n+1):mn]
  t.boot[b] <- mean(x.b) - mean(y.b)
}
Pval <- (1 + sum(t.boot > t.obs))/(B + 1)
Pval


# 2-sample BS t-test (one sided hypothesis) -----------> Algorithm 2

y <- c(10, 27, 31, 40, 46, 50, 52, 104, 146)

x <- c(16, 23, 38, 94, 99, 141, 197)

z <- c(x,y)

m <- length(x)
n <- length(y)
my <- mean(y)
mx <- mean(x)

mz <- mean(z)

x.tilde <- x - mx + mz
y.tilde <- y - my + mz

mean(x.tilde)
mean(y.tilde)

B <- 1000
t.boot <- c(1:B)
for(b in 1:B){
  
  x.b <- sample(x.tilde, m, replace = T)
  y.b <- sample(y.tilde, n, replace = T)
  t.boot[b] <- t.test(x.b, y.b)$statistic
}

Pval <- (1 + sum(t.boot > t.obs))/(B + 1)
Pval

# Example 3: Correlation test

car_data <- cars

x <- car_data$speed

y <- car_data$dist

cor(x,y)

## Resampling pairs

n <- length(x)
B <- 1000

coeff.boot <- c(1:B)
index <- c(1:n)
for(b in 1:B){
  index.b <- sample(index, size = n, replace = T)
  x.boot <- x[index.b]
  y.boot <- y[index.b]
  coeff.boot[b] <- cor(x.boot, y.boot)
}

quantile(coeff.boot, probs = c(0.025, 0.975))

## Resampling x and y separately

n <- length(x)
B <- 1000

coeff.boot <- c(1:B)
index <- c(1:n)
for(b in 1:B){

  x.boot <- sample(x, size = n, replace = T)
  y.boot <- sample(y, size = n, replace = T)
  coeff.boot[b] <- cor(x.boot, y.boot)
}

quantile(coeff.boot, probs = c(0.025, 0.975))

############# Permutation tests #################

z <- c(94,197,16,38,99,141,23)
y <- c(52, 104, 146, 10, 51, 30, 40, 27, 46)

n <- length(y)
m <- length(z)

x <- c(z,y)
B <- 1000
t.boot <- c(1:B)

for(b in 1:B){
  x.boot <- sample(x, size = n+m, replace = F) # this is what makes the difference
  z.boot <- x.boot[1:n]
  y.boot <- x.boot[(n + 1):(n + m)]
  t.boot[b] <- t.test(z.boot, y.boot, alternative = "greater", var.equal = T)$statistic
}

Pval <- (1 + sum(t.boot > t.obs))/(B + 1)
Pval

hist(t.boot, nclass = 50, probability = T)
lines(c(t.obs, t.obs), c(0,10), col = 3, lwd = 3)


## Categorical Data Analysis
# Example: Aspirin use and heart attacks

p.placebo <- 189/(189 + 10845)
p.placebo

p.aspirin <- 104/(104 + 10933)
p.aspirin

n.p <- 11034
n.a <- 11037

diff <- p.placebo - p.aspirin

p.tot <- (189 + 104)/(189 + 10845 + 104 + 10933)
p.tot

z <- (p.placebo - p.aspirin)/sqrt(p.tot * (1 - p.tot)*(1/n.p + 1/n.a))

1 - pnorm(z,0,1)

## Parametric BS

B <- 5000

z.b <- c(1:B)
for(i in 1:B){
  s1 <- sum(rbinom(n.p, 1, p.tot)) # made assumption
  p.p.b <- s1/(189 + 10845)
  s2 <- sum(rbinom(n.a, 1, p.tot)) # made assumption
  p.a.b <- s2/(104 + 10933)
  p.tot.b <- (s1 + s2)/(n.p + n.a)
  z.b[i] <- (p.p.b - p.a.b)/sqrt(p.tot.b * (1 - p.tot.b) * (1/n.p + 1/n.a))
}

## Non-parametric BS

z.i <- c

############################# PROJECT I ####################################




############################# PROJECT II ####################################




############################# PROJECT III ####################################
# setwd('C:/Users/harve/OneDrive/Documenten/DataScience_UHasselt/R_codes')

# Question 1a
air <- airquality
head(air)

hist(air$Wind)

x <- air$Wind
n <- length(air$Wind)
B <- 1000

# Vectors to store bootstrap estimates
mx <- c(1:B)
mdx <- c(1:B)
tmx <- c(1:B)

# Bootstrapping
for (i in 1:B){
  boot.i <- sample(x, n, replace = T)
  mx[i] <- mean(boot.i)
  mdx[i] <- median(boot.i)
  tmx[i] <- mean(boot.i, trim = 0.1)
}

# standard error of the mean
std <- function(x) sd(x)/sqrt(n)

# Calculate the MSE for each estimator
mse_mx <- mean((mx - mean(x))^2)
mse_mdx <- mean((mdx - median(x))^2)
mse_tmx <- mean((tmx - mean(x))^2)

# Print MSE values
cat("MSE (Sample Mean):", mse_mx, "\n")
cat("MSE (Sample Median):", mse_mdx, "\n")
cat("MSE (Trimmed Mean):", mse_tmx, "\n")


# Question 1b
# Jackknife


# Question 1c



# Question 2

# dose, no. of beetles alive, no. of beetles dead, total no. of beetles in the grp

# read the data
beatle <- read.table('beetle.txt', header=FALSE, na.strings=".", dec=".",
strip.white=TRUE, col.names=c("dose", "y","z","n"))

head(beatle)

plot(beatle$dose,beatle$y/beatle$n,xlab="DOSE",ylab="prop. of live beetles")

attach(beatle)
dim(beatle)

# Question 2a

prob_alive <- beatle$y/beatle$n
prob_dead <- beatle$z/beatle$n

# Formulate the dose-response model
dose.model <- glm(cbind(z, n - z) ~ dose, data = beatle, family = binomial(link = "logit"))

# Print the model summary
summary(dose.model)

lines(dose, dose.model$fit)

# Question 2b
# SAS

# Question 2c
# Parametric

# Non-Parametric

# Question 2d

# Question 2e

# Question 2f

# Question 3

table1data <- c(80,83,78,88,78,93,88,78,97,103,99,104,103,95,95,97,99)
doses <- as.factor(c(1,1,1,1,1,2,2,2,3,3,3,4,4,4,5,5,5)) # the first dose level is placebo

# Question 3a

# Question 3b

# Question 4

x<-c(11,6,14,13,13,6,10,9,17,12)

# Question 4a

# Question 4b

# Question 5

x <- c(10,11,7)
y <- c(19,13,12)

# Question 5a

# Question 5b

x <- c(10, 13, 10, 8, 7, 8, 17, 8, 10, 6)
y <- c(12, 6, 18, 7, 10, 11, 13, 12, 13, 14)


