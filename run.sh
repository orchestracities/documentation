#!/bin/sh

docker build -t docs .
docker run -p 8000:8000 docs