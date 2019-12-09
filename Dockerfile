FROM nginx:alpine

RUN apk add --no-cache \
    coreutils \
    bash \
    tzdata \
    py2-pip \
    curl
    
RUN pip install awscli

ENV AWS_DEFAULT_REGION=ap-northeast-1

COPY ./cron_job.sh /cron_job.sh
COPY run_server.sh /run_server.sh
COPY nginx.conf /etc/nginx/nginx.conf
RUN  mkdir /var/log/nginx/backup

CMD ["sh","/run_server.sh"]
