#!/bin/bash

function tomcat_clear()
{
	if [ "$#" -lt 2 -o -z "$0" -o -z "$1" ] ; then
		echo "Usage: tomcat_clear tomcat_path web_name"
		return 1
	fi
	tomcat_path="$1"
	web_name="$2"
	if ! [ -d "$tomcat_path" ] ; then
		return 1
	fi
	cd $tomcat_path
	if [ -d "work" ]; then
		rm -rf work
	fi
	cd webapps
	if [ -f "$web_name.war" ]; then
		mv -f "$web_name.war" /del
	fi
	if [ -d "$web_name" ]; then
		rm -rf "/del/$web_name"
		mv -f "$web_name" /del
	fi
}
