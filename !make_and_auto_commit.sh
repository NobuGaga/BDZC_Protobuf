#/bin/bash

pushd tools

echo "MAKE CLIENT PROTO FILES *.pb"
svn update "../../client/game/Assets/Resources/Dev/Pb/"

autogen.exe -protoexe protoc.exe -indir "../proto" -outdir "../pb" -outtype descriptor_set_out -outext bytes

cp "./../pb/*" "../../client/game/Assets/Resources/Dev/Pb/"
svn commit -m "commit protocol" "../../client/game/Assets/Resources/Dev/Pb/"

echo "MAKE SERVER PROTO FILES *.cc *.h"
svn update "../../server/code/server/GameCommon/protobuf"
autogen.exe -protoexe protoc.exe -indir "../proto" -outdir "../../server/code/server/GameCommon/protobuf" -outtype cpp_out -fullheader gen_protobuf.h -fullbody gen_protobuf.cc -pch_file stdafx.h
svn commit -m "commit protocol" "../../server/code/server/GameCommon/protobuf"

popd

echo "------------------------------------------"
echo "- ALL TASK DONE !!!                       "
echo "------------------------------------------"

#TortoiseProc.exe /command:commit /path:"./"
svn commit -m "commit protocol" ./
