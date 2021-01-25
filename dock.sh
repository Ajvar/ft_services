#!/bin/bash

var=$(docker ps | grep "$1" | cut -d ' ' -f1)
echo $var
docker exec -it $var sh; docker kill $var 2>/dev/null 1>&2
