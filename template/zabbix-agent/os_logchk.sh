#!/bin/sh
 
declare -r DIR_BASE='/opt/zabbix'
declare -r EXE_LOGCHK="${DIR_BASE}/logchk.sh"
 
/bin/sh $EXE_LOGCHK messages 'error|fail|fioerr' 'ldap|rtc_cmos'
 
exit 0
