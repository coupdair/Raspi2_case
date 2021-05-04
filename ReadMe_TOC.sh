#!/bin/bash

f=ReadMe.md

grep '# ' $f | sed 's/# /#@/;s/  / /g;s/  / /g;s/  / /g;s/ /-/g;s/\.//g' | tr [:upper:] [:lower:] | sed 's/#@/# /;s/###/          - /;s/##/     - /;s/#/- /;'
