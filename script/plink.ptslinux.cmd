rem https://stackoverflow.com/questions/2772456/string-replacement-in-batch-file

set arg1=%1

rem //PTSLINUX.MSHOME.NET/tsp/
if "%arg1:~2,19%" == "PTSLINUX.MSHOME.NET" (
	set Where=%arg1://PTSLINUX.MSHOME.NET/tsp/=%
	set Ip=ptslinux.mshome.net

) else if "%arg1:~2,15%" == "192.168.217.165" ( 
	set Where=%arg1://192.168.217.165/tsp/=%
	set Ip=192.168.217.165

) else (
	echo ¾îµð?
)

plink tsp@%Ip% "export LANG=C;cd %Where% && %2 %3 %4 %5 %6 %7 %8 %9"
