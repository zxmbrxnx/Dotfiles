#!/bin/sh
 
echo " $(/usr/sbin/ifconfig enp2s0 | grep "inet " | awk '{print $2}')"
