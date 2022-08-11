#/bin/bash

pushd `dirname $0` >> /dev/null

pushd tools  >> /dev/null

echo "MAKE CLIENT PROTO FILES *.pb"
./autogen -protoexe ./protoc -indir ../proto -outdir ../pb -outtype descriptor_set_out -outext bytes
if [ ! $? -eq 0 ]; then
    echo "!!!proto file ERROR FOUND!!!"
    exit $?
fi

cp ./../pb/* ../../client/game/Assets/Resources/Dev/Pb/

echo "MAKE SERVER PROTO FILES *.cc *.h"
./autogen -protoexe ./protoc -indir ../proto -outdir ../../server/code/server/GameCommon/protobuf -outtype cpp_out -fullheader gen_protobuf.h -fullbody gen_protobuf.cc -pch_file stdafx.h

if [ ! $? -eq 0 ]; then
    echo "!!!proto file ERROR FOUND!!!"
    exit $?
fi

popd

# 由于SVN提交多个路径不能以"../"或"./"为开头，所以必须到上一级目录进行提交
pushd ../
svn commit -m "commit protobuf" server/code/server/GameCommon/protobuf/* client/game/Assets/Resources/Dev/Pb/* ./proto/*
#TortoiseProc.exe /command:commit /path:"server/code/server/GameCommon/protobuf/*client/game/Assets/Resources/Dev/Pb/*proto/" /logmsg:"commit protobuf" /closeonend:4
popd

echo "------------------------------------------"
echo "- ALL TASK DONE !!!                       "
echo "------------------------------------------"

popd
