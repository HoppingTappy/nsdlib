
rem --- nsd.lib ---
pushd nsd
	call _make
	copy *.lib ..\..\lib\
popd

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
