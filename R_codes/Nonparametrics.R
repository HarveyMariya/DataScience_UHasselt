# Wilcoxon Rank-Sum Test
# library(CATTexact) # exact trend test
treated <- c(26,36,40)
control <- c(25,10,35)

wilcox.test(treated, control, alternative = "greater")


# Illustration of the Continuity Correction
# m = 11, n = 3 and W_s = 12, P_{H_O}(W_s \leq 12) #leq - less or equal

treated <- c(1,2,9)
control <- c(3,4,5,6,7,8,10,11,12,13,14)

# exact
wilcox.test(treated, control, alternative = 'less')

# approximation
wilcox.test(treated, control, alternative = 'less', exact = F, correct = F)

# approximation with continuity correction
wilcox.test(treated, control, alternative = 'less', exact = F, correct = T)

# Ties-Normal Approximation
# Wilcoxon Rank Sum Test for Ties
treated <- c(25,36,40)
control <- c(25,10,35)

# library(coin)
# library(exactRankTests) ---> outdated

wilcox.exact(treated, control, alternative = "greater", exact = )

# Two-sided Alternative
treated <- c(26,36,40)
control <- c(25,10,35)

wilcox.test(treated, control, alternative = "two.sided")

# Exact distribution is not symmetric in case of ties
treated <- c(1,2,9)
control <- c(3,3,3,3,3,4,5,6,7,8,10,11,12,13,14)

wilcox.exact(treated, control, alternative = "less", exact = T)

wilcox.exact(treated, control, alternative = "two.sided", exact = T)

# Farm boys vs Town Boys Example
farm <- c(14.8, 10.6, 7.3, 12.9, 6.3, 16.1, 9.0, 11.4, 4.2, 2.7)
town <- c(12.7, 16.9, 7.6, 2.4, 6.2, 9.9, 14.2, 7.9, 11.3, 6.4, 6.1, 10.6,
          12.6, 16.0, 8.3, 9.1, 15.3, 14.8, 2.1, 10.6, 6.7, 6.7, 10.6, 5.0, 17.7,
          5.6, 3.6, 18.6, 1.8, 2.6, 11.8, 5.6, 1.0, 3.2, 5.9, 4.0)

wilcox.exact(farm, town, alternative = 'greater', exact = T)

# Sign Test
treatA <- c(20,15,30,40,55)
treatB <- c(21,13,37,52,50)

diff <- treatB - treatA
sign <- sum(diff > 0)

binom.test(sign, length(diff), 1/2, alternative = "greater")


############## Homework 1 ########################
# Question 1
# Hypothesis: Examine if yields are higher at vineyards where modern techniques are used.
# Obtain the exact p-value
state.art.techniques <- c(1.83, 1.89, 2.04, 2.45, 2.38, 2.91, 2.64, 2.46)
traditional.methods <- c(2.15, 1.88, 1.90, 1.74, 2.21)

wilcox.test(state.art.techniques, traditional.methods, alternative = "greater")

# Question 2
# Hypothesis:the program gives better results for men compared to women
# Obtain the exact p-value
women <- c(2,2,3)
men <- c(0,2,5)

# weight_gain - 2
# no_change - 1
# weight_loss - 0
# men - treatment

control <- c(2,2,1,1,0,0,0)
treatment <- c(1,1,0,0,0,0,0)


wilcox.exact(treatment, control, alternative = "less") # correct answer

# Question 3
# Hypothesis:the mileage of cars with the new fuel additive are significant higher
# Obtain the exact p-value
no.fuel.additive <- c(309,304,292,305)
fuel.additive <- c(366,292,309,309)

wilcox.exact(fuel.additive, no.fuel.additive, alternative = "greater")


############## Homework 2 ########################
# Question 1 (Sign Test)
# Hypothesis: Investigate that the Heart Rate Recovery(HRR) is greater for athelets who do not monitor their heartbeat
# Obtain the exact p-value
monitoring <- c(33.3,37.6,24.1,37.2,30.3,23.7,25.1,27.9,28.7,31.6)
no.monitoring <- c(33.4,37.9,24.1,37.0,30.1,24.0,25.1,28.0,28.8,32.0)
diff <- no.monitoring - monitoring

sign <- sum(diff > 0)

binom.test(sign, length(diff[diff != 0]), 1/2, alternative =  "greater")

# Question 2 (Signed Rank Test)
# Hypothesis: Investigate that the Heart Rate Recovery(HRR) is greater for atheletes who do not monitor their heartbeat
# Obtain the exact p-value
monitoring <- c(33.3,37.6,24.1,37.2,30.3,23.7,25.1,27.9,28.7,31.6)
no.monitoring <- c(33.4,37.9,24.1,37.0,30.1,24.0,25.1,28.0,28.8,32.0)

wilcox.exact(no.monitoring, monitoring, paired = TRUE, alternative = "greater")


# Question 3 (Signed Rank Test)
# Hypothesis: Waiting time of the customers at the counter is more than 20mins
# # Obtain the exact p-value
# H0: Median waiting time = 20 min
# Ha: Median waiting time > 20 min

times <- c(25,30,45,27,15,5,33,31,25,28,21)


wilcox.exact(times, mu = 20, alternative = "greater")

## Kruskal-Wallis Test
datagaf <- data.frame(gaf = c(25,10,35,36,26,40),
                      treatment = factor(c(rep("treat A",2),
                                           rep("treat B", 2), rep("treat C", 2))))
# library(coin)
kw <- kruskal_test(gaf ~ treatment, data = datagaf,
                   distribution = approximate(nresample = 9999))
kw

## Jonckheere-Terpstra Test
# library(DescTools)


# rat <- c( 133,139,149,160,184,111,125,143,148,157,99,114,116,127,146 )
# g <- ordered(c(rep(1,5),rep(2,5),rep(3,5)))
# JonckheereTerpstraTest(rat, g, alternative = "decreasing")


rat <- c( 133,139,149,160,184,111,125,143,148,157,99,114,116,127,146 )
g <- ordered(c(rep(3,5),rep(2,5),rep(1,5)))

# we have established that group A > B > C
JonckheereTerpstraTest(rat, g, alternative = "increasing")

## Friedman Test
response <- c(23,20,43,46,46,19,20,37,46,44,27,22,39,44,49)
agegroup <- factor(rep(c("20-30","30-40","40-50","50-60","60-70"),3))
treatment <- factor(c(rep("A",5),rep("B",5),rep("C",5)))
friedman.test(response, groups = treatment, blocks = agegroup)

## Homework 3
# Question 1
# Conclusion: At 5% level of significance, we conclude that the O-ring groups differ in
# terms of the temperature
# Use Kruskal-Wallis Test
w <- c(66,67,67,67,68,68,70,70,72,73,75,76,76,78,79,80,81)
x <- c(57,58,63,70,70)
y <- c(75)
z <- c(53)

kw.test <- kruskal.test(list(w,x,y,z))
kw.test

# Question 2
# Conclusion: We conclude in favor of the alternative hypothesis with p-value = 0.013,
# lower temperatures are seen with increasing number of O-ring incidents
# Use Jonckheere-Terpstra Test

temperature <- c(66,67,67,67,68,68,70,70,72,73,75,
       76,76,78,79,80,81,57,58,63,70,70,75,53)

ord <- ordered(c(rep(4,17),rep(3,5),rep(2,1),rep(1,1)))

# Establish the order as Oring0 > Oring1 > Oring2 > Oring3
JonckheereTerpstraTest(temperature, ord, alternative = "decreasing")


# Question 3
# Conclusion: We reject the null hypothesis in favor of the alternative and 
# conclude that there is a difference in the different leakage.
# Use Friedman Test
leakage <- c(308,132,454,64,102,526,0,28,182,134,96,28,268,
             324,268,90,166,228,134,34,332,296,458,6,198,350,
             200,90,28,274,16,16)

subject <- factor(c(rep(1,4),rep(2,4),rep(3,4),rep(4,4),
                    rep(5,4),rep(6,4),rep(7,4),rep(8,4)))

suit_type <- factor(rep(c('A','B','C','D'),8))

friedman.test(leakage, groups = suit_type, blocks = subject)


######################## EXAM PART I #############################
# Question 1
library(coin)
library(DescTools)
library(exactRankTests)


treated <- c(120,124,215,90,67,95,190,180,135,399)
control <- c(12,120,20,32,95,135,60)

wilcox.exact(treated, control, alternative = "greater")



# Question 2
# set.seed(2262068) # redo using Kruskal Wallis
# 
# silver <- as.matrix(c(5.9,6.8,6.4,7.0,6.6,7.7,7.2,6.9,6.2,
#                       6.9,9.0,6.6,8.1,9.3,9.2,8.6,
#                       4.9,5.5,4.6,4.5,
#                       5.3,5.6,5.5,5.1,6.2,5.8,5.8))
# group <- c(rep("1st",9), rep("2nd",7), rep("3rd",4), rep("4th",7))
# 
# tapply(silver, group, median)
# 
# JonckheereTerpstraTest(silver, group, alternative = "decreasing", nperm = 999)

first <- c(5.9,6.8,6.4,7.0,6.6,7.7,7.2,6.9,6.2)

second <- c(6.9,9.0,6.6,8.1,9.3,9.2,8.6)

third <- c(4.9,5.5,4.6,4.5)

fourth <- c(5.3,5.6,5.5,5.1,6.2,5.8,5.8)


kruskal.test(list(first, second, third, fourth))


# Question 3

outlet1 <- c(6.97,4.65,5.05,3.70,6.19,3.91,4.44)
outlet2 <- c(5.58,6.13,6.46,4.41,5.04,3.94,5.20)

wilcox.exact(outlet1, outlet2, paired = TRUE, alternative = "two.sided")


# Question 4

response <- c(8.5,7.5,9.0,8.0,7.0,
              8.0,8.0,6.0,6.0,5.5,
              3.5,6.0,4.0,7.0,4.5,
              6.0,5.5,7.0,4.0,7.5)

vice_president <- factor(rep(c("A", "B", "C", "D", "E"),4))

treatment <- factor(c(rep("Arkansas",5), rep("Colorado",5), rep("Illinois",5), rep("Iowa",5)))

friedman.test(response, groups = treatment, blocks = vice_president)



# Question 5
set.seed(2262068)
height <- as.matrix(c(12,15,9,8,16,7,14,
            11,17,9,7,8,12,
            8,9,11,9,12,11,6))

group <- c(rep("Organic",7), rep("Inorganic",6), rep("Control",7))

tapply(height, group, median)

JonckheereTerpstraTest(height, group, alternative = "decreasing", nperm = 999) # she said here should be increasing because R use the ordering according to alphabetical order





######################## EXAM PART II #############################

library(readxl)
library(KernSmooth)
library(splines)
library(Metrics)



# Patients in hospital Distance to Hospita
data <- read.table("C:/Users/harve/OneDrive/Desktop/new.txt", header = FALSE)
colnames(data) <- c("County", "Population", "PIH", "DTH")
data$Population <- as.numeric(data$Population)
data$Value1 <- as.numeric(data$PIH)
data$Value2 <- as.numeric(data$DTH)



np_new <- na.omit(np_data)

plot(np_new$Fuel,np_new$BerthVisits, xlim = c(0,11000), ylim = c(0,1000))

plot(np_data$pcWine, np_data$totWine, ylim = c(0,250), xlim = c(0,28))

plot(data$DTH, data$PIH)

x <- data$DTH # price
y <- data$PIH  # demand

x <- as.numeric(np_new$Fuel)
y <- as.numeric(np_new$BerthVisits)


lines(ksmooth(x,y, kernel="normal", bandwidth=20,
              range.x=range(x), x.points=x),col = "red", lwd=3,
      lty=1)

lines(locpoly(x, y, degree = 2, kernel = "normal", bandwidth = 50, 
              range.x = range(x), gridsize = 400), col = "blue", lwd = 3, lty = 2)

lines(x, predict(model4), col="purple", lwd=3, lty=1)

lines(smooth.spline(x, y), col="green", lwd=3, lty=2)


# local polynomial of degree 2
# lines(locpoly(x,y, degree=2, kernel="normal",
#               bandwidth=10, range.x=range(x)), col = "blue", lwd=3,
#       lty=2)

# lines(smooth.spline(x, y), col="green", lwd=3, lty=1)

legend("topright", c("NWE", "LPE", "B-spline", "Smooth-spline"),ncol=1,
       col=c("red","blue", "purple","green"), lwd=c(2,2), lty=c(1,2))


# B-splines

model4 <- lm(y ~ bs(x, degree = 1))

summary(model4)

plot(x,y)
plot(np_new$Fuel,np_new$BerthVisits, xlim = c(0,11000), ylim = c(0,1000))

lines(x, predict(model4), col="blue", lwd=3, lty=1)
lines(smooth.spline(x, y), col="red", lwd=3, lty=2)
# lines(x, predict(model5), col="yellow", lwd=3, lty=1)
legend("bottom", c("B-splines", "Smoothing spline", "P-spline"),ncol=1, 
       col=c("blue","red"), 
       lwd=c(2,2), lty=c(1,2))


# P-splines
model5 <- lm(y ~ pspline(x))
summary(model5)



model1 <- ksmooth(x, y, kernel = "normal", bandwidth = "20")

model2 <- locpoly(x, y, degree = 2, kernel = "normal", bandwidth = 20)

model3 <- smooth.spline(x, y)

Nad <- rmse(model1$x, model1$y)

Loc <- rmse(model2$x, model2$y)

Smo <- rmse(model3$x, model3$y)

RSS1 <- c(crossprod(model4$residuals))

MSE1 <- RSS1/length(model4$residuals)

Bspline <- sqrt(MSE1)

RSS2 <- c(crossprod(model5$residuals))

MSE2 <- RSS2/length(model5$residuals)

Pspline <- sqrt(MSE2)

col.e <- c("Nadaraya-Watson", "Local polynomial", "Smooth-spline", "B-spline")

row.e <- c(Nad, Loc, Smo, Bspline)

estimates <- rbind(col.e, row.e) 

estimates




################# PART 2 #################
# Normal Distribution
set.seed(714)
x = rnorm(1000, 0,1)

par(mfrow = c(2,2))
tot_bins = 4

# freq = F tells r to plot the density instead of the frequency
hist(x, breaks = seq(min(x), max(x), l=tot_bins+1),
     freq = F, col = "orange",
     main = "Histogram", xlab = "x", ylab = "f(x)",
     yaxs = "i", xaxs = "i", ylim = c(0,0.5)) # i removes the top space from both axes

curve(dnorm(x, mean = 0, sd = 1), add = T, col = "blue", lwd = 2)
curve(dnorm(x, mean = mean(x), sd = sd(x)), add = T, col = "brown",
      lwd = 2, lty = 2)


tot_bins = 10
hist(x, breaks = seq(min(x), max(x), l=tot_bins+1),
     freq = F, col = "orange",
     main = "Histogram", xlab = "x", ylab = "f(x)",
     yaxs = "i", xaxs = "i", ylim = c(0,0.5))

curve(dnorm(x, mean = 0, sd = 1), add = T, col = "blue", lwd = 2)
curve(dnorm(x, mean = mean(x), sd = sd(x)), add = T, col = "brown",
      lwd = 2, lty = 2)


tot_bins = 20
hist(x, breaks = seq(min(x), max(x), l=tot_bins+1),
     freq = F, col = "orange",
     main = "Histogram", xlab = "x", ylab = "f(x)",
     yaxs = "i", xaxs = "i", ylim = c(0,0.5))

curve(dnorm(x, mean = 0, sd = 1), add = T, col = "blue", lwd = 2)
curve(dnorm(x, mean = mean(x), sd = sd(x)), add = T, col = "brown",
      lwd = 2, lty = 2)



tot_bins = 30
hist(x, breaks = seq(min(x), max(x), l=tot_bins+1),
     freq = F, col = "orange",
     main = "Histogram", xlab = "x", ylab = "f(x)",
     yaxs = "i", xaxs = "i", ylim = c(0,0.5))

curve(dnorm(x, mean = 0, sd = 1), add = T, col = "blue", lwd = 2)
curve(dnorm(x, mean = mean(x), sd = sd(x)), add = T, col = "brown",
      lwd = 2, lty = 2)



library(readxl)
library(KernSmooth)
library(splines)
library(Metrics)

# Project Data Testing (Non-Parametrics)
poi <- read.csv("C:/Users/harve/Downloads/pedalme_/pedalme_features.csv")
# plot(poi$week, poi$demand)
plot(poi$X, poi$demand)

x <- new_para$X
y <- new_para$demand
plot(x,y)

lines(ksmooth(x,y, kernel="normal", bandwidth=20,
              range.x=range(x), x.points=x),col = "red", lwd=3,
      lty=1)

# local polynomial of degree 2
lines(locpoly(x,y, degree=2, kernel="normal",
              bandwidth=20, range.x=range(x)), col = "blue", lwd=3,
      lty=2)
legend("topright", c("NWE", "LPE"),ncol=1,
       col=c("red","blue"), lwd=c(2,2), lty=c(1,2))

new_para <- poi[50:100,]



plot(poi$X[50:150], poi$demand[50:150])


# Part 2
# Homework 1

set.seed(2262068)
library(dplyr)
library(ggplot2)
library(ggpubr)

x <- c(rnorm(9/20*100,-6/5,(3/4)^2),rnorm(9/20*100,6/5,(3/5)^2),rnorm(0.1*100,0,(1/4)^2))
x1 <- 9/20*rnorm(100, -6/5,(3/4)^2) + 9/20*rnorm(100, -6/5,(3/4)^2) + 1/10*rnorm(100, 0,(1/4)^2)
df <- data.frame(x)
df1 <- data.frame(x1)
bandwidth <- bw.nrd(df$x)
bandwidth1 <- bw.nrd(df1$x1)


ggplot(df, aes(x = x)) +
  geom_density(kernel = "gaussian", bw = bandwidth) +
  ggtitle("Kernel Density Estimation of X") +
  xlab("X") + ylab("Density")

ggplot(df1, aes(x = x1)) +
  geom_density(kernel = "gaussian", color = "blue", lwd = 0.8) +
  ggtitle("Kernel Density Estimation of X") +
  xlab("X") + ylab("Density")

f0 = density(x1)
plot(f0, col = "red", lwd = 2, ylim = c(0,1))

# Question 2
ggplot(df, aes(x = x)) +
  geom_histogram(aes(y = after_stat(density)), bins = 10, color = "black", fill = "lightgray") +
  geom_density(kernel = "gaussian", color = "red", lwd = 1.5, lty = 1) +
  geom_density(kernel = "epanechnikov", color = "blue", lwd = 1.5, lty = 2) +
  geom_density(kernel = "rectangular", color = "brown", lwd = 1.5, lty = 3) +
  geom_density(kernel = "biweight", color = "orange", lwd = 1.5, lty = 4) +
  ggtitle("Histogram and Kernel Density Estimations of X") +
  xlab("X") + ylab("Density") +
  scale_color_manual(name = "Kernel",
                     values = c("Gaussian" = "red", "Epanechnikov" = "blue", 
                                "Rectangular" = "brown", "Biweight" = "orange"))


f1 = density(x1, kernel = "gaussian")
f2 = density(x1, kernel = "epanechnikov")
f3 = density(x1, kernel = "rectangular")
f4 = density(x1, kernel = "biweight")

hist(x1, freq = FALSE)
lines(f1, lwd = 2, col = "blue", lty = 1)
lines(f2, lwd = 2, col = "brown", lty = 2)
lines(f3, lwd = 2, col = "red", lty = 3)
lines(f4, lwd = 2, col = "purple", lty = 4)
legend("topright", c("Gaussian", "Epanechnikov", "Rectangular","Biweight"),
       ncol = 1, col = c("blue","brown","red","purple"), lwd = 2, lty = 1:4)
