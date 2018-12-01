votingappPath='./src/votingapp'

build(){
  pushd $votingappPath
  ./deps.sh
  rm -rf ./deploy
  (go build -o ./deploy/votingapp && cp -r ui ./deploy) || return 1
  popd
}

run(){
  app='votingapp'
  pushd $votingappPath
  pid=$(ps | grep $app | awk '{ print $1 }' | head -1)
  kill -9 $pid || true
  ./deploy/$app &
  popd
}

test(){
  http_client(){
    curl --url 'http://localhost:8080/vote' \
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
    return 0
  else 
    return 1
  fi
}

if (build && run && test) > log 2> error; then
  echo "Pipeline WORKING!"
else
  echo "Pipeline FAILED!"
  exit 1
fi