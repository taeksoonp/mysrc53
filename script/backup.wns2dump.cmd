rem ng: cd d:\Backup\backup\
set Back_dir=d:\Backup\backup\

pscp -P 22000 tsp@mycam.to:/usr/local/wrs/dbbackup/latest.sql %Back_dir%
copy %Back_dir%latest.sql \\192.168.217.119\������\08_�ӽ�\wns2backup\
explorer %Back_dir%

time /t
echo -��--------------------------------------------------------