#!/bin/bash
##################################MANAGE_COMMANDLINE_ARGUMENTS#######################################
#help function
Help()
{
  # Display Help
  echo "Build docker container to use wdf in BETIF"
  echo
  echo "Syntax: docker-build-wdf.sh [-h/--help] CPU_OR_GPU"
  echo "options:"
  echo "-h/--help   Print this Help."
  echo "CPU_OR_GPU  cpu, to build cpu image. gpu, to build gpu image."
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
sudo docker -D build --build-arg HOST_UID=$(id -u) -t wdf-betif:$1 -f Dockefile-$1 .
