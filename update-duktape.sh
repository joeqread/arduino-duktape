#!/bin/sh
pwd=`pwd`

[ ! -d "${pwd}/dep" ] && mkdir ${pwd}/dep
cd dep

if [ -d "duktape" ]; then
  cd duktape
  git checkout master
  git reset --hard
  git fetch --prune
  git pull
else
  git clone --recurse-submodules https://github.com/svaarala/duktape.git duktape || exit 10;
  cd duktape
fi

cd src-tools

out=`make`
if [[ $? != 0 ]]; then
  echo "Error running make: ${out}"
  exit 1;
fi

out=`node duktool.js configure --source-directory ../src-input --output-directory ../../../src`
if [[ $? != 0 ]]; then
  echo "Error running configure: ${out}"
  exit 1;
fi

cd $pwd
cd -R dep/duktape/extras ./extras
echo "Done!"

