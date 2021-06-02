#!/bin/bash

#echo $1 $2 $3 ' > echo $1 $2 $3'
set -e
set -u
set -o pipefail
#while getopts sba: options


# Application Variables
physical_cores_per_node=$(grep ^cpu\\scores /proc/cpuinfo | uniq |  awk '{print $4}')

function usage()
{
	echo  " 
############################################################################
############# LAAMPS APPLICATION INSTALLATION, SETUP & USE #################
############################################################################

You must have sudo rights to complete this installation.

Usage : $0 
[-s installation setup and compilation of LAMMPS] 
[-r Run a job ] 
[-c Setup checker]
[-b Perform benchmark]
[-h help commands]"
}

function installation()
{
# - I found the most recent stable version (29 Oct 2020) here "https://lammps.sandia.gov/tars/"
# - 165M tar.gz file
# - Using relative paths; assuming running out of work directory

echo "
############################################################################
################### STEP 3p2. INSTALLING lAMMPS  ###########################
############################################################################"

wget https://lammps.sandia.gov/tars/lammps-stable.tar.gz
tar -xvf lammps-stable.tar.gz
cd lammps-29Oct20

# Building with cmake
mkdir -p build; cd build
cmake ../cmake -D CMAKE_INSTALL_PREFIX=/usr/local/ -D BUILD_MPI=on -D PKG_KSPACE=on -D FFT=FFTW3 -D BUILD_SHARED_LIBS=yes -D FORCE_OWN_FFTW=ON
#cmake ../cmake
#cmake --build . #Compilation step with 1 core
make -j ${physical_cores_per_node}
make install
rm ../../lammps-stable.tar.gz
}

function open-mpi-install()
{

echo "
############################################################################
################### STEP 2. INSTALLING OPEN MPI  ###########################
############################################################################"
wget https://download.open-mpi.org/release/open-mpi/v4.1/openmpi-4.1.1.tar.gz
tar -xvf openmpi-4.1.1.tar.gz
cd openmpi-4.1.1
./configure --prefix=/usr/local
make -j ${physical_cores_per_node}
make install

export PATH=$PATH:/usr/local/bin
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib
cd ..
rm -r  openmpi-4.1.1
rm openmpi-4.1.1.tar.gz
}

function fftw3()
{
echo "
############################################################################
################### STEP 3p1 INSTALLING FFTW3  ############################
############################################################################"

wget http://www.fftw.org/fftw-3.3.9.tar.gz
tar -xvf fftw-3.3.9.tar.gz
cd fftw-3.3.9
./configure --prefix=/usr/local --enable-shared
make -j ${physical_cores_per_node}
make install

rm -r ../fftw-3.3.9
rm ../fftw-3.3.9.tar.gz
cd ..
}

function cmake-install()
{
wget https://github.com/Kitware/CMake/releases/download/v3.20.3/cmake-3.20.3.tar.gz
tar -xvf cmake-3.20.3.tar.gz
cd cmake-3.20.3
./bootstrap
make -j ${physical_cores_per_node}
make install; cd ..
}

function python-lammps()
{
yum install -y python3-devel
cmake -C ../cmake/presets/minimal.cmake -D CMAKE_INSTALL_PREFIX=/usr/local/ -D BUILD_SHARED_LIBS=on -D LAMMPS_EXCEPTIONS=on -D PKG_PYTHON=on ../cmake
make -j ${physical_cores_per_node}
make install
export LD_LIBRARY_PATH=/usr/local/lib64:$LD_LIBRARY_PATH
}

function setup-checker()
{
if cmake --version > /dev/null; then
	echo "STEP 1: cmake exists; not setup required here"

else
        echo "STEP 1: cmake DOES NOT EXIST, ready to proceed with installing  this package"
	cmake-install
fi
if mpirun --version > /dev/null; then
	echo "STEP 2: mpirun exists; however this executable is only compatible with open mpi, proceed cautiously"
else
        echo "STEP 2: mpirun DOES NOT EXIST; ready to proceed with installing openmpi"
	open-mpi-install  
fi
#if whereis libfftw3 > /dev/null; then
#	echo "Found FFTW3 libraries, do not need to reinstall it"
#else
#	echo "FFTW3 libary does not exist; ready to proceed with installing this library"
echo "STEP 3p1: Installing FFTW3"
fftw3
#fi
}

while getopts sbhc options
do
	case $options in
		s) 
		 	echo "###### Performing Installation #####"
		 	usage
			setup-checker
			installation
			python-lammps
			;;
		b)
		 	echo "##### Performing Benchmark #####"
		 	usage
			;;
		h)
			usage
			;;
		c)
			usage
			setup-checker
			;;
		*)
			usage
			echo "Invalid argument"
	esac
done
shift $(($OPTIND -1))
#echo "the verbosity is ..${verbosity}.. and the tone is ..${tone}.."

