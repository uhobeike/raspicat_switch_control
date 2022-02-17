#!/bin/bash -e

# raspicat_navigation

# When the switch is on
if [ $1 -eq "on" ]; then
  echo start_raspicat_navigation
  roslaunch raspicat_navigation raspicat_bringup_navigation.launch &
  raspicat_navigation_pid=$!
  led_on 1
  sleep 3
fi
#######################

# When the switch is off
if [ $1 -eq "off" ]; then
  echo finish_raspicat_navigation
  kill $raspicat_navigation_pid
  led_off 1
  sleep 3
fi
########################