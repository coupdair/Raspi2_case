#!/bin/bash

#temporary stuff for CI, i.e. within Linux docker container

update=$1

pwd
ls ..
ls ../*

di=ci-temporary

#dev. SCAD libs
li=library.scad
if [ "$update" == "" ]
then
  #move (in docker image)
  mv ./$di/$li ../
  ls ../$li/
  #update version
  cd ../$li/; make version
else #}move
  #update (in source tree)
  rsync -var ../$li/* ./$di/$li/
  rm -f ./$di/$li/*.stl ./$di/$li/*.png
  #update version
  cd ./$di/$li/; make version
fi #}update
