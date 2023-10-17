FROM ubuntu:22.04
LABEL authors="ambassador4ik"

RUN apt-get update && apt-get upgrade -y && \
    apt-get install openjdk-11-jdk build-essential cmake -y

COPY ./src /app
WORKDIR /app

CMD ["/bin/sh"]