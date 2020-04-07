if [ -z "$LD_LIBRARY_PATH" ]; then
    LD_LIBRARY_PATH=/usr/lib/tegra:/usr/lib/tegra-egl
else
    LD_LIBRARY_PATH="/usr/lib/tegra:/usr/lib/tegra-egl:$LD_LIBRARY_PATH"
fi
export LD_LIBRARY_PATH
