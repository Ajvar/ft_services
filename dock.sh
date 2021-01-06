#!/bin/bash

var=$(docker ps | grep "k8s_$1_$1-0" | cut -d ' ' -f1)
echo $var
docker exec -it ${var} sh; docker kill $var 2>/dev/null 1>&2
