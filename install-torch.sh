#!/bin/bash

##############################
# check if installation is already done in user's dir
USER_DIR=/home/scratch/$USER/torch
if [ -d $USER_DIR ] ; then
    echo You already have a directory called $USER_DIR
    echo You have either already installed it, or you can remove this
    echo directory and rerun this script if you are trying to reinstall.
    exit 1
fi

##############################
# shortcut: copy installation if it exists
SHARED_DIR=/home/scratch/torchshared/torch
if [ -f $SHARED_DIR/bin/th ]
then # it is installed
    echo It appears torch is already installed in $SHARED_DIR
    read -p "Copy from this into $USER_DIR instead of downloading Torch? (y/n) " yn
    if [ "$yn" != "y" ]
    then
        echo Quitting.
        exit 2
    fi
    mkdir -p /home/scratch/$USER
    cp -r $SHARED_DIR $USER_DIR

    echo
    echo Done copy.

    export PATH=$USER_DIR/bin:$PATH
else
    ##############################
    # install Torch
    export PREFIX=/home/scratch/$USER/torch
    #export PREFIX="/home/scratch/torchshared/torch"
    mkdir -p $PREFIX

    rm -rf /tmp/luajit-rocks
    rm -rf /tmp/luajit-rocks-$USER
    rm -rf /tmp/torch-install-scripts-$USER
    mkdir -p /tmp/torch-install-scripts-$USER
    cd /tmp/torch-install-scripts-$USER
    wget https://raw.githubusercontent.com/torch/ezinstall/master/install-luajit+torch
    cat install-luajit+torch | grep -v 'cunn\|cutorch' \
        | sed -e 's/|| *sudo.*$//' \
              -e '/path_to_nvcc=.*/,+4d' \
              -e '/^.*luarocks install qtlua.*$/,+1d' \
              -e '/^.*luarocks install qttorch.*$/,+1d' \
              -e "s#cd /tmp#mkdir -p /tmp/luajit-rocks-$USER ; cd /tmp/luajit-rocks-$USER#" \
        > install-script2
    bash install-script2 # installs into PREFIX

    export PATH=$PREFIX/bin:$PATH

    ##############################
    # install graph and nngraph
    cd /tmp/torch-install-scripts-$USER
    git clone git://github.com/koraykv/torch-graph.git
    cd torch-graph
    luarocks make
    cd ..
    git clone git://github.com/koraykv/torch-nngraph.git
    cd torch-nngraph
    luarocks make

    ##############################
    # install others
    luarocks install json
    luarocks install csv
    luarocks install gm
    luarocks install unsup
    luarocks install xlua

    echo
    echo Done installing Torch, follow the instructions below to see if it was successful.
fi

echo Now installing iTorch...
##############################
# install iTorch
rm -rf /tmp/install-itorch-$USER
mkdir -p /tmp/install-itorch-$USER
cd /tmp/install-itorch-$USER

# get zeromq3 includes and libs
wget https://kojipkgs.fedoraproject.org/packages/zeromq3/3.2.4/1.fc20/x86_64/zeromq3-3.2.4-1.fc20.x86_64.rpm
wget https://kojipkgs.fedoraproject.org/packages/zeromq3/3.2.4/1.fc20/x86_64/zeromq3-devel-3.2.4-1.fc20.x86_64.rpm
for i in *.rpm ; do rpm2cpio $i > $i.cpio; done
for i in *.cpio ; do 7z x $i ; done
cd usr/lib64
rm -f libzmq.so libzmq.so.3
ln -s libzmq.so.3.0.0 libzmq.so
ln -s libzmq.so.3.0.0 libzmq.so.3
cd ..
ln -s lib64 lib
cd ..

# install libzmq using this zeromq3 installation
luarocks install lzmq ZMQ_DIR=/tmp/install-itorch-$USER/usr ZMQ_INCDIR=/tmp/install-itorch-$USER/usr/include

# TODO: add user specific instructions for later practical: install newer version of IPython i.e. 2.2+
# this is NOT machine specific: this will install to the user's networked home directory
# Check for IPython 2.2 or newer:
if python2.7 -c '
import sys
try:
    import IPython
except ImportError:
    sys.exit(0)

from pkg_resources import parse_version as pv
if pv(IPython.__version__) < pv("2.2"):
    sys.exit(0)
else:
    sys.exit(1)
'; then
    which pip2.7 || easy_install-2.7 --user pip
    export PATH=$HOME/.local/bin:$PATH # for pip
    pip2.7 install --user --upgrade ipython[notebook]
fi

# install iTorch
git clone https://github.com/facebook/iTorch.git
cd iTorch
luarocks make


echo
echo Now add the bin directory to your path, possibly in your .bashrc if you like:
echo '    export PATH='$USER_DIR/bin':$PATH'
echo
echo Type th to start an interactive LuaJIT session with Torch preloaded.
echo
