#!/bin/bash
#====================================================
# Author: VizierBi
# Create Date: 2018-10-19
# Description:微信监控报警脚本 
#====================================================
CropID='wwaebf94b1310467a9'
Secret='W6ahrPd1vg-M2I1CbXa9MYhRW_Vp10NNmOQNov2ELvY'
GURL="https://qyapi.weixin.qq.com/cgi-bin/gettoken?corpid=$CropID&corpsecret=$Secret"
Gtoken=$(/usr/bin/curl -s -G $GURL | awk -F\" '{print $10}')
PURL="https://qyapi.weixin.qq.com/cgi-bin/message/send?access_token=$Gtoken"

function body(){
	local int AppID=1000002
	local UserID=$1
	local PartyID=1
	local Msg=$(echo "$@" | cut -d" " -f3-)
	printf '{\n'
	printf '\t"touser": "'"$User"\"",\n"
	printf '\t"toparty": "'"$PartyID"\"",\n"
	printf '\t"msgtype": "text",\n'
	printf '\t"agentid": "'" $AppID "\"",\n"
	printf '\t"text": {\n'
	printf '\t\t"content": "'"$Msg"\""\n"
	printf '\t},\n'
	printf '\t"safe":"0"\n'
	printf '}\n'
}
/usr/bin/curl --data-ascii "$(body $1 $2 $3)" $PURL

