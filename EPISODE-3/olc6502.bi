'6502 core registers

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
    pc AS _UNSIGNED INTEGER
    status AS _UNSIGNED _BYTE
    flags AS FLAGS_6502
END TYPE

TYPE OPS
    op_name AS STRING
    addrmode AS _UNSIGNED _BYTE
    cycles AS _UNSIGNED _BYTE

END TYPE


DIM SHARED addr_mode_IMP AS _UNSIGNED _BYTE
DIM SHARED add_mode_ZPO AS _UNSIGNED _BYTE
DIM SHARED add_mode_ZPY AS _UNSIGNED _BYTE
DIM SHARED add_mode_ABS AS _UNSIGNED _BYTE
DIM SHARED add_mode_ABY AS _UNSIGNED _BYTE
DIM SHARED add_mode_IZX AS _UNSIGNED _BYTE
DIM SHARED add_mode_IMM AS _UNSIGNED _BYTE
DIM SHARED add_mode_REL AS _UNSIGNED _BYTE
DIM SHARED add_mode_ABX AS _UNSIGNED _BYTE
DIM SHARED addr_mode_IND AS _UNSIGNED _BYTE
DIM SHARED addr_mode_IZY AS _UNSIGNED _BYTE
DIM SHARED addr_mode_ZPX AS _UNSIGNED _BYTE

DIM SHARED cpu_regs AS regs_6502

DIM SHARED addr_abs AS _UNSIGNED INTEGER
DIM SHARED addr_rel AS _UNSIGNED INTEGER
DIM SHARED fetched AS _UNSIGNED _BYTE
DIM SHARED opcode AS _UNSIGNED _BYTE
DIM SHARED temp AS _UNSIGNED INTEGER
DIM SHARED cycles AS _UNSIGNED _BYTE
DIM SHARED clock_cycles AS _UNSIGNED LONG
DIM SHARED hi AS _UNSIGNED INTEGER
DIM SHARED lo AS _UNSIGNED INTEGER



cpu_regs.flags.C = _SHL(1, 0)
cpu_regs.flags.Z = _SHL(1, 1)
cpu_regs.flags.I = _SHL(1, 2)
cpu_regs.flags.D = _SHL(1, 3)
cpu_regs.flags.B = _SHL(1, 4)
cpu_regs.flags.U = _SHL(1, 5)
cpu_regs.flags.V = _SHL(1, 6)
cpu_regs.flags.N = _SHL(1, 7)


addr_mode_IMP = 0
add_mode_ZPO = 1
add_mode_ZPY = 2
add_mode_ABS = 3
add_mode_ABY = 4
add_mode_IZX = 5
add_mode_IMM = 6
add_mode_REL = 7
add_mode_ABX = 8
addr_mode_IND = 9
addr_mode_IZY = 10
addr_mode_ZPX = 11







DIM SHARED instructions(255) AS OPS


FOR i = 0 TO 255 ' - 1
    READ instructions(i).op_name, instructions(i).addrmode, instructions(i).cycles
NEXT i


''6502 instruction set with addresses and cycles-FIXED for now!
DATA "BRK",6,7,"ORA",5,6,"???",0,2,"???",0,8,"???",0,3,"ORA",1,3,"ASL",1,5,"???",0,5
DATA "PHP",0,3,"ORA",6,2,"ASL",0,2,"???",0,2,"???",0,4,"ORA",3,4,"ASL",3,6,"???",0,6
DATA "BPL",7,2,"ORA",10,5,"???",0,2,"???",0,8,"???",0,4,"ORA",11,4,"ASL",11,6,"???",0,6
DATA "CLC",0,2,"ORA",4,4,"???",0,2,"???",0,7,"???",0,4,"ORA",8,4,"ASL",8,7,"???",0,7
DATA "JSR",3,6,"AND",5,6,"???",0,2,"???",0,8,"BIT",1,3,"AND",1,3,"ROL",1,5,"???",0,5
DATA "PLP",0,4,"AND",6,2,"ROL",0,2,"???",0,2,"BIT",3,4,"AND",3,4,"ROL",3,6,"???",0,6
DATA "BMI",7,2,"AND",10,5,"???",0,2,"???",0,8,"???",0,4,"AND",11,4,"ROL",11,6,"???",0,6
DATA "SEC",0,2,"AND",4,4,"???",0,2,"???",0,7,"???",0,4,"AND",8,4,"ROL",8,7,"???",0,7
DATA "RTI",0,6,"EOR",5,6,"???",0,2,"???",0,8,"???",0,3,"EOR",1,3,"LSR",1,5,"???",0,5
DATA "PHA",0,3,"EOR",6,2,"LSR",0,2,"???",0,2,"JMP",3,3,"EOR",3,4,"LSR",3,6,"???",0,6
DATA "BVC",7,2,"EOR",10,5,"???",0,2,"???",0,8,"???",0,4,"EOR",11,4,"LSR",11,6,"???",0,6
DATA "CLI",0,2,"EOR",4,4,"???",0,2,"???",0,7,"???",0,4,"EOR",8,4,"LSR",8,7,"???",0,7
DATA "RTS",0,6,"ADC",5,6,"???",0,2,"???",0,8,"???",0,3,"ADC",1,3,"ROR",1,5,"???",0,5
DATA "PLA",0,4,"ADC",6,2,"ROR",0,2,"???",0,2,"JMP",9,5,"ADC",3,4,"ROR",3,6,"???",0,6
DATA "BVS",7,2,"ADC",10,5,"???",0,2,"???",0,8,"???",0,4,"ADC",11,4,"ROR",11,6,"???",0,6
DATA "SEI",0,2,"ADC",4,4,"???",0,2,"???",0,7,"???",0,4,"ADC",8,4,"ROR",8,7,"???",0,7
DATA "???",0,2,"STA",5,6,"???",0,2,"???",0,6,"STY",1,3,"STA",1,3,"STX",1,3,"???",0,3
DATA "DEY",0,2,"???",0,2,"TXA",0,2,"???",0,2,"STY",3,4,"STA",3,4,"STX",3,4,"???",0,4
DATA "BCC",7,2,"STA",10,6,"???",0,2,"???",0,6,"STY",11,4,"STA",11,4,"STX",2,4,"???",0,4
DATA "TYA",0,2,"STA",4,5,"TXS",0,2,"???",0,5,"???",0,5,"STA",8,5,"???",0,5,"???",0,5
DATA "LDY",6,2,"LDA",5,6,"LDX",6,2,"???",0,6,"LDY",1,3,"LDA",1,3,"LDX",1,3,"???",0,3
DATA "TAY",0,2,"LDA",6,2,"TAX",0,2,"???",0,2,"LDY",3,4,"LDA",3,4,"LDX",3,4,"???",0,4
DATA "BCS",7,2,"LDA",10,5,"???",0,2,"???",0,5,"LDY",11,4,"LDA",11,4,"LDX",2,4,"???",0,4
DATA "CLV",0,2,"LDA",4,4,"TSX",0,2,"???",0,4,"LDY",8,4,"LDA",8,4,"LDX",4,4,"???",0,4
DATA "CPY",6,2,"CMP",5,6,"???",0,2,"???",0,8,"CPY",1,3,"CMP",1,3,"DEC",1,5,"???",0,5
DATA "INY",0,2,"CMP",6,2,"DEX",0,2,"???",0,2,"CPY",3,4,"CMP",3,4,"DEC",3,6,"???",0,6
DATA "BNE",7,2,"CMP",10,5,"???",0,2,"???",0,8,"???",0,4,"CMP",11,4,"DEC",11,6,"???",0,6
DATA "CLD",0,2,"CMP",4,4,"NOP",0,2,"???",0,7,"???",0,4,"CMP",8,4,"DEC",8,7,"???",0,7
DATA "CPX",6,2,"SBC",5,6,"???",0,2,"???",0,8,"CPX",1,3,"SBC",1,3,"INC",1,5,"???",0,5
DATA "INX",0,2,"SBC",6,2,"NOP",0,2,"???",0,2,"CPX",3,4,"SBC",3,4,"INC",3,6,"???",0,6
DATA "BEQ",7,2,"SBC",10,5,"???",0,2,"???",0,8,"???",0,4,"SBC",11,4,"INC",11,6,"???",0,6
DATA "SED",0,2,"SBC",4,4,"NOP",0,2,"???",0,7,"???",0,4,"SBC",8,4,"INC",8,7,"???",0,7





REM  '$include: 'olc6502.bm'


