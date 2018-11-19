FROM alpine:3.6
LABEL Description="Concourse resource Heat"
MAINTAINER kourosh.vivan@gmail.com

RUN ln -s /lib /lib64 \
    && \
        apk --upgrade add --no-cache \
            py-lxml \
            py-pip \
            openssl \
            ca-certificates \
    && \
        apk --upgrade add --no-cache --virtual \
            build-dependencies \
            build-base \
            python-dev \
            libffi-dev \
            openssl-dev \
            linux-headers

ADD requirements.txt /opt/
RUN pip install --upgrade --no-cache-dir -r /opt/requirements.txt

RUN apk del \
        build-dependencies \
        build-base \
        python-dev \
        libffi-dev \
        openssl-dev \
        linux-headers

# install resource assets
ADD assets/ /opt/resource/
