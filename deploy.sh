#!/bin/bash
set -e

echo "Starting identidock system"

docker run -d --restart=always --name redis redis:latest
docker run -d --restart=always --name dnmonster amouat/dnmonster:latest
docker run -d --restart=always --name identidock --link dnmonster:dnmonster --link redis:redis andrkrutsch/identidock:latest
docker run -d --restart=always --name proxy --link identidock:identidock -p 80:80 -e NGINX_HOST=127.0.0.1 -e NGINX_PROXY=http://identidock:9090 andrkrutsch/proxy:latest

echo "Started"