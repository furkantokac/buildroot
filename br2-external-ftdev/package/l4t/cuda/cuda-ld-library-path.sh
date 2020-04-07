if [ -z "$LD_LIBRARY_PATH" ]; then
    LD_LIBRARY_PATH=/usr/local/cuda/lib
else
    LD_LIBRARY_PATH="/usr/local/cuda/lib:$LD_LIBRARY_PATH"
fi
export LD_LIBRARY_PATH
