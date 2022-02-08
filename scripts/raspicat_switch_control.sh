#!/bin/bash -e

init () {
  led_off 0
  led_off 1
  led_off 2
  led_off 3
}

led_on () {
  echo 1 > /dev/rtled$1
  if [ $1 = 0 ]; then
    led_0=1
  elif [ $1 = 1 ]; then
    led_1=1
  elif [ $1 = 2 ]; then
    led_2=1
  elif [ $1 = 3 ]; then
    led_3=1
  fi
}

led_off () {
  echo 0 > /dev/rtled$1
  if [ $1 = 0 ]; then
    led_0=0
  elif [ $1 = 1 ]; then
    led_1=0
  elif [ $1 = 2 ]; then
    led_2=0
  elif [ $1 = 3 ]; then
    led_3=0
  fi
}

check_switch_status () {
  switch_status=`cat /dev/rtswitch$1`
}

check_led_status () {
  led=led_$1
  led_status=$[led_$1]
}

raspicat_navigation () {
  check_switch_status 0
  check_led_status 1
  if [ $switch_status = 0 -a $led_status = 0 ]; then
    echo start_raspicat_navigation
    roslaunch raspicat_navigation raspicat_bringup_navigation.launch &
    raspicat_navigation_pid=$!
    led_on 1
    sleep 3
  elif [ $switch_status = 0 -a $led_status = 1 ]; then
    echo finish_raspicat_navigation
    kill $raspicat_navigation_pid
    led_off 1
    sleep 3
  fi
}

waypoint_navigation () {
  check_switch_status 1
  check_led_status 2
  if [ $switch_status = 0 -a $led_status = 0 ]; then
    echo start_waypoint_navigation
    rostopic pub -1 /goal_command std_msgs/String go
    led_on 2
    sleep 2
  elif [ $switch_status = 0 -a $led_status = 1 ]; then
    echo start_waypoint_navigation
    rostopic pub -1 /goal_command std_msgs/String go
    led_off 2
    sleep 2
  fi
}

rosbag () {
  check_switch_status 2
  check_led_status 3
  if [ $switch_status = 0 -a $led_status = 0 ]; then
    echo start_rosbag_record
    mkdir -p /mnt/ssd/rosbag/
    rosrun rosbag record -a -o /mnt/ssd/rosbag/navigation &
    rosbag_record_pid=$!
    led_on 3
    sleep 3
  elif [ $switch_status = 0 -a $led_status = 1 ]; then
    echo finish_rosbag_record
    kill $rosbag_record_pid
    led_off 3
    sleep 3
  fi
}

raspicat_switch_control () {
  raspicat_navigation
  waypoint_navigation
  rosbag
  # gamepad_control
  # restart
}

check_ros_process () {
  if [ -n "$(pgrep rosmaster)" ]; then
    led_on 0
  else
    led_off 0
  fi
}

exit () {
  init
  killall -9 rosmaster
}

trap 'exit' EXIT

main () {
  source /opt/ros/melodic/setup.bash
  source /home/ubuntu/tsudanuma_ws/devel/setup.bash
  init
  while :
  do
    raspicat_switch_control
    check_ros_process
    sleep 0.01
  done
}

main