# Chapter 3: Question 1

ff <- function(x) {
  fx <- exp(x) / (1 + exp(x))
  fx1 <- exp(x) / (1 + exp(x))^2
  fx2 <- -exp(x) * (exp(x) - 1) / (1 + exp(x))^3
  fx3 <- exp(x) * (-4 * exp(x) + exp(2 * x) + 1) / (exp(x) + 1)^4
  u <- list(fx = fx, fx1 = fx1, fx2 = fx2, fx3 = fx3)
  return(u)
}
x <- seq(-3, 3, .001)
u <- ff(x)
plot(x, u$fx,
  type = "l", lwd = 2,
  xlab = expression(italic(x)),
  ylab = expression(italic(f)(italic(x)))
)
u0 <- ff(0)
tx <- u0$fx + u0$fx1 * x + u0$fx2 * x^2 / 2 + u0$fx3 * x^3 / 6
lines(x, tx, col = "red")

# Question 2a

# Here is the contour plot and some co
ff <- function(x1, x2) {
  f <- exp(x1) * (4 * x1^2 + 2 * x2^2 + 4 * x1 * x2 + 2 * x2 + 1)
  return(f)
}
x1 <- seq(-2, 2, .005)
x2 <- seq(-2, 2, .005)
mm <- outer(x1, x2, "ff")
contour(x1, x2, mm,
  levels = c(.2, .4, .7, 1, 1.7, 1.75, 1.8, 2, 3, 4, 5, 6, 20)
)

# Question 2b

# p = phi; r = rho
fff <- function(x1, x2) {
  f <- exp(x1) * (4 * x1^2 + 2 * x2^2 + 4 * x1 * x2 + 2 * x2 + 1)
  f1 <- c(f + exp(x1) * (8 * x1 + 4 * x2), exp(x1) * (4 * x2 + 4 * x1 + 2))
  f2 <- matrix(c(
    f + 2 * exp(x1) * (8 * x1 + 4 * x2) + 8 * exp(x1),
    exp(x1) * (4 * x2 + 4 * x1 + 2) + 4 * exp(x1),
    exp(x1) * (4 * x2 + 4 * x1 + 2) + 4 * exp(x1), 4 * exp(x1)
  ), 2, 2, byrow = TRUE)
  u <- list(f = f, f1 = f1, f2 = f2)
  return(u)
}
fff(.5, -1)
fff(-1.5, 1)
# checking the eigenvalues of the Hessian in (0.5,-1)
eigen(fff(0.5, -1)$f2)
# checking the eigenvalues of the Hessian in (-1.5,1)
eigen(fff(-1.5, 1)$f2)

# Question 4b

wf <- function(y, p, r) {
  f <- p * r * y^(r - 1) * exp(-p * y^r)
  f1 <- p * r * y^(r - 2) * (-exp(-p * y^r)) * (p * r * y^r - r + 1)
  f2 <- p * r * y^(r - 3) * exp(-p * y^r) *
    (r * (p^2 * r * y^(2 * r) - 3 * p * (r - 1) * y^r + r - 3) + 2)
  u <- list(f = f, f1 = f1, f2 = f2)
}
x <- seq(.001, 4, .0001)
u <- wf(x, 1, 2)
plot(x, u$f, type = "l", ylim = c(0, 1))
uu <- wf(1, 1, 2)
yy <- uu$f + uu$f1 * (x - 1) + uu$f2 * (x - 1)^2 / 2
lines(x, yy, col = "red")
