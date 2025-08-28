#!/bin/bash
#SBATCH --nodes 1
#SBATCH --ntasks 1
#SBATCH --cpus-per-task 4
#SBATCH --partition=spgpu
#SBATCH --gres=gpu:1
#SBATCH --mem 64gb
#SBATCH --time 72:00:00
#SBATCH --output=bindcraft_%A.log
#SBATCH --account=mkiyer0
#SBATCH --job-name=Q14956

# Initialise environment and modules
# CONDA_BASE=$(conda info --base)
# source ${CONDA_BASE}/bin/activate /home/geojames/.conda/envs/BindCraft
# export LD_LIBRARY_PATH=${CONDA_BASE}/lib

# alternatively you can source the environment directly
# source /path/to/mambaforge/bin/activate /path/to/mambaforge/envs/BindCraft
source /sw/pkgs/arc/mamba/py3.12/bin/activate /home/geojames/.conda/envs/BindCraft

# Get the directory where the bindcraft script is located
SCRIPT_DIR=$(dirname "$0")

# Parsing command line options
SETTINGS=""
FILTERS=""
ADVANCED=""
TEMP=$(getopt -o s:f:a: --long settings:,filters:,advanced: -n 'bindcraft.slurm' -- "$@")
eval set -- "$TEMP"

while true ; do
    case "$1" in
        -s|--settings) SETTINGS="$2" ; shift 2 ;;
        -f|--filters) FILTERS="$2" ; shift 2 ;;
        -a|--advanced) ADVANCED="$2" ; shift 2 ;;
        --) shift ; break ;;
        *) echo "Invalid Option" ; exit 1 ;;
    esac
done

# Ensure that SETTINGS is not empty
if [ -z "$SETTINGS" ]; then
    echo "Error: The -s or --settings option is required."
    exit 1
fi

echo "Running the BindCraft pipeline"
python -u "${SCRIPT_DIR}/bindcraft.py" --settings "${SETTINGS}" --filters "${FILTERS}" --advanced "${ADVANCED}"
