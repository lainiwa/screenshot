FROM alpine:3.14.0 AS builder
RUN apk add --no-cache --update git \
                                alpine-sdk \
                                cmake \
                                nasm
RUN git clone --recursive https://github.com/fhanau/Efficient-Compression-Tool /root/ect
WORKDIR /root/ect
RUN git checkout 777dcb8 .
WORKDIR /root/ect/build
RUN cmake ../src && make -j"$(nproc)"

FROM koalaman/shellcheck:v0.7.1 AS test
COPY . /app
RUN ["shellcheck", "/app/screenshot"]

FROM alpine:3.14.0 as prod
LABEL org.opencontainers.image.source=https://github.com/lainiwa/screenshot
ENV SCREENSHOT_DIR /opt/shared
COPY --from=builder /root/ect/build/ect /usr/local/bin
RUN apk add --no-cache --update scrot \
                                tesseract-ocr \
                                tesseract-ocr-data-rus
RUN chmod 777 /var/lock
COPY . /app
ENTRYPOINT ["/app/screenshot"]
