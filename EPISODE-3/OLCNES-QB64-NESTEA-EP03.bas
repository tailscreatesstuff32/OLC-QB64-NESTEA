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

        IF bEmulationrun THEN 'wip for now.... slowish

            DO
                clock_NES

            LOOP WHILE NOT framecomplete
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





        frames_per_sec
        episode3_UI



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

SUB episode3_UI ()

    _DEST canvas



    'LINE (0, 0)-(256 * scale, 240 * scale), _RGB(0, 0, 0), BF

    CLS , _RGBA(0, 0, 128, 255)


    ' _SETALPHA 150, , nestea_logo
    '_SETALPHA 255, , nestea_logo
    '_CLEARCOLOR _RGB32(0, 0, 0, 0), nestea_logo
    'LINE (0, 0)-(256 * 2, 240 * 2), _RGBA(0, 0, 0, 255), BF
    '   _dest nes_scrn



    '_PUTIMAGE (0, 0)-(256 * 2, 240 * 2), nes_scrn, canvas

    'PPU_clock

    'test_code
    _PUTIMAGE (0, 0)-(256 * 2, 240 * 2), nes_scrn, canvas
    _DEST canvas

    '  _PUTIMAGE (0, 0)-(500, 500), nestea_logo, canvas



    '  DrawRAM 2, 2, &H0000, 16, 16
    ' DrawRAM 2, 182, &H8000, 16, 16
    'DrawAudio
    DrawCPUepisode2 516, 2
    DrawCodeepisode2 516, 72, 26



    'Drawstring 10, 370, "SPACE = Step Instruction    R = RESET    I = IRQ    N = NMI", _RGB(255, 255, 255)


    'FOR p = 0 TO 7
    '    FOR s = 0 TO 3
    '        rect_x = 516 + p * (6 * 5) + s * 6
    '        rect_y = 340

    '        LINE (rect_x, rect_y)-((rect_x + 6) - 1, (rect_y + 6) - 1), _RGB(0, 0, 0), BF

    '    NEXT s
    'NEXT p


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


SUB main_code


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

END SUB



SUB frames_per_sec
    ff% = ff% + 1


    IF TIMER - start! >= 1 THEN fps% = ff%: ff% = 0: start! = TIMER
    _TITLE origtitle + "-FPS:" + STR$(fps%)


END SUB


'the NES
'$include: 'bus.bm'

'$INCLUDE: 'init_subs_funcs.bm'





















'SUB test_code

'    framecomplete = 0
'    ' CLS , _RGB32(0, 0, 0, 0)

'    ' frames_per_sec
'    _DEST statictv
'    DO


'        IF Rand(0, 1) = 0 THEN
'            col1& = nes_pal1(&H3F&) '_RGB32(0, 0, 0, 255)

'        ELSE

'            col1& = nes_pal1(&H30&) ' _RGB32(255, 255, 255, 255)
'        END IF
'        PSET (cycle - 1, scanline), col1&

'        cycle = cycle + 1
'        IF cycle >= 341 THEN
'            cycle = 0

'            scanline = scanline + 1
'            IF scanline >= 261 THEN
'                framecomplete = -1
'                scanline = -1

'            END IF
'        END IF
'        '_DISPLAY
'    LOOP WHILE NOT framecomplete


'    '  _PUTIMAGE (0, 0)-(256 * 2, 240 * 2), statictv, canvas
'    ' _DISPLAY

'END SUB
