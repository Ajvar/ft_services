#!/usr/bin/env zsh

WPIP=$( sudo kubectl get svc wordpress | cut -d " " -f 10 )
PHPIP=$( sudo kubectl get svc phpmyadmin | cut -d " " -f 10 | cut -d $'\n' -f2)
docker build -t 42nginx --build-arg WPIP=${WPIP} --build-arg PHPIP=${PHPIP} srcs/nginx
./ft_reset.sh nginx

