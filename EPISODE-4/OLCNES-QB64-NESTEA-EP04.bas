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

img& = _LOADIMAGE("NESTEA_LOGO.png", 32)
_SOURCE img&

nestea_logo = _NEWIMAGE(1000, 1000, 32)

_DEST nes_scrn
CLS

_DEST nestea_logo

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

_BLEND

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

        '  _LIMIT 60 'maybe have a better timer...
        frames_per_sec


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
        IF keypress(ASC("r")) THEN reset_NES 'reset the NES
        IF keypress(ASC("p")) THEN nselectedpalette = nselectedpalette + 1 AND &H07& 'select palette

        IF bEmulationrun THEN 'wip for now.... slowish

            'DO

            '    clock_NES

            'LOOP WHILE NOT framecomplete
            'framecomplete = 0
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
                ' _TITLE STR$(cycle)
            END IF



        END IF

        episode3_UI


        '_TITLE STR$(UBOUND(mapasm))



        _PUTIMAGE (516, 348)-(516 + 127, 348 + 127), GetPatternTable(0, nselectedpalette), canvas
        _PUTIMAGE (648, 348)-(648 + 127, 348 + 127), GetPatternTable(1, nselectedpalette), canvas

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
    _FREEIMAGE sprPatternTable(0)
    _FREEIMAGE sprPatternTable(1)
    _FREEIMAGE nestea_logo
    _FREEIMAGE displayarea
    _FREEIMAGE canvas
    _FREEIMAGE nes_scrn

END SUB

SUB disassemble (maparray() AS STRING, nStart AS _UNSIGNED INTEGER, nStop AS _UNSIGNED INTEGER)
    DIM addr AS _UNSIGNED LONG
    DIM value AS _UNSIGNED _BYTE
    DIM value_sgn AS _BYTE
    DIM lo AS _UNSIGNED _BYTE
    DIM hi AS _UNSIGNED _BYTE
    DIM maplines(0) AS STRING
    DIM op AS _UNSIGNED _BYTE

    DIM line_addr AS _UNSIGNED INTEGER
    DIM sInst AS STRING

    'TYPE OPS
    '    op_name AS STRING
    '    addrmode AS _UNSIGNED _BYTE
    '    cycles AS _UNSIGNED _BYTE

    'addr_mode_IMP = 0
    'add_mode_ZPO = 1
    'add_mode_ZPY = 2
    'add_mode_ABS = 3
    'add_mode_ABY = 4
    'add_mode_IZX = 5
    'add_mode_IMM = 6
    'add_mode_REL = 7
    'add_mode_ABX = 8
    'addr_mode_IND = 9
    'addr_mode_IZY = 10
    'addr_mode_ZPX = 11


    'END TYPE

    REDIM maplines(nStop + 1) AS STRING

    addr = nStart
    WHILE addr <= nStop

        line_addr = addr

        sInst = "$" + hex_range(addr, 4) + ": "


        op = bus_cpuRead(addr, 1)
        '_title str$( addr )
        'if addr = &H02 then op = 4
        'if addr = &H11 then op = &HfD
        'if addr = &H14 then op = &HfE





        addr = addr + 1

        sInst = sInst + instructions(op).op_name + " "
        IF instructions(op).addrmode = addr_mode_IMP THEN
            sInst = sInst + " {IMP}"
        ELSEIF instructions(op).addrmode = add_mode_IMM THEN
            value = bus_cpuRead(addr, 1)
            addr = addr + 1
            sInst = sInst + "#$" + hex_range(value, 2) + " {IMM}"
        ELSEIF instructions(op).addrmode = add_mode_ABS THEN
            lo = bus_cpuRead(addr, 1)
            addr = addr + 1
            hi = bus_cpuRead(addr, 1)
            addr = addr + 1
            sInst = sInst + "$" + hex_range(_SHL(hi, 8) OR lo, 4) + " {ABS}"
        ELSEIF instructions(op).addrmode = add_mode_ZPO THEN

            lo = bus_cpuRead(addr, 1)
            addr = addr + 1
            hi = &H00
            sInst = sInst + "$" + hex_range(lo, 2) + " {ZPO}"
        ELSEIF instructions(op).addrmode = addr_mode_ZPX THEN
            lo = bus_cpuRead(addr, 1)
            addr = addr + 1
            hi = &H00
            sInst = sInst + "$" + hex_range(lo, 2) + ", X {ZPX}"
        ELSEIF instructions(op).addrmode = add_mode_ZPY THEN
            lo = bus_cpuRead(addr, 1)
            addr = addr + 1
            hi = &H00
            sInst = sInst + "$" + hex_range(lo, 2) + ", Y {ZPY}"
        ELSEIF instructions(op).addrmode = add_mode_IZX THEN
            lo = bus_cpuRead(addr, 1)
            addr = addr + 1
            hi = &H00
            sInst = sInst + "($" + hex_range(lo, 2) + ", X) {IZX}"
        ELSEIF instructions(op).addrmode = addr_mode_IZY THEN
            lo = bus_cpuRead(addr, 1)
            addr = addr + 1
            hi = &H00
            sInst = sInst + "($" + hex_range(lo, 2) + ", Y) {IZY}"
        ELSEIF instructions(op).addrmode = add_mode_ABX THEN
            lo = bus_cpuRead(addr, 1)
            addr = addr + 1
            hi = bus_cpuRead(addr, 1)
            addr = addr + 1
            sInst = sInst + "$" + hex_range(_SHL(hi, 8) OR lo, 4) + ", X {ABX}"
        ELSEIF instructions(op).addrmode = add_mode_ABY THEN
            lo = bus_cpuRead(addr, 1)
            addr = addr + 1
            hi = bus_cpuRead(addr, 1)
            addr = addr + 1
            sInst = sInst + "$" + hex_range(_SHL(hi, 8) OR lo, 4) + ", Y {ABY}"
        ELSEIF instructions(op).addrmode = addr_mode_IND THEN
            lo = bus_cpuRead(addr, 1)
            addr = addr + 1
            hi = bus_cpuRead(addr, 1)
            addr = addr + 1
            sInst = sInst + "($" + hex_range(_SHL(hi, 8) OR lo, 4) + ") {IND}"
        ELSEIF instructions(op).addrmode = add_mode_REL THEN
            value = bus_cpuRead(addr, 1)
            value_sgn = value
            addr = addr + 1
            sInst = sInst + "$" + hex_range(value, 2) + " [$" + hex_range(addr + value_sgn, 4) + "] {REL}"


        END IF

        'IF line_addr >= 2 THEN
        maparray(line_addr) = sInst
        '  END IF
    WEND

    maparray(65536) = " "

    '  disassemble  = maplines()




END SUB

SUB DrawCodeepisode2 (x AS INTEGER, y AS INTEGER, nLines AS INTEGER)
    'nliney = _SHR(nLines, 1) * 10 + y
    'Drawstring x, nliney, "$0000" + ": " + "BRK" + " " + "#$00" + " " + "{IMM}", _RGB(0, 255, 255)


    'WHILE nliney < (nLines * 10) + y
    '    nliney = nliney + 10
    '    Drawstring x, nliney, "$0000" + ": " + "BRK" + " " + "#$00" + " " + "{IMM}", _RGB(255, 255, 255)
    'WEND

    'nliney = _SHR(nLines, 1) * 10 + y

    'WHILE nliney > y
    '    nliney = nliney - 10
    '    Drawstring x, nliney, "$0000" + ": " + "BRK" + " " + "#$00" + " " + "{IMM}", _RGB(255, 255, 255)
    'WEND
    DIM pc AS _UNSIGNED LONG

    pc = cpu_regs.pc


    nLineY = _SHR(nLines, 1) * 10 + y

    IF LEN(mapAsm(pc)) <> 0 THEN
        'LOCATE nLineY, x
        'COLOR 3
        'middle
        'PRINT mapAsm((pc))
        Drawstring x, nLineY, mapAsm(pc), _RGB(0, 255, 255)
        'bottom
        '_TITLE STR$(pc)


        WHILE nLineY < (nLines * 10) + y

            pc = pc + 1
            IF pc >= UBOUND(mapasm) THEN
                pc = LBOUND(mapasm)
            END IF

            IF pc <= LBOUND(mapasm) THEN
                pc = UBOUND(mapasm)
            END IF


            IF LEN(mapAsm((pc))) <> 0 THEN
                nLineY = nLineY + 10
                'LOCATE nLineY, x
                'COLOR 7
                'PRINT mapAsm(pc)
                '    IF pc <= LBOUND(mapasm) THEN
                Drawstring x, nLineY, mapAsm(pc), _RGB(255, 255, 255)

                '   ELSE
                '        Drawstring x, nLineY, "test", _RGB(255, 255, 255)

                '     END IF


            END IF
        WEND
    END IF





    'top
    pc = cpu_regs.pc

    nLineY = _SHR(nLines, 1) * 10 + y
    ' mapAsm(&HFFFF~%) = "test"
    IF LEN(mapAsm(pc)) <> 0 THEN
        WHILE nLineY > y
            pc = pc - 1

            IF pc >= UBOUND(mapasm) THEN
                pc = LBOUND(mapasm)
            END IF

            IF pc <= LBOUND(mapasm) THEN
                pc = UBOUND(mapasm)
            END IF


            IF LEN(mapAsm(pc)) <> 0 THEN
                nLineY = nLineY - 10
                'LOCATE nLineY, x
                'COLOR 7

                'PRINT mapAsm(pc)
                '  IF pc < LBOUND(mapasm) THEN
                Drawstring x, nLineY, mapAsm(pc), _RGB(255, 255, 255)

                '   ELSE
                '       Drawstring x, nLineY, "test", _RGB(255, 255, 255)

                ' END IF
            END IF



        WEND

    END IF

END SUB

SUB nes_init ()

    cartridge "tennis.nes", 1
    _DEST _CONSOLE
    IF cart_ImageValid THEN
        PRINT "Success!"
    ELSE
        PRINT "failed!"

    END IF


    InsertCartridge 0 'might not need






    ' disassemble mapAsm(), &H0000, &HBFF8
    disassemble mapAsm(), &H0000, &HFFFF~%
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





