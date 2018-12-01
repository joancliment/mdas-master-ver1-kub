. common.sh

cat parameters-template.json \
| sed 's/${CLIENT_ID}/'${CLIENT_ID}'/g' \
| sed 's/${CLIENT_SECRET}/'${CLIENT_SECRET}'/g' \
| sed 's/${NAME}/'$cluster'/g'> parameters.json

./deploy.sh \
  -g $group \
  -i $subscription \
  -n $deployment \
  -l $location 

create_registry 