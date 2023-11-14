################# Bayesian ####################

# Exercise 1
# Calculate the AUC of a binomial distribution and likelihood function
n <- 10
s.obs <- 5
theta <- s.obs/n

library(ggplot2)
data <- data.frame(s = 0:n, prob = dbinom(0:n, n, theta))

# the distribution
ggplot(data, aes(x = s, y = prob)) + geom_bar(stat = "identity")

# Sum of the AUC
s <- 0:n
sum(dbinom(s,n,theta))

#Binomial as Likelihood function
n <- 10
s.obs <- 5

# specify the possible values of theta
theta <- seq(0,1,0.01)

plot(theta, dbinom(s.obs, n, theta), type = "l", ylab = "likelihood")

library(DescTools)

AUC(theta, dbinom(s.obs,n,theta), method = c("trapezoid"), na.rm =F)

# Likelihood ratio
# Calculate the likelihood ratio for two hypothesis of theta(e.g theta = 0.5 vs 0.75)
n <- 12
s.obs <- 9

theta1 <- 0.5
theta2 <- 0.75

# this gives the relative evidence for the two hypothesis
dbinom(s.obs, n, theta1)/dbinom(s.obs, n, theta2)

# Ex2:
# Given: n=10, s=2 and n=100 and s=20 and theta=0.3 vs theta=0.2
# plot the likelihood function

n1 <- 10
s1 <- 2
theta <- seq(0,1,0.01)
plot(theta, dbinom(s1, n1, theta), type="l", ylab = 'likelihood')
abline(v = 0.3, lty = 1, col = 4)

n2 <- 100
s2 <- 20
plot(theta, dbinom(s2, n2, theta), type="l", ylab = 'likelihood')
abline(v = 0.2, lty = 1, col = 2)

# combined plot
plot(theta, dbinom(s1, n1, theta), type="l", ylab = 'likelihood')
lines(theta, dbinom(s2, n2, theta), col = "red", lwd = 2)
abline(v = 0.2, lty = 2, lwd = 3, col = 1)

# standardized likelihood
theta.ML <- s2/n2
plot(theta, dbinom(s1, n1, theta), type="l", ylab = 'likelihood', ylim = c(0,1))
lines(theta, dbinom(s2, n2, theta)/dbinom(s1, n1, theta.ML), col = "red", lwd = 2)
abline(v = 0.2, lty = 2, lwd = 3, col = 1)

###################
# Calculate the likelihood function for each value of theta
theta1 <- 0.3
theta2 <- 0.2

L1_theta1 <- dbinom(s1, n1, theta1)
L1_theta2 <- dbinom(s1, n1, theta2)
L2_theta1 <- dbinom(s2, n2, theta1)
L2_theta2 <- dbinom(s2, n2, theta2)

# Calculate the likelihood ratio for each experiment
LR1 <- L1_theta1/L1_theta2
LR2 <- L2_theta1/L2_theta2
########

# plot of likelihood function
the<-seq(0,1,0.01)
plot(the,dbinom(s1,n1,the),type="l",ylab="likelihood",ylim=c(0,1))
# add plot of standardized likelihood
theta.ML<-s1/n1
lines(the,dbinom(s2,n2,the)/dbinom(s2,n2,s2/n2),col="red")

LR1
LR2


###################### Chapter 2 ###############################
## data specification for a binomial likelihood and beta prior
s <- 9
n <- 12

# parameters of the prior distribution
alpha <- 2
beta <- 2

# the denominator of the posterior function
theta <- seq(0,1, 0.01)

likelihood <- dbinom(s, n, theta)
prior <- dbeta(theta, alpha, beta)
denominator <- AUC(theta, likelihood*prior, method = 'trapezoid')
posterior <- likelihood * prior/denominator

# plot the distributions
# blue- likelihood, red- prior, black- posterior
plot(theta, likelihood, type = 'l', ylim = c(0,5), col = 'blue', ylab = '')
lines(theta, prior, col = 'red')
lines(theta, posterior)

# a plot that shows a function that is proportional tho the likelihood
plot(theta,likelihood,type="l",ylim=c(0,5),col="blue",ylab="",lty=3)
lines(theta,likelihood/AUC(theta,likelihood,method="trapezoid"),col="blue")
lines(theta,prior,col="red")
lines(theta,posterior)

# Another prior distribution
likelihood<-dbinom(s,n,theta)
prior<-dbeta(theta,alpha,beta)*(theta>0.5)*2
denominator<-AUC(theta,likelihood*prior,method="trapezoid")
posterior<-likelihood*prior/denominator

plot(theta,likelihood/AUC(theta,likelihood,method="trapezoid"),
     type="l",ylim=c(0,5),col="blue",ylab="")
lines(theta,prior,col="red")
lines(theta,posterior)

# method 2: based on analytical derivations
theta<-seq(0,1,0.01)

likelihood<-dbeta(theta,s+1,n-s+1)
prior<-dbeta(theta,alpha,beta)
posterior<-dbeta(theta,alpha+s,beta+n-s)

plot(theta,likelihood,type="l",ylim=c(0,5),col="blue",ylab="")
lines(theta,prior,col="red")
lines(theta,posterior)


## Gaussian case
## data specification

n<-50 # sample size
ybar<-318 # sample mean
sd<-119.5 # sample sd

## prior specification
mu0<-328 # prior mean
sd0<-5 # prior sd

############# Method1
mu<-seq(250,400,0.01)

likelihood<-dnorm(mu,mean=ybar,sd=sd/sqrt(n))
prior<-dnorm(mu,mean=mu0,sd=sd0)
denominator<-AUC(mu,likelihood*prior,method="trapezoid")
posterior<-likelihood*prior/denominator
# Plotting these results gives:

plot(mu,likelihood,ylim=c(0,0.1),type="l",col="blue",ylab="")
lines(mu,prior,col="red")
lines(mu,posterior)

############## Method 2: based on analytical derivations
mu<-seq(250,400,0.01)

likelihood<-dnorm(mu,mean=ybar,sd=sd/sqrt(n))
prior<-dnorm(mu,mean=mu0,sd=sd0)
prec<-1/sd0^2+n/sd^2
varbar<-1/prec
mubar<-(mu0/sd0^2 + ybar*n/sd^2)*varbar
posterior<-dnorm(mu,mean=mubar,sd=sqrt(varbar))

# Plotting these results gives:

plot(mu,likelihood,type="l",ylim=c(0,0.10),col="blue",ylab="")
lines(mu,prior,col="red")
lines(mu,posterior)


## Poisson case
## data specification
n<-4351 # sample size
sum.y<-9758 # sum of the counts

## prior specification
alpha0<-3 # prior shape parameter
beta0<-1 # prior rate parameter

# Method 1: Numerical calculation of the denominator
mu<-seq(0,10,0.001)

likelihood<-dgamma(mu,shape=sum.y+1,rate=n)
prior<-dgamma(mu,shape=alpha0,rate=beta0)
denominator<-AUC(mu,likelihood*prior,method="trapezoid")
posterior<-likelihood*prior/denominator

plot(mu,likelihood,type="l",col="blue",ylab="",ylim=c(0,20))
lines(mu,prior,col="red")
lines(mu,posterior)


# Method 2: based on analytical derivations
mu<-seq(0,10,0.001)

likelihood<-dgamma(mu,shape=sum.y+1,rate=n)
prior<-dgamma(mu,shape=alpha0,rate=beta0)
posterior<-dgamma(mu,shape=alpha0+sum.y,rate=beta0+n)

plot(mu,likelihood,type="l",col="blue",ylab="",ylim=c(0,20))
lines(mu,prior,col="red")
lines(mu,posterior)


# Transformation rule
# Visualize the distribution of the parameter theta
theta<-seq(0,1,0.01)
alpha<-19
beta<-133
posterior<-dbeta(theta,alpha,beta)
plot(theta,posterior,type="l",col="blue",ylab="",ylim=c(0,20))


psi<-log(theta)
posterior<-dbeta(theta,alpha,beta)*theta
plot(psi,posterior,type="l",col="blue",ylab="")


#################### Exercise 2 ####################
## data specification for a binomial likelihood and beta prior
s <- 3
n <- 20

# parameters of the prior distribution
alpha <- 10
beta <- 20

# the denominator of the posterior function
theta <- seq(0,1, 0.01)

likelihood <- dbinom(s, n, theta)
prior <- dbeta(theta, alpha, beta)
denominator <- AUC(theta, likelihood*prior, method = 'trapezoid')
posterior <- likelihood * prior/denominator

# plot the distributions
# blue- likelihood, red- prior, black- posterior
plot(theta, likelihood, type = 'l', ylim = c(0,5), col = 'blue', ylab = '')
lines(theta, prior, col = 'red')
lines(theta, posterior)


## data specification for a binomial likelihood and beta prior
s <- 3
n <- 20

# parameters of the prior distribution
alpha <- 100
beta <- 200

# the denominator of the posterior function
theta <- seq(0,1, 0.01)

likelihood <- dbinom(s, n, theta)
prior <- dbeta(theta, alpha, beta)
denominator <- AUC(theta, likelihood*prior, method = 'trapezoid')
posterior <- likelihood * prior/denominator

# plot the distributions
# blue- likelihood, red- prior, black- posterior
plot(theta, likelihood, type = 'l', ylim = c(0,5), col = 'blue', ylab = '')
lines(theta, prior, ylim,col = 'red')
lines(theta, posterior)

### Chapter 3
# 1. Binomial case
# data specification
s <- 9
n <- 12

# prior specification
alpha0 <- 2
beta0 <- 2

theta<-seq(0,1,0.01)

likelihood<-dbeta(theta,s+1,n-s+1)
prior<-dbeta(theta,alpha0,beta0)
posterior<-dbeta(theta,alpha0+s,beta0+n-s)

# plot of the posterior distribution
plot(theta,likelihood,type="l",ylim=c(0,5),col="blue",ylab="")
lines(theta,prior,col="red")
lines(theta,posterior)

# Posterior measures of location and variance
alpha<-alpha0+s # posterior alpha
beta<-beta0+n-s # posterior beta

## DIRECT POSTERIOR PROBABILITY
a<-0.2
b<-1
pbeta(b,alpha,beta)-pbeta(a,alpha,beta)

## POSTERIOR MODE
(alpha-1)/(alpha+beta-2)

## POSTERIOR MEAN
alpha/(alpha+beta)

## POSTERIOR MEDIAN
qbeta(0.5,alpha,beta)

## POSTERIOR VARIANCE
var<-alpha*beta/((alpha+beta)^2*(alpha+beta+1))
var

sd<-sqrt(var)
sd


# Posterior interval estimation
## EQUAL TAIL CI
c(qbeta(0.025,alpha,beta),qbeta(0.975,alpha,beta))

## HPD CI
hpdbeta <- function(alpha,beta)
{
  p2 <- alpha
  q2 <- beta
  
  f <- function(x,p=p2,q=q2){
    b<-qbeta(pbeta(x,p,q)+0.95,p,q);(dbeta(x,p,q)-dbeta(b,p,q))^2}
  
  hpdmin <- optimize(f,lower=0,upper=qbeta(0.05,p2,q2),p=p2,q=q2)$minimum
  hpdmax <- qbeta(pbeta(hpdmin,p2,q2)+0.95,p2,q2)
  return(c(hpdmin,hpdmax))
}
hpdbeta(alpha,beta)

# Predictive distribution
par(mfrow=c(1,1))
m<-50
ytilde <- 0:50

term1 <- log(choose(m,ytilde))
term2 <- lgamma(alpha+ytilde)+lgamma(m-ytilde+beta)-lgamma(alpha+beta+m)

term3 <- lgamma(alpha)+lgamma(beta)-lgamma(alpha+beta)
lpart <- term1+term2-term3
dytilde <- exp(lpart)

plot(ytilde,dytilde,type="n")
lines(ytilde,dytilde,type="h",col="dark red",lwd=3)

# 2. Gaussian Case
## data specification
n<-50 # sample size
ybar<-318 # sample mean
sd<-119.5 # sample sd

## prior specification
mu0<-328 # prior mean
sd0<-5 # prior sd

# Plot of posterior distribution
mu<-seq(250,400,0.01)

likelihood<-dnorm(mu,mean=ybar,sd=sd/sqrt(n))
prior<-dnorm(mu,mean=mu0,sd=sd0)
prec<-1/sd0^2+n/sd^2
varbar<-1/prec
mubar<-(mu0/sd0^2 + ybar*n/sd^2)*varbar
posterior<-dnorm(mu,mean=mubar,sd=sqrt(varbar))

plot(mu,likelihood,type="l",ylim=c(0,0.10),col="blue",ylab="")
lines(mu,prior,col="red")
lines(mu,posterior)

# Posterior measures of location and variance

mubar # posterior mean

varbar # posterior variance

# DIRECT POSTERIOR PROBABILITY
a<-300
b<-320
pnorm(b,mubar,sqrt(varbar))-pnorm(a,mubar,sqrt(varbar))

# Posterior interval estimation

# EQUAL TAIL (AND HPD) CI
c(qnorm(0.025,mubar,sqrt(varbar)),qnorm(0.975,mubar,sqrt(varbar)))

# Predictive distribution

sigma <- sd/sqrt(n)
PPD <- dnorm(mu,mean=mubar,sd=sqrt(varbar+sigma^2))
plot(mu,likelihood,type="l",ylim=c(0,0.10),col="blue",ylab="")
lines(mu,PPD,col="green")

# 3. Poisson Case
## data specification
n<-4351 # sample size
sum.y<-9758 # sum of the counts

## prior specification
alpha0<-3 # prior shape parameter
beta0<-1 # prior rate parameter

# Plot of posterior distribution
mu<-seq(0,10,0.001)

likelihood<-dgamma(mu,shape=sum.y+1,rate=n)
prior<-dgamma(mu,shape=alpha0,rate=beta0)
posterior<-dgamma(mu,shape=alpha0+sum.y,rate=beta0+n)

plot(mu,likelihood,type="l",col="blue",ylab="",ylim=c(0,20))
lines(mu,prior,col="red")
lines(mu,posterior)

# Posterior measures of location and variance

abar <- alpha0+sum.y
bbar <- beta0+n

# posterior mean
abar/bbar

# posterior mode
(abar-1)/bbar

# posterior median
qgamma(0.5,shape=abar,rate=bbar)

# posterior variance
abar/bbar^2

# Posterior interval estimation

## EQUAL TAIL CI
c(qgamma(0.025,shape=abar,rate=bbar),qgamma(0.975,shape=abar,rate=bbar))

## HPD CI
hpdgamma <- function(alpha,beta)
{
  p2 <- alpha
  q2 <- beta
  
  f <- function(x,p=p2,q=q2){
    b<-qgamma(pgamma(x,shape=p,rate=q)+0.95,shape=p,rate=q);
    (dgamma(x,shape=p,rate=q)-dgamma(b,shape=p,rate=q))^2}
  
  hpdmin <- optimize(f,lower=0,upper=qgamma(0.05,shape=p2,rate=q2),p=p2,q=q2)$minimum
  hpdmax <- qgamma(pgamma(hpdmin,shape=p2,rate=q2)+0.95,shape=p2,rate=q2)
  return(c(hpdmin,hpdmax))
}
hpdgamma(abar,bbar)


# Predictive distribution
par(mfrow=c(1,1))
alpha <- 3
beta <- 1
ytilde <- 0:30

lpart1 <- lgamma(alpha+ytilde)-lgamma(alpha)-lfactorial(ytilde)
lpart2 <- alpha*(log(beta)-log(beta+1))
lpart3 <- -ytilde*log(beta+1)

lpart <- lpart1+lpart2+lpart3
dytilde <- exp(lpart)

plot(ytilde,dytilde,type="n")
lines(ytilde,dytilde,type="h",col="dark red",lwd=3)


########################################## OPENBUGS/JAGS ####################################
# install.packages("R2OpenBUGS")
# install.packages("rjags")

# Bayesian inference Using Gibbs Sampler
# JAGS (Just Another Gibbs Sampler) language.


# Example1.txt


# a simple Bayesian LIMO that assumes a normal dist. with mean and SD
# the model places normal and uniform priors on 'mu' and 'sigma
# Aim: estimate the posterior mean and SD


# model #specifies the start of the model block
# {
#   for (i in 1:N) {
#     x[i] ~ dnorm(mu, tau) # Likelihood function:specifies each observation is normally dist. with mean and precision(inverse variance)
#   }
#   mu ~ dnorm(0.00000E+00, 1.00000E-04) # Normal prior: specifies mean 0 and precision 10000
#   tau <- pow(sigma, -2) # Precision: 1/sigma-square
#   sigma ~ dunif(0.00000E+00, 100) # prior sigma: uniform dust. bet 0 & 100
# }

# Example2.txt
# model
# {
#   for (i in 1:N) {
#     eta[i] <- alpha + beta * weeks[i]
#     lambda[i] <- gamma/(1 + exp(-eta[i]))
#     calls[i] ~ dpois(lambda[i])
#   }
#   alpha ~ dnorm(-5, 16)
#   beta ~ dnorm(0.75, 4)
#   gamma ~ dgamma(3.5, 0.08333)
# }

# PROJECT SET A:
# Question 2: 

# Summary for the posterior of thetha+
n1 <- 3455
x1 <- 171
alpha1 <- x1 + 1
beta1 <- n1 - (x1 + 1)
post_theta1 <- rbeta(1000, alpha1, beta1)
summary(post_theta1)
sd(post_theta1)


# Summary for the posterior of thetha-
n2 <- 4437
x2 <- 117
alpha2 <- x2 + 1
beta2 <- n2 - (x2 + 1)
post_theta2 <- rbeta(1000, alpha2, beta2)
summary(post_theta2)

# Question 3
# Posterior dist for thetha+
# Let posterior1 rep +ve and posterior2 rep -ve
posterior1 <- rbeta(1000, alpha1, beta1)
posterior2 <- rbeta(1000, alpha2, beta2)

RR_posterior <- posterior1/posterior2

summary(RR_posterior)

# Create a histogram of the posterior distribution for relative risk
hist(RR_posterior, breaks = 50, main = "Posterior Distribution of Relative Risk", 
     xlab = "Relative Risk")

# 95% credible interval for relative risk
quantile(RR_posterior, c(0.025, 0.975))

# Conclusion: Based on the Credible Interval calculated from the Relative Risk of the 
# Posterior Distribution, we can clearly see the association between smoking and 
# Stroke. At 95% credible interval [1.49; 2.38], since the relative risk does not include 1, we may
# conclude that there is a relationship between smoking and stroke.


# model {
#   for ( i in 1 : 2 ) {
#     r[i] ~ dbin (theta[i], n[i])
#     theta[i] ~ dbeta(1,1)
#   }
# }
# data :
#   n = c(3435,4437)
# r = c(171,117)
# datalist <- list('n' = n , 'r'= r )

# RUN JAGS FROM INSIDE OF R

library("rjags")


# DATA PREPARATION

# Data
n1 <- 3435  
n2 <- 4437  
y1 <- 171   
y2 <- 117

model.data <- list(y1 = y1, y2 = y2, n1 = n1, n2 = n2)

# DEFINE INITIAL VALUES

model.inits <- list(theta1 = runif(1, 0, 1), theta2 = runif(1, 0, 1))

# MODEL SPECIFICATION 
# -> PUT MODEL SPECIFICATION IN A FILE CALLED example1.txt
# read.csv("C:/Users/harve/Downloads/G4.pilot.data.csv")
# install.packages("Rcmdr") # for files.show()
library(Rcmdr)

# save the file in the working directory you have set from setwd()
# the BUGS program is in a text file named example1
file.show("smoking.txt")

# SET UP MODEL
# specify model, data, initial values, number of parallel chains
jags <- jags.model('smoking.txt',
                   data = model.data,
                   inits = model.inits,
                   n.chains = 2)

# Generate MCMC samples and save output for specified variables
# thin - thinning interval
out <- coda.samples(jags,
                    c('theta', 'theta'),
                    n.iter=10000, thin=1)

# Posterior summary statistics
burnin <- 2000
summary(window(out,start=burnin))

# History plot & posterior distributions & autocorrelation plot
plot(out, trace=TRUE, density = TRUE)   
plot(window(out,start=burnin), trace=TRUE, density = TRUE)   

# library(coda)
autocorr.plot(out)

############################
library("rjags")

# DATA PREPARATION
# Data
n1 <- 3435  
n2 <- 4437  
y1 <- 171   
y2 <- 117

model.data <- list(n=c(n1,n2), r=c(y1,y2))

# DEFINE INITIAL VALUES
model.inits <- list(theta=c(runif(2,0,1)))

# MODEL SPECIFICATION 
model_code <- "
model {
  for ( i in 1 : 2 ) {
    r[i] ~ dbin (theta[i], n[i])
    theta[i] ~ dbeta(1,1)
  }
}"

# SET UP MODEL
# specify model, data, initial values, number of parallel chains
jags <- jags.model(model_code,
                   data = model.data,
                   inits = model.inits,
                   n.chains = 2)

# Generate MCMC samples and save output for specified variables
# thin - thinning interval
out <- coda.samples(jags,
                    c('theta'),
                    n.iter=10000, thin=1)

# Posterior summary statistics
burnin <- 2000
summary(window(out,start=burnin))

# History plot & posterior distributions & autocorrelation plot
plot(out, trace=TRUE, density = TRUE)   
plot(window(out,start=burnin), trace=TRUE, density = TRUE)   
autocorr.plot(out)


###########################################
# Project version 2.0

malformation <- function()
{
  for (i in 1:n)
  {
    y[i] ~ dbin(p[i],Nfetus[i])
    logit(p[i])<-alpha+beta*d[i]
  }
  # specifying priors
  alpha ~ dlogis(0, 0.1)
  beta ~ dlogis(0, 0.1)
  #Posterior distribution of the BMD 
  P0 <- exp(alpha)/(1+exp(alpha))
  o0 <- exp(alpha)
  o10 <- exp(beta*10)
  
  #(This part is only relevent for question 2.4)
  q.star <- (0.05*(1-P0)) + P0
  bmd <- (logit(q.star)-alpha)/beta
}

########################## Building the code ###############
library(rjags)

# Data
d <- c(0, 62.5, 128, 250, 500)
Nfetus <- c(282, 225, 290, 261, 141)
y <- c(67, 34, 193, 250, 141)

# number of observations
n <- length(d)
model.inits2 <- list(alpha=0,beta=0, tau=0)
model.inits1 <- list(alpha = runif(1,0,1),beta = runif(1,0,1))
model.inits <- list(model.inits1, model.inits2)
parameters = c("alpha", "beta")
# Model
model_string <- "
model {
  for (i in 1:n) {
    y[i] ~ dbin(p[i], Nfetus[i])
    logit(p[i]) <- alpha + beta * d[i]
    #posterior distribtuion of the BMD for the different doses
    P <- exp(alpha + beta * d[i]) / (1 + exp(alpha + beta * d[i]))
  }
  # specifying priors
  alpha ~ dlogis(0, 0.1)
  beta ~ dlogis(0, 0.1)
  #Posterior distribution of the BMD 
  P0 <- exp(alpha) / (1 + exp(alpha))
  o0 <- exp(alpha)
  o10 <- exp(beta*10)
}
"

# data list
data_list <- list(n = n, d = d, Nfetus = Nfetus, y = y)

# Compile and run model
model <- jags.model(textConnection(model_string), inits = model.inits ,data = data_list, n.chains = 2)
update(model, 1000) # burn-in
samples <- coda.samples(model, variable.names = c("alpha", "beta"), n.iter = 5000)

# Check the samples object
str(samples)

# Extract the samples for alpha and beta
alpha_samples <- as.numeric(samples[[1]])
beta_samples <- as.numeric(samples[[2]])

# Calculate o0 and o10
o0_estimate <- exp(mean(alpha_samples))
o10_estimate <- exp(mean(beta_samples * 10))

print(paste("o0 Estimate:", o0_estimate))
print(paste("o10 Estimate:", o10_estimate))

# Calculate mean and standard deviation for alpha and beta
alpha_mean <- mean(alpha_samples)
beta_mean <- mean(beta_samples)
alpha_sd <- sd(alpha_samples)
beta_sd <- sd(beta_samples)

print(paste("Alpha Estimate:", alpha_mean))
print(paste("Beta Estimate:", beta_mean))
print(paste("Alpha Standard Deviation:", alpha_sd))
print(paste("Beta Standard Deviation:", beta_sd))

# HDInterval package
install.packages("HDInterval")
library(HDInterval)

# HDI interval for alpha and beta
alpha_hdi <- hdi(alpha_samples)
beta_hdi <- hdi(beta_samples)

print("Alpha HDI Interval:")
print(alpha_hdi)
print("Beta HDI Interval:")
print(beta_hdi)


