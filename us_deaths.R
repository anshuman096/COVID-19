library(ggplot2)
library(plotly)
source('utils/utils.R')

total.deaths = get.US.total.deaths()


ggplot(total.deaths, aes(x = Date, y = `New York`)) + 
  geom_bar(stat = 'identity')



plot = ggplot(melt(total.deaths[total.deaths$Date > '2020-03-15'], id = 'Date'),
              aes(Date, value, col = variable)) + geom_line()
ggplotly(plot)
