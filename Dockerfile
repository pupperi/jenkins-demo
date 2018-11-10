FROM golang:1.10

RUN mkdir /go/src/app
WORKDIR /go/src/app

ADD ./main.go ./
ADD ./main_test.go ./

RUN go get -d -v ./...
RUN go install -v ./...

CMD ["app"]
EXPOSE 8181
