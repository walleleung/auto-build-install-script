#!/bin/bash

function git_update()
{
  if [ "$#" -lt 2 -o -z "$0" -o -z "$1" ] ; then
    echo "Usage: update_git gitpath giturl"
    return 1
  fi
  gitpath="$1"
  giturl="$2"
  if [ -d "$gitpath" ] ; then
    cd $gitpath
    git pull master origin
  else
    mkdir -p "$gitpath"
    git clone "$giturl" "$gitpath"
    cd "$gitpath"
  fi
}
