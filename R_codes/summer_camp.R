# Visualization -> Modelling -> Communication (Result)

library(tidyverse)
library(nycflights13)

# Visualization
# Template:
# ggplot(data = <DATA>) + 
#   <GEOM_FUNCTION>(
#     mapping = aes(<MAPPINGS>),
#     stat = <STAT>, 
#     position = <POSITION>
#   ) +
#   <COORDINATE_FUNCTION> +
#   <FACET_FUNCTION>
  
  
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy))


ggplot(data = mpg) +
  geom_point(mapping = aes(x = cyl, y = hwy))

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, color = class))

# this becomes two colors in the legend
ggplot(data = mpg) +
  +   geom_point(mapping = aes(x = displ, y = hwy, color = displ < 5))

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, size = class))

# Facets
# N.B: the variable passed to facet_wrap should be a factor
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_wrap(~ class, nrow = 2)

# Facet on the combination of two variables
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_grid(drv ~ cyl)

# creates grid of plots with rows
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid(drv ~ .)

# creates grid of plots with columns
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid(. ~ cyl)

# it uses only 6 shapes
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, shape = class))

# jitter spreads the overlapping points in the dataset. It introduces small amount of 
# random noise.
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy), position = "jitter")

# Geometric objects
# bar charts -> bar geoms
# line charts -> line geoms
# boxplots -> boxplot geoms
# Scatterplots -> point geom

ggplot(data = mpg) +
  geom_smooth(
    mapping = aes(x = displ, y = hwy, color = drv),
    show.legend = TRUE
  )

# To display multiple geoms in the same plots
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) +
  geom_smooth(mapping = aes(x = displ, y = hwy))

ggplot(data = mpg, mapping = aes(x = displ, hwy)) + 
  geom_point(mapping = aes(color = class)) +
  geom_smooth()

ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point(mapping = aes(color = class)) + 
  geom_smooth(data = filter(mpg, class == "subcompact"), se = FALSE)


# Exercise
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy), size = 3) +
  geom_smooth(mapping = aes(x = displ, y = hwy), se = F)

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy), size = 3) +
  geom_smooth(mapping = aes(x = displ, y = hwy, group = drv), se = F)

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, color = drv), size = 3) +
  geom_smooth(mapping = aes(x = displ, y = hwy, group = drv, color = drv), se = F)

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, color = drv), size = 3) +
  geom_smooth(mapping = aes(x = displ, y = hwy), se = F)

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, color = drv), size = 3) +
  geom_smooth(mapping = aes(x = displ, y = hwy, group = drv, linetype = drv), se = F)


# Bar charts
ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut, y = after_stat(prop), group = 1))

# Error bars
ggplot(data = diamonds) + 
  stat_summary(
    mapping = aes(x = cut, y = depth),
    fun.min = min,
    fun.max = max,
    fun = median
  )

# using fill on the bars
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, fill = cut))

ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, fill = clarity))

# overlapping objects directly beside one another
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, fill = clarity), position = "dodge")


# Make a third column in the dataframe
df <- data.frame(runif(3), runif(3))
names(df) <- c(1, 2)
df$'3' <- df$'1' + df$'2'

# To check the size in memory y occupies
x <- runif(1e6)
y <- list(x, x, x)
obj_size(y)


a <- c(1, 5, 3, 2)
b <- a
b[[1]] <- 10

# Data transformation
# Filter - Arrange - Select - Mutate - Summarise} all works with group_by

# Filter
jan1 <- filter(flights, month == 1, day == 1)

# prints and save the result
(dec25 <- filter(flights, month == 12, day == 25))

# instead of sqrt(2)^2 == 2 use near(sqrt(2)^2 , 2)
# instead of 1 / 49 * 49 == 1 use near(1 / 49 * 49 , 1)

filter(flights, month == 11 | month == 12) # OR
nov_dec <- filter(flights, month %in% c(11,12))

# flights that weren't delayed (on arrival or departure) by more than two hours
filter(flights, arr_delay <= 120 | dep_delay <= 120)
filter(flights, !(arr_delay > 120 | dep_delay > 120))

# Flew to Houston(IAH or HOU)
(arr_IAH_HOU <- filter(flights, dest == "IAH" | dest == "HOU"))

# Flights that departed in summer (July, August, September)
filter(flights, month %in% c(7,8,9))

# count the number of missing observations in dep_time column
(cnt <- sum(is.na(flights$dep_time)))

# Arrange function
#By default it follows ascending order
arrange(flights, year, month, day, arr_time)

# arrange in descending order
arrange(flights, desc(dep_delay))

arrange(flights, is.na(dep_time)) # OR flights %>% arrange(is.na(dep_time))

# sort flights to find the most delayed flights
flights %>% arrange(arr_delay)

# Find the flights that left earliest
flights %>% arrange(dep_time)

# Sort flights to find the fastest (highest speed) flights
View(flights %>% arrange(desc(distance/air_time)))


# Select function
# it allows you to subset the data
flights %>% select(year, month, day) # OR flights %>% select(year:day)

# select all the columns except
flights %>% select(-c(year:day))

# select dep_time, dep_delay, arr_time and arr_delay
flights %>% select(dep_time, dep_delay, arr_time, arr_delay)

# to move specific columns to the begining of the dataframe
flights %>% select(time_hour, air_time, everything())

# checks and selects any of the variables located in the dataframe
flights %>% select(any_of(c("year", "month", "day", "arr_delay")))

# Rename function
View(flights %>% rename(tail_num = tailnum))

# Mutate function
# first let us make a subset of the data
new_flights <- flights %>% 
  select(ends_with(c('delay','time')), distance)

new_flights %>% mutate(gain = dep_delay - arr_delay, speed = distance/air_time * 60)

# keep only the newly calculated variables
new_flights %>% transmute(gain = dep_delay - arr_delay, speed = distance/air_time * 60)


# Summarise function
# make a subset of the data
sub_flight <- flights %>% select(year, month, day, air_time, dep_delay, arr_time)

# use the group_by and summarise function
g <- sub_flight %>% group_by(year, month, day) %>% summarise(delay = mean(air_time, na.rm = T))

# summarise by getting the mean of air_time for 2013
sub_flight %>% group_by(year) %>% summarise(delay = mean(air_time, na.rm = T))

# Combining multiple operations with pipe
flights %>% group_by(dest) %>%
  summarise(
    count = n(),
    dist = mean(distance, na.rm = T),
    delay = mean(arr_delay, na.rm = T)
  ) %>%
  filter(count > 20, dest != "HNL")

# remove missing obeservation
without_na <- flights %>% filter(!is.na(dep_delay), !is.na(arr_delay))



# Vectorised if: use ifelse
# %% is modulu

x <- 1:10
ifelse(x %% 5 == 0, "XXX", as.character(x))

ifelse(x %% 2 == 0, "even", "odd")

# for more conditions (> 2) you could use case
dplyr::case_when(
  x %% 9 == 0 ~ "think",
  x %% 5 == 0 ~ "y",
  x %% 7 == 0 ~ "m",
  is.na(x) ~ "???",
  TRUE ~ as.character(x)
)

# Switch statement
(switch("c",a = 1, b = 2))

x_option <- function(x){
  switch(x,
         a = "option 1",
         b = "option 2",
         c = "option 3",
         stop("Invalid 'x' value")
         )
}


# Loops

means <- c(1, 50, 20)

out <- vector("list", length(means))

for (i in 1:length(means)) {
  
  # this will return a single value in each list
  out[i] <- rnorm(10, means[i])
  }

for (i in 1:length(means)) {
  
  # this will return a list of 10 values in each list
  out[[i]] <- rnorm(10, means[[i]])
}

# for vectors with length 0, the loop will fail but seq_along will be helpful

means <- c()
seq_along(means)


out <- vector("list", length(means))
for (i in seq_along(means)) {
  out[[i]] <- rnorm(10, means[[i]])
}

out

xs <- as.Date(c("2020-01-01", "2010-01-01"))

for (i in seq_along(xs)) {
  print(xs[[i]])
}


# Functions
# use args(function) to check the arguments of a function e.g args(mean)
# three components of a function: 
      # arguments: list of arguments
      #   body: the code inside the function
      #     environment: the data structure (this is specified implicitly)

f01 <- function(x){
  sin(1 / x ^ 2)
}

# list apply is used here to calculate the length of unique values in each column
lapply(mtcars, function(x) length(unique(x)))


# filter and return a subset of the dataframe where none of the columns have numeric values
Filter(function(x) !is.numeric(x), mtcars)


# put functions in a list
funs <- list(
  half = function(x) x / 2,
  double = function(x) x * 2
)

funs$double(5)

# Invoking a function
args <- list(1:10, na.rm = TRUE)

do.call(mean, args)

# Function composition
square <- function(x) x ^ 2
deviation <- function(x) x - mean(x)

p <- runif(100)

# nesting
sqrt(mean(square(deviation(p))))

# OR using objects
out <- deviation(p)
out <- square(out)
out <- mean(out)
out <- sqrt(out)
out

# OR using pipes
library(magrittr)
# the magrittr package makes use of %>% as it consists a sequence of transformation
p %>% 
  deviation() %>%
  square() %>%
  mean() %>%
  sqrt()



x_ok <- function(x) {
  !is.null(x) & length(x) == 1 & x > 0
}

x_ok <- function(x) {
  !is.null(x) && length(x) == 1 && x > 0
}

x_ok(NULL)
x_ok(1)
x_ok(1:3)

show_time <- function(x = stop("Error!")) {
  stop <- function(...) Sys.time()
  print(x)
}
show_time()


# read/know on.exit() function

# A function can take any of the forms below:
# prefix --> sum(x)
# infix --> x + y
# replacement --> names(df) <- c('a','b')
# special --> if, for etc.

# Examples:
# 5 + 4 can be expressed as '+'(5,4)
# names(df) <- c('x','y','z') can be expressed as 'names<-'(df, c('x','y','z'))


# create and customize your own infix functions
'%a%' <- function(a,b) (b*b) + a
'% %' <- function(x,y) (x/y) - y
'%db%' <- function(c, d, e) (c * d * e) - (c + d + e) 

4 %a% 3
5 % % 2
a <- 4
b <- 5
c <- 6

'%db%' (a,b,c) # OR '%db%' (4,5,6)

# create and customize your own replacement functions
# replace the second item in a list x with value
'second<-' <- function(x, value){
  x[2] <- value
  x
}

x <- 2:9
second(x) <- 10
x

'modify<-' <- function(x, position, value){
  x[position] <- value
  x
}
x <- 'modify<-'(x,5,10)  # OR modify(x, 1) <- 10
x
