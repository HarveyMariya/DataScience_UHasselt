# Sample Size Calculation
# Follow the following steps always:
# 1. Hypothesis
# 2. Significance level
# 3. Power
# 4. Variance or SD
# 5. Effect size 

# Example:
# 1. Sig level = 0.05
# 2. Power = 85%
# 3. Variance = 400 or SD = 20
# 4. Effect size = 15

# T-test
# One-sided
power.t.test(n =, delta = 15, sig.level = 0.05, 
             sd = 20, power = 0.85, type = "two.sample", alternative = "one.sided")

# two-sided
power.t.test(n =, delta = 15, sig.level = 0.05, 
             sd = 20, power = 0.80, type = "two.sample", alternative = "two.sided", strict = F)


# Proportional test
# p1 - proportion 1
# p2 - proportion 2
power.prop.test(n = NULL, p1 = 0.1, p2 = 0.4,
                sig.level = 0.05, power = 0.80)

power.prop.test(n = NULL, p1 = 0.6, p2 = 0.9, sig.level = 0.05, power = 0.90,
                alternative = "one.sided")

power.prop.test(n = NULL, p1 = 0.1, p2 = 0.4, sig.level = 0.05, power = 0.90,
                alternative = "one.sided")


# ANOVA data
# Input parameters needed:
# 1. no of groups
# 2. between variability: parameter determined by assumed effectsize
# 3. Within-variability: nuisance parameter

power.anova.test(groups = 5, n = NULL, between.var = 1, within.var = 5, sig.level = 0.05,
                 power = 0.90)

power.anova.test(groups = 5, n = NULL, between.var = var(c(10, 10, 10, 10, 12)), within.var = 5,
                 sig.level = 0.05, power = 0.90)


# Black Tulip Sample Size Calculation
sample_flower <- read.csv("C:/Users/harve/Downloads/G4.pilot.data.csv")
head(sample_flower)

# Fit Poisson regression model
pois_model <- glm(tot.vase.days ~ species + garden + rater, data = sample_flower, family = poisson)
pois_model

# Check for over-dispersion
dispersion <- sum(resid(pois_model, type = "pearson")^2) / df.residual(pois_model)
if (dispersion > 1) {
  print("Over-dispersion detected")
} else {
  print("No over-dispersion detected")
}

# Since Over-dispersion is detected we simulate to get the required sample size of the study.
# Calculate the mean of the outcome
mean_flower <- mean(sample_flower$tot.vase.days)
mean_flower
# Calculate the variance of the outcome
# sample_var <- sum((sample_flower$tot.vase.days - mean_flower)^2) / (nrow(sample_flower) - 1)
sample_var <- sd(sample_flower$tot.vase.days)^2


# rm(list=ls()) #clears the environment
# install libraries
# install.packages(c("tidyverse", "pwr", "lme4", "sjPlot", "simr", "effectsize"))
# install.packages(c("DT", "knitr", "flextable"))
# install.packages("DescTools")
# install.packages("pacman")



lambda <- 23.8
effect_sizes <- c(1, 2, 3)

df <- data.frame()

# for (i in effect_sizes) {
#   result <- poisson_power_simulator(lambda0 = lambda, lambda1 = lambda + i, alpha = 0.05,
#                                     test = "two_sided", n_sims = 500, seed_nr = 1234)
#   df_i <- data.frame(n_grid = result$n_grid, power_vec = result$power_vec, effect_size = i)
#   df <- rbind(df, df_i)
# }


result1 <- poisson_power_simulator(lambda0 = 18.4, lambda1 = 19.4, alpha = 0.05,
                                  test = "two_sided", n_sims = 500, seed_nr = 1234)


result2 <- poisson_power_simulator(lambda0 = 18.4, lambda1 = 20.4, alpha = 0.05,
                                  test = "two_sided", n_sims = 500, seed_nr = 1234)


result3 <- poisson_power_simulator(lambda0 = 18.4, lambda1 = 21.4, alpha = 0.05,
                                  test = "two_sided", n_sims = 500, seed_nr = 1234)




plot(result1$n_grid, result1$power_vec * 100, type = "l", col = "blue", 
     xlab = "Sample Size", ylab = "Power", ylim = c(0,100), 
     main = "Power Analysis Results (Variance = 18.4)")
lines(result2$n_grid, result2$power_vec * 100, col = "red")
lines(result3$n_grid, result3$power_vec * 100, col = "green")
legend("bottomright", legend = c("Effect Size 1", "Effect Size 2", "Effect Size 3"), 
       col = c("blue", "red", "green"), lty = 1, cex = 0.8, bty = "n")
abline(h = 80, lty = 2)


#######################################################
ggplot() +
  geom_line(data = result1, aes(x = n_grid, y = power_vec), color = "blue") +
  geom_line(data = result2, aes(x = n_grid, y = power_vec), color = "red") +
  geom_line(data = result3, aes(x = n_grid, y = power_vec), color = "green") +
  labs(color = "Effect Size") +
  scale_color_manual(values = c("blue", "red", "green")) +
  theme_minimal()

library(ggplot2)

ggplot(df, aes(x = n_grid, y = power_vec, color = factor(effect_size))) +
  geom_line() +
  scale_color_manual(values = c("blue", "red", "green")) +
  labs(color = "Effect Size") +
  theme_minimal()


###################################

poisson_power_simulator(lambda0 = 18.4, eff_size = 1, 
                        alpha = 0.05, n = 50)
purrr::map_df(50:100, function(i){
  poisson_power_simulator(lambda0 = 18.4, eff_size = 1, 
                          alpha = 0.05, n = i, n_reps = 500)
})


####################################### EDA ##########################

original_gaus <- read.csv("C:/Users/harve/Downloads/gaussian_data_G4.csv")

original_count <- read.csv("C:/Users/harve/Downloads/count_data_G4.csv")

binary_data <- read.csv("C:/Users/harve/Downloads/Binary_longitudinal.csv")

gaus_no_missing <- na.omit(original_gaus)

count_no_missing <- na.omit(original_count)

# Export gaus_no_missing as a CSV file
write.csv(gaus_no_missing, file = "gaus_no_missing.csv", row.names = FALSE)

# Export count_no_missing as a CSV file
write.csv(count_no_missing, file = "count_no_missing.csv", row.names = FALSE)

# Export gaus_no_missing as a CSV file
write.csv(original_gaus_long, file = "gaus_new_long.csv", row.names = FALSE)

original_gaus_long <- na.omit(original_gaus_long)

ggplot(gaus_no_missing, aes(x = as.factor(Compound), y = Flower_index)) + 
  geom_boxplot() + 
  labs(x = "Compound", y = "Flower_index")

library(tidyverse)

library(ggplot2)

original_gaus_long <- data.frame(original_gaus %>% tidyr::pivot_longer(cols = T_0:T_20, 
                                      names_to = "Time",
                                      values_to = "Width") %>%
  mutate(Time2 = sapply(str_split(Time, "_"), "[[",2)))

# Export gaus_no_missing as a CSV file
write.csv(original_gaus_long, file = "gaus_new_long.csv", row.names = FALSE)

original_gaus_long <- na.omit(original_gaus_long)
original_gaus_long$Time2 <- as.numeric(original_gaus_long$Time2)

###########################################################

original_gaus_mn <- original_gaus_long %>% group_by(Compound, Type, Time2) %>%
  summarise(mn = mean(Width, na.rm=T),
            vv = var(Width, na.rm=T)) %>% 
  mutate(Compound = factor(Compound),
         Type = factor(Type),
         Time2 = as.numeric(Time2))

# Mean profiles
original_gaus_mn %>% ggplot(aes(x = Time2, y = mn,
                                color = Compound,
                                group = interaction(Compound, Type))) +
  geom_line(linewidth = 1.5)+
  facet_wrap(.~Type)+
  theme_bw() + 
  labs(x='Time', y='Average width') +
  ggtitle("Mean Profiles in Compounds by Species over time")

# Variance profiles
original_gaus_mn %>% ggplot(aes(x = Time2, y = vv,
                                color = Compound,
                                group = interaction(Compound, Type))) +
  geom_line(linewidth = 1.5)+
  facet_wrap(.~Type)+
  theme_bw() + 
  labs(x='Time', y='Average width') +
  ggtitle("Variance Profiles in Compounds by Species over time")


gard <- original_gaus_long %>% group_by(Compound, Garden, Time2) %>%
  summarise(mn = mean(Width, na.rm=T),
            vv = var(Width, na.rm=T)) %>% 
  mutate(Compound = factor(Compound),
         Type = factor(Garden),
         Time2 = as.numeric(Time2))

# Mean profiles for Garden
gard %>% ggplot(aes(x = Time2, y = mn,
                                color = Compound,
                                group = interaction(Compound, Garden))) +
  geom_line(linewidth = 1.5)+
  facet_wrap(.~Garden)+
  theme_bw() + 
  labs(x='Time', y='Average width') +
  ggtitle("Mean Profiles in Compounds by Garden over time")

# Variance profiles for Garden
gard %>% ggplot(aes(x = Time2, y = vv,
                    color = Compound,
                    group = interaction(Compound, Garden))) +
  geom_line(linewidth = 1.5)+
  facet_wrap(.~Garden)+
  theme_bw() + 
  labs(x='Time', y='Average width') +
  ggtitle("Mean Profiles in Compounds by Garden over time")



error_b <- original_gaus_long %>%
  group_by(Compound) %>%
  summarise(
    sd = sd(Width, na.rm = T),
    len = mean(Width, na.rm = T)
  )

ggplot(
  error_b, 
  aes(x = Compound, y = len, ymin = len-sd, ymax = len+sd)
)+
  geom_errorbar(width = 0.2)+
  geom_point(size = 1.5) +
  theme_bw() + 
  labs(x='Compound', y='Average width') +
  ggtitle("Average Width in different Compounds")



error_bar <- original_gaus_long %>%
  group_by(Compound, Type) %>%
  summarise(
    sd = sd(Width, na.rm = T),
    len = mean(Width, na.rm = T)
  ) %>%
  mutate(Type = factor(Type))

ggplot(error_bar, aes(x = Compound, y = len, color = Type)) +
  geom_errorbar(aes(ymin = len - sd, ymax = len + sd), 
                position = position_dodge(0.9), 
                width = 0.2) +
  geom_point(position = position_dodge(0.9)) +
  theme_bw() + 
  labs(x='Compound', y='Average width') +
  ggtitle("Comparison of the Compound with the average width of the types of flower") +
  theme(legend.position = "top")


##################### Binary ############
x <- binary_data %>% group_by(compound, species, time) %>%
  summarise(mn = round(mean(fresh, na.rm=T),2),
            vv = var(fresh, na.rm=T)) %>% 
  mutate(Compound = factor(compound),
         Type = factor(species),
         Time = as.numeric(time))

x %>% ggplot(aes(x = Time, y = vv,
                 color = Compound,
                 group = interaction(Compound, Type))) +
  geom_line(linewidth = 0.2)+
  theme_bw() + 
  labs(x='Time', y='Average width') +
  ggtitle("Mean Profiles in Compounds by Species over time")


x %>% ggplot(aes(x = Time, y = mn,
                                color = Compound,
                                group = interaction(Compound, Type))) +
  geom_line(linewidth = 1.5)+
  facet_wrap(.~Type)+
  theme_bw() + 
  labs(x='Time', y='Average width') +
  ggtitle("Mean Profiles in Compounds by Species over time")

# Mean Profiles by Garden
binary_data %>% group_by(compound, garden, time) %>%
  summarise(mn = round(mean(fresh, na.rm=T),2),
            vv = var(fresh, na.rm=T)) %>% 
  mutate(Compound = factor(compound),
         Type = factor(garden),
         Time = as.numeric(time))

# Calculate the percent of missing observations in tot.vase.days by compound
original_count %>%
  group_by(compound) %>%
  summarize(missing_count = sum(is.na(tot.vase.days)),
            missing_pct = mean(is.na(tot.vase.days)) * 100)


# Calculate the mean for each time point per compound
# mean_width <- aggregate(gaus_no_missing[,7:27], 
#                         by=list(Compound=gaus_no_missing$Compound), 
#                         FUN=mean)

# Reshape the data to long format
# mean_width_long <- tidyr::gather(mean_width, "Time", "Width", -Compound)


# mean_width$avg <- rowMeans(mean_width[,2:22])


# mean_width_long <- mean_width %>%
#   gather(key = "time", value = "width", -Compound, -avg)


##############################################################

# Model GEE
library(geepack)

# Binary
gee_binary1 <- geeglm(fresh ~ time + as.factor(compound) + time*as.factor(compound),
                     data = binary_data, id = flowerID, family = binomial,
                     corstr = "ar1")
summary(gee_binary1)

gee_binary2 <- geeglm(fresh ~ time*as.factor(compound),
                     data = binary_data, id = flowerID, family = binomial,
                     corstr = "ar1")

summary(gee_binary2)


# Count
count_no_missing$compound <- as.factor(count_no_missing$compound)
count_no_missing$subplotID <- as.factor(count_no_missing$subplotID)
count_no_missing$rater <- as.factor(count_no_missing$rater)


gee_count <- geeglm(tot.vase.days ~ compound + subplotID + rater, family = poisson,
                    data = count_no_missing, id = flowerID, corstr = "unstructured")

