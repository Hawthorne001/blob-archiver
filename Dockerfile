FROM golang:1.21.6-alpine3.19 as builder

RUN apk add --no-cache make gcc musl-dev linux-headers jq bash

WORKDIR /app

COPY ./go.mod ./go.sum /app/

RUN go mod download

COPY . /app

RUN make build

FROM alpine:3.20.3

COPY --from=builder /app/archiver/bin/blob-archiver /usr/local/bin/blob-archiver
COPY --from=builder /app/api/bin/blob-api /usr/local/bin/blob-api