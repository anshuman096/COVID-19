function update-data {
    cd JHU-COVID-19
    git pull
    cd ..
}

update-data
python restructure.py
