#!/bin/bash

sleep_for(){
	t=$1
	while [[ $t -gt 0 ]]; do
		printf "\r\e[KSeconds:%2s\tFrequency:%4s\tNext move to %s,%s in %s seconds" $sec $freq $x $y $t
		((--t))
		sleep 1
	done
}

do_time_check(){
	[[ -n $time ]] && {
	[ ${time:0:2} -gt 24 ] && { echo "Invalid time. Running infinite loop";return 1; }
	[ ${time:3:2} -gt 60 ] && { echo "Invalid time. Running infinite loop";return 1; }
	
	[ "$(date +'%H')" -gt "${time:0:2}" ] && { echo "Time up H"; exit 0; }
	[ "$(date +'%H')" -eq "${time:0:2}" ] && [ $(date +'%M') -ge ${time:3:2} ] && { echo "Time up M"; exit 0; }
	
	today=$(date +'%Y-%m-%d')
	end_sec=$(date -d "$today $time" +'%s')
	now_sec=$(date +'%s')
	sec=$(($end_sec-$now_sec))
}
	
	[[ -z $freq ]] && freq=$(echo "${sec:-3600}/10" | bc)
	[ ${freq:-100} -gt 200 ] && freq=200
	sec=$((sec-freq))
}

measure_desktop(){
xy=$(xdotool getdisplaygeometry)
max_x=${xy// *}
max_y=${xy//* }
x=$max_x
y=$max_y
}

set_mouse_location(){
x=$((x - 25))
y=$((y - 25))
x=$((x < 0 ? -x : x))
y=$((y < 0 ? -y : y))
}

while getopts ':t:s:f:' option
do
case $option in 
	t) time=$OPTARG;;
	s) sec=$OPTARG;;
	f) freq=$OPTARG;;
esac
done

measure_desktop
while true; do
    do_time_check
    set_mouse_location
    xdotool mousemove $x $y
    sleep_for ${freq}
done
