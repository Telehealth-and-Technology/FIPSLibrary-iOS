#
# setenv-i386.sh
#

SYSTEM="Darwin"
MACHINE="x86_64"
KERNEL_BITS=64

export MACHINE
export SYSTEM
export KERNEL_BITS

echo "MACHINE = " $MACHINE
echo "SYSTEM = " $SYSTEM
echo "BUILD = " $BUILD
echo "KERNEL_BITS = " $KERNEL_BITS

# adjust the path to ensure we always get the correct tools
export PATH="`pwd`"/iOS:$PATH
