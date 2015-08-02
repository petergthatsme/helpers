#!/bin/bash

#author: peter g

#This file will be specific to the hardware present. It assigns sound defaults based on the hostname. 

#TODO
#- could try to figure what hardware is actually present with a given host before setting defaults, etc., that way 
#things wont break if for some reason say a given dac is not connected. 
#- move all current sink inputs to the default when creating a new combined sink, in case script is ran while
#the sound is already being sent to a particular sink

. `dirname $0`/sound_common.sh

SINK_AMP_FIIOE17=alsa_output.usb-FiiO_FiiO_USB_DAC-E17-01-DACE17.analog-stereo
SINK_INTERNAL_DESKTOP5=alsa_output.pci-0000_00_1b.0.analog-stereo
SINK_INTERNAL_DAKINE=alsa_output.pci-0000_00_1b.0.analog-stereo

SOURCE_USB1=alsa_input.usb-C-Media_Electronics_Inc._USB_PnP_Sound_Device-00-Device.analog-mono
SOURCE_INTERNAL_DESKTOP5=alsa_input.pci-0000_00_1b.0.analog-stereo
SOURCE_INTERNAL_DAKINE=alsa_input.pci-0000_00_1b.0.analog-stereo

if [ "$HOSTNAME" == "desktop5" ] ; then
    #input
    pacmd set-default-source ${SOURCE_USB1}
    #pacmd set-default-source ${SOURCE_INTERNAL_DESKTOP5}

    #output
    unload_sink combined_sinks
    
    sleep 0.3

    #NOTE: have be sure output quality in /etc/pulse/daemon.conf supports all slave sinks when combining
    #... until pulseaudio finally starts supporting quality on per-sink basis 
    #pacmd load-module module-combine-sink sink_name=combined_sinks slaves=${SINK_AMP_FIIOE17},${SINK_INTERNAL_DESKTOP5}

    #the default sink should be both the amp/dac and the internal card
    #pacmd set-default-sink combined_sinks

    pacmd set-default-sink ${SINK_AMP_FIIOE17}
    sleep 0.3
    pactl -- set-sink-volume ${SINK_AMP_FIIOE17} 75%

#if [ "$HOSTNAME" == "desktop5" ] ; then
    ##input
    #pacmd set-default-source ${SOURCE_USB1}
    ##pacmd set-default-source ${SOURCE_INTERNAL_DESKTOP5}

    ##output
    #unload_sink combined_sinks
    
    #sleep 0.3

    ##NOTE: have be sure output quality in /etc/pulse/daemon.conf supports all slave sinks when combining
    ##... until pulseaudio finally starts supporting quality on per-sink basis 
    #pacmd load-module module-combine-sink sink_name=combined_sinks slaves=${SINK_AMP_FIIOE17},${SINK_INTERNAL_DESKTOP5}

    ##the default sink should be both the amp/dac and the internal card
    #pacmd set-default-sink combined_sinks

    #sleep 0.3

    #pactl -- set-sink-volume ${SINK_AMP_FIIOE17} 75%
    #pactl -- set-sink-volume ${SINK_INTERNAL_DESKTOP5} 75%

elif [ "$HOSTNAME" == "dakine" ] ; then
    #output
    pacmd set-default-sink ${SINK_AMP_FIIOE17}

#do noting on other hosts
#else

fi


