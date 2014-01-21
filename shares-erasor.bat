@ECHO OFF
SETLOCAL EnableDelayedExpansion

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::                                                                                ::
::  Shares Erasor                                                                 ::
::                                                                                ::
::  A DOS Batch script to remove all shares and disable auto shares               ::
::  on Windows systems.                                                           ::
::  'Disable auto shares' task is to prevent the creation of administrative       ::
::  shares and 'Remove all shares' task is to delete hidden, administrative and   ::
::  classic shares via the Win32_Share class.                                     ::
::                                                                                ::
::  Copyright (C) 2013-2014 Cr@zy <webmaster@crazyws.fr>                          ::
::                                                                                ::
::  Shares Erasor is free software; you can redistribute it and/or modify         ::
::  it under the terms of the GNU Lesser General Public License as published by   ::
::  the Free Software Foundation, either version 3 of the License, or             ::
::  (at your option) any later version.                                           ::
::                                                                                ::
::  Shares Erasor is distributed in the hope that it will be useful,              ::
::  but WITHOUT ANY WARRANTY; without even the implied warranty of                ::
::  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the                  ::
::  GNU Lesser General Public License for more details.                           ::
::                                                                                ::
::  You should have received a copy of the GNU Lesser General Public License      ::
::  along with this program. If not, see http://www.gnu.org/licenses/.            ::
::                                                                                ::
::  Usage: shares-erasor.bat                                                      ::
::                                                                                ::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

TITLE Shares Erasor v1.0



::::::::::::::::::::::::::::::::::::::::
:MENU
::::::::::::::::::::::::::::::::::::::::
CLS
ECHO.
ECHO # Shares Erasor v1.0
ECHO.

:: Check for admin rights
net session >nul 2>&1
IF NOT %ERRORLEVEL% == 0 ECHO ERROR: This script must be run as administrator to work properly! && PAUSE && GOTO EXIT

:: Batch vars (no edits necessary)
SET disableSharesReg=%TEMP%\disableShares_%RANDOM%.reg
SET removeSharesVbs=%TEMP%\removeShares_%RANDOM%.vbs

ECHO 1 - Disable auto shares
ECHO 2 - Remove all shares
ECHO 3 - All
ECHO 9 - Exit
ECHO.
SET /P shareserasorTask=Choose a task: 
ECHO.

IF %shareserasorTask% == 1 GOTO DISABLE
IF %shareserasorTask% == 2 GOTO REMOVE
IF %shareserasorTask% == 3 GOTO DISABLE
IF %shareserasorTask% == 9 GOTO EXIT
GOTO MENU



::::::::::::::::::::::::::::::::::::::::
:DISABLE
::::::::::::::::::::::::::::::::::::::::

:: Disable auto shares
ECHO Disable auto shares...
ECHO REGEDIT4>%disableSharesReg%
ECHO [HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters]>>%disableSharesReg%
ECHO "AutoShareWks"=dword:00000000>>%disableSharesReg%
ECHO "AutoShareServer"=dword:00000000>>%disableSharesReg%
regedit /s %disableSharesReg%
DEL %disableSharesReg%
SET disableSharesReg=
ECHO - AutoShareWks dword key added (value=0)
ECHO - AutoShareServer dword key added (value=0)
IF %shareserasorTask% == 1 ECHO. && PAUSE && GOTO MENU
ECHO.



::::::::::::::::::::::::::::::::::::::::
:REMOVE
::::::::::::::::::::::::::::::::::::::::

:: Remove all shares
ECHO Remove all shares...
ECHO strComputer = "." >%removeSharesVbs%
ECHO. >>%removeSharesVbs%
ECHO Set objWMIService = GetObject("winmgmts:" _ >>%removeSharesVbs%
ECHO    ^& "{impersonationLevel=impersonate}!\\" _ >>%removeSharesVbs%
ECHO    ^& strComputer ^& "\root\cimv2") >>%removeSharesVbs%
ECHO. >>%removeSharesVbs%
ECHO On Error Resume Next >>%removeSharesVbs%
ECHO Set colShares = objWMIService.ExecQuery( _ >>%removeSharesVbs%
ECHO    "Select * from Win32_Share") >>%removeSharesVbs%
ECHO. >>%removeSharesVbs%
ECHO If colShares.Count ^<^> 0 Then >>%removeSharesVbs%
ECHO    For each objShare in colShares >>%removeSharesVbs%
ECHO       WScript.StdOut.Write "- " ^& objShare.Name >>%removeSharesVbs%
ECHO       If objShare.Path ^<^> "" Then >>%removeSharesVbs%
ECHO          WScript.StdOut.Write " (" ^& objShare.Path ^& ")" >>%removeSharesVbs%
ECHO       End If >>%removeSharesVbs%
ECHO       WScript.StdOut.Write " removed" >>%removeSharesVbs%
ECHO       WScript.StdOut.WriteBlankLines(1) >>%removeSharesVbs%
ECHO       objShare.Delete >>%removeSharesVbs%
ECHO    Next >>%removeSharesVbs%
ECHO    On Error Goto 0 >>%removeSharesVbs%
ECHO Else >>%removeSharesVbs%
ECHO    WScript.StdOut.Write "N/A" >>%removeSharesVbs%
ECHO End If >>%removeSharesVbs%

FOR /F "delims=" %%a in ('wscript.exe %removeSharesVbs%') do (
	ECHO %%a
)



::::::::::::::::::::::::::::::::::::::::
:EOF
::::::::::::::::::::::::::::::::::::::::

ECHO.
PAUSE
GOTO MENU



::::::::::::::::::::::::::::::::::::::::
:EXIT
::::::::::::::::::::::::::::::::::::::::

ENDLOCAL