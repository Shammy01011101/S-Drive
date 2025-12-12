@echo off
title Reduce Windows.edb

sc config wsearch start=disabled
sc stop wsearch
esentutl.exe /d %ProgramData%\Microsoft\Search\Data\Applications\Windows\Windows.edb
sc config wsearch start=delayed-auto
sc start wsearch

echo All operations have been completed. This window will close in 40 seconds
PING -n 41 127.0.0.1>nul