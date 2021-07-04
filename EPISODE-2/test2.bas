' test program a9 c0 aa e8 69 c4 00

TYPE FLAGS_6502
    C AS _UNSIGNED _BYTE
    Z AS _UNSIGNED _BYTE
    I AS _UNSIGNED _BYTE
    D AS _UNSIGNED _BYTE
    B AS _UNSIGNED _BYTE
    U AS _UNSIGNED _BYTE
    V AS _UNSIGNED _BYTE
    N AS _UNSIGNED _BYTE

END TYPE

TYPE regs_6502
    a_reg AS _UNSIGNED _BYTE
    x_reg AS _UNSIGNED _BYTE
    y_reg AS _UNSIGNED _BYTE
    stkp AS _UNSIGNED _BYTE
    pc AS _UNSIGNED _BYTE
    status AS _UNSIGNED _BYTE
    flags AS FLAGS_6502
END TYPE

DIM cpu_regs AS regs_6502

DIM addr_abs AS _UNSIGNED INTEGER
DIM addr_rel AS _UNSIGNED INTEGER
DIM fetched AS _UNSIGNED _BYTE
DIM opcode AS _UNSIGNED _BYTE
DIM temp AS _UNSIGNED INTEGER
DIM cycles AS _UNSIGNED _BYTE
DIM clock_cycles AS _UNSIGNED LONG
DIM hi AS _UNSIGNED INTEGER
DIM lo AS _UNSIGNED INTEGER


init

LOCATE 1, 50

PRINT " N "; " V "; " - "; " B "; " D "; " I "; " Z "; " C "
LOCATE 2, 50



PRINT get_flag(cpu_regs.flags.N); get_flag(cpu_regs.flags.V); " - "; get_flag(cpu_regs.flags.B); get_flag(cpu_regs.flags.D); get_flag(cpu_regs.flags.I); get_flag(cpu_regs.flags.Z); get_flag(cpu_regs.flags.C)



'$include: 'bus.bm'






SUB init ()

    cpu_regs.flags.C = _SHL(1, 0)
    cpu_regs.flags.Z = _SHL(1, 1)
    cpu_regs.flags.I = _SHL(1, 2)
    cpu_regs.flags.D = _SHL(1, 3)
    cpu_regs.flags.B = _SHL(1, 4)
    cpu_regs.flags.U = _SHL(1, 5)
    cpu_regs.flags.V = _SHL(1, 6)
    cpu_regs.flags.N = _SHL(1, 7)


END SUB




FUNCTION read_from_bus (addr AS _UNSIGNED INTEGER)

    read_from_bus = bus_read(addr, 0)

END FUNCTION



SUB write_to_bus (addr AS _UNSIGNED INTEGER, d AS _UNSIGNED _BYTE)

    bus_write addr, d

END SUB


SUB reset_6502 (addr AS _UNSIGNED INTEGER)
    SHARED cpu_regs AS regs_6502
    SHARED addr_abs AS _UNSIGNED INTEGER
    SHARED addr_rel AS _UNSIGNED INTEGER
    SHARED fetched AS _UNSIGNED _BYTE
    SHARED cycles AS _UNSIGNED _BYTE
    SHARED hi AS _UNSIGNED INTEGER
    SHARED lo AS _UNSIGNED INTEGER




    addr_abs = &HFFFC
    lo = read_from_bus(addr_abs + 0)
    hi = read_from_bus(addr_abs + 1)

    cpu_regs.pc = _SHL(hi, 8) OR lo
    cpu_regs.a_reg = 0
    cpu_regs.x_reg = 0
    cpu_regs.stkp = &HFD

    cpu_regs.status = &H00 OR cpu_regs.flags.U

    addr_rel = &H0000
    addr_abs = &H0000
    fetched = &H00

    cycles = 8

END FUNCTION


SUB irq ()
    SHARED cpu_regs AS regs_6502
    SHARED addr_abs AS _UNSIGNED INTEGER
    SHARED addr_rel AS _UNSIGNED INTEGER
    SHARED fetched AS _UNSIGNED _BYTE
    SHARED cycles AS _UNSIGNED _BYTE
    SHARED hi AS _UNSIGNED INTEGER
    SHARED lo AS _UNSIGNED INTEGER



    DIM hi AS _UNSIGNED INTEGER
    DIM lo AS _UNSIGNED INTEGER

    IF get_flag(cpu_regs.flags.I) = 0 THEN


        write_to_bus &H0100 + cpu_regs.stkp, _SHR(cpu_regs.pc, 8) AND &H00FF
        cpu_regs.stkp = cpu_regs.stkp - 1
        write_to_bus &H0100 + cpu_regs.stkp, cpu_regs.pc AND &H00FF
        cpu_regs.stkp = cpu_regs.stkp - 1
        set_flag cpu_regs.flags.B, 0
        set_flag cpu_regs.flags.U, 0
        set_flag cpu_regs.flags.I, 0
        write_to_bus &H0100 + cpu_regs.stkp, cpu_regs.status

        addr_abs = &HFFFE
        lo = read_from_bus(addr_abs + 0)
        hi = read_from_bus(addr_abs + 1)
        cpu_regs.pc = _SHL(hi, 8) OR lo


        cycles = 7
    END IF


END SUB


SUB nmi ()
    SHARED cpu_regs AS regs_6502
    SHARED addr_abs AS _UNSIGNED INTEGER
    SHARED addr_rel AS _UNSIGNED INTEGER
    SHARED fetched AS _UNSIGNED _BYTE
    SHARED cycles AS _UNSIGNED _BYTE
    SHARED hi AS _UNSIGNED INTEGER
    SHARED lo AS _UNSIGNED INTEGER



    write_to_bus &H0100 + cpu_regs.stkp, _SHR(cpu_regs.pc, 8) AND &H00FF
    cpu_regs.stkp = cpu_regs.stkp - 1
    write_to_bus &H0100 + cpu_regs.stkp, cpu_regs.pc AND &H00FF
    cpu_regs.stkp = cpu_regs.stkp - 1
    set_flag cpu_regs.flags.B, 0
    set_flag cpu_regs.flags.U, 0
    set_flag cpu_regs.flags.I, 0

    addr_abs = &HFFFE
    lo = read_from_bus(addr_abs + 0)
    hi = read_from_bus(addr_abs + 1)
    cpu_regs.pc = _SHL(hi, 8) OR lo


    cycles = 8

END SUB


'----------------------------------------------
SUB fetch
    SHARED opcode AS _UNSIGNED _BYTE
    SHARED addr_abs AS _UNSIGNED INTEGER
    SHARED addr_rel AS _UNSIGNED INTEGER
    SHARED fetched AS _UNSIGNED _BYTE

    'not finshed  WIP
    IF NOT addrmode(opcode) = addr_IMP THEN
        fetched = read_from_bus(addr_abs)
    END IF


END SUB
'----------------------------------------------




'uint8_t ADC();  uint8_t AND();  uint8_t ASL();  uint8_t BCC();
'uint8_t BCS();  uint8_t BEQ();  uint8_t BIT();  uint8_t BMI();
'uint8_t BNE();  uint8_t BPL();  uint8_t BRK();  uint8_t BVC();
'uint8_t BVS();  uint8_t CLC();  uint8_t CLD();  uint8_t CLI();
'uint8_t CLV();  uint8_t CMP();  uint8_t CPX();  uint8_t CPY();
'uint8_t DEC();  uint8_t DEX();  uint8_t DEY();  uint8_t EOR();
'uint8_t INC();  uint8_t INX();  uint8_t INY();  uint8_t JMP();
'uint8_t JSR();  uint8_t LDA();  uint8_t LDX();  uint8_t LDY();
'uint8_t LSR();  uint8_t NOP();  uint8_t ORA();  uint8_t PHA();
'uint8_t PHP();  uint8_t PLA();  uint8_t PLP();  uint8_t ROL();
'uint8_t ROR();  uint8_t RTI();  uint8_t RTS();  uint8_t SBC();
'uint8_t SEC();  uint8_t SED();  uint8_t SEI();  uint8_t STA();
'uint8_t STX();  uint8_t STY();  uint8_t TAX();  uint8_t TAY();
'uint8_t TSX();  uint8_t TXA();  uint8_t TXS();  uint8_t TYA();


'uint8_t XXX();


'A instructions----------------------COMPLETE needs testing

FUNCTION ADC~%
    SHARED cpu_regs AS regs_6502
    SHARED addr_abs AS _UNSIGNED INTEGER
    SHARED addr_rel AS _UNSIGNED INTEGER
    SHARED fetched AS _UNSIGNED _BYTE
    SHARED temp AS _UNSIGNED INTEGER

    fetch 'warning! not finished

    temp = cpu_regs.a_reg + fetched + get_flag(cpu_regs.flags.C)



    set_flag cpu_regs.flags.C, temp > 255
    set_flag cpu_regs.flags.Z, (temp AND &H00FF) = 0
    set_flag cpu_regs.flags.V, (NOT (cpu_regs.a_reg XOR fetched) AND (cpu_regs.a_reg XOR temp) AND &H0080)

    set_flag cpu_regs.flags.N, temp AND &H80


    cpu_regs.a_reg = temp AND &H00FF


    ADC~% = 1


END FUNCTION



FUNCTION SBC~%
    SHARED cpu_regs AS regs_6502
    DIM value AS _UNSIGNED INTEGER
    SHARED addr_abs AS _UNSIGNED INTEGER
    SHARED addr_rel AS _UNSIGNED INTEGER
    SHARED fetched AS _UNSIGNED _BYTE
    SHARED temp AS _UNSIGNED INTEGER



    fetch

    value = fetched XOR &H00FF

    temp = cpu_regs.a_reg + value + get_flag(cpu_regs.flags.C)
    set_flag cpu_regs.flags.C, temp AND 255
    set_flag cpu_regs.flags.Z, (temp AND &H00FF) = 0
    set_flag cpu_regs.flags.V, (temp XOR cpu_regs.a_reg) AND (temp XOR value) AND &H0080
    set_flag cpu_regs.flags.N, temp AND &H0080
    cpu_regs.a_reg = temp AND &H00FF

    SBC~% = 1


END FUNCTION



FUNCTION aAND~%
    SHARED cpu_regs AS regs_6502
    SHARED addr_abs AS _UNSIGNED INTEGER
    SHARED addr_rel AS _UNSIGNED INTEGER
    SHARED fetched AS _UNSIGNED _BYTE

    fetch
    cpu_regs.a_reg = cpu_regs.a_reg AND fetched

    set_flag cpu_regs.flags.Z, cpu_regs.a_reg = &H0
    set_flag cpu_regs.flags.N, cpu_regs.a_reg AND &H80

    bAND = 1


END FUNCTION

FUNCTION ASL~%
    SHARED cpu_regs AS regs_6502
    SHARED addr_abs AS _UNSIGNED INTEGER
    SHARED addr_rel AS _UNSIGNED INTEGER
    SHARED fetched AS _UNSIGNED _BYTE
    SHARED temp AS _UNSIGNED INTEGER


    fetch
    tmp = _SHL(fetched, 1)
    set_flag cpu_regs.flags.C, (temp AND &H00FF) > 0
    set_flag cpu_regs.flags.Z, (temp AND &H00FF) = 0
    set_flag cpu_regs.flags.N, temp AND &H80

    IF addr_mode = addr_IMP THEN
        cpu_regs.a_reg = temp AND &H00FF
    ELSE
        write_to_bus addr_abs, temp AND &H00FF
    END IF



END FUNCTION
'------------------------------------------------

'B instructions------------------------COMPLETE needs testing
FUNCTION BCC~%
    SHARED cpu_regs AS regs_6502
    SHARED addr_abs AS _UNSIGNED INTEGER
    SHARED addr_rel AS _UNSIGNED INTEGER
    SHARED fetched AS _UNSIGNED _BYTE
    SHARED cycles AS _UNSIGNED _BYTE



    IF get_flag(cpu_regs.flags.C) = 0 THEN
        cycles = cycles + 1

        addr_abs = cpu_regs.pc + addr_rel

        IF (addr_abs AND &HFF00) <> (cpu_regs.pc AND &HFF00) THEN
            cycles = cycles + 1

        END IF
        cpu_regs.pc = addr_abs


    END IF
END FUNCTION

FUNCTION BCS~%
    SHARED cpu_regs AS regs_6502
    SHARED addr_abs AS _UNSIGNED INTEGER
    SHARED addr_rel AS _UNSIGNED INTEGER
    SHARED fetched AS _UNSIGNED _BYTE
    SHARED cycles AS _UNSIGNED _BYTE


    IF get_flag(cpu_regs.flags.C) = 1 THEN
        cycles = cycles + 1

        addr_abs = cpu_regs.pc + addr_rel

        IF (addr_abs AND &HFF00) <> (cpu_regs.pc AND &HFF00) THEN
            cycles = cycles + 1

        END IF
        cpu_regs.pc = addr_abs


    END IF
END FUNCTION

FUNCTION BEQ~%
    SHARED cpu_regs AS regs_6502
    SHARED addr_abs AS _UNSIGNED INTEGER
    SHARED addr_rel AS _UNSIGNED INTEGER
    SHARED fetched AS _UNSIGNED _BYTE
    SHARED cycles AS _UNSIGNED _BYTE




    IF get_flag(cpu_regs.flags.Z) = 1 THEN
        cycles = cycles + 1

        addr_abs = cpu_regs.pc + addr_rel

        IF (addr_abs AND &HFF00) <> (cpu_regs.pc AND &HFF00) THEN
            cycles = cycles + 1

        END IF
        cpu_regs.pc = addr_abs


    END IF
END FUNCTION




FUNCTION BIT~%
    SHARED cpu_regs AS regs_6502
    SHARED addr_abs AS _UNSIGNED INTEGER
    SHARED addr_rel AS _UNSIGNED INTEGER
    SHARED fetched AS _UNSIGNED _BYTE
    SHARED temp AS _UNSIGNED INTEGER



    fetch

    temp = cpu_regs.a_reg AND fetched
    set_flag cpu_regs.flags.Z, (temp AND &H00FF) = &H00
    set_flag cpu_regs.flags.N, fetched AND _SHL(1, 7)
    set_flag cpu_regs.flags.V, fetched AND _SHL(1, 6)



END FUNCTION

FUNCTION BMI~%
    SHARED cpu_regs AS regs_6502
    SHARED addr_abs AS _UNSIGNED INTEGER
    SHARED addr_rel AS _UNSIGNED INTEGER
    SHARED fetched AS _UNSIGNED _BYTE
    SHARED cycles AS _UNSIGNED _BYTE




    IF get_flag(cpu_regs.flags.N) = 1 THEN
        cycles = cycles + 1

        addr_abs = cpu_regs.pc + addr_rel

        IF (addr_abs AND &HFF00) <> (cpu_regs.pc AND &HFF00) THEN
            cycles = cycles + 1

        END IF
        cpu_regs.pc = addr_abs


    END IF
END FUNCTION

FUNCTION BNE~%
    SHARED cpu_regs AS regs_6502
    SHARED addr_abs AS _UNSIGNED INTEGER
    SHARED addr_rel AS _UNSIGNED INTEGER
    SHARED fetched AS _UNSIGNED _BYTE
    SHARED cycles AS _UNSIGNED _BYTE




    IF get_flag(cpu_regs.flags.Z) = 0 THEN
        cycles = cycles + 1

        addr_abs = cpu_regs.pc + addr_rel

        IF (addr_abs AND &HFF00) <> (cpu_regs.pc AND &HFF00) THEN
            cycles = cycles + 1

        END IF
        cpu_regs.pc = addr_abs


    END IF
END FUNCTION


FUNCTION BPL~%
    SHARED cpu_regs AS regs_6502
    SHARED addr_abs AS _UNSIGNED INTEGER
    SHARED addr_rel AS _UNSIGNED INTEGER
    SHARED fetched AS _UNSIGNED _BYTE
    SHARED cycles AS _UNSIGNED _BYTE




    IF get_flag(cpu_regs.flags.N) = 0 THEN
        cycles = cycles + 1

        addr_abs = cpu_regs.pc + addr_rel

        IF (addr_abs AND &HFF00) <> (cpu_regs.pc AND &HFF00) THEN
            cycles = cycles + 1

        END IF
        cpu_regs.pc = addr_abs


    END IF
END FUNCTION

FUNCTION BRK~%
    SHARED cpu_regs AS regs_6502
    cpu_regs.pc = cpu_regs.pc + 1
    set_flag cpu_regs.flags.I, 1
    write_to_bus &H0100 + cpu_regs.stkp, _SHR(cpu_regs.pc, 8) AND &H00FF
    cpu_regs.stkp = cpu_regs.stkp - 1

    set_flag cpu_regs.flags.B, 1
    write_to_bus &H0100 + cpu_regs.stkp, cpu_reg.status
    cpu_regs.stkp = cpu_regs.stkp - 1
    set_flag cpu_regs.flags.B, 0

    cpu_regs.pc = read_from_bus(&HFFFE) OR _SHL(read_from_bus(&HFFFF), 8)

END FUNCTION


FUNCTION BVC~%
    SHARED cpu_regs AS regs_6502
    SHARED addr_abs AS _UNSIGNED INTEGER
    SHARED addr_rel AS _UNSIGNED INTEGER
    SHARED fetched AS _UNSIGNED _BYTE
    SHARED cycles AS _UNSIGNED _BYTE




    IF get_flag(cpu_regs.flags.V) = 0 THEN
        cycles = cycles + 1

        addr_abs = cpu_regs.pc + addr_rel

        IF (addr_abs AND &HFF00) <> (cpu_regs.pc AND &HFF00) THEN
            cycles = cycles + 1

        END IF
        cpu_regs.pc = addr_abs


    END IF
END FUNCTION



FUNCTION BVS~%
    SHARED cpu_regs AS regs_6502
    SHARED addr_abs AS _UNSIGNED INTEGER
    SHARED addr_rel AS _UNSIGNED INTEGER
    SHARED fetched AS _UNSIGNED _BYTE
    SHARED cycles AS _UNSIGNED _BYTE




    IF get_flag(cpu_regs.flags.V) = 1 THEN
        cycles = cycles + 1

        addr_abs = cpu_regs.pc + addr_rel

        IF (addr_abs AND &HFF00) <> (cpu_regs.pc AND &HFF00) THEN
            cycles = cycles + 1

        END IF
        cpu_regs.pc = addr_abs


    END IF
END FUNCTION
'----------------------------------------------------



'C instructions ---------------------COMPLETE needs testing
FUNCTION CLC~%
    SHARED cpu_regs AS regs_6502

    set_flag cpu_regs.flags.C, 0
END FUNCTION

FUNCTION CLD~%
    SHARED cpu_regs AS regs_6502

    set_flag cpu_regs.flags.D, 0
END FUNCTION

FUNCTION CLI~%
    SHARED cpu_regs AS regs_6502

    set_flag cpu_regs.flags.I, 0
END FUNCTION

FUNCTION CLV~%
    SHARED cpu_regs AS regs_6502

    set_flag cpu_regs.flags.V, 0

END FUNCTION

FUNCTION CMP~%
    SHARED cpu_regs AS regs_6502
    SHARED addr_abs AS _UNSIGNED INTEGER
    SHARED addr_rel AS _UNSIGNED INTEGER
    SHARED fetched AS _UNSIGNED _BYTE
    SHARED temp AS _UNSIGNED INTEGER


    fetch

    temp = cpu_regs.a_reg - fetched
    set_flag cpu_regs.flags.C, cpu_regs.a_reg >= fetched
    set_flag cpu_regs.flags.Z, (temp AND &H00FF) = &H00
    set_flag cpu_regs.flags.N, (temp AND &H0080)


    CMP~% = 1
END FUNCTION


FUNCTION CPX~%
    SHARED cpu_regs AS regs_6502
    SHARED addr_abs AS _UNSIGNED INTEGER
    SHARED addr_rel AS _UNSIGNED INTEGER
    SHARED fetched AS _UNSIGNED _BYTE
    SHARED temp AS _UNSIGNED INTEGER


    fetch

    temp = cpu_regs.x_reg - fetched
    set_flag cpu_regs.flags.C, cpu_regs.a_reg >= fetched
    set_flag cpu_regs.flags.Z, (temp AND &H00FF) = &H00
    set_flag cpu_regs.flags.N, (temp AND &H0080)


    CPX~% = 0
END FUNCTION




FUNCTION CPY~%
    SHARED cpu_regs AS regs_6502
    SHARED addr_abs AS _UNSIGNED INTEGER
    SHARED addr_rel AS _UNSIGNED INTEGER
    SHARED fetched AS _UNSIGNED _BYTE
    SHARED temp AS _UNSIGNED INTEGER


    fetch

    temp = cpu_regs.y_reg - fetched
    set_flag cpu_regs.flags.C, cpu_regs.a_reg >= fetched
    set_flag cpu_regs.flags.Z, (temp AND &H00FF) = &H00
    set_flag cpu_regs.flags.N, (temp AND &H0080)


    CPY~% = 0

END FUNCTION


'---------------------------------------


'D instructions------------------------------COMPLETE needs testing
FUNCTION DEC~%
    SHARED cpu_regs AS regs_6502
    SHARED addr_abs AS _UNSIGNED INTEGER
    SHARED addr_rel AS _UNSIGNED INTEGER
    SHARED fetched AS _UNSIGNED _BYTE
    SHARED temp AS _UNSIGNED INTEGER


    fetch

    temp = fetched - 1
    write_to_bus addr_abs, temp AND &H00FF
    set_flag cpu_regs.flags.Z, (temp AND &H00FF) = &H0000
    set_flag cpu_regs.flags.N, (temp AND &H00FF)
    DEC~% = 0
END FUNCTION

FUNCTION DEX~%
    SHARED cpu_regs AS regs_6502


    cpu_regs.x_reg = cpu_regs.x_reg - 1
    set_flag cpu_regs.flags.Z, cpu_regs.x_reg = &H00

    set_flag cpu_regs.flags.N, cpu_regs.x_reg AND &H80
    DEX~% = 0
END FUNCTION

FUNCTION DEY~%
    SHARED cpu_regs AS regs_6502


    cpu_regs.y_reg = cpu_regs.y_reg - 1
    set_flag cpu_regs.flags.Z, cpu_regs.y_reg = &H00

    set_flag cpu_regs.flags.N, cpu_regs.y_reg AND &H80
    DEY~% = 0
END FUNCTION
'------------------------------------------------






'E instruction-----------------------COMPLETE needs testing
FUNCTION EOR~%
    SHARED cpu_regs AS regs_6502
    SHARED addr_abs AS _UNSIGNED INTEGER
    SHARED addr_rel AS _UNSIGNED INTEGER
    SHARED fetched AS _UNSIGNED _BYTE

    fetch

    cpu_regs.a_reg = cpu_regs.a_reg XOR fetched
    set_flag cpu_regs.flags.Z, cpu_regs.a_reg = &H00
    set_flag cpu_regs.flags.N, cpu_regs.a_reg = &H80

    EOR~% = 1

END FUNCTION


'------------------------------------

'I instruction-----------------------COMPLETE needs testing
FUNCTION INC~%
    SHARED cpu_regs AS regs_6502
    SHARED addr_abs AS _UNSIGNED INTEGER
    SHARED addr_rel AS _UNSIGNED INTEGER
    SHARED fetched AS _UNSIGNED _BYTE
    SHARED temp AS _UNSIGNED INTEGER


    fetch
    temp = fetched + 1
    write_to_bus addr_abs, temp AND &H00FF
    set_flag cpu_regs.flags.Z, (temp AND &H00FF) = &H0000
    set_flag cpu_regs.flags.N, (temp AND &H0080)

    INC~% = 0

END FUNCTION


FUNCTION INX~%
    SHARED cpu_regs AS regs_6502


    cpu_regs.x_reg = cpu_regs.x_reg + 1
    set_flag cpu_regs.flags.Z, cpu_regs.x_reg = &H00

    set_flag cpu_regs.flags.N, cpu_regs.x_reg AND &H80
    INX~% = 0
END FUNCTION

FUNCTION INY~%
    SHARED cpu_regs AS regs_6502


    cpu_regs.y_reg = cpu_regs.y_reg + 1
    set_flag cpu_regs.flags.Z, cpu_regs.y_reg = &H00

    set_flag cpu_regs.flags.N, cpu_regs.y_reg AND &H80
    INY~% = 0
END FUNCTION

'------------------------------------


'J instructions---------------------COMPLETE needs testing

FUNCTION JMP~%
    SHARED cpu_regs AS regs_6502
    SHARED addr_abs AS _UNSIGNED INTEGER
    SHARED addr_rel AS _UNSIGNED INTEGER
    SHARED fetched AS _UNSIGNED _BYTE



    cpu_regs.pc = addr_abs
    JMP~% = 0
END FUNCTION


FUNCTION JSR~%
    SHARED cpu_regs AS regs_6502
    SHARED addr_abs AS _UNSIGNED INTEGER
    SHARED addr_rel AS _UNSIGNED INTEGER
    SHARED fetched AS _UNSIGNED _BYTE



    cpu_regs.pc = cpu_regs.pc - 1
    write_to_bus &H0100 + cpu_regs.stkp, (_SHR(cpu_regs.pc, 8)) AND &H00FF
    cpu_regs.stkp = cpu_regs.stkp - 1
    write_to_bus &H0100 + cpu_regs.stkp, cpu_regs.pc AND &H00FF
    cpu_regs.pc = addr_abs
    JSR~% = 0

END FUNCTION



'-----------------------------------


'L instructions---------------COMPLETE needs testing
FUNCTION LDA~%
    SHARED cpu_regs AS regs_6502
    SHARED addr_abs AS _UNSIGNED INTEGER
    SHARED addr_rel AS _UNSIGNED INTEGER
    SHARED fetched AS _UNSIGNED _BYTE

    fetch
    cpu_regs.a_reg = fetched

    set_flag cpu_regs.flags.Z, cpu_regs.a_reg = &H00

    set_flag cpu_regs.flags.N, cpu_regs.a_reg AND &H80
    LDA~% = 1
END FUNCTION


FUNCTION LDX~%
    SHARED cpu_regs AS regs_6502
    SHARED addr_abs AS _UNSIGNED INTEGER
    SHARED addr_rel AS _UNSIGNED INTEGER
    SHARED fetched AS _UNSIGNED _BYTE

    fetch
    cpu_regs.x_reg = fetched

    set_flag cpu_regs.flags.Z, cpu_regs.x_reg = &H00

    set_flag cpu_regs.flags.N, cpu_regs.x_reg AND &H80
    LDX~% = 1
END FUNCTION

FUNCTION LDY~%
    SHARED cpu_regs AS regs_6502
    SHARED addr_abs AS _UNSIGNED INTEGER
    SHARED addr_rel AS _UNSIGNED INTEGER
    SHARED fetched AS _UNSIGNED _BYTE

    fetch
    cpu_regs.y_reg = fetched

    set_flag cpu_regs.flags.Z, cpu_regs.y_reg = &H00

    set_flag cpu_regs.flags.N, cpu_regs.y_reg AND &H80
    LDY~% = 1
END FUNCTION

FUNCTION LSR~%
    SHARED cpu_regs AS regs_6502
    SHARED addr_abs AS _UNSIGNED INTEGER
    SHARED addr_rel AS _UNSIGNED INTEGER
    SHARED fetched AS _UNSIGNED _BYTE
    SHARED temp AS _UNSIGNED INTEGER


    fetch

    set_flag cpu_regs.flags.C, fetched AND &H0001

    temp = _SHL(fetched, 1)

    set_flag cpu_regs.flags.Z, (temp AND &H00FF) = &H0000
    set_flag cpu_regs.flags.N, temp AND &H0080
    IF addrmode = addr_IMP THEN
        cpu_regs.a_reg = temp AND &H00FF
    ELSE
        write_to_bus addr_abs, temp AND &H00FF

    END IF


    LSR~% = 0
END FUNCTION

'------------------------------


'N instructions-----------COMPLETE needs testing
FUNCTION NOP~%
    SHARED opcode AS _UNSIGNED _BYTE
    opcode = &H00
    SELECT CASE opcode

        CASE &H1C
        CASE &H3C
        CASE &H5C
        CASE &H7C
        CASE &HDC
        CASE &HFC
        CASE ELSE
            '   NOP~% = 1
    END SELECT
    NOP~% = 0
END FUNCTION

'----------------------------


'O instructions------------------COMPLETE needs testing

FUNCTION ORA~%
    SHARED cpu_regs AS regs_6502
    SHARED addr_abs AS _UNSIGNED INTEGER
    SHARED addr_rel AS _UNSIGNED INTEGER
    SHARED fetched AS _UNSIGNED _BYTE

    fetch

    cpu_regs.a_reg = cpu_regs.a_reg OR fetched

    set_flag cpu_regs.flags.Z, cpu_regs.a_reg = &H00
    set_flag cpu_regs.flags.N, cpu_regs.a_reg AND &H80


    ORA~% = 1
END FUNCTION

'--------------------------------


'P instructions----------------------COMPLETE needs testing

FUNCTION PHA~%
    SHARED cpu_regs AS regs_6502
    write_to_bus &H0100 + cpu_regs.stkp, cpu_regs.a_reg
    cpu_regs.stkp = cpu_regs.stkp - 1

END FUNCTION


FUNCTION PHP~%
    SHARED cpu_regs AS regs_6502

    write_to_bus &H0100 + cpu_regs.stkp, cpu_regs.status OR cpu_regs.flags.B OR cpu_regs.flags.U
    set_flag cpu_regs.flags.B, 0
    set_flag cpu_regs.flags.U, 0
    cpu_regs.stkp = cpu_regs.stkp - 1
    PHP~% = 0

END FUNCTION




FUNCTION PLA~%
    SHARED cpu_regs AS regs_6502

    cpu_regs.stkp = cpu_regs.stkp + 1
    cpu_regs.a_reg = read_from_bus(&H0100 + cpu_regs.stkp)
    set_flag cpu_regs.flags.Z, cpu_regs.a_reg = &H00
    set_flag cpu_regs.flags.N, cpu_regs.a_reg AND &H80
    PLA~% = 0


END FUNCTION


FUNCTION PLP~%
    SHARED cpu_regs AS regs_6502

    cpu_regs.stkp = cpu_regs.stkp + 1
    cpu_regs.status = read_from_bus(&H0100 + cpu_regs.stkp)
    set_flag cpu_regs.flags.U, 1
    PLP~% = 0


END FUNCTION







'-----------------------------------



'R instructions----------------------COMPLETE needs testing





FUNCTION ROL~%
    SHARED cpu_regs AS regs_6502
    SHARED addr_abs AS _UNSIGNED INTEGER
    SHARED addr_rel AS _UNSIGNED INTEGER
    SHARED fetched AS _UNSIGNED _BYTE
    SHARED temp AS _UNSIGNED INTEGER



    fetch
    temp = _SHL(fetched, 1) OR get_flag(cpu_regs.flags.C)
    set_flag cpu_regs.flags.C, (temp AND &HFF00)
    set_flag cpu_regs.flags.Z, (temp AND &H00FF) = &H0000
    set_flag cpu_regs.flags.N, (temp AND &H0080)

    IF addrmode = addr_IMP THEN
        cpu_regs.a_reg = temp AND &H00FF
    ELSE
        write_to_bus addr_abs, temp AND &H00FF
    END IF


END FUNCTION


FUNCTION ROR~%
    SHARED cpu_regs AS regs_6502
    SHARED addr_abs AS _UNSIGNED INTEGER
    SHARED addr_rel AS _UNSIGNED INTEGER
    SHARED fetched AS _UNSIGNED _BYTE
    SHARED temp AS _UNSIGNED INTEGER


    fetch
    temp = _SHL(get_flag(cpu_regs.flags.C), 7) OR _SHR(fetched, 1)
    set_flag cpu_regs.flags.C, (temp AND &H01)
    set_flag cpu_regs.flags.Z, (temp AND &H00FF) = &H0000
    set_flag cpu_regs.flags.N, (temp AND &H0080)

    IF addrmode = addr_IMP THEN
        cpu_regs.a_reg = temp AND &H00FF
    ELSE
        write_to_bus addr_abs, temp AND &H00FF
    END IF



END FUNCTION




FUNCTION RTI~%
    SHARED cpu_regs AS regs_6502



    cpu_regs.stkp = cpu_regs.stkp + 1
    cpu_regs.status = read_from_bus(&H0100 + cpu_regs.stkp)
    cpu_regs.status = cpu_regs.status NOT cpu_regs.flags.B
    cpu_regs.status = cpu_regs.status NOT cpu_regs.flags.U

    cpu_regs.stkp = cpu_regs.stkp + 1
    cpu_regs.pc = read_from_bus(&H0100 + cpu_regs.stkp)
    cpu_regs.stkp = cpu_regs.stkp + 1
    cpu_regs.pc = cpu_regs.pc OR _SHL(read_from_bus(&H0100 + cpu_regs.stkp), 8)
    RTI~% = 0

END FUNCTION


FUNCTION RTS~%
    SHARED cpu_regs AS regs_6502


    cpu_regs.stkp = cpu_regs.stkp + 1
    pc = read_from_bus(&H0100 + cpu_regs.stkp)
    cpu_regs.stkp = cpu_regs.stkp + 1
    pc = pc OR _SHL(read_from_bus(&H0100 + cpu_regs.stkp), 8)


    cpu_regs.pc = cpu_regs.pc + 1

    RTS~% = 0
END FUNCTION







'-----------------------------------


'S instructions----------------------COMPLETE needs testing

FUNCTION SEC~%
    SHARED cpu_regs AS regs_6502

    set_flag cpu_regs.flags.C, 1
END FUNCTION


FUNCTION SEI~%
    SHARED cpu_regs AS regs_6502

    set_flag cpu_regs.flags.I, 1
END FUNCTION

FUNCTION SED~%
    SHARED cpu_regs AS regs_6502

    set_flag cpu_regs.flags.D, 1
END FUNCTION

FUNCTION STA~%
    SHARED cpu_regs AS regs_6502
    SHARED addr_abs AS _UNSIGNED INTEGER
    SHARED addr_rel AS _UNSIGNED INTEGER
    SHARED fetched AS _UNSIGNED _BYTE



    write_to_bus addr_abs, cpu_regs.a_reg

END FUNCTION

FUNCTION STX~%
    SHARED cpu_regs AS regs_6502

    write_to_bus addr_abs, cpu_regs.x_reg
END FUNCTION

FUNCTION STY~%
    SHARED cpu_regs AS regs_6502
    SHARED addr_abs AS _UNSIGNED INTEGER
    SHARED addr_rel AS _UNSIGNED INTEGER
    SHARED fetched AS _UNSIGNED _BYTE


    write_to_bus addr_abs, cpu_regs.y_reg
END FUNCTION

'-------------------------------------






'T instructions-------------------------------------COMPLETE needs testing
FUNCTION TAX%
    SHARED cpu_regs AS regs_6502
    cpu_regs.x_reg = cpu_regs.a_reg


    set_flag cpu_regs.flags.Z, cpu_regs.x_reg = &H00
    set_flag cpu_regs.flags.N, cpu_regs.x_reg AND &H80

END FUNCTION

FUNCTION TAY%
    SHARED cpu_regs AS regs_6502
    cpu_regs.y_reg = cpu_regs.a_reg


    set_flag cpu_regs.flags.Z, cpu_regs.y_reg = &H00
    set_flag cpu_regs.flags.N, cpu_regs.y_reg AND &H80

END FUNCTION


FUNCTION TSX%
    SHARED cpu_regs AS regs_6502
    cpu_regs.x_reg = cpu_regs.stkp


    set_flag cpu_regs.flags.Z, cpu_regs.x_reg = &H00
    set_flag cpu_regs.flags.N, cpu_regs.x_reg AND &H80

END FUNCTION






FUNCTION TXA~%
    SHARED cpu_regs AS regs_6502
    cpu_regs.a_reg = cpu_regs.x_reg


    set_flag cpu_regs.flags.Z, cpu_regs.a_reg = &H00
    set_flag cpu_regs.flags.N, cpu_regs.a_reg AND &H80

END FUNCTION





FUNCTION TXS~%
    SHARED cpu_regs AS regs_6502

    cpu_regs.stkp = cpu_regs.x_reg
END FUNCTION


FUNCTION TYA~%
    SHARED cpu_regs AS regs_6502
    cpu_regs.a_reg = cpu_regs.y_reg


    set_flag cpu_regs.flags.Z, cpu_regs.a_reg = &H00
    set_flag cpu_regs.flags.N, cpu_regs.a_reg AND &H80

END FUNCTION

'---------------------------------------------------------



'NOP------------------------------------------------------COMPLETE needs testing
FUNCTION XXX~%

END FUNCTION

'-------------------------------------













FUNCTION complete
    SHARED cycles AS _UNSIGNED _BYTE

    complete = (cycles = 0)
END FUNCTION



SUB set_flag (f AS _UNSIGNED _BYTE, b AS _UNSIGNED _BYTE)
    SHARED cpu_regs AS regs_6502
    IF b = 1 THEN
        cpu_regs.status = cpu_regs.status OR f
    ELSE
        cpu_regs.status = cpu_regs.status AND NOT f


    END IF


END SUB



FUNCTION get_flag (f AS _UNSIGNED _BYTE)
    SHARED cpu_regs AS regs_6502

    IF cpu_regs.status AND f THEN
        get_flag = 1
    ELSE
        get_flag = 0
    END IF

END FUNCTION


'move to different file
FUNCTION BIN$ (n%)
    max% = 8 * LEN(n%) ': MSB% = 1   'uncomment for 16 (32 or 64) bit returns
    FOR i = max% - 1 TO 0 STEP -1 'read as big-endian MSB to LSB
        IF (n% AND 2 ^ i) THEN MSB% = 1: B$ = B$ + "1" ELSE IF MSB% THEN B$ = B$ + "0"
    NEXT
    IF B$ = "" THEN BIN$ = "0" ELSE BIN$ = B$ 'check for empty string
END FUNCTION


