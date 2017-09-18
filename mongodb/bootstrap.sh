#!/bin/bash

mongo_create() {
	docker run --name some-mongo -p 27017:27017 -d mongo --auth
}

mongo_data_init() {
	if [ -f data.csv ]; then
		mongoimport -d CO2 -c readings --type csv --file data.csv --headerline
	else;
		echo "no data.csv"; exit 1
	fi
}

mongo_auth_setup() {
        MONGOPW=$(curl -s "https://www.random.org/passwords/?num=1&len=24&format=plain") && \
        sed -e 's|MONGOPW|$MONGOPW|' mongo_user_template.js >> tmp/mongo_user.js && \
        mongo admin < tmp/mongo_user.js
}

mongo_create && mongo_data_init && mongo_auth_setup
