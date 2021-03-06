#!/bin/bash

# 自动将maven工程下target目录下的jar和war包推送到变量jar_path和war_path下
function mvn_push2target()
{
	error_text="推送jar包和war包失败，失败原因为："
	if [ $# -lt 1 -o -z "$1" ] ; then
		echo $error_text没有指定target目录，不做处理
		return
	fi  
	prog_sp=$1
	if ! [ -d "$prog_sp" ] ; then
		echo $error_text指定的target目录$prog_sp不存在，不做处理
		return 1
	fi  
	if [ -z "$jar_path" -o -z "$war_path" ] ; then
		echo ${error_text}jar和war的目标目录没有配置，请配置jar_path和war_path环境变量
		return 1
	fi
	cp -vf $prog_sp/*.jar $jar_path 2>/dev/null
	cp -vf $prog_sp/*.war $war_path 2>/dev/null
	if [ -d "$prog_sp/lib" ] ; then 
		cp -f $prog_sp/lib/*.jar $jar_path/lib
	fi  
}

# 自动将工作空间下所有maven工程target目录下的jar和war包推送到变量jar_path和war_path下
function mvn_push2sp()
{
	error_text="推送jar包和war包失败，失败原因为："
	if [ $# -lt 1 -o -z "$1" ] ; then
		echo $error_text没有指定工程目录，不做处理
		return
	fi  
	prog_sp=$1
	if ! [ -d "$prog_sp" ] ; then
		echo $error_text指定的工程目录$prog_sp不存在，不做处理
		return
	fi  
	sps=`find "$prog_sp" -type d -mtime -1 -name "target"`
	for sp in $sps ;
	do  
		push_jar_and_war_4target $sp 
	done
}
