#!/bin/bash
##################################MANAGE_COMMANDLINE_ARGUMENTS#######################################
#help function
Help()
{
   # Display Help
   echo "Install wdf library (wdfpipe.github.io) through conda."
   echo
   echo "Syntax: conda-install-wdf.sh [-h/--help] CONDA_PREFIX_OF_YOUR_ENV"
   echo "options:"
   echo "-h/--help                 Print this Help."
   echo "CONDA_PREFIX_OF_YOUR_ENV  Root directory of the conda env to install wdf into."
   echo
}
# Initialize a flag to track if an option was processed
option_processed=0
while [ $# -gt 0 ]; do
  case "$1" in
    -h|--help) # display Help
      Help
      exit 0
      ;;
    -*) # incorrect option
      echo "Error: Invalid option"
      exit 1
      ;;
    *) # non-option argument
      option_processed=1
      # Check if the first non-option argument is a directory
      if [ ! -d "$1" ]; then
        echo "Error: '$1' is not a directory"
        exit 1
      fi
      break
      ;;
  esac
  option_processed=1
  shift
done
# Check if no options or arguments were provided
if [ $option_processed -eq 0 ]; then
  Help
  exit 0
fi
##################################INSTALLING_WDF###################################################
#update library cache
sudo /sbin/ldconfig
#install dependencies
conda install compilers "cmake>3.10" make git boost pybind11 fftw gsl conda-forge::libframel -c conda-forge -y
#set conda env root as install dir
export ENV_ROOT="$1"
#install pytsa
echo "PyTSA installation!"
git clone https://github.com/elenacuoco/p4TSA && cd p4TSA && cmake --install-prefix=$ENV_ROOT CMakeLists.txt \
&& make -j "$(nproc)" \
&& make install \
&& cd python-wrapper \
&& python setup.py install \
&& cd .. \
&& cd .. \
&& rm -fr p4TSA
#update library cache
sudo /sbin/ldconfig
#install WDF
echo "WDF installation!"
git clone https://gitlab.com/wdfpipe/wdf.git &&\
cd wdf && python setup.py install &&\
cd .. && rm -fr wdf/
