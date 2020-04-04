import os
import csv
import ast
import datetime
import pandas as pd


def format_row(row):
    """

    """
    last_update = row[2]
    try:
        date_time = datetime.datetime.strptime(last_update, "%Y-%m-%dT%H:%M:%S")
    except:
        try:
            date_time = datetime.datetime.strptime(last_update, "%m/%d/%Y %H:%M")
        except:
            date_time = datetime.datetime.strptime(last_update, "%m/%d/%y %H:%M")
    formatted_row = row[:2] + [str(date_time)] + row[3:]
    print(formatted_row)
    return str(row)

def format_observation(row):
    """
    Some countries do not have any observations for latitude and longitude.
    We are adding two empty spaces to those observation rows to maintain
    uniformity of data
    """
    observation = row[:1] + row[2:]
    if len(observation) == 5:
        observation += ['', '']
    return observation



dates_dict = {}
for filename in os.listdir('csse_covid_19_data/csse_covid_19_daily_reports'):
    if filename.endswith('.csv'):
        filepath = 'csse_covid_19_data/csse_covid_19_daily_reports/' + filename
        with open(filepath, encoding = 'utf-8-sig') as f:
            f_csv = csv.reader(f)
            next(f_csv)
            for row in f_csv:
                formatted_row = format_row(row)
                # if key not in dates_dict:
                #     dates_dict[key] = [format_observation(row)]
                # else:
                #     continue
        f.close()


countries_dict = {}
header = ['Province/State', 'Last Update', 'Confirmed', 'Deaths', 'Recovered', 'Latitude', 'Longitude']







#
#                 country = row[1].strip()
#                 if country not in countries_dict:
#                     countries_dict[country] = []
#                 formatted_row = format_observation(row)
#                 if formatted_row not in countries_dict[country]:
#                     countries_dict[country].append(formatted_row)
#
#
#
# dest_filepath = 'csse_covid_19_data/csse_covid_19_country_reports/'
# os.mkdir(dest_filepath)
# for country in countries_dict:
#     df = pd.DataFrame(countries_dict[country])
#     df.columns = header
#     df.to_csv(dest_filepath + country + '.csv', index = False)
