# download data/database
source setup_ots.sh

./srcs/otsdaq_demo/tools/get_tutorial_data.sh --tutorial first_demo --version v2_5
./srcs/otsdaq_demo/tools/get_tutorial_database.sh --tutorial first_demo --version v2_5

mkdir -p tmpDB && cd tmpDB && conftool.py exportDatabase

export ARTDAQ_DATABASE_URI=mongodb://ots-db/stm

conftool.py importDatabase && cd .. && rm -rf tmpDB

# patch the setup script so that the db URI is pointed to mongodb
patch -R setup_ots.sh install/patch.setup_ots
