#!/bin/bash
cd $HOME/pyconjp-2018
docker-compose build --no-cache
docker-compose down
docker-compose up -d
