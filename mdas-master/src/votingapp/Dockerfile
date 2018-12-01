# BUILDER
FROM golang:alpine AS builder
RUN apk update && apk add git 

COPY deps.sh . 
RUN sh -c './deps.sh'

COPY . .
RUN go build -o /deploy/votingapp && cp -r ui /deploy

# RUNTIME
FROM alpine
WORKDIR /app
COPY --from=builder /deploy .
ENTRYPOINT [ "sh", "-c", "sleep 10 && ./votingapp" ]