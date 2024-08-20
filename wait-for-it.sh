#!/bin/bash

COUNT=0
while [ $COUNT -lt 5 ]; do
  RESPONSE=$(curl http://elasticsearch:9200)
  if echo "$RESPONSE" | grep -q '"status":401'; then
    RESPONSE=$(curl -u elastic:$ELASTIC_PASSWORD -X POST "http://elasticsearch:9200/_security/user/kibana_system/_password" -d '{"password": "'"$KIBANA_PASSWORD"'"}' -H "Content-Type: application/json")
    echo "$RESPONSE"
    break
  else
    echo "$RESPONSE"
    sleep 15
    ((COUNT++))
  fi
done