library(ggplot2)
source('utils/utils.R')

total.confirmed = get.US.total.confirmed()

ggplot(total.confirmed, aes(x = Date, y = `New York`)) + 
  geom_bar(stat = 'identity')

ggplot(total.confirmed[total.confirmed$Date > '2020-03-15'], aes(x = Date)) + 
  geom_line(aes(y = Washington), color = 'green') +
  geom_line(aes(y = California), color = 'red' ) + 
  geom_line(aes(y = Florida), color = 'black') + 
  geom_line(aes(y = `New York`), color = 'brown') 

plot = ggplot(melt(total.confirmed[total.confirmed$Date > '2020-03-15'], id = 'Date'),
              aes(Date, value, col = variable)) + geom_line()
ggplotly(plot)







