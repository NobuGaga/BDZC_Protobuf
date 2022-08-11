@ECHO OFF

PUSHD tools

ECHO MAKE CLIENT PROTO FILES *.pb
svn update ..\..\client\game\Assets\Resources\Dev\Pb\

autogen.exe -protoexe protoc.exe -indir ..\proto -outdir ..\pb -outtype descriptor_set_out -outext bytes

COPY .\..\pb\* ..\..\client\game\Assets\Resources\Dev\Pb\
svn commit -m "commit protocol" ..\..\client\game\Assets\Resources\Dev\Pb\

ECHO MAKE SERVER PROTO FILES *.cc *.h
svn update ..\..\server\code\server\GameCommon\protobuf
autogen.exe -protoexe protoc.exe -indir ..\proto -outdir ..\..\server\code\server\GameCommon\protobuf -outtype cpp_out -fullheader gen_protobuf.h -fullbody gen_protobuf.cc -pch_file stdafx.h
svn commit -m "commit protocol" ..\..\server\code\server\GameCommon\protobuf

POPD

ECHO "------------------------------------------"
ECHO "- ALL TASK DONE !!!                       "
ECHO "------------------------------------------"

::TortoiseProc.exe /command:commit /path:"./"
svn commit -m "commit protocol" ./
