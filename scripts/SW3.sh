#!/bin/bash -e

# rosbag_record

# When the switch is on
if [ $1 -eq "on" ]; then
  echo start_rosbag_record
  mkdir -p /mnt/ssd/rosbag/
  rosrun rosbag record -a -o /mnt/ssd/rosbag/navigation &
  rosbag_record_pid=$!
  led_on 3
  sleep 3
fi
#######################

# When the switch is off
if [ $1 -eq "off" ]; then
  echo finish_rosbag_record
  kill $rosbag_record_pid
  led_off 3
  sleep 3
fi
########################