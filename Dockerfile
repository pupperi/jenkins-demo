FROM golang:1.10

WORKDIR /go/src/app
COPY . /go/src/app

RUN go get -d -v ./...
RUN go install -v ./...

CMD ["app"]
EXPOSE 8181
