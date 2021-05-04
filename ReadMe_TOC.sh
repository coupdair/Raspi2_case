#!/bin/bash

f=ReadMe.md
ft=`basename $0 .sh`.tmp

#get TOC
grep '# ' $f | grep -v '(#' > $ft

#header
echo '<!--- begin@of@TOC --->'
echo 'Table of contents'
echo

#make MarkDown links
while read l
do
#echo ":$l:"
  #rank
  
  #title
  t=`echo "$l" | sed 's/# //;s/#//g'`
  #rank and link
  k=`echo "$l" | sed 's/# /#@/;s/  / /g;s/  / /g;s/  / /g;s/ /-/g;s/\.//g' | tr [:upper:] [:lower:]`
#echo "$t $k"
  #gather
  /bin/echo -e -n $k | sed "s/@/@[$t](/" | sed 's/#@/# /;s/###/          - /;s/##/     - /;s/#/- /;'
  echo ')'
done < $ft | sed 's/(/(\#/'

#footer
echo '<!--- end@of@TOC --->'

#clean
rm $ft
