
mkdir ..\bin
pushd	..\bin
	del /q *.*
popd

py freqTableGen.py -f 442 -o nsd\
rem --- nsd.lib ---
pushd nsd
	call _make
	copy *.lib ..\..\lib\
popd

call "C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\Common7\Tools\VsDevCmd.bat"

cd %~dp0
MSBuild "nsc\nsc.sln" /t:clean;rebuild /p:Configuration=Release;Platform="x86"
if %ERRORLEVEL% neq 0 (
	echo ErrorLevel:%ERRORLEVEL%
	echo ƒrƒ‹ƒhŽ¸”s
)



rem --- nsc.exe ---
pushd nsc\release
	copy *.exe ..\..\..\bin\
popd

rem --- rom.bin ---
pushd rom
	call _make
	copy *.bin ..\..\bin\
popd

rem --- nsdl.chm ---
pushd help
	copy *.chm ..\..\doc\
popd
