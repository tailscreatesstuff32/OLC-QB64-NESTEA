RANDOMIZE TIMER


TYPE RECT
    left AS LONG
    top AS LONG
    right AS LONG
    bottom AS LONG
END TYPE


DECLARE CUSTOMTYPE LIBRARY
    FUNCTION FindWindow& (BYVAL ClassName AS _OFFSET, WindowName$)
END DECLARE

DECLARE DYNAMIC LIBRARY "User32"
    FUNCTION GetWindowLongA& (BYVAL hwnd AS LONG, BYVAL nIndex AS LONG)
    FUNCTION SetWindowLongA& (BYVAL hwnd AS LONG, BYVAL nIndex AS LONG, BYVAL dwNewLong AS LONG)
    FUNCTION SetWindowPos& (BYVAL hwnd AS LONG, BYVAL hWndInsertAfter AS LONG, BYVAL x AS LONG, BYVAL y AS LONG, BYVAL cx AS LONG, BYVAL cy AS LONG, BYVAL wFlags AS LONG)
    SUB GetClientRect (BYVAL hWnd AS LONG, lpRect AS RECT)
END DECLARE

CONST GWL_STYLE = -16
CONST GWL_EXSTYLE = -20
CONST WS_BORDER = &H800000
CONST WS_VISIBLE = &H10000000
CONST WS_POPUP = &H80000000
CONST WS_THICKFRAME = &H40000
CONST WS_CAPTION = &HC00000
CONST WS_SYSMENU = &H80000
CONST WS_EX_APPWINDOW = &H40000
CONST WS_EX_WINDOWEDGE = &H100

hwnd& = _WINDOWHANDLE

winstyle& = GetWindowLongA&(hwnd&, GWL_STYLE)
a& = SetWindowLongA&(hwnd&, GWL_STYLE, WS_CAPTION OR WS_SYSMENU OR WS_VISIBLE OR WS_THICKFRAME)
a& = SetWindowLongA&(hwnd&, GWL_EXSTYLE, WS_EX_APPWINDOW OR WS_EX_WINDOWEDGE)
'a& = SetWindowPos&(hwnd&, 0, 0, 0, 0, 0, 39)
''//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
DIM SHARED mapAsm(65536) AS STRING

DIM SHARED keys(255) AS _UNSIGNED _BYTE
DIM SHARED displayarea AS LONG
DIM SHARED canvas AS LONG

DIM SHARED scale: scale = 2

$RESIZE:ON
'$CONSOLE
'$EXEICON
'ICON

':STRETCH

'canvas = _NEWIMAGE(500, 480, 32) '       how big your original game screen is
'displayarea = _NEWIMAGE(500 * scale, 480 * scale, 32) '  how big you want it to be at start





canvas = _NEWIMAGE(780, 480, 32) '       how big your original game screen is
displayarea = _NEWIMAGE(780 * scale, 480 * scale, 32) '  how big you want it to be at start

SCREEN displayarea '                     create a window with the initial size
_DEST canvas '                           tell QB64 we'll be drawing on the canvas&

'_TITLE "OLCNES-QB64"
_TITLE "NESTEA-QB64"


'_FONT _LOADFONT("C:\Windows\Fonts\Cour.ttf", 16, "MONOSPACE") 'select monospace font

_FONT 8

_CONSOLE ON
