#!/bin/bash
#
# set-target-distro.sh
#
#######################################################################
#
#    Copyright 2013 Michael Chaberski
#
#    Licensed under the Apache License, Version 2.0 (the "License");
#    you may not use this file except in compliance with the License.
#    You may obtain a copy of the License at
#
#        http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS,
#    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#    See the License for the specific language governing permissions and
#    limitations under the License.
#
#######################################################################
#~
#~ This script's purpose is to automate the changes to files 
#~ in debian/* required in order to build (e.g. using 
#~ pbuilder/pdebuild) for Ubuntu or for Debian distributions other
#~ than unstable. 
#~ 
#~ For now, we're only building for Ubuntu/precise, but supporting other
#~ distros should be pretty transparent. (Just add alternatives to the 
#~ case statement.
#~ 
#######################################################################

TARGET_DISTRO=$1

if [ -z "$TARGET_DISTRO" ] ; then
  echo "must specify target distro as argument 1" >&2
  exit 1
fi

DERIVATIVE_NAME=mikeppa

DERIVATIVE_VERSION=$2

if [ -z "$DERIVATIVE_VERSION" ] ; then
  DERIVATIVE_VERSION=1
fi

cp changelog changelog.orig
sed -i 's/nbis (\(.*\)) \(.*\);/nbis (\1'${DERIVATIVE_NAME}${DERIVATIVE_VERSION}') '${TARGET_DISTRO}';/' changelog

if [ $? -ne 0 ] ; then
  echo "modifying changelog failed" >&2
  exit 1
fi

diff changelog.orig changelog

STDS_VERSION="3.9.4"

case "$TARGET_DISTRO" in 
  precise )
    STDS_VERSION="3.9.3" ;;
  unstable )
    STDS_VERSION="3.9.4" ;;
esac

cp control control.orig
sed -i 's/^Standards-Version: \(.\+\)$/Standards-Version: '${STDS_VERSION}'/' control
diff control.orig control
