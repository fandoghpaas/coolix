CRON=${CRON:-'0 */24 * * *'}
echo "$CRON /cron_job.sh > /var/log/cron_job.log 2 &>1"  >> /etc/crontabs/root
crond  -b
nginx -g "daemon off;"
