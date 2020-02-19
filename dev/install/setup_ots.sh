echo # This script is intended to be sourced.

sh -c "[ `ps $$ | grep bash | wc -l` -gt 0 ] || { echo 'Please switch to the bash shell before running the otsdaq-demo.'; exit; }" || exit

echo -e "setup[${LINENO}]: \t ====================================================="
echo -e "setup[${LINENO}]: \t Initially your products path was PRODUCTS=${PRODUCTS}"

#unalias because the original VM aliased for users
unalias kx >/dev/null 2>&1
unalias ots >/dev/null 2>&1

unsetup_all >/dev/null 2>&1
unset PRODUCTS
unset MRB_SOURCE

PRODUCTS=/cvmfs/fermilab.opensciencegrid.org/products/artdaq
source ${PRODUCTS}/setup

setup mrb
setup git
source ${PWD}/localProducts_*/setup
source mrbSetEnv
echo -e "setup[${LINENO}]: \t Now your products path is PRODUCTS=${PRODUCTS}"
echo

ulimit -c unlimited

# Setup environment when building with MRB (As there's no setupARTDAQOTS file)

#export OTSDAQ_DEMO_LIB=${MRB_BUILDDIR}/otsdaq_demo/lib
#export OTSDAQ_LIB=${MRB_BUILDDIR}/otsdaq/lib
#export OTSDAQ_UTILITIES_LIB=${MRB_BUILDDIR}/otsdaq_utilities/lib
#Done with Setup environment when building with MRB (As there's no setupARTDAQOTS file)

#setup ninja generator
#============================
setup ninja v1_8_2
alias makeninja='pushd $MRB_BUILDDIR; ninja; popd'
alias mz='mrb z; mrbsetenv; mrb b --generator ninja'
alias mb='makeninja'

export CETPKG_INSTALL=${PWD}/products
export CETPKG_J=$(nproc)

export OTS_MAIN_PORT=2015

export USER_DATA="/opt/data/UserData"
export ARTDAQ_DATABASE_URI="filesystemdb:///opt/data/UserDatabase/filesystemdb/test_db"
#export ARTDAQ_DATABASE_URI=mongodb://ots-db/stm
export OTSDAQ_DATA="/opt/data/OutputData"

echo -e "setup[${LINENO}]: \t Now your user data path is USER_DATA \t\t = ${USER_DATA}"
echo -e "setup[${LINENO}]: \t Now your database path is ARTDAQ_DATABASE_URI \t = ${ARTDAQ_DATABASE_URI}"
echo -e "setup[${LINENO}]: \t Now your output data path is OTSDAQ_DATA \t = ${OTSDAQ_DATA}"
echo

alias rawEventDump="art -c ${PWD}/srcs/otsdaq/artdaq-ots/ArtModules/fcl/rawEventDump.fcl"
alias kx='ots -k'

echo
echo -e "setup[${LINENO}]: \t Now use 'ots --wiz' to configure otsdaq"
echo -e "setup[${LINENO}]: \t\t Then use 'ots' to start otsdaq"
echo -e "setup[${LINENO}]: \t\t Or use 'ots --help' for more options"
echo
echo -e "setup[${LINENO}]: \t\t use 'kx' to kill otsdaq processes"
echo
