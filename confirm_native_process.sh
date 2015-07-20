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
	if [ -e "native_template_list.txt" ]
	then
		echo "native_template_list.txt is exists."
	else
		echo "native_template_list.txt doesn\'t exist"
		exit 1
	fi

	mkdir ./native
	mkdir ./native/mobile-2.3
	mkdir ./native/mobile-2.3.1
	mkdir ./native/mobile-2.4
}

create() {
	./tizen create native-project -p $platform -t $project -n $project_name -- ./native/$platform > /dev/null
	if [ -d "./native/$platform/$project_name" ]
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
	if [ -e "./native/$platform/$project_name/$debug/$project_name" ]
	then
		build_success_cnt=`expr $build_success_cnt + 1`
		ls -al ./native/$platform/$project_name/$debug/$project_name
		package
	elif [ -e "./native/$platform/$project_name/$debug/lib$project_name.so" ]
	then
		build_success_cnt=`expr $build_success_cnt + 1`
		ls -al ./native/$platform/$project_name/$debug/lib$project_name.so
	elif [ -e "./native/$platform/$project_name/$debug/lib$project_name.a" ]
	then
		build_success_cnt=`expr $build_success_cnt + 1`
		ls -al ./native/$platform/$project_name/$debug/lib$project_name.a
	else
		build_fail_cnt=`expr $build_failed_cnt + 1`
		echo "$platform-$project_name build failed"
	fi
	rm -rf ./native/$platform/$project_name/$debug
	build_total_cnt=`expr $build_total_cnt + 1`
}

build() {
	debug="Debug"
	./tizen build-native -c llvm -C $debug -a x86 --	./native/$platform/$project_name > /dev/null
	build_check
	./tizen build-native -c gcc -C $debug -a x86 -- ./native/$platform/$project_name > /dev/null
	build_check
	./tizen build-native -c llvm -C $debug -a arm -- ./native/$platform/$project_name >	/dev/null
	build_check
	./tizen build-native -c gcc -C $debug -a arm -- ./native/$platform/$project_name > /dev/null
	build_check

	debug="Release"
	./tizen build-native -c llvm -C $debug -a x86 -- ./native/$platform/$project_name > /dev/null
	build_check
	./tizen build-native -c gcc -C $debug -a x86 -- ./native/$platform/$project_name > /dev/null
	build_check
	./tizen build-native -c llvm -C $debug -a arm -- ./native/$platform/$project_name	> /dev/null
	build_check
	./tizen	build-native -c	gcc -C $debug -a arm -- ./native/$platform/$project_name > /dev/null
	build_check
}

package() {
	./tizen package -t tpk -s profileTest -- ./native/$platform/$project_name/$debug >	/dev/null
	if [ -e "./native/$platform/$project_name/$debug/org.tizen.$project_name-1.0.0-i386.tpk" ]
	then
		echo "$platform-org.tizen.$project_name-1.0.0-i386.tpk packaging is successed"
		package_success_cnt=`expr $package_success_cnt + 1`
	else
		echo "$platform-org.tizen.$project_name-1.0.0-i386.tpk packaging is failed"
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
	done < native_template_list.txt
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
