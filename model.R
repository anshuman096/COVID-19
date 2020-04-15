library(ggplot2)
source('utils/utils.R')


gradient = function(a, b, c, t, y, y.hat, param) {
  param0 = 0
  for(i in 1:length(t)) {
    if(param == 'a')
      param0 = param0 + (2 * exp(-b * exp(-c * t[i])) * (y.hat[i] - y[i])) 
    else if(param == 'b')
      param0 = param0 + (2 * y.hat[i] * exp(-c * t[i]) * (y[i] - y.hat[i]))
    else 
      param0 = param0 + (2 * b * t[i] * y.hat[i] * exp(-c * t[i]) * (y.hat[i] - 1))
  }
  
  return((1/length(t)) * param0)
} 

gompertz = function(a, b, c, days) {
  y.hat = a * exp(-b * exp(-c * days))
  return(y.hat)
}

cost = function(y, y.hat) {
  n = length(y) # or y.hat, both should be the same
  cost = (1/n) * sum(y - y.hat)^2
  return(cost)
}

total.confirmed = get.US.total.confirmed()
num.days = append(c(0), cumsum(as.numeric(diff(total.confirmed$Date))))
cumulative = rowSums(total.confirmed[, 2:length(total.confirmed)])
us.cumulative = data.frame(cbind(num.days, cumulative))
colnames(us.cumulative) = c('Number of Days', 'Cumulative Count')

ggplot(us.cumulative, aes(x = `Number of Days`, y = `Cumulative Count`)) + geom_bar(stat = 'identity') + 
  scale_y_continuous(labels = scales::comma)

n = length(num.days)  # number of days so far
# We will be fittin a Gompertz function to this pandemic curve via gradient descent. To start off, 
# we need to select starting values for our parameter. These initial estimates have minimal mathematical
# backing to their choosing

# Initial choice for a -  little more than current max in US
a = 595000
# Initial choice for b - number of days to midpoint of slope
b = 70
# Initial choice for c
c = 0.02

actual.cases = us.cumulative$`Cumulative Count`
projected.cases = gompertz(a, b, c, num.days)
curr.cost = cost(actual.cases, projected.cases)


precision = 0.0000001
alpha = 0.01 # the learning rate
minA = FALSE
minB = FALSE
minC = FALSE

gradient(a, b, c, num.days, actual.cases, projected.cases, 'a') * alpha
gradient(a, b, c, num.days, actual.cases, projected.cases, 'b') * alpha
gradient(a, b, c, num.days, actual.cases, projected.cases, 'c') * alpha
while(!minA || !minB || !minC) {
  if(!minA)
    a0 = a - alpha * gradient(a, b, c, num.days, actual.cases, projected.cases, 'a')
  if(!minB)
    b0 = b - alpha * gradient(a, b, c, num.days, actual.cases, projected.cases, 'b')
  if(!minC)
    c0 = c - alpha * gradient(a, b, c, num.days, actual.cases, projected.cases, 'c')
  # check if the  change in our parameters is minimal
  minA = (abs(a0 - a) < precision)
  minB = (abs(b0 - b) < precision)
  minC = (abs(c0 - c) < precision)
  # simultaneously update all parameter values 
  a = a0
  b = b0
  c = c0
}

projected.cases = gompertz(a, b, c, num.days)
curr.cost = cost(actual.cases, projected.cases)


