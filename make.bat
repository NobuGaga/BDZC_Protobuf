@ECHO OFF

PUSHD tools

ECHO MAKE CLIENT PROTO FILES *.pb
autogen.exe -protoexe protoc.exe -indir ..\proto -outdir ..\pb -outtype descriptor_set_out -outext bytes
IF NOT %ERRORLEVEL% == 0 ( ECHO !!!proto file ERROR FOUND!!! && GOTO EOF )

COPY .\..\pb\* ..\..\client\game\Assets\Resources\Dev\Pb\

ECHO MAKE SERVER PROTO FILES *.cc *.h
autogen.exe -protoexe protoc.exe -indir ..\proto -outdir ..\..\server\code\server\GameCommon\protobuf -outtype cpp_out -fullheader gen_protobuf.h -fullbody gen_protobuf.cc -pch_file stdafx.h

IF NOT %ERRORLEVEL% == 0 ( ECHO !!!proto file ERROR FOUND!!! && GOTO EOF )

POPD

:: 由于SVN提交多个路径不能以"..\"或".\"为开头，所以必须到上一级目录进行提交
PUSHD ..\
TortoiseProc.exe /command:commit /path:"server\code\server\GameCommon\protobuf\*client\game\Assets\Resources\Dev\Pb\*proto\" /logmsg:"commit protobuf" /closeonend:4
POPD

ECHO "------------------------------------------"
ECHO "- ALL TASK DONE !!!                       "
ECHO "------------------------------------------"

:EOF