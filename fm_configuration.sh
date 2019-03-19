#!/bin/bash
abort()
{
    echo >&2 
    echo "Error Encountered" >&2
    exit 1
}

trap 'abort' 0

set -e
echo "-----------------------------------------------------------------"
echo "Configuration started ......"
echo "Run this once and delete it later"
echo "Watch the progress bar......"
echo "src all http://iotdk.intel.com/repos/1.1/iotdk/all" > /etc/opkg/base-feeds.conf
echo "src x86 http://iotdk.intel.com/repos/1.1/iotdk/x86" >> /etc/opkg/base-feeds.conf
echo "src i586 http://iotdk.intel.com/repos/1.1/iotdk/i586" >> /etc/opkg/base-feeds.conf
echo "Progress |####                                                  |"
sleep 1
opkg update
opkg install git
opkg install --force-downgrade libusb-1.0-dev
echo "Progress |########                                              |"                     
sleep 2
#Source compilation
mkdir -p /rtlsdr
cd /rtlsdr
git clone https://github.com/steve-m/librtlsdr #Steve's repository for code to turn the SDR into an FM receiver
cd librtlsdr
echo "Progress |##############                                        |"                   
sleep 2
autoreconf -i
echo "Progress |###################                                   |"
sleep 2
./configure
make
echo "Progress |#######################################               |"                   
sleep 2
make install
echo "Progress |##############################################        |"
sleep 2
make install-udev-rules
echo "/usr/local/lib" > /etc/ld.so.conf
ldconfig
echo "pcm.!default sysdefault:Device" > ~/.asoundrc #Set Enter USB to AUX device as default audio out. 
# In some cases this might be required to be changed to Headset 
echo "Progress |######################################################|"                   
sleep 2
#######################################################################
trap : 0

echo >&2 '
Configuration Done
'
echo "Complete."
