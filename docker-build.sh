#!/bin/bash

file="wordpress-6.6.1-ru_RU.zip"
directory="tmp/"

if ! test -f "./$file"; then
    curl -o "./$file" -L "https://ru.wordpress.org/$file"
fi

rm -rf "./$directory"
mkdir "./$directory"
unzip -q "./$file" -d "./$directory"

repository="hyperpaint"
name="wordpress"
version="6.6.1"
build="3"

docker build -t "$repository/$name:$version" .
docker tag "$repository/$name:$version" "$repository/$name:$version-$build"
