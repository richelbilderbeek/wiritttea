#/bin/bash

# View the queue with the long names readable
squeue -u $USER -o "%.8i %.6P %.28j %.8u %.2t %.10M %.6D %R"