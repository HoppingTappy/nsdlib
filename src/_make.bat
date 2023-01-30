@echo off

SET PATH_BACK=%PATH%

rem --- nsd.lib ---
py freqTableGen.py -f 442 -o nsd\
cd nsd
	call _make
	copy *.lib ..\..\lib\
cd ..
rem --- nsc.exe ---
rem call "C:\Program Files (x86)\Microsoft Visual Studio .NET 2003\Common7\Tools\vsvars32.bat"
rem devenv nsc.sln /build Release
rem pushd nsc\release
rem 	copy *.exe ..\..\..\bin\
rem popd
rem SET PATH=%PATH_BACK%

rem --- nsc64.exe ---
call "C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvars64.bat"
pushd nsc64\
	MSBuild -t:Build -p:Configuration=Release;Platform="x64"
	cd x64\Release
	copy *.exe ..\..\..\..\bin\
popd
SET PATH=%PATH_BACK%

rem --- rom.bin ---
cd rom
	call _make
	copy *.bin ..\..\bin\
cd ..
rem --- nsdl.chm ---
pushd help
	copy *.chm ..\..\doc\
popd
