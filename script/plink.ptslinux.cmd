rem https://stackoverflow.com/questions/2772456/string-replacement-in-batch-file

set arg1=%1
set Where=%arg1://PTSLINUX.MSHOME.NET=/home%
plink  tsp@ptslinux.mshome.net "cd %Where% && %2 %3 %4 %5 %6 %7 %8 %9"
