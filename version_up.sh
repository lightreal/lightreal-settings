#!/bin/sh

echo ""

trim_string()
{
    trimmed=$1
    trimmed=${trimmed%% }
    trimmed=${trimmed## }

    echo "$trimmed"
}

PKGINFO_FILE="pkginfo.manifest"
CHANGELOG_FILE="changelog"

if [ "$1" != "" ] ; then
    cd $1

    CURRENT_BRANCH="`git branch -a | sed -n '/* .*/p' | sed 's/* //'`"

    GIT_ROOT="`git rev-parse --show-toplevel`"
    echo "** git root: $GIT_ROOT\n"
    cd "$GIT_ROOT"/package

    CURRENT_VERSION="`cat $PKGINFO_FILE | sed -n '/Version: /p' | sed 's/Version: //'`"
    echo "** $CURRENT_BRANCH's version is $CURRENT_VERSION\n"
    CURRENT_VERSION_MINOR=`expr "$CURRENT_VERSION" : '.*\(.\)'`

    TEMP=`expr "${#CURRENT_VERSION}" "-" 1`
    NEW_VERSION_MAJOR=`echo $CURRENT_VERSION | cut -b 1-$TEMP`
    NEW_VERSION_MINOR=`expr "$CURRENT_VERSION_MINOR" "+" 1`

    echo "** modified $PKGINFO_FILE"
    sed -i "1 s/"$CURRENT_VERSION"/"$NEW_VERSION_MAJOR""$NEW_VERSION_MINOR"/" $PKGINFO_FILE

    echo "** modified $CHANGELOG_FILE"
    NAME=`git config --global --get user.name`
    EMAIL=`git config --global --get user.email`
    DATE=`date --utc +"%Y-%m-%d"`
    sed -i 1i"== $NAME <$EMAIL> $DATE" $CHANGELOG_FILE

    DESC=`git log -n 1 | sed -n '5p' | cut -d ':' -f2`
    sed -i 1i"\-$DESC" $CHANGELOG_FILE

    NEW_VERSION=`sed -n '1p' $PKGINFO_FILE | cut -d ':' -f2`
    sed -i 1i"*$NEW_VERSION" $CHANGELOG_FILE

    read -p "Do you like to make a commit? [y/n]" answer
    if [ -z $answer ] || [ $answer = y ] || [ $answer = Y ] ; then
        git commit $CHANGELOG_FILE $PKGINFO_FILE -s -m "package: update version ($(trim_string $NEW_VERSION))"
    fi
else
    echo "Invalid path argument"
    return
fi
