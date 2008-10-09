REM Run this script to update all the translations after modification of a
REM resource string in u_translation.pas and compilation of the program.

REM Update first the path to your Lazarus installation and run "make" in lazarus/tools


D:\appli\lazarus\pp\bin\i386-win32\rstconv -i units\win32\u_translation.rst -o ..\tools\data\language\skychart.po
D:\appli\lazarus\tools\updatepofiles ..\tools\data\language\skychart.po

D:\appli\lazarus\pp\bin\i386-win32\rstconv -i units\win32\u_help.rst -o ..\tools\data\language\help.po
D:\appli\lazarus\tools\updatepofiles ..\tools\data\language\help.po

pause
