import os
import csv
import ast
import datetime
import pandas as pd

def generate_observation(row, date_time):
    """
    Helper function that creates formatted row from user inputted
    row and user generated date time string.

    Parameters
    ----------
    row : list
        the JHU csv row that will be transformed
    date_time : datetime object
        date time object showing last update

    Returns
    -------
    list
        formatted csv row

    """
    if len(row) == 6:
        observation = row[:2] + [str(date_time)] + row[3:]
        observation += ['', '']
    elif len(row) == 8:
        coordinates = ['%.4f' % n for n in list(map(float, row[-2:]))]
        observation = row[:2] + [str(date_time)] + row[3:-2] + coordinates
    else:
        try:
            coordinates = ['%.4f' % n for n in list(map(float, row[5:7]))]
        except:
            coordinates = row[5:7]
        observation = row[2:4] + [str(date_time)] + row[7:10] + coordinates
    return observation


def format_row(row, header):
    """
    Function to format data table rows and provide uniformity across all recorded
    rows of data tables. JHU datasets record their data in 3 different ways. This
    function takes as input a row from any of the JHU csvs and outputs a row of a
    uniform format.
    Parameters
    ----------
    row : list
        list of data from JHU csv
    header : list
        header of corresponding row

    Returns
    -------
    list
        Formatted list

    """
    date_time = row[2] if len(header) == 6 or len(header) == 8 else row[4]
    try:
        date_time = datetime.datetime.strptime(date_time, "%Y-%m-%dT%H:%M:%S").date()
    except:
        try:
            date_time = datetime.datetime.strptime(date_time, "%Y-%m-%d %H:%M:%S").date()
        except:
            try:
                date_time = datetime.datetime.strptime(date_time, "%m/%d/%Y %H:%M").date()
            except:
                date_time = datetime.datetime.strptime(date_time, "%m/%d/%y %H:%M").date()
    return generate_observation(row, date_time)



countries_json = {}
for filename in os.listdir('JHU-COVID-19/csse_covid_19_data/csse_covid_19_daily_reports'):
    if filename.endswith('.csv'):
        filepath = 'JHU-COVID-19/csse_covid_19_data/csse_covid_19_daily_reports/' + filename
        with open(filepath, encoding = 'utf-8-sig') as f:
            f_csv = csv.reader(f)
            curr_header = next(f_csv)
            for row in f_csv:
                row = format_row(row, curr_header)
                country = row[1]
                if country not in countries_json:
                    countries_json[country] = {str(row)}
                else:
                    countries_json[country].add(str(row))
        f.close()

header = ['Province/State', 'Country/Region', 'Last Update', 'Confirmed', 'Deaths', 'Recovered', 'Latitude', 'Longitude']


dest_filepath = 'csse_covid_19_country_reports/'
if os.path.isdir(dest_filepath) is False:
    os.mkdir(dest_filepath)
for country in countries_json:
    country_data = list(countries_json[country])
    country_data = [ast.literal_eval(row) for row in country_data]
    df = pd.DataFrame(country_data)
    df.columns = header
    df.to_csv(dest_filepath + country + '.csv', index = False)
