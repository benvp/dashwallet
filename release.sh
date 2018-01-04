#!/bin/sh
echo Building dashwallet...

docker build -t dashwallet .

docker create --name extract dashwallet
docker cp extract:/export ./_release/
docker rm -f extract

echo
echo Built successfully.
echo You can find the release in the ./_release folder.
