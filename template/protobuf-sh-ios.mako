#!/usr/bin/env bash

path=`pwd`
echo "${path}"

name="$1"
module="$2"
nameProto="$1Proto"
echo "${name}"

namelower=$(echo $name | awk '{print tolower($0)}')

_out="$path/../Protobuf/$module"
defile="$path/$nameProto.proto"

if [[ -d $_out ]]
then
  echo "exists"
else
  mkdir -p $_out
fi

protoc --proto_path=${path} --plugin=/usr/local/bin/protoc-gen-objc $defile --objc_out=${_out}