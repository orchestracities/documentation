#!/bin/sh

LATEST_UPDATE='*Latest Update: '$(date '+%Y-%m-%d %H:%M:%S')'*'
sed -i.bak "1s/.*/${LATEST_UPDATE}/" docs/index.md && rm docs/index.md.bak
echo ${LATEST_UPDATE}
