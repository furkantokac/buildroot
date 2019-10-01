# This script converts some image formats to ppm so you need to netpbm installed to use the
# script.

# Check if ppm installed
command_exists () {
    type "$1" &> /dev/null ;
}

if ! command_exists pngtopnm
then
    echo ">>> Error! netpbm package is not installed."
    echo ">>> You can try : sudo apt-get install netpbm"
    exit
fi


# Check if necessary parameters are set
if [ -z ${FILENAME+x} ]
then
    echo ">>> Error! No file specified."
    echo ">>> Usage:"
    echo "  FILENAME=filename.png ./convert-to-ppm.sh"
    exit
fi


# Extract file extension
EXT="${FILENAME##*.}"


# Convert extension to lower case
EXT=${EXT,,}


# If extension is jpg, make it jpeg
if [ "$EXT" == "jpg" ]; then
    EXT="jpeg"
fi


# If extension is not supported, this part will fail and we'll exit from the script
"$EXT"topnm $FILENAME > .tmp.pnm
if [ $? -ne 0 ]
then
    echo ">>> Error! File extension \"$EXT\" is not supported."
    exit
fi


# Do the rest
pnmquant 224 .tmp.pnm > .tmp_clut224.pnm
pnmtoplainpnm .tmp_clut224.pnm > logo_linux_clut224.ppm

rm .tmp.pnm .tmp_clut224.pnm


# Done
echo ">>> Your ppm image \"logo_linux_clut224.ppm\" has successfully generated."
