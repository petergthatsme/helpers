
#!/bin/bash

#author: peter g

#helpers for the rest of the sound controlling files

function write_to_screen {
    killall osd_cat  2> /dev/null
    echo "$1" | osd_cat --font='rk24'  --color=red --pos=top  --align=right  --offset=30  --indent=20
} 

function get_current_volume {
    pacmd list-sinks|grep -A 10 '* index'| awk '/\tvolume: /{ print $3 }'
} 

function get_default_sink_index {
    pacmd list-sinks | grep '* index'| awk '{ print $3 }'
} 

function unload_sink {
    #grab the module ids for the sinks with given name
    MODULE_IDS=$(pacmd list-sinks| grep -A 25 'combined_sinks'| awk '/module: /{ print $2 }')
    for theid in ${MODULE_IDS}
    do
        echo Unloading sink with module id $theid
        pacmd unload-module $theid
    done
}

