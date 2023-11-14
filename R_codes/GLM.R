############### GLM #############

############################### Example logistics regression ############
# Using proportion of cases with heart disease as the response and number of cases as the weight
snoring <- data.frame(
  snore = c(0,2,4,5),
  heartdisyes = c(24,35,21,30),
  n = c(1379, 638, 213, 254)
)
snoring

snoring.lg <- glm(heartdisyes/n ~ snore, weights = n, family = binomial(), data = snoring)
snoring.lg

#############################
# install.packages('epiR')
# install.packages(c('MASS',"DescTools"))

american <- matrix(c(621, 239, 89, 42), nrow = 2, byrow = T)
dimnames(american) <- list(c("White","Black"), c("Yes","No or Undecided"))
names(dimnames(american)) <- c("Racer","Belief_in_Afterlife")
american

addmargins(american)


prop.table(american, margin = 1)

# Risk difference
prop.test(american, conf.level = 0.90,correct = F)

#### Relative Risk and Odd Ratio
library(epiR)
library(MASS)

epi.2by2(american, conf.level = 0.90)

# Pearson Chi-square statistic
Xsq <- chisq.test(american, correct = F)
Xsq$expected

loglm(~ Racer + Belief_in_Afterlife, data = american)


# Question 2
mammography <- matrix(c(13, 77, 144, 4, 16, 54, 1, 12, 91), nrow = 3, byrow = T)
dimnames(mammography) <- list(c("Never (0)","Over one year ago (1)","Within the past year (2)"), c("NL", "SL", "VL"))
names(dimnames(mammography)) <- c("Mammography_Exp", "Detection_of_Breast_Cancer")
mammography

prop.table(mammography)

prop.table(mammography, margin = 1)

prop.table(mammography, margin = 2)

q2 <- chisq.test(mammography, correct = F)
q2

loglm(~ Mammography_Exp + Detection_of_Breast_Cancer, data = mammography)
# A woman's opinion on the ability of a mammogram to detect a 
# new case of breast cancer is associated with her decision to have mammogram.

# Alternative test
fisher.test(mammography, alternative = "greater")

# Just trying other test
#library(DescTools)
#MHChisqTest(mammography, srow = c(0,1,2))


# Question 3
organ_malformation <- matrix(c(17066, 14464, 788, 126, 37, 48, 38, 5, 1, 1), nrow = 2, byrow = T)
dimnames(organ_malformation) <- list(c('Absent','Present'), c('0', '<1', '1-2', '3-5', '>=6'))
names(dimnames(organ_malformation)) <- c('Malformation', 'Maternal Alcohol Consumption (drinks/day)')
organ_malformation

addmargins(organ_malformation)

# changing the variables to scores
organ_malformation_score <- matrix(c(17066, 14464, 788, 126, 37, 48, 38, 5, 1, 1), nrow = 5, byrow = T)
dimnames(organ_malformation_score) <- list(c(1,2,3,4,5), c(0,1))
names(dimnames(organ_malformation_score)) <- c('Alcohol','Malform')
organ_malformation_score

MHChisqTest(organ_malformation_score, srow = c(1,2,3,4,5))

catt_exact(dose.ratings = c(1,2,3,4,5),
           totals = organ_malformation_score[,1] + organ_malformation_score[,2],
           cases = organ_malformation_score[,2])

MHChisqTest(organ_malformation_score, srow = c(0,0.5,1.5,4,8))

catt_exact(dose.ratings = c(0,0.5,1.5,4,8),
           totals = organ_malformation_score[,1] + organ_malformation_score[,2],
           cases = organ_malformation_score[,2])

# Mantel-Haenszel Chi-square test
# this had a higher chi-square statitics because the variables were not changed to scores
MHChisqTest(organ_malformation, srow = c(1,2,3,4,5))


# Question 4
knee_surgery <- matrix(c(3,2,7,1), nrow = 2, byrow = T)
dimnames(knee_surgery) <- list(c(1,2), c(2,1))
names(dimnames(knee_surgery)) <- c('Injury','Result')

MHChisqTest(knee_surgery, srow = c(0,1))

##################### Assignment 2 (GLM) ###########################################
smoking <- factor(rep(c('No', 'Yes'), each = 4), levels = c('No', 'Yes'))
dusty_area <- factor(rep(rep(c('Yes','No'),c(2,2)),2), levels = c('Yes','No'))
byssinosis <- factor(rep(c('Yes','No'), 4), levels = c('Yes', 'No'))
count <- c(81,364, 37, 2696, 18, 196, 24, 1988)
Byssinosis <- data.frame(smoking, dusty_area, byssinosis, count)
Byssinosis

# Create the contingency table by collapsing over smoking status
table_byssinosis <- xtabs(count ~ dusty_area + byssinosis, data = Byssinosis)
table_byssinosis

# calculate the odds ratio
# library(epitools)
# Interpret: the OR (13.55) shows that the odds that patients surviving in the dusty area is 13.55 times the odds of patients not in the dusty area.
oddsratio(table_byssinosis)

# the p-value depicts that there is a relationsip between dusty area and byssinosis while controlling for smoking status
chisq.test(table_byssinosis)

# Create the 2 by 2 contingency tables for each smoking level
table_smoking_yes <- xtabs(count ~ dusty_area + byssinosis, data = subset(Byssinosis, smoking == "Yes"))
table_smoking_no <- xtabs(count ~ dusty_area + byssinosis, data = subset(Byssinosis, smoking == "No"))

# Calculate the odds ratios for each smoking level
odds_ratio_yes <- oddsratio(table_smoking_yes)
odds_ratio_no <- oddsratio(table_smoking_no)

# View the odds ratios
odds_ratio_yes
odds_ratio_no
# This indicates that the odds ratio of dusty_area and byssinosis is 7.61 when smoking is "Yes", and 16.15 when smoking is "No". 
# This suggests that the relationship between dusty_area and byssinosis may be different for different smoking levels.

# Estimate the conditional odds ratio between Dusty Area and Byssinosis, controling for smoking
# Create a 2 by 2 by 2 contingency table
table_3way <- xtabs(count ~ smoking + dusty_area + byssinosis, data = Byssinosis)
ftable(table_3way)

# Estimate the conditional odds ratio between Dusty Area and Byssinosis
# Test of independence
test_interaction <- mantelhaen.test(table_3way)
test_interaction

# Test for Homogeneity of the odds ratio (not asked in this question)
test_homogeneity <- BreslowDayTest(table_3way, correct = FALSE)
test_homogeneity


############## Assignment 3 ###################
cities <- c("Beijing","Shanghai","Shenyang","Nanjing","Harbin","Zhengzhou","Taiyuan","Nanchang")
City <- factor(rep(cities,rep(4,length(cities))),levels=cities)
Smoker <- factor(rep(rep(c("Yes","No"),c(2,2)),8),levels=c("Yes","No"))
Cancer <- factor(rep(c("Yes","No"),16),levels=c("Yes","No"))
Count <- c(126,100,35,61,908,688,497,807,913,747,336,598,235,172,58,121,402,308,121,215,182,156,72,98,60,99,11,43,104,89,21,36)
chismoke <- data.frame(City,Smoker,Cancer,Count)
chismoke


# Question 1
# Logistic regression
# create data frame
chinese.smoke <- data.frame(
  City = factor(c(rep("Beijing", 2), rep("Shangai", 2), rep("Shenyang", 2), rep("Nanjing", 2), 
           rep("Harbin", 2), rep("Zhengzhou", 2), rep("Taiyuan", 2))),
  Smoking = factor(rep(c("Smokers", "Nonsmokers"), 7)),
  Yes = c(126, 35, 908, 497, 913, 497, 913, 336, 402, 121, 182, 72, 60, 21),
  No = c(100, 61, 688, 807, 747, 807, 747, 598, 308, 215, 156, 98, 99, 36),
  OR = c(2.20, 2.14, 2.18, 2.18, 2.32, 1.59, 2.37),
  mu11k = c(113.0, 773.2, 799.3, 799.3, 355.0, 169.0, 53.0),
  var = c(16.9, 179.3, 149.3, 149.3, 57.1, 28.3, 9.0)
)

# remove column 5 in the dataset
chinese.smoke[,-5]


# add calculated variables
# chinese.smoke$Odds_Ratio <- with(chinese.smoke, Yes / No)
# chinese.smoke$µ11k <- with(data, log(Yes / No))
# chinese.smoke$Var_n11k <- with(data, 1 / Yes + 1 / No)

# view data
data
# fit model
model <- glm(cbind(Yes, No) ~ City + Smoking, data = chinese.smoke, family = binomial(link = "logit"))

# show summary of model
summary(model)


# Pearson and Likelihood tests of goodness of fit
# H0: the model has a good fit
# H1: the model is not a good fit
# Pearson
pchisq(sum(resid(model,type='pearson')^2),df=model$df.residual,lower.tail=FALSE)

# Likelihood ratio test
pchisq(model$deviance,df=model$df.residual,lower.tail=FALSE)



# Likelihood ratio test
library(lmtest)
GLM.0 <- glm(cbind(Yes, No) ~ 1, family='binomial'(link = 'logit'), data = chinese.smoke)
GLM.1 <- glm(cbind(Yes, No) ~ City + Smoking, data = chinese.smoke, family = binomial(link = "logit"))

lrtest(GLM.0, GLM.1)

# Pearson chi-square
pchisq(GLM.0$deviance - GLM.1$deviance,
       df = GLM.0$df.residual - GLM.1$df.residual, lower.tail = F)



