# Pack of DABC/Go4/Stream libraries

## Checkout repository

    cd ~/git
    git clone https://github.com/gsi-ee/pack.git

## Create build directory

    mkdir -p ~/build/pack

## Reuse existing ROOT

If there is ROOT build exists, one can reuse it calling:

    source path/to/bin/thisroot.sh

## Configure and build

    cd ~/build/pack
    cmake ~/git/pack
    make -j

## Use generated login script

    . ~/build/pack/trb3login

## Update and rebuild

    cd ~/git/pack
    git pull
    cd ~/build/pack
    make -j

## Use DABC and Go4 analysis

* https://web-docs.gsi.de/~dabc/doc/dabc2/hadaq_trb3_package.html
* https://web-docs.gsi.de/~dabc/doc/stream/hadaq_tdc_calibr.html



