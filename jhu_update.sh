function update-data {
    cd JHU-COVID-19
    git pull
    cd ..
}

update-data
python generate_country_reports.py
