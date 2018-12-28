rem https://stackoverflow.com/questions/2772456/string-replacement-in-batch-file

set arg1=%1
set Where=%arg1://192168.217.165=/home%
plink  ts.p@192.168.217.165 "cd %Where% && %2 %3 %4 %5 %6 %7 %8 %9"
