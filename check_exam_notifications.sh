#!/bin/bash

link="https://exams.keralauniversity.ac.in/Login/check1"

function send_mail(){

	python3 /software/python_scripts/mailsender.py -t 'surabhiar997@gmail.com' -c 'surajar994@gmail.com' -b "${notes}" -s 'Notification'

}

log(){ 
	printf "%s %s\n" "$(date +'%d-%m-%Y %H:%M')" "$1"
}

function check(){
notes=$(curl "$link" 2>/dev/null| awk '
/Published on/ {
    if (++count == 1) { inblock = 1; print; next }
    else if (count == 2) { inblock = 0; exit }
}
inblock')

echo "${notes}" | grep -q 'English Language' && send_mail || log "There are no notifications for English Language"
}

while getopts 'd:' options; do
	case $options in
	d) 
	[[ ! $OPTARG =~ ^[0-9]+$ ]] && { log "Argument should be a number. Exit"; exit; }
	day_shift=$OPTARG
	;;
	esac
done

latest_notice=$(curl "$link" 2>/dev/null | grep Published | head -1 | sed -nr 's/.*Published on ([^<]*).*/\1/p')
check_date=$(date -d "${day_shift:-0} days ago" +'%d/%m/%Y')

[[ $latest_notice == $check_date ]] && { log "Latest notice is today. Checking them"; check; } || { log "Nothing for $check_date. Exit"; }
