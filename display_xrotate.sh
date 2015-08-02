#!/bin/bash

#author: peter g


#builds on:
#http://crunchbang.org/forums/viewtopic.php?id=25839

#xinput_calibrator   --output-type xinput

    #xinput set-int-prop "SYNAPTICS Synaptics Touch Digitizer V04" "Evdev Axis Calibration" 32 4
    #xinput set-int-prop "SYNAPTICS Synaptics Touch Digitizer V04" "Evdev Axes Swap" 8 0

    #xinput set-prop "SYNAPTICS Synaptics Touch Digitizer V04"  --type=float "Coordinate Transformation Matrix" 0 -1.0 1.0058 1.0 0.0 0.0 0.0 0.0 1.0
   
  

#xrandr -o right
#xsetwacom set "Wacom ISDv4 EC Pen stylus" Rotate cw
#xsetwacom set "Wacom ISDv4 EC Pen eraser" Rotate cw
#Wacom ISDv4 EC Pen stylus               id: 8   type: STYLUS    
#Wacom ISDv4 EC Pen eraser               id: 16  type: ERASER 
#exit 1

#xsetwacom set "Wacom ISDv4 E6 Pen stylus" Rotate $wacom
#xsetwacom set "Wacom ISDv4 E6 Finger touch" Rotate $wacom
#xsetwacom set "Wacom ISDv4 E6 Pen eraser" Rotate $wacom

if [ -n "$2" ]; then
    sleep $2
fi


function set_coord_matrix {
    echo $1
    
    if [ $(hostname) == "laptop5" ] ; then
        case $1 in
            left)  xinput set-prop "$2"  --type=float "Coordinate Transformation Matrix" 1.0 0.0 -0.013 0.0035 1.0 0.0 0.0 0.0 1.0 ; \
                   xinput set-prop "$3"  --type=float "Coordinate Transformation Matrix" 1.0 0.0 -0.013 0.0035 1.0 0.0 0.0 0.0 1.0; \
                   xinput set-prop "$4"  --type=float "Coordinate Transformation Matrix" 0 -1.0 1.0058 1.0 0.0 0.0 0.0 0.0 1.0;; 
            right)  xinput set-prop "$2"  --type=float "Coordinate Transformation Matrix" 1.0 0.0 -0.013 0.0035 1.0 0.0 0.0 0.0 1.0 ; \
                    xinput set-prop "$3"  --type=float "Coordinate Transformation Matrix" 1.0 0.0 -0.013 0.0035 1.0 0.0 0.0 0.0 1.0;\
                    xinput set-prop "$4"  --type=float "Coordinate Transformation Matrix" 1.0 0.0 -0.013 0.0035 1.0 0.0 0.0 0.0 1.0;;
            normal)  xinput set-prop "$2"   --type=float "Coordinate Transformation Matrix" 1.0 0.0 -0.002 0.0035 1.0 0.0 0.0 0.0 1.0 ; \
                     xinput set-prop "$3"   --type=float "Coordinate Transformation Matrix" 1.0 0.0 -0.002 0.0035 1.0 0.0 0.0 0.0 1.0; \
                     xinput set-prop "$4"   --type=float "Coordinate Transformation Matrix" 1.0 0.0 -0.002 0.0035 1.0 0.0 0.0 0.0 1.0;; 
            inverted)  xinput set-prop "$2"   --type=float "Coordinate Transformation Matrix" 1.0 0.0 -0.008 -0.001 1.0 0.0 0.0 0.0 1.0 ; \
                       xinput set-prop "$3"   --type=float "Coordinate Transformation Matrix" 1.0 0.0 -0.008 -0.001 1.0 0.0 0.0 0.0 1.0; \
                       xinput set-prop "$4"   --type=float "Coordinate Transformation Matrix" 1.0 0.0 -0.008 -0.001 1.0 0.0 0.0 0.0 1.0;;
        esac
    fi
} 

if [ $(hostname) == "laptop5" ] ; then
    wacom_stylus="Wacom ISDv4 EC Pen stylus"
    wacom_eraser="Wacom ISDv4 EC Pen eraser"

    #TODO: fix.. not working right now
    wacom_touch="SYNAPTICS Synaptics Touch Digitizer V04"
    output="eDP1"

    # get current rotation
    current="$(xrandr -q --verbose | grep 'connected' | egrep -o '\) (normal|left|inverted|right) \(' | egrep -o '(normal|left|inverted|right)')"


elif [ $(hostname) == "laptop4" ] ; then
    wacom_stylus="Wacom ISDv4 EC Pen stylus"
    wacom_eraser="Wacom ISDv4 EC Pen eraser"

    #TODO: fix.. not working right now:w
    wacom_touch="Atmel Atmel maXTouch Digitizer"
    output="eDP1"

    # get current rotation
    current="$(xrandr -q --verbose | grep 'connected' | egrep -o '\) (normal|left|inverted|right) \(' | egrep -o '(normal|left|inverted|right)')"

elif [ $(hostname) == "laptop3" ] ; then
    wacom_stylus="Wacom ISDv4 E6 Pen stylus"
    wacom_eraser="Wacom ISDv4 E6 Pen eraser"
    wacom_touch="Wacom ISDv4 E6 Finger touch"
    output="LVDS1"

    # get current rotation
    current="$(xrandr -q --verbose | grep 'connected' | egrep -o '\) (normal|left|inverted|right) \(' | egrep -o '(normal|left|inverted|right)')"
    #current=`xrandr --verbose | grep "$output" | sed "s/^[^ ]* [^ ]* [^ ]* ([^(]*) \([a-z]*\).*/\1/"`
else
    echo "Bad computer..."
    exit 1
fi

need_restart=0

echo $current
case $current in
    normal)    geom=0;;
    left)      geom=1;;
    inverted)  geom=2;;
    right)     geom=3;;
esac
echo Geometry is $geom


if [ "$1" == "invert" ] || [ "$1" == "flip" ] || [ "$1" == "fix" ] || [ "$1" == "left" ] \
    || [ "$1" == "normal" ] || [ "$1" == "inverted" ];
then
    # based on current rotation set new rotation
    if [ "$1" == "invert" ];
    then
        # invert
        case $geom in
            0)  wacom=half; xrandr_setting=inverted; fvwmEdgeValue=0;;
            1)  wacom=cw; xrandr_setting=right; fvwmEdgeValue=0;;
            2)  wacom=none; xrandr_setting=normal; fvwmEdgeValue=1 ;;
            3)  wacom=ccw; xrandr_setting=left; fvwmEdgeValue=0;;
        esac

    elif [ "$1" == "flip" ];
    then
        # flip
        case $geom in
            0)  wacom=cw; xrandr_setting=right;;
            1)  wacom=half; xrandr_setting=inverted;;
            2)  wacom=ccw; xrandr_setting=left;;
            3)  wacom=none; xrandr_setting=normal;;
        esac
    elif [ "$1" == "left" ];
    then
        wacom=ccw
        xrandr_setting=left
        fvwmEdgeValue=0

        #xinput set-prop ${wacom_stylus}   --type=float "Coordinate Transformation Matrix" 1.0 0.0 -0.013 0.0035 1.0 0.0 0.0 0.0 1.0
        #xinput set-prop ${wacom_eraser}   --type=float "Coordinate Transformation Matrix" 1.0 0.0 -0.013 0.0035 1.0 0.0 0.0 0.0 1.0

        set_coord_matrix "$xrandr_setting" "${wacom_stylus}" "${wacom_eraser}" "${wacom_touch}"

        if [ "$geom" == "0" ] || [ "$geom" == "2" ];
        then
            need_restart=1
        fi

    elif [ "$1" == "normal" ];
    then
        wacom=none
        xrandr_setting=normal
        fvwmEdgeValue=1

        set_coord_matrix "$xrandr_setting" "${wacom_stylus}" "${wacom_eraser}" "${wacom_touch}"

        if [ "$geom" == "1" ] || [ "$geom" == "3" ]; then
            need_restart=1
        fi


    elif [ "$1" == "inverted" ];
    then
        wacom=half
        xrandr_setting=inverted
        fvwmEdgeValue=0

        set_coord_matrix "$xrandr_setting" "${wacom_stylus}" "${wacom_eraser}" "${wacom_touch}"

        if [ "$geom" == "1" ] || [ "$geom" == "3" ];
        then
            need_restart=1
        fi

    elif [ "$1" == "fix" ];
    then
        # fix
        case $geom in
            0)  wacom=none; xrandr_setting=normal;;
            1)  wacom=ccw; xrandr_setting=left;;
            2)  wacom=half; xrandr_setting=inverted;;
            3)  wacom=cw; xrandr_setting=right;;
        esac

        set_coord_matrix "$xrandr_setting" "${wacom_stylus}" "${wacom_eraser}" "${wacom_touch}"
    fi

    echo "xrandr to ${xrandr_setting}, xsetwacom to ${wacom}" >&2

    # rotate display
    xrandr -o ${xrandr_setting}

    xsetwacom set "${wacom_stylus}" Rotate $wacom 
    xsetwacom set "${wacom_eraser}" Rotate $wacom
    #can't do this via xsetwacom on laptop5

    xsetwacom set "${wacom_touch}" Rotate $wacom  

    # rotate wacom
    #xsetwacom set "Wacom ISDv4 E6 Pen stylus" Rotate $wacom
    #xsetwacom set "Wacom ISDv4 E6 Finger touch" Rotate $wacom
    #xsetwacom set "Wacom ISDv4 E6 Pen eraser" Rotate $wacom

    #Wacom ISDv4 E6 Pen stylus               id: 9   type: STYLUS    
    #Wacom ISDv4 E6 Finger touch             id: 10  type: TOUCH     
    #Wacom ISDv4 E6 Pen eraser               id: 14  type: ERASER    

    #HACK FOR NOW
    if [ `hostname` == "laptop4" ]; 
    then
        ~/bin/helix_hack.sh
    fi

    if [ $need_restart == 1 ];
    then
        #have to wait a bit so that restart catches the fvwm correct orientation 
        #~/fvwm/install/bin/FvwmCommand "ReorganizeWindowsBeforeRestart"
        #sleep 4
        ~/fvwm/install/bin/FvwmCommand "Restart"
        #give fvwm to redraw windows before reorganizing
        sleep 6
        ~/fvwm/install/bin/FvwmCommand "ReorganizeWindows"
    fi

    #$FVWM_HOME_DIR/bin/FvwmCommand "EdgeThickness $fvwmEdgeValue"
    ~/fvwm/install/bin/FvwmCommand "EdgeThickness $fvwmEdgeValue"

    sleep 1
    set_coord_matrix "${xrandr_setting}" "${wacom_stylus}" "${wacom_eraser}"

    ~/bin/wacomTabletTouch.sh off

else
    echo "possible parameters: flip, invert, fix"
fi

#echo "$PATH" >> ~/testing.txt
#echo "123" >> ~/testing.txt


