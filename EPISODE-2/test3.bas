
'$include: 'bus.bi'

WIDTH 86, 25

init
main



DIM SHARED mapAsm(65535) AS STRING
'REDIM SHARED mapAsm(65535)








SUB init ()
    'SHARED cpu_regs AS regs_6502
    DIM nOffset AS _UNSIGNED INTEGER


    cpu_regs.flags.C = _SHL(1, 0)
    cpu_regs.flags.Z = _SHL(1, 1)
    cpu_regs.flags.I = _SHL(1, 2)
    cpu_regs.flags.D = _SHL(1, 3)
    cpu_regs.flags.B = _SHL(1, 4)
    cpu_regs.flags.U = _SHL(1, 5)
    cpu_regs.flags.V = _SHL(1, 6)
    cpu_regs.flags.N = _SHL(1, 7)

    'A2 0A 8E 00 00 A2 03 8E 01 00 AC 00 00 A9 00 18 6D 01 00 88 D0 FA 8D 02 00 EA EA EA"



    ss$ = "A20A8E0000A2038E0100AC0000A900186D010088D0FA8D0200EAEAEA" 'test program



    nOffset = &H8000

    FOR x = 0 TO LEN(ss$) - 1
        'PRINT nOffset

        ram(nOffset) = VAL("&H" + MID$(ss$, 2 * x + 1, 2))
        nOffset = nOffset + 1
    NEXT x



    nOffset = &HFFFC
    ram(nOffset) = &H00
    nOffset = &HFFFD
    ram(nOffset) = &H80
    'REDIM mapAsm(&HFFFF) AS STRING
    disassemble mapAsm(), &H0000, &HFFFF
    '_TITLE STR$(UBOUND(mapAsm))

    reset_6502



END SUB


SUB main ()

    'cpu_regs.pc = cpu_regs.pc + 18
    DrawCpu 57, 1
    DrawRam 2, 2, &H0000, 8, 16
    DrawRam 2, 12, &H8000, 8, 16
    DrawCode 58, 9, 26





    LOCATE 22, 1
    PRINT "SPACE = Step Instruction"
    PRINT "R = RESET    I = IRQ    N = NMI"





END SUB


SUB DrawCpu (x AS INTEGER, y AS INTEGER)
    LOCATE y, x

    'PRINT " N "; " V "; " - "; " B "; " D "; " I "; " Z "; " C "

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
    PRINT " A: $"; LTRIM$(hex_range(cpu_regs.a_reg, 2))
    LOCATE , x
    PRINT " X: $"; LTRIM$(hex_range(cpu_regs.x_reg, 2))
    LOCATE , x
    PRINT " Y: $"; LTRIM$(hex_range(cpu_regs.y_reg, 2))
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

    pc = cpu_regs.pc / 2
    nLineY = _SHR(nLines, 1) + y
    IF pc <> UBOUND(mapAsm) THEN

        LOCATE nLineY, x
        COLOR 3
        'middle
        PRINT mapAsm((pc))

        'bottom

        WHILE nLineY < (nLines * 1) + y
            nLineY = nLineY + 1
            pc = pc + 1

            IF pc <> UBOUND(mapAsm) THEN
                LOCATE nLineY, x
                COLOR 7
                PRINT mapAsm(pc)
            END IF
        WEND
    END IF
    'top

    pc = cpu_regs.pc / 2

    nLineY = _SHR(nLines, 1) + y
    IF pc <> UBOUND(mapAsm) THEN
        WHILE nLineY > y
            nLineY = nLineY - 1
            pc = pc - 1
            IF pc <> UBOUND(mapAsm) THEN
                LOCATE nLineY, x
                COLOR 7

                PRINT mapAsm(pc)
            END IF
        WEND
    END IF

END SUB




'$include: 'bus.bm'



