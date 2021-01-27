#!/bin/bash

if [ -z "$1" ]
  then
    echo "Include a value to send as argument"
    exit 1
fi

# Send a temperature reading to a device named TestDev2
curl -H "fiware-service: Town" -H "fiware-servicepath: /WasteManagement/Demo" "http://localhost:7896/iot/d?i=TestDev2&k=VG93bjovV2FzdGVNYW5hZ2VtZW50L0RlbW86RGV2aWNlOjE=&d=temp|$1"
