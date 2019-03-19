#!/bin/bash
if [ $# -eq 0 ]
  then
    echo ""
    echo "Specify the frequency as an argument in MHz."
    exit 1
fi
rtl_fm -f $1e6 -M wbfm -s 200000 -r 48000 - | aplay -r 48k -f S16_LE
