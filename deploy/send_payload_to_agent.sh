#!/bin/bash

if [ -z "$1" ]
  then
    echo "Include a value to send as argument"
    exit 1
fi

# Send an air quality reading to a device named Device
curl -H "fiware-service: Town" -H "fiware-servicepath: /EnvironmentManagement/Demo" "http://localhost:7896/iot/d?i=Device&k=VG93bjovRW52aXJvbm1lbnRNYW5hZ2VtZW50L0RlbW86QWlyUXVhbGl0eTox&d=rssi|$1"
