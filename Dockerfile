FROM alpine:3.12.1 AS builder
RUN apk add --no-cache --update git alpine-sdk cmake nasm
RUN git clone --recursive https://github.com/fhanau/Efficient-Compression-Tool /root/ect
WORKDIR /root/ect
RUN git checkout 777dcb8 .
RUN mkdir build && cd build && cmake ../src && make -j$(nproc)

FROM alpine:3.12.1
COPY --from=builder /root/ect/build/ect /usr/local/bin
RUN apk add --no-cache --update scrot tesseract-ocr tesseract-ocr-data-rus
RUN chmod 777 /var/lock
WORKDIR /user
COPY . /app
ENTRYPOINT ["/app/screenshot"]
