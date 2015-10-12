#!/usr/bin/env bash
base=`pwd`
echo "${base}"

cd java/{{prj._project_}}/model/src/script

for f in gen-*.sh; do
	sh $f
done

cd $base
cd android/{{prj._project_}}/app/src/script

for f in gen-*.sh; do
	sh $f
done

cd $base
cd ios/{{prj._project_}}/{{prj._project_}}/Script

for f in gen-*.sh; do
	sh $f
done