#!/bin/sh

#author: peter g
#
#Setup mouse options/settings.
#

applyOptionsDeathAdder () {
    echo "Setting up device: $1"
    xinput list-props "$1"
    xinput set-prop "$1" "Device Accel Profile" -1
    xinput set-float-prop "$1" "Device Accel Velocity Scaling" 1
    xinput set-float-prop "$1" "Device Accel Constant Deceleration" 1.75
    xinput set-float-prop "$1" "Device Accel Adaptive Deceleration" 1.0
    xinput list-props "$1"
} 


MOUSE_IDS=`xinput | grep 'Razer Razer DeathAdder 2013' | grep pointer  | sed -e  's/^.*id=//' | awk '{print $1}'`

echo $MOUSE_IDS
if [ ! -z "${MOUSE_IDS}" ]; then
    echo "\n\n Setting up the DeathAdder \n\n\n"
    for theid in $MOUSE_IDS
    do
        echo Processing $theid
        applyOptionsDeathAdder $theid
    done
fi


applyOptionsSteelSeriesV2 () {
    echo "Setting up device: $1"
    xinput list-props "$1"
    xinput set-prop "$1" "Device Accel Profile" -1
    xinput set-float-prop "$1" "Device Accel Velocity Scaling" 1
    xinput set-float-prop "$1" "Device Accel Constant Deceleration" 1.60
    xinput set-float-prop "$1" "Device Accel Adaptive Deceleration" 1.0
    xinput list-props "$1"
} 

MOUSE_IDS=`xinput | grep 'SteelSeries Kinzu V2 Gaming Mouse' | grep pointer  | sed -e  's/^.*id=//' | awk '{print $1}'`


echo $MOUSE_IDS
if [ ! -z "${MOUSE_IDS}" ]; then
    echo "\n\n Setting up the SteelSeriesV2 \n\n\n"
    for theid in $MOUSE_IDS
    do
        echo Processing $theid
        applyOptionsSteelSeriesV2 $theid
    done
fi


