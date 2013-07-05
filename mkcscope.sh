#!/bin/sh

## rebuild 모드로 동작한다.
## 기존에 존재하던 cscope.files 파일을 삭제한다.
[ "$1" = "-r" -o "$1" = "-R" ] && rm -f cscope.files > /dev/null


## cscope.files 파일이 존재하지 않으면 검색할 파일의 리스트를 새롭게
## cscope.files로 저장한다.
if [ ! -f cscope.files ]; then
    echo "Rebuild files list..."
    find $PWD \( -name .svn -o -name CVS \) -prune -o \
	        \( -name '*.CPP' -o -name '*.cpp' -o -name '*.C' -o -name '*.c' -o \
			-name '*.H' -o -name '*.h' -o -name '*.HPP' -o -name '*.hpp' -o \
			-name '*.s' -o -name '*.S' -o -name '*.incl' -o -name '*.java' \) \
        -print > cscope.files
fi


## 만약 cscope.files의 size가 0이라면 대상 파일이 존재하지 않는 것이다.
if [ ! -s cscope.files ];then
	echo "Target files are not exist..."
	rm -f cscope.files
	exit 1
fi


## 기존에 존재하던 cscope 파일과 tags 파일을 삭제한다.
if [ -f cscope.out -o -f tags ]; then
    rm -f cscope.out tags
    echo "Deleting a old database files is complete..."
fi


## file list로부터 cscope database 파일을 생성한다.
## cscope 파일을 일단 실행해 보고, cscope 파일이 존재하는지를 check한다.
cscope -h > /dev/null 2>&1
if [ $? -eq 0 ];then
	echo "Running cscope..."
	cscope -U -b -i cscope.files
else
	echo "[WARNING] cscope isn't exist."
fi


## file list로부터 ctags database 파일을 생성한다.
echo "Making tags..."
ctags -L cscope.files

echo "Making CSCOPE or CTAGS database files is complete..." 
