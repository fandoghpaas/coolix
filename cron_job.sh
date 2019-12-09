#!/bin/bash

BUCKETNAME="your_s3_bucket"
LOGDIR="/var/log/nginx/backup"
LOGDATE=$(date +"%Y%m%d%H")

LOGFILES=("access" "error")

echo "Moving access logs to dated logs.."

for LOGFILE in "${LOGFILES[@]}"
do
  CURFILE="$LOGDIR/$LOGFILE.log"
  NEWFILE="$LOGDIR/$LOGFILE-$LOGDATE.log"
  mv $CURFILE $NEWFILE
done

echo "done!.."


echo "Sending rotate signal to nginx.."

NGINX_MASTER_PID=`ps aux | grep nginx | grep master | awk '{ printf $1" "}'`

kill -USR1 $NGINX_MASTER_PID

echo "done!.."

sleep 1

echo "Uploading log files to s3.."

for LOGFILE in "${LOGFILES[@]}"
do
  S3_FILENAME="$LOGFILE-$LOGDATE-$HOSTNAME.log"
  ACTUAL_FILENAME="$LOGFILE-$LOGDATE.log"
  FILE="$LOGDIR/$ACTUAL_FILENAME"
  gzip $FILE
  aws s3 cp --endpoint-url=$AWS_ENDPOINT_URL $FILE.gz s3://nginx-logs/$S3_FILENAME.gz
  rm $FILE.gz
done

echo "done!.."
