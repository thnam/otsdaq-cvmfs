#!/bin/bash
#
# This is a modified version of the ots installation script at:
# https://cdcvs.fnal.gov/redmine/projects/otsdaq-utilities/repository/revisions/develop/raw/tools/quick_ots_install.sh 
#

USER=$(whoami)
FOR_USER=$(stat -c "%U" $PWD)
FOR_GROUP=$(stat -c "%G" $PWD)
	
echo -e "quick_ots_install.sh [${LINENO}]  "
echo -e "quick_ots_install.sh [${LINENO}]  \t ~~ quick_ots_install ~~ "
echo -e "quick_ots_install.sh [${LINENO}]  "
echo -e "quick_ots_install.sh [${LINENO}]  \t usage: source quick_ots_install.sh"
echo -e "quick_ots_install.sh [${LINENO}]  "
echo -e "quick_ots_install.sh [${LINENO}]  \t user '$USER' installing for target user '$FOR_USER $FOR_GROUP'"
echo -e "quick_ots_install.sh [${LINENO}]  \t (note: target user is set based on the owner of $PWD)"
echo -e "quick_ots_install.sh [${LINENO}]  "

#install ots
rm -rf ots quick_ots_install.zip
wget https://otsdaq.fnal.gov/downloads/quick_ots_install.zip
unzip quick_ots_install.zip
mv ots/* .
rmdir ots

#update all
REPO_DIR="$(find srcs/ -maxdepth 1 -iname 'otsdaq*')"
		
for p in ${REPO_DIR[@]}; do
	if [ -d $p ]; then
		if [ -d $p/.git ]; then
		
			bp=$(basename $p)
						
			echo -e "UpdateOTS.sh [${LINENO}]  \t Repo directory found as: $bp"
			
			cd $p
      git stash
			git pull
      git checkout v2_05_00
			cd -
		fi
	fi	   
done

#setup qualifiers
rm -rf change_ots_qualifiers.sh
cp srcs/otsdaq_utilities/tools/change_ots_qualifiers.sh .
chmod 755 change_ots_qualifiers.sh
./change_ots_qualifiers.sh v2_05_00 s85:e17:prof

# setup and compile
source /cvmfs/fermilab.opensciencegrid.org/products/artdaq/setup
setup mrb
export MRB_PROJECT=otsdaq_stm
mrb newDev -v v2_05_00 -q s85:e17:prof -f
source  localProducts_otsdaq_stm_v2_05_00_s85_e17_prof/setup
setup ninja v1_8_2
export CETPKG_J=$(nproc)
source mrbSetEnv
mrb i --generator ninja

# replace the default setup scripte
rm setup_ots.sh && cp install/setup_ots.sh .
mkdir -p /opt/data/{UserData,OutputData,UserDatabase}

# clean up
rm quick_ots_install.* 

ech o-e "quick_ots_install.sh [${LINENO}]  \t =================="
echo -e "quick_ots_install.sh [${LINENO}]  \t quick_ots_install script done!"
echo -e "quick_ots_install.sh [${LINENO}]  \t"
echo -e "quick_ots_install.sh [${LINENO}]  \t Next time, cd to ${PWD}:"
echo -e "quick_ots_install.sh [${LINENO}]  \t\t source setup_ots.sh     #########################################   #to setup ots"
echo -e "quick_ots_install.sh [${LINENO}]  \t\t mb                      #########################################   #for incremental build"
echo -e "quick_ots_install.sh [${LINENO}]  \t\t mz                      #########################################   #for clean build"
echo -e "quick_ots_install.sh [${LINENO}]  \t\t UpdateOTS.sh            #########################################   #to see update options"
echo -e "quick_ots_install.sh [${LINENO}]  \t\t ./change_ots_qualifiers.sh           ############################   #to see qualifier options"
echo -e "quick_ots_install.sh [${LINENO}]  \t\t chmod 755 reset_ots_tutorial.sh; ./reset_ots_tutorial.sh --list     #to see tutorial options"
echo -e "quick_ots_install.sh [${LINENO}]  \t\t ots -w                  #########################################   #to run ots in wiz(safe) mode"
echo -e "quick_ots_install.sh [${LINENO}]  \t\t ots                     #########################################   #to run ots in normal mode"

echo -e "quick_ots_install.sh [${LINENO}]  \t *******************************"
echo -e "quick_ots_install.sh [${LINENO}]  \t *******************************"
