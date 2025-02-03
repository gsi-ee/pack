# Pack of DABC/Go4/Stream libraries

## Checkout repository

    cd ~/git
    git clone --recurse-submodules https://github.com/gsi-ee/pack.git

## Create build directory

    mkdir -p ~/build/pack

## Reuse existing ROOT

If there is ROOT build exists, one can reuse it calling:

    source path/to/bin/thisroot.sh

## Install some prerequicities

Check if one need some packages to be installed. For ROOT there is https://root.cern/install/dependencies/ list of packages which may be required.
For the Go4 one needs Qt6 with webengine components. On the opensuse on can install it with:

    sudo zypper install qt6-webenginecore-devel qt6-webenginewidgets-devel qt6-base-common-devel qt6-gui-devel


## Configure and build

    cd ~/build/pack
    cmake ~/git/pack
    make -j

## Use generated login script

    . ~/build/pack/dabcgo4login

## Update and rebuild

    cd ~/git/pack
    git pull
    git submodule update --recursive --remote
    cd ~/build/pack
    make -j

## Use DABC and Go4 analysis

* https://web-docs.gsi.de/~dabc/doc/dabc2/hadaq_trb3_package.html
* https://web-docs.gsi.de/~dabc/doc/stream/hadaq_tdc_calibr.html



