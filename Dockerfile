FROM nforceroh/alpine-s6:edge
LABEL maintainer Sylvain Martin (sylvain@nforcer.com)

### Disable Features From Base Image
ENV ENABLE_SMTP=false \
    ADMIN_PASS=admin \
#    PLUGIN_ASN=TRUE \
#    PLUGIN_CLAMAV=TRUE \
#    PLUGIN_EMAILS=TRUE \
    PLUGIN_GREYLISTING=TRUE \
    PLUGIN_MILTER=FALSE \
#    CLAMAV_HOST=clamav \
#    CLAMAV_PORT=3310 \
    REDIS_HOST=redis \
    REDIS_PORT=6379 \
    REDIS_TIMEOUT=15s \
    REDIS_DB=7 \
    LOG_LEVEL=info
# error,warning,info,debug

### Install Dependencies
RUN echo 'http://dl-cdn.alpinelinux.org/alpine/edge/testing' >> /etc/apk/repositories \
    && apk update \
    && apk add --no-cache \
            ca-certificates \
            rspamd \
            rspamd-controller \
            rsyslog \
    && mkdir /run/rspamd \
### Cleanup
    && rm -rf /var/cache/apk/* /usr/src/*

### Add Files
ADD install /

### Networking Configuration
# Port 11334 is for web frontend
# Port 11332 is for milter
# Port 11333 is for worker
EXPOSE 11333 11334