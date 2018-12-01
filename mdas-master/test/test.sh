#!/bin/bash
url=${VOTING_URL:-'http://votingapp:8080/vote'}
http_client(){
  curl --url $url \
    --request $1 \
    --data "$2" \
    --header 'Content-Type: application/json' \
    --silent
}

topics='{"topics":["bash","python","go"]}' 
expectedWinner='bash'
echo "Given voting topics $topics, When vote for $options, Then winner is $expectedWinner"

http_client POST $topics
for option in bash bash bash python
do
  http_client PUT '{"topic":"'$option'"}'
done
winner=$(http_client DELETE | jq -r '.winner')

if [ "$expectedWinner" = "$winner" ]; then
  exit 0
else 
  echo 'TEST FAILED'
  exit 1
fi