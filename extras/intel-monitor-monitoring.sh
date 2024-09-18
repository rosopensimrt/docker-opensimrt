#!/bin/bash

set -e

CURRENT_GRAPHICAL_USER="" 		
CURRENT_GRAPHICAL_USER_ID="" 		
CURRENT_ACTIVE_SESSION="" 	
CURRENT_XAUTHORITY="" 		
CURRENT_DISPLAY="" 			
CURRENT_PIDFILE="" 			
CURRENT_INR=""				

update_creds(){
	sessions=$(loginctl | grep 'seat0' | awk '{print $1}')
	for session in $sessions; do 
		#echo $session
		is_active=$(loginctl show-session $session | grep "Active" | cut -d'=' -f2)
		if [ "$is_active" = "yes" ]; then
			USER=$(loginctl show-session $session | grep "Name" | cut -d'=' -f2)
			U_ID=$(loginctl show-session $session | grep "User" | cut -d'=' -f2)
			ACTIVE_SESSION=$session
		fi

	done
	XAUTHORITY=/home/$USER/.Xauthority

	DISPLAY=$(ps -u $USER -o pid= \
		| xargs -I PID -r cat /proc/PID/environ 2> /dev/null \
		| tr '\0' '\n' \
		| grep ^DISPLAY=: \
		| sort -u \
		| cut -d'=' -f2)
	DISPLAY=${DISPLAY:-":1"}
	INR=`ps -U $USER | grep intel-virtual | awk '{print $1}'`

	PIDFILE=/var/run/user/$U_ID/intel-virtual-output.pid 
	CURRENT_GRAPHICAL_USER=$USER 		
	CURRENT_GRAPHICAL_USER_ID=$U_ID 	
	CURRENT_ACTIVE_SESSION=$ACTIVE_SESSION 	
	CURRENT_XAUTHORITY=$XAUTHORITY 		
	CURRENT_DISPLAY=$DISPLAY 		
	CURRENT_PIDFILE=$PIDFILE 		
	CURRENT_INR=$INR 			
}
IS_RUNNING="no"

start_process(){
	((/usr/bin/intel-virtual-output -d ${CURRENT_DISPLAY})  & jobs -p > ${CURRENT_PIDFILE})
	IS_RUNNING="yes"
}
process_loop(){
	start_process
	while :
		do
			#update_creds
			is_active=$(loginctl show-session ${CURRENT_ACTIVE_SESSION} | grep "Active" | cut -d'=' -f2)
			if [ "$is_active" = "yes" ]; then
				if [ "$IS_RUNNING" = "yes" ]; then
					sleep 1 
				else
					start_process
				fi

			else
				if [ "$IS_RUNNING" = "yes" ]; then
					stop_process
					IS_RUNNING="no"
				else
					sleep 2
				fi
			fi
		done
}

stop_process(){
	echo called stop_process
	killall intel-virtual-output
	sleep 1
}

echo got here $1 $(export)
update_creds
echo whatta ${CURRENT_GRAPHICAL_USER} ${CURRENT_DISPLAY}

case $1 in
    pre)   # Actions before suspend/hibernate
	if [ -n "${CURRENT_INR}" ]; then
		stop_process
	fi;;
    stop)
	update_creds
	if [ -n "${CURRENT_INR}" ]; then
		stop_process
	else
	    echo "intel-virtual-output wasnt running" >&2
	fi;;
    start)
	if [ -n "${CURRENT_GRAPHICAL_USER}" ] && [ -n "${CURRENT_DISPLAY}" ]; then
		if [ -n "${CURRENT_INR}" ]; then
			stop_process_user
		fi

		process_loop
	else
		echo "something wasn't really set" >&2
	fi;;


    post)  # Actions after resume/wake
	if [ -n "${CURRENT_GRAPHICAL_USER}" ] && [ -n "${CURRENT_DISPLAY}" ]; then
		if [ -n "${CURRENT_INR}" ]; then
			stop_process_user
		fi
		process_loop
	else
		echo "something wasnt really set" >&2
	fi;;
esac
