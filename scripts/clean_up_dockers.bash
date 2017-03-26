#!/usr/bin/env bash

exited_docker=$(docker ps -a -q -f status=exited | wc -l) 
if [ "$exited_docker" -gt 0 ] ; then
	docker rm -v $(docker ps -a -q -f status=exited)
fi

dangling_images=$(docker images -f "dangling=true" -q | wc -l)
if [ "$dangling_images" -gt 0 ] ; then
 docker rmi $(docker images -f "dangling=true" -q)
fi

dangling_volumes=$(docker volume ls -qf dangling=true | wc -l )
if [ "$dangling_volumes" -gt 0 ] ; then
 docker volume rm $(docker volume ls -qf dangling=true)
fi
