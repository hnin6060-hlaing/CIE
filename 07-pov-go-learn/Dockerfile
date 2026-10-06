FROM alpine:3.24.2

# CA bundle (you may not need this if alpine's ca-certificates works for you)
ADD "https://curl.haxx.se/ca/cacert.pem" "/etc/ssl/certs/ca-certificates.crt"

# Copy your prebuilt http-echo binary into the image
COPY ./dist/linux/arm64/http-echo /http-echo

RUN apk add --no-cache \
    curl \
    bind-tools \
    net-tools \
    iptables \
    iproute2

ENTRYPOINT ["/http-echo"]