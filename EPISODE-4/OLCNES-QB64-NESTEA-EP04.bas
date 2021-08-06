'OPTION _EXPLICIT

$LET INCLUDED = 1

$EXEICON:'qb64.ico'
_ICON

'$CHECKING:OFF
'$INCLUDE: 'init.bi'

'the NES
'$INCLUDE: 'bus.bi'

'$INCLUDE: 'ComDlgFileName.bi '


DIM SHARED AS LONG count
DIM SHARED AS _OFFSET hFileSubmenu, hRecentSubmenu, hContSubmenu, hAboutSubmenu, hViewSubmenu, hDebugSubmenu


'DIM SHARED winrect AS RECT
DIM SHARED nestea_logo AS _UNSIGNED LONG
DIM SHARED col AS _UNSIGNED LONG
DIM SHARED bEmulationrun AS _BYTE
DIM SHARED step_cont AS _BYTE
DIM SHARED origtitle AS STRING
DIM SHARED nselectedpalette AS _UNSIGNED _BYTE

DIM SHARED ff%
DIM SHARED fps%
DIM SHARED start!


DIM SHARED sprPatternTable(1) AS _UNSIGNED LONG
sprPatternTable(0) = _NEWIMAGE(128, 128, 32)
_DEST sprPatternTable(0)
CLS
sprPatternTable(1) = _NEWIMAGE(128, 128, 32)
_DEST sprPatternTable(1)
CLS

bEmulationrun = 0

img~& = _LOADIMAGE("NESTEA_LOGO.png", 32)
_SOURCE img~&

nestea_logo = _NEWIMAGE(1000, 1000, 32)

_DEST nes_scrn
CLS

_DEST nestea_logo

_DONTBLEND
FOR y = 0 TO 1000 - 1
    FOR x = 0 TO 1000 - 1
        col~& = POINT(x, y)

        alpha~& = _ALPHA(col~&) / 2
        red~& = _RED(col~&)
        green~& = _GREEN(col~&)
        blue~& = _BLUE(col~&)

        col~& = _RGB32(red~&, green~&, blue~&, alpha~&)

        PSET (x, y), col~&



    NEXT x
NEXT y

_BLEND

_FREEIMAGE img~&

_DEST canvas
_SOURCE displayarea


DIM SHARED btn1 AS MENUITEMINFO

''///////////////////////////////////////////////////////////////////////////////////////////////////
SetMenu _WINDOWHANDLE, hMenu




hMenu = CreateMenu

DIM AS LONG prev, new


nes_init

main
'END

'NES main
SUB main ()
    origtitle = _TITLE$

    DIM AS LONG Prev, new

    DO
        _DEST canvas
        i% = _MOUSEINPUT


        _LIMIT 60 'maybe have a better timer...
        frames_per_sec

        'Prev = new
        'GetMenuItemInfo hSubMenu, 0, 1, _OFFSET(btn1)
        'new = (btn1.fState <> 128)
        'IF (Prev = 0 AND new <> 0) THEN BEEP


        'player 1 controller
        controller(0) = &H00
        IF keyheld(ASC("x")) THEN controller(0) = controller(0) OR &H80 ELSE controller(0) = controller(0) OR &H00
        IF keyheld(ASC("z")) THEN controller(0) = controller(0) OR &H40 ELSE controller(0) = controller(0) OR &H00
        IF keyheld(ASC("a")) THEN controller(0) = controller(0) OR &H20 ELSE controller(0) = controller(0) OR &H00
        IF keyheld(ASC("s")) THEN controller(0) = controller(0) OR &H10 ELSE controller(0) = controller(0) OR &H00
        IF keyheld(72) THEN controller(0) = controller(0) OR &H08 ELSE controller(0) = controller(0) OR &H00
        IF keyheld(80) THEN controller(0) = controller(0) OR &H04 ELSE controller(0) = controller(0) OR &H00
        IF keyheld(75) THEN controller(0) = controller(0) OR &H02 ELSE controller(0) = controller(0) OR &H00
        IF keyheld(77) THEN controller(0) = controller(0) OR &H01 ELSE controller(0) = controller(0) OR &H00


        'TODO add player 2 controller


        IF keypress(ASC(" ")) THEN bEmulationrun = NOT bEmulationrun 'run emulation
        IF keypress(ASC("x")) THEN step_cont = NOT step_cont 'run emulation
        IF keypress(ASC("r")) THEN reset_NES 'reset the NES
        IF keypress(ASC("p")) THEN nselectedpalette = nselectedpalette + 1 AND &H07& 'select palette


        IF bEmulationrun THEN 'wip for now.... slowish

            DO

                clock_NES

            LOOP WHILE NOT framecomplete
            framecomplete = 0

        ELSEIF step_cont THEN

            DO

                clock_NES

            LOOP WHILE NOT complete


            DO

                clock_NES

            LOOP WHILE complete


        ELSE

            IF keypress(ASC("r")) THEN
                reset_NES

            END IF


            'run 1 whole frame
            IF keypress(ASC("f")) THEN

                DO

                    clock_NES

                LOOP WHILE NOT framecomplete


                'DO

                '    clock_NES

                'LOOP WHILE NOT complete
                framecomplete = 0
            END IF


            'run code step by step
            IF keypress(ASC("c")) THEN

                DO

                    clock_NES

                LOOP WHILE NOT complete


                DO

                    clock_NES

                LOOP WHILE complete

            END IF



        END IF

        episode4_UI


        _PUTIMAGE (516, 348)-(516 + 127, 348 + 127), GetPatternTable(0, nselectedpalette), canvas
        _PUTIMAGE (648, 348)-(648 + 127, 348 + 127), GetPatternTable(1, nselectedpalette), canvas

        'IF ImageValid = -1 THEN
        '    WHILE _SNDRAWLEN < 0.1 AND ImageValid = -1
        '        _SNDRAW 0.4 * (RND * 1 - 0.5)
        '    WEND
        'END IF


        IF _RESIZE THEN
            oldimage& = displayarea
            displayarea = _NEWIMAGE(_RESIZEWIDTH, _RESIZEHEIGHT, 32)
            SCREEN displayarea
            _FREEIMAGE oldimage&
        END IF

        _PUTIMAGE (0, 25)-(_RESIZEWIDTH, _RESIZEHEIGHT), canvas, displayarea ' stretch canvas to fill the screen;


        _DISPLAY

    LOOP UNTIL INKEY$ = CHR$(27) '  CHR$(ASC("q"))


    cleanup

END SUB


SUB nes_init ()

    DIM AS STRING cart

    app_menu (_WINDOWHANDLE)

    _PUTIMAGE ((_WIDTH(displayarea) / 2) - 400, 0)-((_WIDTH(displayarea) / 2) + 400, _HEIGHT(displayarea)), nestea_logo, 0
    '  _DISPLAY

    cart = ComDlgFileName("Open Source File", _CWD$, "*.NES|*.NES", OFN_FORCESHOWHIDDEN)


    insert_cartridge cart, 1
    _DEST _CONSOLE

    IF cart_ImageValid THEN
        PRINT "Success!"
    ELSE
        PRINT "failed!"
        cleanup
        END
    END IF


    ' InsertCartridge 0 'might not need

    disassemble mapAsm(), &H0000, &HFFFF~%
    reset_NES




END SUB

SUB app_menu (hwnd AS _OFFSET)

    'hFileSubmenu = CreatePopupMenu
    'hSubMenu = CreatePopupMenu
    ' hMenu = CreateMenu

    hFileSubmenu = CreateMenu
    hRecentSubmenu = CreateMenu
    hContSubmenu = CreateMenu
    hAboutSubmenu = CreateMenu
    hViewSubmenu = CreateMenu
    hDebugSubmenu = CreateMenu



    'file menu//////////////////////////////////////////////////////////////////////////////////////////////
    count = GetMenuItemCount(hMenu): PRINT count
    MenuItem.cbSize = LEN(MenuItem)
    MenuItem.fMask = MIIM_ID OR MIIM_TYPE
    MenuItem.fType = MFT_SEPARATOR
    MenuItem.wID = count

    IF InsertMenuItem(hMenu, count, 1, _OFFSET(MenuItem)) THEN ELSE END

    count = GetMenuItemCount(hFileSubmenu)
    MenuItem.cbSize = LEN(MenuItem)
    MenuItem.fMask = MIIM_STATE OR MIIM_ID OR MIIM_TYPE
    MenuItem.fType = MFT_STRING
    DIM AS STRING TypeData: TypeData = "Load Rom" + CHR$(0)
    MenuItem.dwTypeData = _OFFSET(TypeData)
    MenuItem.cch = LEN(MenuItem.dwTypeData)
    MenuItem.wID = NES_LOAD_ROM

    IF InsertMenuItem(hFileSubmenu, count, 1, _OFFSET(MenuItem)) THEN PRINT ELSE END

    count = GetMenuItemCount(hFileSubmenu)
    MenuItem.cbSize = LEN(MenuItem)
    MenuItem.fMask = MIIM_STATE OR MIIM_ID OR MIIM_TYPE
    MenuItem.fState = MFS_GRAYED
    MenuItem.fType = MFT_STRING
    TypeData = "Empty" + CHR$(0)
    MenuItem.dwTypeData = _OFFSET(TypeData)
    MenuItem.cch = LEN(MenuItem.dwTypeData)
    MenuItem.wID = EMPTY_LIST

    IF InsertMenuItem(hRecentSubmenu, count, 1, _OFFSET(MenuItem)) THEN ELSE END

    count = GetMenuItemCount(hFileSubmenu)
    MenuItem.cbSize = LEN(MenuItem)
    MenuItem.fMask = MIIM_ID OR MIIM_TYPE OR MIIM_SUBMENU
    MenuItem.fType = MFT_STRING
    TypeData = "Recent Roms" + CHR$(0)
    MenuItem.dwTypeData = _OFFSET(TypeData)
    MenuItem.hSubMenu = hRecentSubmenu
    MenuItem.cch = LEN(MenuItem.dwTypeData)
    MenuItem.wID = NES_RECENT_ROMS

    IF InsertMenuItem(hFileSubmenu, count, 1, _OFFSET(MenuItem)) THEN ELSE END

    count = GetMenuItemCount(hFileSubmenu)
    MenuItem.cbSize = LEN(MenuItem)
    MenuItem.fMask = MIIM_STATE OR MIIM_ID OR MIIM_TYPE
    MenuItem.fState = MFS_ENABLED
    MenuItem.fType = MFT_STRING
    TypeData = "Exit" + CHR$(0)
    MenuItem.dwTypeData = _OFFSET(TypeData)
    MenuItem.cch = LEN(MenuItem.dwTypeData)
    MenuItem.wID = 2

    IF InsertMenuItem(hFileSubmenu, count, 1, _OFFSET(MenuItem)) THEN ELSE END

    count = GetMenuItemCount(hFileSubmenu)
    MenuItem.cbSize = LEN(MenuItem)
    MenuItem.fMask = MIIM_ID OR MIIM_TYPE OR MIIM_SUBMENU
    MenuItem.fType = MFT_STRING
    TypeData = "File" + CHR$(0)
    MenuItem.dwTypeData = _OFFSET(TypeData)
    MenuItem.cch = LEN(MenuItem.dwTypeData)
    MenuItem.hSubMenu = hFileSubmenu
    MenuItem.wID = count

    IF InsertMenuItem(hMenu, count, 1, _OFFSET(MenuItem)) THEN ELSE END


    '///////////////////////////////////////////////////////////////////////////////////////////////////

    'view menu////////////////////////////////////////////////////////////////////////////////////

    count = GetMenuItemCount(hViewSubmenu)
    MenuItem.cbSize = LEN(MenuItem)
    MenuItem.fMask = MIIM_STATE OR MIIM_ID OR MIIM_TYPE
    MenuItem.fState = MFS_GRAYED
    MenuItem.fType = MFT_STRING
    TypeData = "Empty" + CHR$(0)
    MenuItem.dwTypeData = _OFFSET(TypeData)
    MenuItem.cch = LEN(MenuItem.dwTypeData)
    MenuItem.wID = EMPTY_LIST


    IF InsertMenuItem(hViewSubmenu, count, 1, _OFFSET(MenuItem)) THEN ELSE END



    count = GetMenuItemCount(hMenu)
    MenuItem.cbSize = LEN(MenuItem)
    MenuItem.fMask = MIIM_ID OR MIIM_TYPE OR MIIM_SUBMENU
    MenuItem.fType = MFT_STRING
    TypeData = "View" + CHR$(0)
    MenuItem.dwTypeData = _OFFSET(TypeData)
    MenuItem.cch = LEN(MenuItem.dwTypeData)
    MenuItem.hSubMenu = hViewSubmenu
    MenuItem.wID = count

    IF InsertMenuItem(hMenu, count, 1, _OFFSET(MenuItem)) THEN ELSE END


    '/////////////////////////////////////////////////////////////////////////////////////////////////
    count = GetMenuItemCount(hDebugubmenu)
    MenuItem.cbSize = LEN(MenuItem)
    MenuItem.fMask = MIIM_STATE OR MIIM_ID OR MIIM_TYPE
    MenuItem.fState = MFS_ENABLED
    MenuItem.fType = MFT_STRING
    TypeData = "Add Breakpoint" + CHR$(0)
    MenuItem.dwTypeData = _OFFSET(TypeData)
    MenuItem.cch = LEN(MenuItem.dwTypeData)
    MenuItem.wID = 0

    IF InsertMenuItem(hDebugSubmenu, count, 1, _OFFSET(MenuItem)) THEN ELSE END

    count = GetMenuItemCount(hDebugubmenu)
    MenuItem.cbSize = LEN(MenuItem)
    MenuItem.fMask = MIIM_STATE OR MIIM_ID OR MIIM_TYPE
    MenuItem.fState = MFS_ENABLED
    MenuItem.fType = MFT_STRING
    TypeData = "Remove Breakpoint" + CHR$(0)
    MenuItem.dwTypeData = _OFFSET(TypeData)
    MenuItem.cch = LEN(MenuItem.dwTypeData)
    MenuItem.wID = 1

    IF InsertMenuItem(hDebugSubmenu, count, 1, _OFFSET(MenuItem)) THEN ELSE END

    count = GetMenuItemCount(hMenu)
    MenuItem.cbSize = LEN(MenuItem)
    MenuItem.fMask = MIIM_ID OR MIIM_TYPE OR MIIM_SUBMENU
    MenuItem.fType = MFT_STRING
    TypeData = "Debug" + CHR$(0)
    MenuItem.dwTypeData = _OFFSET(TypeData)
    MenuItem.cch = LEN(MenuItem.dwTypeData)
    MenuItem.hSubMenu = hDebugSubmenu
    MenuItem.wID = count

    IF InsertMenuItem(hMenu, count, 1, _OFFSET(MenuItem)) THEN ELSE END


    '/////////////////////////////////////////////////////////////////////////////////////////////////


    'controls menu////////////////////////////////////////////////////////////////////////////////////

    count = GetMenuItemCount(hContSubmenu)
    MenuItem.cbSize = LEN(MenuItem)
    MenuItem.fMask = MIIM_ID OR MIIM_TYPE
    MenuItem.fType = MFT_STRING
    TypeData = "Setup" + CHR$(0)
    MenuItem.dwTypeData = _OFFSET(TypeData)
    MenuItem.cch = LEN(MenuItem.dwTypeData)
    MenuItem.wID = count

    IF InsertMenuItem(hContSubmenu, count, 1, _OFFSET(MenuItem)) THEN ELSE END



    count = GetMenuItemCount(hMenu)
    MenuItem.cbSize = LEN(MenuItem)
    MenuItem.fMask = MIIM_ID OR MIIM_TYPE OR MIIM_SUBMENU
    MenuItem.fType = MFT_STRING
    TypeData = "Controls" + CHR$(0)
    MenuItem.dwTypeData = _OFFSET(TypeData)
    MenuItem.cch = LEN(MenuItem.dwTypeData)
    MenuItem.hSubMenu = hContSubmenu
    MenuItem.wID = count

    IF InsertMenuItem(hMenu, count, 1, _OFFSET(MenuItem)) THEN ELSE END


    '/////////////////////////////////////////////////////////////////////////////////////////////////

    'about menu////////////////////////////////////////////////////////////////////////////////////

    count = GetMenuItemCount(hContSubmenu)
    MenuItem.cbSize = LEN(MenuItem)
    MenuItem.fMask = MIIM_ID OR MIIM_TYPE
    MenuItem.fType = MFT_STRING
    TypeData = "about OLC-QB64-NESTEA" + CHR$(0)
    MenuItem.dwTypeData = _OFFSET(TypeData)
    MenuItem.cch = LEN(MenuItem.dwTypeData)
    MenuItem.wID = count

    IF InsertMenuItem(hAboutSubmenu, count, 1, _OFFSET(MenuItem)) THEN ELSE END



    count = GetMenuItemCount(hMenu)
    MenuItem.cbSize = LEN(MenuItem)
    MenuItem.fMask = MIIM_ID OR MIIM_TYPE OR MIIM_SUBMENU
    MenuItem.fType = MFT_STRING
    TypeData = "About" + CHR$(0)
    MenuItem.dwTypeData = _OFFSET(TypeData)
    MenuItem.cch = LEN(MenuItem.dwTypeData)
    MenuItem.hSubMenu = hAboutSubmenu
    MenuItem.wID = count

    IF InsertMenuItem(hMenu, count, 1, _OFFSET(MenuItem)) THEN ELSE END


    '/////////////////////////////////////////////////////////////////////////////////////////////////

    IF SetMenu(hwnd, hMenu) THEN ELSE END

END SUB

SUB cleanup ()
    SCREEN 0
    _FREEIMAGE sprPatternTable(0)
    _FREEIMAGE sprPatternTable(1)
    _FREEIMAGE nestea_logo
    _FREEIMAGE displayarea
    _FREEIMAGE canvas
    _FREEIMAGE nes_scrn


END SUB



SUB frames_per_sec
    ff% = ff% + 1


    IF TIMER - start! >= 1 THEN fps% = ff%: ff% = 0: start! = TIMER
    _TITLE origtitle + "-FPS:" + STR$(fps%)


END SUB

'the NES
'$include: 'bus.bm'

'$include: 'ComDlgFileName.bm'
'$INCLUDE: 'init_subs_funcs.bm'


