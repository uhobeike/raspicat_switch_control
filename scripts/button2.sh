#!/bin/bash -e

# When the button is on
if [ $1 -eq "on" ]; then
  echo start_waypoint_navigation
  rostopic pub -1 /goal_command std_msgs/String go
  led_on 2
  sleep 2
fi
#######################

# When the button is off
if [ $1 -eq "off" ]; then
  echo start_waypoint_navigation
  rostopic pub -1 /goal_command std_msgs/String go
  led_off 2
  sleep 2
fi
########################