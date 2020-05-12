library(ggplot2)
library(plotly)
source('utils/utils.R')

total.confirmed = get.US.total.confirmed()
new.cases = get.US.new.cases(total.confirmed)

ggplot(new.cases, aes(x = Date, y = `New York`)) + 
  geom_bar(stat = 'identity')


ggplot(new.cases[new.cases$Date > '2020-03-15',], aes(x = Date)) + 
  geom_line(aes(y = Washington), color = 'green') +
  geom_line(aes(y = California), color = 'red' ) + 
  geom_line(aes(y = Florida), color = 'black') + 
  geom_line(aes(y = `New York`), color = 'brown')


plot = ggplot(melt(new.cases[new.cases$Date > '2020-03-15',], id = 'Date'),
              aes(Date, value, col = variable)) + geom_line()
ggplotly(plot)
