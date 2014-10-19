#!/bin/bash

#author: peter g

#builds on:
#http://crunchbang.org/forums/viewtopic.php?id=25839


# config
output="LVDS1"

# get current rotation
current=`xrandr --verbose | grep "$output" | sed "s/^[^ ]* [^ ]* [^ ]* ([^(]*) \([a-z]*\).*/\1/"`
case $current in
  normal)    geom=0;;
  left)      geom=1;;
  inverted)  geom=2;;
  right)     geom=3;;
esac

if [ "$1" == "invert" ] || [ "$1" == "flip" ];
then


  # based on current rotation set new rotation
  if [ "$1" == "invert" ];
  then
  
    # invert
    case $geom in
      0)  wacom=half; xrandr=inverted; fvwmEdgeValue=0;;
      1)  wacom=cw; xrandr=right; fvwmEdgeValue=1;;
      2)  wacom=none; xrandr=normal; fvwmEdgeValue=1 ;;
      3)  wacom=ccw; xrandr=left; fvwmEdgeValue=1;;
    esac

  else
    
    # flip
    case $geom in
      0)  wacom=cw; xrandr=right;;
      1)  wacom=half; xrandr=inverted;;
      2)  wacom=ccw; xrandr=left;;
      3)  wacom=none; xrandr=normal;;
    esac

  fi

  echo "xrandr to $xrandr, xsetwacom to $wacom" >&2

  # rotate display
  xrandr -o $xrandr

  # rotate wacom
  xsetwacom set "Wacom ISDv4 E6 Pen stylus" Rotate $wacom
  xsetwacom set "Wacom ISDv4 E6 Finger touch" Rotate $wacom
  xsetwacom set "Wacom ISDv4 E6 Pen eraser" Rotate $wacom

  $FVWM_HOME_DIR/bin/FvwmCommand "EdgeThickness $fvwmEdgeValue"

  #Wacom ISDv4 E6 Pen stylus               id: 9   type: STYLUS    
  #Wacom ISDv4 E6 Finger touch             id: 10  type: TOUCH     
  #Wacom ISDv4 E6 Pen eraser               id: 14  type: ERASER    

else

  echo "possible parameters: flip, invert"
 
fi
