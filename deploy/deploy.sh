#!/bin/bash

# Restore the gravitee db in Mongo with a default setup, apis and Oauth
docker cp ./mongodump deploy_mongo_1:/home/dump
docker exec -it deploy_mongo_1 mongorestore /home/dump
