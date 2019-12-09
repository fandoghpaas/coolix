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
RUN echo '* * * * * /cron_job.sh'  >> /etc/crontabs/root

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT "/entrypoint.sh"

