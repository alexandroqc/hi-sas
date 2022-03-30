#!/bin/ash

if [ $APP_ENV == "development"  ]; then
	/start-reload.sh
else
	/start.sh
fi