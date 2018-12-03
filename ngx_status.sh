#!/bin/bash
#====================================================
# Author: VizierBi
# Create Date: 2018-12-03
# Description:监控nginx主机性能 
#====================================================
HOST="115.159.220.230"
PORT="80"

function actice {
	/usr/bin/curl "http://$HOST:$PORT/ngx_status/" 2>/dev/null | grep "Active" | awk '{print $NF}'
	}
function reading {
	/usr/bin/curl "http://$HOST:$PORT/ngx_status/" 2>/dev/null | grep "Reading" | awk '{print $2}'
	}
function writing {
	/usr/bin/curl "http://$HOST:$PORT/ngx_status/" 2>/dev/null | grep "Writing" | awk '{print $4}'
	}
function waiting {
	/usr/bin/curl "http://$HOST:$PORT/ngx_status/" 2>/dev/null | grep "Waiting" | awk '{print $6}'
	}
function accepts {
	/usr/bin/curl "http://$HOST:$PORT/ngx_status/" 2>/dev/null | awk NR==3 | awk '{print $1}'
	}
function handled {
	/usr/bin/curl "http://$HOST:$PORT/ngx_status/" 2>/dev/null | awk NR==3 | awk '{print $2}'
	}
function requests {
	/usr/bin/curl "http://$HOST:$PORT/ngx_status/" 2>/dev/null | awk NR==3 | awk '{print $3}'
	}
$1
