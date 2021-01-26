#!/bin/bash
docker-compose up -d
echo "Starting docker containers, giving them some time to start..."
sleep 120
# Restore dbs in Mongo with a default setup, apis and Oauth
docker cp ./mongodump deploy_mongo_1:/home/dump
docker exec -it deploy_mongo_1 mongorestore /home/dump 
