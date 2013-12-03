# Shares Erasor

A DOS Batch script to remove all shares and disable auto shares on Windows systems.
'Disable auto shares' task is to prevent the creation of administrative shares and 'Remove all shares' task is to delete hidden, administrative and classic shares via the Win32_Share class.

Tested on :
* Windows XP
* Windows Vista 32 bits & 64 bits
* Windows 7 32 bits & 64 bits
* Windows 8 32 bits & 64 bits.

## Requirements

* Administrative rights.
* [WSH (Windows Script Host)](http://support.microsoft.com/kb/232211) : Open a command prompt and type ``wscript`` to check.

## Installation

* Download and run ``shares-erasor.bat``.
* Task 1 : Disable auto shares. To [prevent the creation of administrative shares](http://support.microsoft.com/kb/288164/en).
* Task 2 : Remove all shares. To [delete hidden, administrative and classic shares](http://support.microsoft.com/kb/288164/en) via the [Win32_Share class](http://msdn.microsoft.com/en-us/library/aa394435%28v=vs.85%29.aspx).
* Task 3 : Run task 1 and 2.

## Screenshot

![](https://github.com/crazy-max/shares-erasor/blob/master/screenshot.png)

## License

LGPL. See ``LICENSE`` for more details.