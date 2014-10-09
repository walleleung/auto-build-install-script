#!/bin/bash

# 检查目录是否存在，不存在自动创建
function ckdir()
{
	fun_info="检查目录是否存在："
	if [ -n "$1" ] ; then
		echo $fun_info失败，目录没有指定
		return 1
	elif ! [ -d "$1" ] ; then
		echo 目录$1不存在，自动创建
		mkdir -p $1
	fi  
}

# 通过程序关键字检查程序是否运行
function ckprogs()
{
	fun_info="通过程序关键字检查程序是否运行："
	if [ -n "$1" ] ; then
		prog_name="$1"
	else
		echo $fun_info失败，程序关键字没有指定
		return 1
	fi
	prog_count=`ps -ef | grep "$prog_name" | grep -v "grep" | grep -v "$0" | wc -l`
	return $(expr $prog_count = 0)
}


# 通过程序名称关键字进行结束程序
function killprogs()
{
	fun_info="通过程序关键字结束程序："
	if [ -n "$1" ] ; then
		prog_name="$1"
	else
		echo $fun_info失败，程序关键字没有指定
		return 1
	fi

	if ! ckprogs "$prog_name" ; then
		echo $fun_info程序$prog_name未运行，不做处理
		return 0
	fi

	if [ -d "$prog_name" -a -f "$prog_name/bin/shutdown.sh" ]; then
		$prog_name/bin/shutdown.sh
		for i in `seq 1 10`
		do
			echo "waiting $prog_name shutdown..."
			sleep 1
			if ! ckprogs "$prog_name" ; then
				return;
			fi
		done
	fi

	echo "kill -9 $prog_name"
	keys=`ps -ef |grep "$prog_name" | grep -v "grep" | awk '{print $2}'`
	for key in ${keys}
do
	kill -9 $key
done
}

# 启动应用程序
function startprog()
{
	fun_info="通过程序关键字结束程序："
	if [ -n "$1" ] ; then
		prog_name="$1"
	else
		echo $fun_info失败，程序关键字没有指定
		return 1
	fi
	if ! ckprogs "$prog_name" ; then
		if [ -d "$prog_name" -a -f "$prog_name/bin/startup.sh" ]; then
			"$prog_name/bin/startup.sh"
		else
			$prog_name
		fi
	fi
}

# 替换zip中的文件
function replace_zip()
{
	if [ $# -ge 2 ] ; then
		zip -d $*
		zip -u $*
	fi
}

# 判断命令是否存在
function check_cmd_exists()
{
	fun_name="$1"
	if [ -n "$fun_name" ] ; then
		which "$fun_name" >/dev/null 2>&1 && return 0
		[ `type "$fun_name" >/dev/null 2>&1 | head -1 | grep "/" | wc -l` -eq 0 ] && return 1
		return 0
	else
		return 1
	fi
}

# 判断函数是否存在
function check_is_fun()
{
	fun_name="$1"
	if [ -n "$fun_name" ] ; then
		type "$fun_name" >/dev/null 2>&1 || return 1
		[ `type "$fun_name" >/dev/null 2>&1 | head -1 | grep "/" | wc -l` -gt 0 ] && return 1
		return 0
	else
		return 1
	fi
}

# 得到最终的程序文件
function get_final_cmd()
{
	fun_info="得到命令最终的程序文件："
	PRG="$1"
	if [ -z "$PRG" ] ; then
		#echo $fun_info失败，没有给定命令名
		return 1
	elif ! [ -f "$PRG" ] ; then
		PRG=`command -v "$PRG"`
	fi

	while [ -h "$PRG" ]; do
		ls=`ls -ld "$PRG"`
		link=`expr "$ls" : '.*-> \(.*\)$'`
		if expr "$link" : '/.*' > /dev/null; then
			PRG="$link"
		else
			PRG=`dirname "$PRG"`/"$link"
		fi  
	done
	echo $PRG
}

# 输出d_开头变量指定的目录，对应的配置文件为lc_path.config
function lcpwd()
{
	if [ -f $lc_config_path/lc_path.config ] ; then
		source $lc_config_path/lc_path.config
	fi
	if [ -n "`eval echo \\${d_$1}`" ] ; then
		eval "echo \${d_$1}"
	else
		#echo 进入指定目录：失败，没有找到$1对应的目录
		return 1
	fi
}

# 读取配置信息
function lcconf()
{
	if [ -f $lc_config_path/lc_conf.config ]; then
		source $lc_config_path/lc_conf.config
	fi
	if [ -n "`echo $1`" ] ; then
		echo $1
	else
		return 1
	fi
}

