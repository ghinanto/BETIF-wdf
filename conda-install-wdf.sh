#!/bin/bash
# Define the Help function
Help()
{
  # Display Help
  echo "Install wdf library (wdfpipe.github.io) in the active conda environment."
  echo
  echo "Syntax: conda-install-wdf.sh [-h]"
  echo "options:"
  echo "h, --help        Print this Help."
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
    *) # unexpected argument
      echo "Error: Unexpected argument '$1'"
      exit 1
      ;;
  esac
  option_processed=1
  shift
done

# Check if no options or arguments were provided
if [ $option_processed -eq 0 ]; then
  # Check if inside a Conda environment
  if [ -z "$CONDA_PREFIX" ]; then
    echo "Error: Not inside a Conda environment (CONDA_PREFIX is not set)"
    exit 1
  fi

  # Check if Python is available in the Conda environment
  if [ ! -x "$CONDA_PREFIX/bin/python" ]; then
    echo "Error: Python not found in '$CONDA_PREFIX/bin'"
    exit 1
  fi

  # Get Python version
  python_version=$("$CONDA_PREFIX/bin/python" -c "import sys; print(sys.version_info[0]); print(sys.version_info[1])" 2>/dev/null)
  if [ $? -ne 0 ]; then
    echo "Error: Unable to retrieve Python version"
    exit 1
  fi

  # Extract major and minor version numbers
  set -- $python_version
  major_version=$1
  minor_version=$2

  # Check if Python version is at least 3.11
  if [ "$major_version" -lt 3 ] || { [ "$major_version" -eq 3 ] && [ "$minor_version" -lt 11 ]; }; then
    echo "Error: Python version $major_version.$minor_version is too low, requires 3.11 or higher"
    exit 1
  fi

  # Prompt user to install in CONDA_PREFIX
  echo "Install wdf library in $CONDA_PREFIX? ([y]/n)"
  read answer
  case "$answer" in
    n|N) # User chose not to install
      echo "Installation aborted"
      exit 0
      ;;
    y|Y|""|*) # User chose yes or pressed Enter (default)
      export ENV_ROOT="$CONDA_PREFIX"
      echo "ENV_ROOT set to $CONDA_PREFIX"
      ;;
  esac
fi
##################################INSTALLING_WDF###################################################
#update library cache
sudo /sbin/ldconfig
#install dependencies
conda install compilers "cmake>3.10" make git boost pybind11 fftw gsl conda-forge::libframel -c conda-forge -y
#set conda env root as install dir
#export ENV_ROOT="$1"
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
#check installation
# Check if wdf can be imported
"$ENV_ROOT/bin/python" -c "import wdf" 2>/dev/null
if [ $? -eq 0 ]; then
  echo "Library wdf is available"
else
  echo "Error: Cannot import wdf"
  exit 1
fi
# Check if pytsa can be imported
"$ENV_ROOT/bin/python" -c "import pytsa" 2>/dev/null
if [ $? -eq 0 ]; then
  echo "Library pytsa is available"
else
  echo "Error: Cannot import pytsa"
  exit 1
fi
