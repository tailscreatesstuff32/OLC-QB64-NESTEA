RANDOMIZE TIMER


TYPE RECT
    left AS LONG
    top AS LONG
    right AS LONG
    bottom AS LONG
END TYPE

TYPE MENUITEMINFO
    AS _UNSIGNED LONG cbSize, fMask, fType, fState, wID
    $IF 64BIT THEN
        AS STRING * 4 padding
    $END IF
    AS _OFFSET hSubMenu, hbmpChecked, hbmpUnchecked, dwItemData, dwTypeData
    AS _UNSIGNED LONG cch
    $IF 64BIT THEN
        AS STRING * 4 padding2
    $END IF
    AS _OFFSET hbmpItem
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

'DECLARE CUSTOMTYPE LIBRARY
'    FUNCTION CreateMenu%& ()
'    FUNCTION SetMenu%% (BYVAL hWnd AS _OFFSET, BYVAL hMenu AS _OFFSET)
'    FUNCTION CreatePopupMenu%& ()
'    FUNCTION InsertMenuItem%% (BYVAL hMenu AS _OFFSET, BYVAL item AS _UNSIGNED LONG, BYVAL fByPosition AS LONG, BYVAL lpmi AS _OFFSET)
'    FUNCTION GetMenuItemCount& (BYVAL hMenu AS _OFFSET)
'    SUB GetMenuItemInfo (BYVAL hMenu AS _OFFSET, BYVAL item AS _UNSIGNED LONG, BYVAL fByPosition AS LONG, BYVAL lpmii AS _OFFSET)
'END DECLARE



'DECLARE CUSTOMTYPE LIBRARY
'    FUNCTION CreateMenu%& ()
'    FUNCTION CreatePopupMenu%& ()
'    SUB AppendMenu (BYVAL hMenu AS _OFFSET, BYVAL uFlags AS _UNSIGNED LONG, BYVAL uIDNewItem AS _OFFSET, lpNewItem AS STRING)
'    FUNCTION SetMenu%% (BYVAL hWnd AS _OFFSET, BYVAL hMenu AS _OFFSET)
'    SUB SetMenu (BYVAL hWnd AS _OFFSET, BYVAL hMenu AS _OFFSET)
'    FUNCTION InsertMenuItem%% (BYVAL hMenu AS _OFFSET, BYVAL item AS _UNSIGNED LONG, BYVAL fByPosition AS LONG, BYVAL lpmi AS _OFFSET)
'    SUB InsertMenuItem (BYVAL hMenu AS _OFFSET, BYVAL item AS _UNSIGNED LONG, BYVAL fByPosition AS LONG, BYVAL lpmi AS _OFFSET)
'    FUNCTION GetMenuItemCount& (BYVAL hMenu AS _OFFSET)
'    SUB GetMenuItemInfo (BYVAL hMenu AS _OFFSET, BYVAL item AS _UNSIGNED LONG, BYVAL fByPosition AS LONG, BYVAL lpmii AS _OFFSET)
'END DECLARE


DECLARE CUSTOMTYPE LIBRARY
    FUNCTION CreateMenu%& ()
    FUNCTION CreatePopupMenu%& ()
    SUB AppendMenu (BYVAL hMenu AS _OFFSET, BYVAL uFlags AS _UNSIGNED LONG, BYVAL uIDNewItem AS _OFFSET, lpNewItem AS STRING)
    FUNCTION SetMenu%% (BYVAL hWnd AS _OFFSET, BYVAL hMenu AS _OFFSET)
    SUB SetMenu (BYVAL hWnd AS _OFFSET, BYVAL hMenu AS _OFFSET)
    FUNCTION InsertMenuItem%% (BYVAL hMenu AS _OFFSET, BYVAL item AS _UNSIGNED LONG, BYVAL fByPosition AS LONG, BYVAL lpmi AS _OFFSET)
    SUB InsertMenuItem (BYVAL hMenu AS _OFFSET, BYVAL item AS _UNSIGNED LONG, BYVAL fByPosition AS LONG, BYVAL lpmi AS _OFFSET)
    FUNCTION GetMenuItemCount& (BYVAL hMenu AS _OFFSET)
    SUB GetMenuItemInfo (BYVAL hMenu AS _OFFSET, BYVAL item AS _UNSIGNED LONG, BYVAL fByPosition AS LONG, BYVAL lpmii AS _OFFSET)
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
CONST WS_MINIMIZE_BUTTON = &H00020000
CONST WS_MAXIMIZE_BUTTON = &H00010000
hwnd1& = _WINDOWHANDLE

winstyle& = GetWindowLongA&(hwnd1&, GWL_STYLE)
a& = SetWindowLongA&(hwnd1&, GWL_STYLE, WS_CAPTION OR WS_SYSMENU OR WS_VISIBLE OR WS_THICKFRAME OR WS_MINIMIZE_BUTTON)
a& = SetWindowLongA&(hwnd1&, GWL_EXSTYLE, WS_EX_APPWINDOW OR WS_EX_WINDOWEDGE)
'a& = SetWindowPos&(hwnd&, 0, 0, 0, 0, 0, 39)
''//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
CONST MIIM_STATE = &H1
CONST MIIM_ID = &H2
CONST MIIM_TYPE = &H10
CONST MFT_SEPARATOR = &H800
CONST MFT_STRING = &H0
CONST MFS_ENABLED = &H0
CONST MFS_CHECKED = &H8
CONST MF_POPUP = &H00000010

CONST MIIM_SUBMENU = &H00000004
CONST MFS_GRAYED = &H00000003

'CONST NES_LOAD_ROM = 1
'CONST NES_RECENT_ROMS = 3
'CONST APP_EXIT = 2


'CONST CONT_SETUP_KEYS = 4
'CONST NES_RECENT_ROMS = 3
'CONST ABOUT_OLCNESTEA = 5
'CONST EMPTY_LIST = 6

CONST NES_LOAD_ROM = 1

CONST CONT_SETUP_KEYS = 4
CONST NES_RECENT_ROMS = 3
CONST ABOUT_OLCNESTEA = 5
CONST EMPTY_LIST = 6
CONST APP_EXIT = 2




DIM SHARED AS LONG PreviousState, newState

''/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
DIM SHARED mapAsm(65536) AS STRING

DIM SHARED keys(255) AS _UNSIGNED _BYTE
DIM SHARED displayarea AS LONG
DIM SHARED canvas AS LONG

DIM SHARED scale: scale = 1.5

$RESIZE:ON
'$CONSOLE
'$EXEICON
'ICON

':STRETCH

'canvas = _NEWIMAGE(500, 480, 32) '       how big your original game screen is
'displayarea = _NEWIMAGE(500 * scale, 480 * scale, 32) '  how big you want it to be at start





canvas = _NEWIMAGE(780, 480, 32) '       how big your original game screen is
displayarea = _NEWIMAGE(780 * scale, 480 * scale + 25, 32) '  how big you want it to be at start

SCREEN displayarea '                     create a window with the initial size
_DEST canvas '                           tell QB64 we'll be drawing on the canvas&

'_TITLE "OLCNES-QB64"
_TITLE "OLC-NESTEA-QB64"


'_FONT _LOADFONT("C:\Windows\Fonts\Cour.ttf", 16, "MONOSPACE") 'select monospace font

_FONT 8
DIM SHARED AS _OFFSET hMenu
DIM SHARED AS MENUITEMINFO MenuItem, Blank: Blank.cbSize = LEN(Blank)



_CONSOLE ON





