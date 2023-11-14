# Home-work 1

library(haven)
library(tidyverse)
library(ggplot2)

# Growth dataset
growth_data <- read_sas("C:/Users/harve/Downloads/growth.sas7bdat")

# BMI dataset for the homework
bmi_data <- read_sas("C:/Users/harve/Downloads/bmilda.sas7bdat")

# Dimension of the dataset
dim(bmi_data)

# Structure of the dataset
str(bmi_data)

# Summary of the dataset
summary(bmi_data)

# Number of observations
unique_id_count <- bmi_data %>% 
  select(id) %>% 
  distinct() %>% 
  n_distinct()

print(unique_id_count)

# Number of observations by Gender
bmi_data %>%
  group_by(sex) %>%
  summarize(count = n_distinct(id)) %>%
  mutate(Gender = ifelse(sex == 0, "Female", "Male"))

# Number of observations by Age
bmi_data %>%
  group_by(fage, sex) %>%
  summarize(count = n_distinct(id))

print(Age_bmi)

# Count the number of NA in the Smoking column
na_count <- sum(is.na(bmi_data$smoking))

print(na_count)

# Drop missing observations using smoking variable
bmi_data <- bmi_data %>% 
  filter(!is.na(smoking))

# Create a new column for time as a continuous variable
bmi_data$time_cont <- as.numeric(bmi_data$time)

# Make time categorical
bmi_data$time <- as.factor(bmi_data$time)

write_xpt(bmi_data, "C:/Users/harve/Downloads/bmi_data.sas7bdat")

# check the linear combination of Age by Gender
# table(bmi_data$sex, bmi_data$fage)

# remove the last column smoking
new_bmi_data <- bmi_data[,-6] # I didn't work with this data


# Subset of the bmi dataset
v <- bmi_data[100:500,] 

v <- bmi_data %>% sample_n(100) #still need some tweaks

########################### EDA #########################################


mean_bmi_general <- bmi_data %>%
  group_by(time) %>%
  summarise(average = mean(bmi, na.rm = TRUE),
            variance = var(bmi, na.rm = TRUE),
            Number_of_patient = n(),
            .groups = "drop")

# Individual profiles
# Dont run
ggplot(v, aes(x = as.factor(time), y = bmi, group = id)) +
  geom_line() +
  labs(x = "Time", y = "BMI") +
  theme_minimal() +
  ggtitle("Individual Profiles according to their BMI")


# Individual Profiles by Gender

ggplot(v, aes(x = as.factor(time), y = bmi, group = id, color = as.factor(sex))) +
  geom_line() +
  labs(x = "Time", y = "BMI") +
  theme_minimal() +
  facet_wrap(~sex) +
  ggtitle("Individual Profiles of BMI by Gender")


# Mean structure
# Overall Mean structure 
ggplot(mean_bmi_general, aes(x = as.factor(time), y = average, group = 1)) +
  geom_line() +
  geom_errorbar(aes(ymin = average - sqrt(variance / Number_of_patient),
                    ymax = average + sqrt(variance / Number_of_patient)), 
                width = 0.1) +
  scale_y_continuous(limits = c(24, 27), breaks = seq(24, 27, by = 0.5)) +
  labs(x = "Time", y = "Average BMI") +
  theme_minimal() +
  ggtitle("Mean Evolution of BMI at Each Time Point")


# Mean structure by Gender
mean_bmi_profile_gender <- bmi_data %>%
  group_by(time, sex) %>%
  summarise(average = mean(bmi, na.rm = TRUE),
            variance = var(bmi, na.rm = TRUE),
            Number_of_patient = n(),
            .groups = "drop")

ggplot(mean_bmi_profile_gender, aes(x = as.factor(time), y = average, group = 1)) +
  geom_line() +
  geom_errorbar(aes(ymin = average - sqrt(variance / Number_of_patient),
                    ymax = average + sqrt(variance / Number_of_patient)), 
                width = 0.1) +
  facet_wrap(~sex) +
  labs(x = "Time", y = "Average BMI") +
  theme_minimal() +
  ggtitle("Mean Evolution of BMI by Gender")


########### Variance Structure ################

# Calculate variance of BMI at each time point
mean_bmi_general <- bmi_data %>%
  group_by(time) %>%
  summarise(average = mean(bmi, na.rm = TRUE),
            variance = var(bmi, na.rm = TRUE),
            Number_of_patient = n(),
            .groups = "drop")


# Create a line plot to visualize the variance structure
ggplot(mean_bmi_general, aes(x = as.factor(time), y = variance, group = 1)) +
  geom_line() +
  geom_errorbar(aes(ymin = variance - sqrt(variance / Number_of_patient),
                    ymax = variance + sqrt(variance / Number_of_patient)),
                width = 0.1) +
  labs(x = "Time", y = "Average BMI") +
  theme_minimal() +
  ggtitle("Variance Evolution of BMI at Each Time Point")


# Calculate variance of BMI by gender and time
mean_bmi_profile_gender <- bmi_data %>%
  group_by(time, sex) %>%
  summarise(average = mean(bmi, na.rm = TRUE),
            variance = var(bmi, na.rm = TRUE),
            Number_of_patient = n(),
            .groups = "drop")

# Confirm the variances for each sex
mean_bmi_profile_gender %>%
  filter(sex == '0') %>%
  group_by(time, sex)

# Create separate plots for each gender
ggplot(mean_bmi_profile_gender, aes(x = as.factor(time), y = variance, group = 1)) +
  geom_line() +
  geom_errorbar(aes(ymin = variance - sqrt(variance / Number_of_patient),
                    ymax = variance + sqrt(variance / Number_of_patient)), 
                width = 0.1) +
  facet_wrap(~sex) +
  labs(x = "Time", y = "Average BMI") +
  theme_minimal() +
  ggtitle("Variance Structure of BMI by Gender")


# Correlation structure
library(corrplot)

# change from long to wide format
wide_bmi_data <- bmi_data %>%
  pivot_wider(names_from = time, values_from = bmi) 

# wide_bmi_data <- wide_bmi_data %>%
#   filter(!is.na(smoking))


# Correlation matrix
cor_matrix <- cor(wide_bmi_data[, c("0", "1", "2", "3", "4", "5", "6", "7", "8", "9")], use = "complete.obs")


# Create the correlation matrix plot
corrplot(cor_matrix, method = "number", type = "upper", tl.cex = 0.7)


######################### Filter the dataset ###########################
id_counts <- table(wide_bmi_data$id)

filtered_data <- wide_bmi_data %>%
  group_by(id) %>%
  filter(n() > 2) %>%
  ungroup()


##################################################################


r2 <- vector("list", length = 100)
SSE <- vector("list", length = 100)
SSR <- vector("list", length = 100)
ni <- vector("list", length = 100)
intercept <- vector("list", length = 100)
slope <- vector("list", length = 100)
SEintercept <- vector("list", length = 100)
SEslope <- vector("list", length = 100)

# Loop through i from 1 to 100
for (i in 1:100) {
  # Subset the data
  subset_data <- bmi_data[bmi_data$id == i, ]
  

  if (nrow(subset_data) > 0) {
    # Fit linear regression model for each subset of data
    Model1 <- lm(bmi ~ time, data = subset_data, x = TRUE)
    
    # Store results in lists
    r2[[i]] <- summary(Model1)$r.squared
    SSE[[i]] <- sum(Model1$residuals^2)
    SSR[[i]] <- anova(Model1)$'Sum Sq'[[1]]
    ni[[i]] <- length(Model1$x[, 1])
    intercept[[i]] <- coef(Model1)[1]
    slope[[i]] <- coef(Model1)[2]
    SEintercept[[i]] <- summary(Model1)$coefficients[, 2][1]
    SEslope[[i]] <- summary(Model1)$coefficients[, 2][2]
  } else {
    # If there are no non-missing cases, assign NA to all elements for that i
    r2[[i]] <- NA
    SSE[[i]] <- NA
    SSR[[i]] <- NA
    ni[[i]] <- NA
    intercept[[i]] <- NA
    slope[[i]] <- NA
    SEintercept[[i]] <- NA
    SEslope[[i]] <- NA
  }
}

result_df <- data.frame(
  id = 1:100,
  r2 = unlist(r2),
  SSE = unlist(SSE),
  SSR = unlist(SSR),
  ni = unlist(ni),
  intercept = unlist(intercept),
  slope = unlist(slope),
  SEintercept = unlist(SEintercept),
  SEslope = unlist(SEslope)
)

# Calculate R2_meta
R2_meta <- sum(SSR) / sum(SSR + SSE)

one <- bmi_data[bmi_data$id == 1, ]
