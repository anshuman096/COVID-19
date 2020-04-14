library(ggplot2)
source('utils/utils.R')

# assign e to Euler's constant
e = exp(1)


aGradient = function(a, b, c, t, y, y.hat) {
  a0 = 0
  for(i in 1:length(t)) {
    a0 = a0 + sum(2 * e^(-b * e^(-c * t[i])) * (y.hat[i] - y[i])) 
  }
  a0 = a0/length(t)
  return(a0)
}

bGradient = function(a, b, c, t, y, y.hat) {
  b0 = 0
}

gompertz = function(a, b, c, days) {
  y.hat = a * e^(-b * e^(-c * days))
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
c = 0.00005

actual.cases = us.cumulative$`Cumulative Count`
projected.cases = gompertz(a, b, c, num.days)
curr.cost = cost(actual.cases, projected.cases)

precision = 1000
alpha = 5e+28 # the learning rate
while(curr.cost > precision) {
  a0 = a - alpha * aGradient(a, b, c, num.days, actual.cases, projected.cases)
  b0 = b - alpha * (2/n) * (sum(projected.cases * e^(-c * num.days) * (actual.cases - projected.cases)))
  c0 = c - alpha * (1/n) * (sum(2 * b * num.days * projected.cases * e^(-c * num.days) * (projected.cases - 1)))
  a = a0
  b = b0
  c = c0
  projected.cases = gompertz(a, b, c, num.days)
  curr.cost = cost(actual.cases, projected.cases)
}

