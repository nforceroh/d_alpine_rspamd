FROM nforceroh/d_alpine-s6:edge
LABEL maintainer Sylvain Martin (sylvain@nforcer.com)

### Disable Features From Base Image
ENV ENABLE_SMTP=false \
    ADMIN_PASS='$2$s3dymobyg84ktaksyhkf8der7juzcnza$omo3btjw5kkawjpsnwx4teh7xfny7136aw9xk1a5w6r3ay4714rb' \
    REDIS_HOST=redis.int.nforcer.com \
    REDIS_PORT=6379 \
    REDIS_TIMEOUT=15s \
    REDIS_DB=7 \
    LOG_LEVEL=info \
    DEBUG_MODE=true
# error,warning,info,debug

### Install Dependencies
RUN echo 'http://dl-cdn.alpinelinux.org/alpine/edge/testing' >> /etc/apk/repositories \
    && apk update \
    && apk add --no-cache \
        ca-certificates \
        rspamd \
        rspamd-client \
        rspamd-controller \
        rspamd-proxy \
        rspamd-fuzzy \
        clamav \
        clamav-libunrar \
        rsyslog \
 ## Cleanup
    && rm -rf /var/cache/apk/* /usr/src/*

### Add Files
ADD install /
VOLUME [ "/data" ]
### Networking Configuration
# Port 11334 is for web frontend
# Port 11332 is for milter
# Port 11333 is for worker
EXPOSE 11332 11333 11334

ENTRYPOINT [ "/init" ]