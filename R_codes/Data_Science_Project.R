
# Data Cleaning for new_stock Dataset

# load libraries
library(dplyr)

# Read the dataset 
new_stock <- read.csv("C:/Users/harve/Downloads/new_stock.csv", header = T)

# check the first 6 rows of the data
head(new_stock)

# check the variable names 
names(new_stock)

# check temperature variable type and change to string
class(new_stock$Transport_environment_name)

# check product_name variable type and change to string
class(new_stock$Product_number)

# change expiry_date variable format to date-time format
new_stock <- na.omit(new_stock) # lost 278 observations

new_stock <- new_stock %>%
  mutate(expiry_date_formatted = as.Date(paste(substr(Expiry_date, 1, 4), substr(Expiry_date, 5, 6), substr(Expiry_date, 7, 8), sep = "-")))

# remove the time in location_date variable
# change the location_date variable to date-time variable

new_stock <- new_stock %>% 
  mutate(Location_date = as.Date(paste(substr(Location_date, 1, 10))))

# make 3 new variables from location_date variable -> Year, Month & Date
new_stock <- new_stock %>%
  mutate(Year = substr(Location_date, 1, 4), Month = substr(Location_date, 6, 7), Date = substr(Location_date, 9, 10))

# save the new dataset
write.csv(new_stock, "C:/Users/harve/Downloads/new_stock_clean.csv", row.names = F)

# new_stock_without_expiry_date dataset

# read the dataset
new_stock_without_expiry_date <- read.csv("C:/Users/harve/Downloads/new_stock_without_expiry_date.csv", header = T)

# check the first 6 rows of the data
head(new_stock_without_expiry_date)

# examine the structure of the data
str(new_stock_without_expiry_date)

# remove missing values
new_stock_without_expiry_date <- na.omit(new_stock_without_expiry_date)
str(new_stock_without_expiry_date) # 2 observations missing

# remove the time in Location_date
# change to date-time format

new_stock_without_expiry_date <- new_stock_without_expiry_date %>%
  mutate(Location_date = as.Date(paste(substr(Location_date, 1, 10))))

# make 3 new variables from location_date variable -> Year, Month & Date

new_stock_without_expiry_date <- new_stock_without_expiry_date %>%
  mutate(Year = substr(Location_date, 1, 4), Month = substr(Location_date, 6, 7), Date = substr(Location_date, 9, 10))

# save the new dataset
write.csv(new_stock_without_expiry_date, "C:/Users/harve/Downloads/new_stock_without_expiry_date_clean.csv", row.names = F)


###################################################################################################################

library(dplyr)
library(readxl)
setwd("C:/Users/harve/Downloads/")

# List of CSV file names
file_names <- c("Orderlijnen 01012022-31012022_1.xlsx", "Orderlijnen 01022022-31032022_2.xlsx",
                "Orderlijnen 01042022-31052022_3.xlsx", "Orderlijnen 01062022-30062022_4.xlsx",
                "Orderlijnen 01072022-31082022_5.xlsx", "Orderlijnen 01092022-30092022_6.xlsx",
                "Orderlijnen 01102022-31102022_7.xlsx", "Orderlijnen 01112022-30112022_8.xlsx",
                "Orderlijnen 01122022-31122022_9.xlsx", "Orderlijnen 01012023-31012023_10.xlsx",
                "Orderlijnen 01022023-28022023_11.xlsx", "Orderlijnen 01032023-31032023_12.xlsx",
                "Orderlijnen 01042023-31052023_13.xlsx", "Orderlijnen 01062023-30062023_14.xlsx",
                "Orderlijnen 01072023-31072023_15.xlsx")  # Add all your file names

# Create an empty list to store data frames
data_frames_list <- list()

# Read and merge CSV files
for (file in file_names) {
  data <- read_excel(file, sheet = 1, col_names = TRUE)
  data_frames_list <- append(data_frames_list, list(data))
}

# Merge all data frames in the list into one
merged_data <- bind_rows(data_frames_list)

# Begin cleaning

# Unwanted columns
unwanted_col <- c(1,2,5,8,11,10,14,15,17,18,19,20,22,23,25,26,27)
new_orderline_data <- merged_data[, -unwanted_col]

# save the new dataset
write.csv(new_orderline_data, "C:/Users/harve/Downloads/new_orderline_clean.csv", row.names = F)


################################################################################################
# New Task
################################################################################################

# Read the dataset orderline
new_data1 <- read.csv("C:/Users/harve/Downloads/new_orderline_clean.csv", header = T)

# count by date
new_data1 %>% 
  select(Order_date) %>% 
  distinct() %>% 
  n_distinct()

# group by date
new1 <- new_data1 %>%
  group_by(c)

# Read the dataset Inbound and Inbound frigo
new_data2 <- read.csv("C:/Users/harve/Downloads/cleaned_Inbound_tijdssloten.csv", header = T)

new_data2 %>% 
  select(Date) %>% 
  distinct() %>% 
  n_distinct()


############################################ ARIMA ########################################

# Load necessary libraries
library(ggplot2)
library(forecast)
library(tseries)


# Generate a time series with 100 days
set.seed(123)
days <- 1:500

# Simulate daily company output (dependent variable)
company_output <- 50 + 2 * days + rnorm(500)

# Create a data frame
data <- data.frame(Day = days, Output = company_output)

# Visualize the time series
ggplot(data, aes(x = Day, y = Output)) +
  geom_line() +
  labs(title = "Company Output Over Time", x = "Day", y = "Output")

# Decompose the time series
ts_decomposed <- decompose(data$Output)
plot(ts_decomposed)

# Perform Dickey-Fuller test (test for stationary)
adf.test(data$Output)

# Choose ARIMA orders (p, d, q) based on ACF and PACF plots and domain knowledge
order <- c(1, 0, 1)  # Example values; you should determine this

# Fit the ARIMA model
arima_model <- arima(data$Output, order = order)

# Print model summary
summary(arima_model)

# Forecast future values
forecast_values <- forecast(arima_model, h = 10)  # Forecast for the next 10 days
plot(forecast_values)

# view the predictions
forecast_values$mean


##################################################
library(dplyr)
library(xts)
library(forecast)
new_data <- read_excel("C:/Users/harve/Downloads/Data_Livlina.xlsx", col_names = T)
new_data$Date <- as.Date(new_data$Date)
data <- as.xts(new_data$Workload,order.by=new_data$Date)
data1 <- as.xts(new_data$`Number of Orders`, order.by = new_data$Date)
plot(data)
plot(data1)

arima_model <- auto.arima(data)
arima_model1 <- auto.arima(data1)
summary(arima_model1)

sarima_model <- auto.arima(data, seasonal = TRUE)
sarima_model1 <- auto.arima(data1, seasonal = T)
summary(sarima_model1)

# Compare AIC values
arima_aic <- AIC(arima_model)
sarima_aic <- AIC(sarima_model)

# Compare BIC values
arima_bic <- BIC(arima_model)
sarima_bic <- BIC(sarima_model)

cat("ARIMA AIC:", arima_aic, " SARIMA AIC:", sarima_aic, "\n")
cat("ARIMA BIC:", arima_bic, " SARIMA BIC:", sarima_bic, "\n")

# Diagnostic plots
plot(arima_model1)
acf(arima_model1$residuals)
pacf(arima_model1$residuals)

# Forecast and evaluate the ARIMA model
forecast_arima <- forecast(arima_model)
accuracy(forecast_arima)


# test if the covariates are related in time series - cointegration test

# If related, use a VAR or Vector error correction model or ARDL

################################################################
library(vars)

ts_data <- new_data[,c(5,11)]

ts_data <- data.frame(na.omit(ts_data))

colnames(ts_data)[2] <- "Number_of_orders"

# Select the lag order using the 'VARselect' function
var_select <- VARselect(ts_data, lag.max = 10, type = "none")
var_select

var_model <- VAR(ts_data, p = 2)
summary(var_model)

granger_test <- causality(var_model, cause = "Workload")

plot(var_model)

summary(var_model)
