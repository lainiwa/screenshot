FROM alpine:3.12.1 AS builder
RUN apk add --no-cache --update git alpine-sdk cmake nasm
RUN git clone --recursive https://github.com/fhanau/Efficient-Compression-Tool /root/ect
WORKDIR /root/ect
RUN git checkout 777dcb8 .
RUN mkdir build && cd build && cmake ../src && make -j$(nproc)

FROM koalaman/shellcheck:v0.7.1 AS test
WORKDIR /app
COPY . /app
RUN ["shellcheck", "/app/screenshot"]

FROM alpine:3.12.1 as prod
LABEL org.opencontainers.image.source https://github.com/lainiwa/screenshot
COPY --from=builder /root/ect/build/ect /usr/local/bin
RUN apk add --no-cache --update \
    scrot=1.3-r0 \
    tesseract-ocr=4.1.1-r3 \
    tesseract-ocr-data-rus=4.1.1-r3
RUN chmod 777 /var/lock
WORKDIR /user
COPY . /app
ENTRYPOINT ["/app/screenshot"]
