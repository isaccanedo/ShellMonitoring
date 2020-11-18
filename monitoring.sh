#!/bin/bash
# ------------------------------------------------------------------------- 
# # Script SHELL simples para monitoramento de sistema Linux e UNIX com 
# comando ping
# -------------------------------------------------------------------------

# ------------------------------------------------------------------------- 
# Autor: Isac Canedo
# Criado: 27/08/2003
# -------------------------------------------------------------------------
 
# adicione o ip / nome do host separado por um espaço em branco, para iterar ainda mais durante o ping
HOSTS="10.72.179.204 10.72.179.205 search.google.com"
 
# número de solicitações de ping
COUNT=1
LOG_FILE=/opt/ping-log.txt
 
 
while [ true ]
do
for myHost in $HOSTS
do
 
  grepPing=$(ping -c $COUNT $myHost | grep 'time=' )
 
  if [ "$myHost" == "search.google.com" ];
  then
    timeUnit=$(echo $grepPing | awk '{ print $9 }' )
    timetaken=$(echo $grepPing | awk '{ print $8 }' | awk -F'=' '{ print $2 }' | awk -F'.' '{ print $1 }' | awk '{printf( "%d", $1 )}')
  else
    timeUnit=$(echo $grepPing | awk '{ print $8 }' )
    timetaken=$(echo $grepPing | awk '{ print $7 }' | awk -F'=' '{ print $2 }' | awk -F'.' '{ print $1 }' | awk '{printf( "%d", $1 )}')
  fi
 
 
  if [ "$timeUnit" != "" ];
  then
    if [ $timeUnit == "ms" -a $timetaken -lt 1 ];
    then
      echo "$grepPing, $myHost is online" `date`
    else
      echo "$grepPing, Host : $myHost is down (ping failed) at $(date)" >> $LOG_FILE
#      echo "$grepPing, Host : $myHost is down (ping failed) at $(date)"
    fi
  else
    echo "ping: unknown host $myHost, at $(date)" >> $LOG_FILE
  fi
done
sleep 1
done
