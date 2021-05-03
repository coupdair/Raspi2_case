#!/bin/bash

#temporary stuff for CI, i.e. within Linux docker container

pwd
ls ..
ls ../*

di=ci-temporary

#dev. SCAD libs
mv ./ci-temporary/library.scad .
