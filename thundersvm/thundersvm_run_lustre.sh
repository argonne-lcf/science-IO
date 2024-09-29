#!/bin/bash -x
# qsub -l select=8:ncpus=208 -l walltime=00:20:00 -A Aurora_deployment -l filesystems=flare -q R783476 -l daos=ops ./run_daos.sh # note -l daos=default

 
module use -a /home/ftartagl/modulefiles
module load oneapi-testing/2024.2.0.531.PUBLIC 

num_nodes=`wc -l < $PBS_NODEFILE`
ranks=$((num_nodes * 12))
ws_size=1024

export ZE_FLAT_DEVICE_HIERARCHY=COMPOSITE
export AFFINITY_ORDERING=compact
export RANKS_PER_TILE=1
export PLATFORM_NUM_GPU=6
export PLATFORM_NUM_GPU_TILES=2


mpiexec -np $ranks -ppn 12 --cpu-bind list:4:9:14:19:20:25:56:61:66:71:74:79 --no-vni -genvall aurora/wrapper.sh thunder/svm_mpi/build_ws1024/bin/thundersvm-train -s 0 -t 2 -g 1 -c 10 -o 1  thunder/svm_mpi/data/real-sim_M100000_K25000_S0.836  
 