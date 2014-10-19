#!/bin/bash

#author: peter g

#control the volume of the default sink
#
#Example:
#sound_volume.sh -5%

. `dirname $0`/sound_common.sh

if [ $1 == "updateOsd" ] ; then
    write_to_screen $(get_current_volume) 
    exit 0
fi

pactl -- set-sink-volume $(get_default_sink_index) "$1"

echo $(get_current_volume)


