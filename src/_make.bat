@echo off

SET PATH_BACK=%PATH%

rem --- nsd.lib ---
py freqTableGen.py -f 442 -o nsd\
pushd nsd
	call _make
	copy *.lib ..\..\lib\
popd
rem --- nsc.exe ---
rem call "C:\Program Files (x86)\Microsoft Visual Studio .NET 2003\Common7\Tools\vsvars32.bat"
rem devenv nsc.sln /build Release
pushd nsc\release
	copy *.exe ..\..\..\bin\
popd
SET PATH=%PATH_BACK%

rem --- nsc64.exe ---
call "C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvars64.bat"
pushd nsc64\
	MSBuild -t:Build -p:Configuration=Release;Platform="x64"
	cd x64\Release
	copy *.exe ..\..\..\..\bin\
popd
SET PATH=%PATH_BACK%

rem --- rom.bin ---
pushd rom
	call _make
	copy *.bin ..\..\bin\
popd
rem --- nsdl.chm ---
pushd help
	copy *.chm ..\..\doc\
popd
