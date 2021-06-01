# LAMMPS with Open MPI Custom Installation

## Synopsis
- All programs and packages have been conscioulsy been installed in /usr/local directory (Open MPI, LAMMPS, et al). While it is undrstood that most HPC deployments, software may be installed in /opt
- For lammps compilation and installation, the executable was built and installed in /usr/local but for some reason the actual tarred lammps folder remained in the work directory. This is where the benchmark files, documentation, etc remained, I was not able to figure this out in addition to setting `-D CMAKE_INSTALL_PREFIX=/usr/local/` correctly.


## Running the code



## Encountered problems and caveats

One of the first challenges encountered was learning what was the optimal way to compile the LAMMPS source code. I was able to make use of the cmake compiler of which should exist by default in most UNIX OS distributions. If not, the code installs it otherwise. Another challenge I faced was I wasn't sure whether to make the complete installation in the user directory or install in root, the latter requiring root access. I opted for installaing in root so please run this code with sudo.

Another challenge I faced was that I did not know how to check the system if fftw3 was already intalled (as I did for mpirun and cmake). It appears 

##
