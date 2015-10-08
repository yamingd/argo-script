path=`pwd`
echo "${path}"

name="$1"
module="$2"
nameProto="$1Proto"
echo "${name}"

namelower=$(echo $name | awk '{print tolower($0)}')

cpp_out="$path/../main/ios/protobuf/$module"
java_out="$path/../main/java"
defile="$path/$nameProto.proto"

mkdir -p $cpp_out

protoc --proto_path=${path} --cpp_out=${cpp_out} --java_out=${java_out} $defile