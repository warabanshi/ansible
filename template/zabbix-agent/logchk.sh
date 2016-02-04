#!/bin/sh
#
# Description : Log Check(5min ago)
#
# Interface   : logchk.sh <arg1> <arg2> <arg3>
#        IN   : <arg1> = LogType [messages]
#             : <arg2> = Match Keyword
#             :  (exp: "Error" , "Error|Critical" )
#             : <arg3> = Exception Keyword
#
#       OUT   : 0 = normal
#               1 = error
#
###########################################################
 
declare -r LOGDIR='/var/log/zabbix'
declare GREP_OPTION='-i'
 
#
# Usage Messages
#
func_usage()
{
        echo -e '\e[32m'
        echo -e 'Usage: logchk.sh <arg1> <arg2> <arg3>'
        echo -e '     : <arg1> = [messages]'
        echo -e '     : <arg2> = keyword'
        echo -e '     : <arg3> = exception'
        echo -e '\e[m'
 
        exit 1
}
 
if [ "$#" -lt 2 ]; then
        func_usage
        exit 1
fi
 
case $1 in
        messages)
                logfile='/var/log/messages'
                DT2=`LANG=C;date --date '5 minutes ago' +'%b %d %H:%M'`
                ;;
        apache)
                logfile="/var/log/httpd/access_log"
                DT2=`LANG=C;date --date '10 minutes ago'  +'%d/%b/%Y:%H:%M'`
                ;;
        *)
                func_usage
                ;;
esac
 
if [ ! -d $LOGDIR ]; then
        mkdir $LOGDIR
fi
 
datfile="${LOGDIR}/log_$1.dat"
DT=`echo $DT2 | sed -e "s/.$//"`
 
key=$2
exception=$3
 
if [ ! -f "$logfile" ]; then
        echo "[NG]$logfile is not found." > $datfile
        exit 1
fi
 
if [ "$exception" ]; then
        RETVAL=`egrep "$GREP_OPTION" "$DT" "$logfile" | egrep -i "$key" | egrep -iv "$exception"`
else
        RETVAL=`egrep "$GREP_OPTION" "$DT" "$logfile" | egrep -i "$key"`
fi
 
 
if [ "$RETVAL" = "" ]; then
        echo "[OK]" | tee $datfile
        exit 0
else
        echo "[NG]$RETVAL" | tee $datfile
        exit 1
fi
 
# EOF;
