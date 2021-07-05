
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
img& = _LOADIMAGE("NESTEA_LOGO.png", 32)
_SOURCE img&

nestea_logo = _NEWIMAGE(1000, 1000, 32)



_DEST nestea_logo
'CLS , _RGBA32(255, 255, 255, 0)

_DONTBLEND
FOR y = 0 TO 1000 - 1
    FOR x = 0 TO 1000 - 1
        col& = POINT(x, y)

        alpha& = _ALPHA(col&) / 10
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


SUB nes_init ()

    cartridge "mario.nes"
    IF ImageValid = -1 THEN
        PRINT "failed"
    ELSE

        PRINT "success"
    END IF

    InsertCartridge 0






END SUB


'NES main

SUB main ()

    '_SOURCE nestea_logo
    '_CLEARCOLOR POINT(0, 0), nestea_logo
    '_SOURCE 0


    'clr~& = POINT(0, 0)
    'topclr~& = clr~& - _RGBA(1, 1, 1, 0)

    '_SOURCE displayarea


    DO
        _LIMIT 60
        _DEST canvas

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

    LOOP

    _FREEIMAGE nestea_logo
    _FREEIMAGE displayarea
    _FREEIMAGE canvas
END SUB


'the NES
'$include: 'bus.bm'

'$INCLUDE: 'init_subs_funcs.bm'






