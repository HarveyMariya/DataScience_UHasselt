install.packages("ISLR2")
library(ISLR2)


x <- rnorm(50)
y <- x + rnorm(50, mean = 50, sd = .2)
cor(x,y)

# Graphics

x <- rnorm(100)
y <- rnorm(100)

plot(x,y)

plot(x, y, xlab = "this is the x-axis",
     ylab = "this is the y-axis",
     main = "Plot of X vs Y")

# Save the output -> pdf: pdf(), jpeg: jpeg()

pdf("Figure.pdf")
plot(x, y, col = "green")
dev.off() # indicates that we are done creating the plot

# Contour plot

x <- seq(-pi, pi, length = 50)

y <- x

f <- outer(x, y, function(x, y) cos(y) / (1 + x^2))

contour(x, y, f)

contour(x, y, f, nlevels = 45, add = T)


fa <- (f - t(f)) / 2

contour(x, y, fa, nlevels = 15)

# heatmap
image(x, y, fa)

# 3D plot
persp(x, y, fa)

persp(x, y, fa, theta = 30)

persp(x, y, fa, theta = 30, phi = 50)


# Indexing Data
A <- matrix(1:16, 4, 4)
A

# 1st & 3rd row and 2nd & 4th column
A[c(1, 3), c(2, 4)]

# 1st to 3rd row and 2nd to 4th column
A[1:3, 2:4]

# 1st & 2nd row with all the columns
A[1:2, ]

# All rows with first 2 columns
A[, 1:2]


# Keep all the rows & columns except what is indicated in the index
A[-c(1, 3), ]

# Dimension of A
dim(A)


# Loading Dataset

Auto <- read.table("C:/Users/harve/Downloads/Auto.data", header = T, na.strings = "?", stringsAsFactors = T)
head(Auto)
dim(Auto)

# remove missing values
Auto <- na.omit(Auto)
dim(Auto)

# check variable names
names(Auto)

# Plots
plot(Auto$cylinders, Auto$mpg)

# attach tells R to make the variables in the df available by name i.e no need for Auto$...
attach(Auto)

# like this...
plot(cylinders, mpg)

# as.factors converts quantitative variables to qualitative variable
cylinders <- as.factor(cylinders)

plot(cylinders, mpg, col = "red", varwidth = T, horizontal = T,
     xlab = "cylinders", ylab = "MPG")

hist(mpg, col = 2, breaks = 15)

# create scatterplot matrix for every pair of variables
pairs(Auto)

# scatterplot for subset of the variables
pairs(
  ~ mpg + displacement + horsepower + weight + acceleration,
  data = Auto
)

plot(horsepower, mpg)

# clicking one or more points in the plot and hit Esc will print the values of the variable
# It corresponds to the rows for the selected points
identify(horsepower, mpg, name)

summary(Auto)
