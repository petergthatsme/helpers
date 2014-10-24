#!/bin/bash

#author: peter g

#Execute a command on a remote host. A good use case is to control hardware that is directly only connected to one machine. 

USAGE="Usage: $0 server_hostname server_ip <command...>"

if [ "$#" == "0" ]; then
	echo "$USAGE"
	exit 1
fi

#NOTE: There is really no need for the hostname being passed in - could just use the ip, but with both need less checking/logic
SERVERHOSTNAME=$1
shift
SERVERIP=$1
shift

if [ "$SERVERHOSTNAME" = `hostname` ]; then
    #echo "remoteExec.sh: local call..." > ~/TEST
    eval $@
else
    #echo "remoteExec.sh: remote call..." > ~/TEST
    ssh -x -o ConnectTimeout=1 -o BatchMode=yes -o StrictHostKeyChecking=no $SERVERIP $@ 
fi

