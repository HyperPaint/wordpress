#!/bin/sh

repository=hyperpaint
name=wordpress
version=6.2
build=3

docker build -t $repository/$name:$version .
docker tag $repository/$name:$version $repository/$name:$version-$build
