library(data.table)
library(ggplot2)

csv.filepath = 'JHU-COVID-19/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_US.csv'
confirmed.cases = data.frame(read.csv(csv.filepath, header = TRUE))
territory.coords = data.frame(confirmed.cases[c("Combined_Key", "Lat", "Long_")])
confirmed.cases = confirmed.cases[, -c(1:6, 8:11)]
total.confirmed = aggregate(. ~ Province_State, data = confirmed.cases, sum, na.rm = TRUE)
col.names = total.confirmed[, c(1:1)]
total.confirmed = data.frame(t(total.confirmed[, -c(1:1)]))
colnames(total.confirmed) = col.names
total.confirmed = setDT(total.confirmed, keep.rownames = TRUE)
colnames(total.confirmed)[1] = "Date"
total.confirmed$Date = as.Date(total.confirmed$Date, format = "X%m.%d.%y")


ggplot(total.confirmed, aes(x = Date, y = `New York`)) + 
  geom_bar(stat = 'identity')

ggplot(total.confirmed[total.confirmed$Date > '2020-03-15'], aes(x = Date)) + 
  geom_line(aes(y = Washington), color = 'green') +
  geom_line(aes(y = California), color = 'red' ) + 
  geom_line(aes(y = Florida), color = 'black')

