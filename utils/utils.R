library(data.table)

get.US.total.confirmed = function() {
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
  return(total.confirmed)
}

get.US.new.cases = function(total.confirmed) {
  new.cases = data.frame(total.confirmed$Date)
  states = names(total.confirmed[2:length(total.confirmed)])
  for(i in c(2:length(total.confirmed))) {
    state.diff = append(c(0), diff(total.confirmed[[i]]))
    new.cases = cbind(new.cases, state.diff)
  }
  colnames(new.cases) = names(total.confirmed)
  return(new.cases)
}



get.US.total.deaths = function() {
  csv.filepath = 'JHU-COVID-19/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_deaths_US.csv'
  confirmed.deaths = data.frame(read.csv(csv.filepath, header = TRUE))
  territory.coords = data.frame(confirmed.deaths[c("Combined_Key", "Lat", "Long_")])
  confirmed.deaths = confirmed.deaths[, -c(1:6, 8:11)]
  total.deaths = aggregate(. ~ Province_State, data = confirmed.deaths, sum, na.rm = TRUE)
  col.names = total.deaths[, c(1:1)]
  total.deaths = data.frame(t(total.deaths[, -c(1:1)]))
  colnames(total.deaths) = col.names
  total.deaths = setDT(total.deaths, keep.rownames = TRUE)
  colnames(total.deaths)[1] = "Date"
  total.deaths$Date = as.Date(total.deaths$Date, format = "X%m.%d.%y")
  return(total.deaths)
}


get.US.new.deaths = function(total.deaths) {
  new.deaths = data.frame(total.deaths$Date)
  states = names(total.deaths[2:length(total.deaths)])
  for(i in c(2:length(total.deaths))) {
    state.diff = append(c(0), diff(total.deaths[[i]]))
    new.deaths = cbind(new.deaths, state.diff)
  }
  colnames(new.deaths) = names(total.deaths)
  return(new.deaths)
}