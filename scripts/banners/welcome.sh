#!/usr/bin/env sh

######################################################################
# @author      : frekle (frekle@bml01.mech.kth.se)
# @file        : welcome
# @created     : Tuesday Jul 23, 2024 13:54:13 CEST
#
# @description : 
######################################################################
N_COLS=`tput cols`
if [ "$N_COLS" -gt 240 ] ; then
	cat /etc/banners/bw_nerd.txt
	cat /etc/banners/notice.txt
else
	cat /etc/banners/notice80.txt
fi


