#!/bin/sh

repository=hyperpaint
name=wordpress
version=6.4.2
build=1

docker build -t $repository/$name:$version .
docker tag $repository/$name:$version $repository/$name:$version-$build
