# LAMMPS with Open MPI Custom Installation

## Synopsis
- This code was prepared using the Rescale platform using "Bring your own software" with 1 node. This softtware does not have OpenMPI and FFT3 which are required to run this code. They are compiled and installed here.
- All programs and packages have been conscioulsy been installed in /usr/local directory (Open MPI, LAMMPS, et al). While it is understood that most HPC deployments, software may be installed in /opt
- For lammps compilation and installation, the executable was built and installed in /usr/local but for some reason the actual tarred lammps folder remained in the work directory. This is where the benchmark files, documentation, etc remained, I was not able to figure this out in addition to setting `-D CMAKE_INSTALL_PREFIX=/usr/local/` correctly.
- The benchmark was not completed. I only started the configuration, compilation and installation of the LAAMPS python package and the LAMMPS shared library which required every package to be compiled in shared mode


## Running the code
- For a "start from scratch" installation, go to the directory where the shell script is located and run the following command:

```
sudo ./lammps-custom-kspace-openmpi-BrunoS.sh -s
```

In addition, for more options, you may run `./lammps-custom-kspace-openmpi-BrunoS.sh -h`

```[uprod_sZSip@ip-10-25-84-68 ~/work]$ ./lammps-custom-kspace-openmpi-BrunoS.sh -h

############################################################################
############# LAAMPS APPLICATION INSTALLATION, SETUP & USE #################
############################################################################

You must have sudo rights to complete this installation.

Usage : ./lammps-custom-kspace-openmpi-BrunoS.sh
[-s installation setup and compilation of LAMMPS]
[-r Run a job ]
[-c Setup checker]
[-b Perform benchmark]
[-h help commands]```


## Encountered problems and caveats

One of the first challenges encountered was learning what was the optimal way to compile the LAMMPS source code. I was able to make use of the cmake compiler of which should exist by default in most UNIX OS distributions. If not, the code installs it otherwise. Another challenge I faced was I wasn't sure whether to make the complete installation in the user directory or install in root, the latter requiring root access. I opted for installaing in root so please run this code with sudo.

Another challenge I faced was that I did not know how to check the system if fftw3 was already intalled (as I did for mpirun and cmake).

Another challenge was that once I installed everything sucessfully and had a working script was for actually running the benchmark. I was thinking ahead that I wanted to create the data and plot it in python. I was not sure what I was getting myself into but I ran into issues as I didn't know I learned I had to rebuild all libraries and packags in shared mode (which I didn't initlaly). This took some time recompiling everything until I found a path to success.


## Next Steps

- Complete the benchmark part of assignment (weak and strong scaling)
