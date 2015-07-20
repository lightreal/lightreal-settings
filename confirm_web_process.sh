#!/bin/sh

echo "=== confirm process ==="
echo ""

create_success_cnt=0
create_fail_cnt=0
create_total_cnt=0
build_success_cnt=0
build_fail_cnt=0
build_total_cnt=0
package_success_cnt=0
package_fail_cnt=0
package_total_cnt=0

init() {
	if [ -e "web_template_list.txt" ]
	then
		echo "web_template_list.txt is exists."
	else
		echo "web_template_list.txt doesn\'t exist"
		exit 1
	fi

	mkdir ./web
	mkdir ./web/mobile-2.3
	mkdir ./web/mobile-2.3.1
	mkdir ./web/mobile-2.4
}

create() {
	./tizen create web-project -p $platform -t $project -n $project_name -- ./web/$platform > /dev/null
	if [ -d "./web/$platform/$project_name" ]
	then
		echo "$platform-$project create success"
		create_success_cnt=`expr $create_success_cnt + 1`
	else
		echo "$platform-$project create fail"
		create_fail_cnt=`expr $create_fail_cnt + 1`
	fi
	create_total_cnt=`expr $create_total_cnt + 1`
}

build_check() {
	if [ -d "./web/$platform/$project_name/.buildResult" ]
	then
		build_success_cnt=`expr $build_success_cnt + 1`
		echo "$platform-$project_name build successed"
		package
	else
		build_fail_cnt=`expr $build_failed_cnt + 1`
		echo "$platform-$project_name build failed"
	fi
	build_total_cnt=`expr $build_total_cnt + 1`
}

build() {
	./tizen build-web -- ./web/$platform/$project_name > /dev/null
	build_check
}

package() {
	./tizen package -t wgt -s profileTest -- ./web/$platform/$project_name/.buildResult >	/dev/null
	if [ -e "./web/$platform/$project_name/.buildResult/$project_name.wgt" ]
	then
		echo "$platform-$project_name.wgt packaging is successed"
		package_success_cnt=`expr $package_success_cnt + 1`
	else
		echo "$platform-$project_name.wgt packaging is failed"
		package_fail_cnt=`expr $package_fail_cnt + 1`
	fi
	package_total_cnt=`expr $package_total_cnt + 1`
}


main() {
	while read line;
	do
		platform=`echo $line | awk '{print $1}'`
		project=`echo $line | awk '{print $2}'`
		project_name=`echo $line | awk '{print $3}'`
		if [ "$project_name" = "" ]
		then
			project_name=$project
		fi

		create
		build
	#	install
	#	uninstall
	done < web_template_list.txt
}

init
main

echo "==== create result ===="
echo "total	: $create_total_cnt"
echo "success	: $create_success_cnt"
echo "fail	: $create_fail_cnt"
echo "==== build result ===="
echo "total	: $build_total_cnt"
echo "success	: $build_success_cnt"
echo "fail	: $build_fail_cnt"
echo "==== package result ===="
echo "total	: $package_total_cnt"
echo "success	: $package_success_cnt"
echo "fail	: $package_fail_cnt"
