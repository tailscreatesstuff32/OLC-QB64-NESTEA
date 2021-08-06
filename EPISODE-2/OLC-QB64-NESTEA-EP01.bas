  DIM SHARED keys(255) AS _BYTE


'$include: 'bus.bi'

WIDTH 86, 40
_TITLE "OLC-QB64-NESTEA-EP01"


init



DO

    main

LOOP UNTIL keypress(27)

DIM SHARED mapAsm(65535) AS STRING



SUB init ()

    DIM nOffset AS _UNSIGNED INTEGER


    cpu_regs.flags.C = _SHL(1, 0)
    cpu_regs.flags.Z = _SHL(1, 1)
    cpu_regs.flags.I = _SHL(1, 2)
    cpu_regs.flags.D = _SHL(1, 3)
    cpu_regs.flags.B = _SHL(1, 4)
    cpu_regs.flags.U = _SHL(1, 5)
    cpu_regs.flags.V = _SHL(1, 6)
    cpu_regs.flags.N = _SHL(1, 7)

    'A2 0A 8E 00 00 A2 03 8E 01 00 AC 00 00 A9 00 18 6D 01 00 88 D0 FA 8D 02 00 EA EA EA" ' original format

    ' ss$ = "A20A8E0000A2038E0100AC0000A900186D010088D0FA8D0200EAEAEA" 'test program  PASSED

    ' ss$ = "a9018d0002a9058d0102a9088d0202" 'test program 2 'PASSED

    'ss$ = "a9c0aae869c400" 'PASSED

    'ss$ = "a98085016501" 'PASSED

    'ss$ = "a208ca8e0002e003d0f88e010200" 'PASSED

    ss$ = "a200a0008a99000248e8c8c010d0f568990002c8c020d0f7" 'PASSED


    nOffset = &H8000

    FOR x = 0 TO LEN(ss$) - 1
        ram(nOffset) = VAL("&H" + MID$(ss$, 2 * x + 1, 2))
        nOffset = nOffset + 1
    NEXT x



    ram(&HFFFC~%) = &H00
    ram(&HFFFD~%) = &H80


    disassemble mapAsm(), &H0000, &HFFFF
    reset_6502



END SUB


SUB main ()
    SHARED k AS STRING
    CLS


    IF keypress(ASC("r")) THEN
        reset_6502

    END IF



    IF keypress(ASC("i")) THEN
        irq

    END IF



    IF keypress(ASC("n")) THEN
        nmi

    END IF

    IF keypress(ASC(" ")) THEN

        DO

            cpu_Clock

        LOOP WHILE NOT complete
    END IF











    DrawCpu 57, 1
    DrawRam 2, 2, &H0000, 16, 16
    DrawRam 2, 20, &H8000, 16, 16
    DrawCode 58, 9, 26





    LOCATE 37, 3
    PRINT "SPACE = Step Instruction    R = RESET    I = IRQ    N = NMI"
    _DISPLAY


END SUB


SUB DrawCpu (x AS INTEGER, y AS INTEGER)
    LOCATE y, x



    IF cpu_regs.status AND cpu_regs.flags.N THEN COLOR 4 ELSE COLOR 2
    PRINT " N ";
    IF cpu_regs.status AND cpu_regs.flags.V THEN COLOR 4 ELSE COLOR 2
    PRINT " V ";
    IF cpu_regs.status AND cpu_regs.flags.U THEN COLOR 4 ELSE COLOR 2
    PRINT " - ";
    IF cpu_regs.status AND cpu_regs.flags.B THEN COLOR 4 ELSE COLOR 2
    PRINT " B ";
    IF cpu_regs.status AND cpu_regs.flags.D THEN COLOR 4 ELSE COLOR 2
    PRINT " D ";
    IF cpu_regs.status AND cpu_regs.flags.I THEN COLOR 4 ELSE COLOR 2
    PRINT " I ";
    IF cpu_regs.status AND cpu_regs.flags.Z THEN COLOR 4 ELSE COLOR 2
    PRINT " Z ";
    IF cpu_regs.status AND cpu_regs.flags.C THEN COLOR 4 ELSE COLOR 2
    PRINT " C "
    COLOR 7


    LOCATE , x

    PRINT get_flag(cpu_regs.flags.N); get_flag(cpu_regs.flags.V); get_flag(cpu_regs.flags.U); get_flag(cpu_regs.flags.B); get_flag(cpu_regs.flags.D); get_flag(cpu_regs.flags.I); get_flag(cpu_regs.flags.Z); get_flag(cpu_regs.flags.C)

    LOCATE , x
    PRINT " PC: $"; LTRIM$(hex_range(cpu_regs.pc, 4))
    LOCATE , x
    PRINT " A: $"; LTRIM$(hex_range(cpu_regs.a_reg, 2)) + " [" + LTRIM$(STR$(cpu_regs.a_reg)) + "]"
    LOCATE , x
    PRINT " X: $"; LTRIM$(hex_range(cpu_regs.x_reg, 2)) + " [" + LTRIM$(STR$(cpu_regs.x_reg)) + "]"
    LOCATE , x
    PRINT " Y: $"; LTRIM$(hex_range(cpu_regs.y_reg, 2)) + " [" + LTRIM$(STR$(cpu_regs.y_reg)) + "]"
    LOCATE , x
    PRINT " Stack P: $"; LTRIM$(hex_range(cpu_regs.stkp, 4))




END SUB

SUB DrawRam (x AS INTEGER, y AS INTEGER, addr AS _UNSIGNED INTEGER, nRows AS INTEGER, nColumns AS INTEGER)
    nRamX = x
    nRamY = y

    FOR row = 0 TO nRows - 1
        sOffset$ = "$" + hex_range(addr, 4) + ":"
        FOR col = 0 TO nColumns - 1


            sOffset$ = sOffset$ + " " + hex_range(bus_read(addr, 1), 2)

            addr = addr + 1

        NEXT col

        LOCATE nRamY, nRamX


        PRINT sOffset$
        nRamY = nRamY + 1
    NEXT row

END SUB


SUB DrawCode (x AS INTEGER, y AS INTEGER, nLines AS INTEGER)
    DIM pc AS _UNSIGNED INTEGER

    pc = cpu_regs.pc


    nLineY = _SHR(nLines, 1) + y

    IF LEN(mapAsm(pc)) > 0 OR pc = UBOUND(mapasm) THEN
        LOCATE nLineY, x
        COLOR 3
        'middle
        PRINT mapAsm((pc))

        'bottom

        WHILE nLineY < (nLines * 1) + y

            pc = pc + 1



            IF LEN(mapAsm(pc)) > 0 OR pc = UBOUND(mapasm) THEN
                nLineY = nLineY + 1
                LOCATE nLineY, x
                COLOR 7
                PRINT mapAsm(pc)

            END IF
        WEND
    END IF
    'top
    pc = cpu_regs.pc

    nLineY = _SHR(nLines, 1) + y

    IF LEN(mapAsm(pc)) > 0 OR pc = UBOUND(mapasm) THEN
        WHILE nLineY > y


            pc = pc - 1



            IF LEN(mapAsm(pc)) > 0 OR pc = UBOUND(mapasm) THEN

                nLineY = nLineY - 1
                LOCATE nLineY, x
                COLOR 7

                PRINT mapAsm(pc)

            ELSE
            END IF

        WEND
    END IF
    '  END IF

END SUB


FUNCTION keypress (k AS _BYTE)

    IF _KEYDOWN(k) THEN
        IF keys(k) = 0 THEN
            keys(k) = 1
            keypress = keys(k)


        END IF
    ELSE
        keys(k) = 0
        keypress = keys(k)


    END IF

END FUNCTION

FUNCTION keyheld (k AS _BYTE)

    keyheld = _KEYDOWN(k)

END FUNCTION


'$include: 'bus.bm'

