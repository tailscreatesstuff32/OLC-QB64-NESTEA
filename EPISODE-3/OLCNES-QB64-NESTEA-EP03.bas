'$CHECKING:OFF
'$INCLUDE: 'init.bi'

'the NES
'$INCLUDE: 'bus.bi'


DIM SHARED winrect AS RECT
DIM SHARED nestea_logo AS _UNSIGNED LONG
DIM SHARED col AS _UNSIGNED LONG
DIM alpha AS _UNSIGNED LONG
DIM red AS _UNSIGNED LONG
DIM green AS _UNSIGNED LONG
DIM blue AS _UNSIGNED LONG
DIM SHARED bEmulationrun AS _BYTE
DIM SHARED origtitle AS STRING


DIM SHARED ff%
DIM SHARED fps%
DIM SHARED start!


bEmulationrun = 0

img& = _LOADIMAGE("NESTEA_LOGO.png", 32)
_SOURCE img&

nestea_logo = _NEWIMAGE(1000, 1000, 32)

'temporary
'DIM SHARED statictv AS _UNSIGNED LONG
'statictv = _NEWIMAGE(256, 240, 32)







_DEST nes_scrn
CLS

_DEST nestea_logo
'CLS , _RGBA32(255, 255, 255, 0)

_DONTBLEND
FOR y = 0 TO 1000 - 1
    FOR x = 0 TO 1000 - 1
        col& = POINT(x, y)

        alpha& = _ALPHA(col&) / 2
        red& = _RED(col&)
        green& = _GREEN(col&)
        blue& = _BLUE(col&)

        col& = _RGB32(red&, green&, blue&, alpha&)

        PSET (x, y), col&



    NEXT x
NEXT y

'FOR y = 0 TO 1000 - 1
'    FOR x = 0 TO 1000 - 1
'        col& = POINT(x, y)

'        alpha& = _ALPHA(col&)
'        red& = _RED(col&)
'        green& = _GREEN(col&)
'        blue& = _BLUE(col&)

'        col& = _RGB32(red&, green&, blue&, alpha&)
'        PSET (x, y), col&



'    NEXT x
'NEXT y
_BLEND


'_DISPLAY



_FREEIMAGE img&




temp& = _RESIZE
_DEST canvas
_SOURCE displayarea


nes_init

main
END

'NES main

SUB main ()
    origtitle = _TITLE$

    DO
        _DEST canvas




        _LIMIT 60
        frames_per_sec
        IF bEmulationrun THEN 'wip for now.... slowish

            DO


                clock_NES


                '  _DISPLAY
            LOOP WHILE NOT framecomplete 'bEmulationrun 'framecomplete
            'complete
            'DO

            '    clock_NES

            'LOOP WHILE complete




            framecomplete = 0
        ELSE

            IF keypress(ASC("r")) THEN
                reset_NES

            END IF



            'IF keypress(ASC("i")) THEN
            '    irq

            'END IF



            'IF keypress(ASC("n")) THEN
            '    nmi

            'END IF


            'run 1 whole frame
            IF keypress(ASC("f")) THEN

                DO

                    clock_NES

                LOOP WHILE NOT framecomplete


                DO

                    clock_NES





                LOOP WHILE NOT complete
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
                _TITLE STR$(cycle)
            END IF



        END IF
        'run emulation
        IF keypress(ASC(" ")) THEN
            bEmulationrun = NOT bEmulationrun

        END IF


        'reset the NES
        IF keypress(ASC("r")) THEN
            reset_NES

        END IF

        episode3_UI

        IF ImageValid = -1 THEN
            WHILE _SNDRAWLEN < 0.1 AND ImageValid = -1
                _SNDRAW 0.4 * (RND * 1 - 0.5)
            WEND
        END IF


        IF _RESIZE THEN
            oldimage& = displayarea
            displayarea = _NEWIMAGE(_RESIZEWIDTH, _RESIZEHEIGHT, 32)
            SCREEN displayarea
            _FREEIMAGE oldimage&
        END IF

        _PUTIMAGE , canvas, displayarea ' stretch canvas to fill the screen;


        _DISPLAY

    LOOP UNTIL INKEY$ = CHR$(ASC("q"))
    SCREEN 0
    '  _FREEIMAGE statictv
    _FREEIMAGE nestea_logo
    _FREEIMAGE displayarea
    _FREEIMAGE canvas
    _FREEIMAGE nes_scrn

END SUB


SUB nes_init ()

    cartridge "nestest.nes", 1
    _DEST _CONSOLE
    IF cart_ImageValid THEN
        PRINT "Success!"
    ELSE
        PRINT "failed!"

    END IF


    InsertCartridge 0 'might not need






    disassemble mapAsm(), &H0000, &HFFFF
    reset_NES




END SUB




SUB frames_per_sec
    ff% = ff% + 1


    IF TIMER - start! >= 1 THEN fps% = ff%: ff% = 0: start! = TIMER
    _TITLE origtitle + "-FPS:" + STR$(fps%)


END SUB


'the NES
'$include: 'bus.bm'

'$INCLUDE: 'init_subs_funcs.bm'





