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
DIM SHARED add__mode_ZPO AS _UNSIGNED _BYTE
DIM SHARED addr_mode_ZPY AS _UNSIGNED _BYTE
DIM SHARED addr_mode_ABS AS _UNSIGNED _BYTE
DIM SHARED addr_mode_ABY AS _UNSIGNED _BYTE
DIM SHARED addr_mode_IZX AS _UNSIGNED _BYTE
DIM SHARED addr_mode_IMM AS _UNSIGNED _BYTE
DIM SHARED addr_mode_REL AS _UNSIGNED _BYTE
DIM SHARED addr_mode_ABX AS _UNSIGNED _BYTE
DIM SHARED addr_mode_IND AS _UNSIGNED _BYTE
DIM SHARED addr_mode_IZY AS _UNSIGNED _BYTE
DIM SHARED addr_mode_ZPX AS _UNSIGNED _BYTE




addr_mode_IMP = 0
add__mode_ZPO = 1
add__mode_ZPY = 2
add__mode_ABS = 3
add__mode_ABY = 4
add__mode_IZX = 5
add__mode_IMM = 6
add__mode_REL = 7
add__mode_ABX = 8
addr_mode_IND = 9
addr_mode_IZY = 10
addr_mode_ZPX = 11




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


DIM SHARED instructions(255) AS OPS


FOR i = 0 TO 0 ' - 1
    READ instructions(i).op_name, instructions(i).addrmode, instructions(i).cycles
NEXT i






''6502 instruction set with addresses and cycles
DATA "BRK",6,7,"ORA",addr_mode_IZX,6,"???",addr_mode_IMP,2,"???",addr_mode_IMP,8,"???",addr_mode_IMP,3,"ORA",addr_mode_ZPO,3,"ASL",addr_mode_ZPO,5,"???",addr_mode_IMP,5
DATA "PHP",addr_mode_IMP,3,"ORA",addr_mode_IMM,2,"ASL",addr_mode_IMP,2,"???",addr_mode_IMP,2,"???",addr_mode_IMP,4,"ORA",addr_mode_ABS,4,"ASL",addr_mode_ABS,6,"???",addr_mode_IMP,6
DATA "BPL",addr_mode_REL,2,"ORA",addr_mode_IZY,5,"???",addr_mode_IMP,2,"???",addr_mode_IMP,8,"???",addr_mode_IMP,4,"ORA",addr_mode_ZPX,4,"ASL",addr_mode_ZPX,6,"???",addr_mode_IMP,6
DATA "CLC",addr_mode_IMP,2,"ORA",addr_mode_ABY,4,"???",addr_mode_IMP,2,"???",addr_mode_IMP,7,"???",addr_mode_IMP,4,"ORA",addr_mode_ABX,4,"ASL",addr_mode_ABX,7,"???",addr_mode_IMP,7
DATA "JSR",addr_mode_ABS,6,"AND",addr_mode_IZX,6,"???",addr_mode_IMP,2,"???",addr_mode_IMP,8,"BIT",addr_mode_ZPO,3,"AND",addr_mode_ZPO,3,"ROL",addr_mode_ZPO,5,"???",addr_mode_IMP,5
DATA "PLP",addr_mode_IMP,4,"AND",addr_mode_IMM,2,"ROL",addr_mode_IMP,2,"???",addr_mode_IMP,2,"BIT",addr_mode_ABS,4,"AND",addr_mode_ABS,4,"ROL",addr_mode_ABS,6,"???",addr_mode_IMP,6
DATA "BMI",addr_mode_REL,2,"AND",addr_mode_IZY,5,"???",addr_mode_IMP,2,"???",addr_mode_IMP,8,"???",addr_mode_IMP,4,"AND",addr_mode_ZPX,4,"ROL",addr_mode_ZPX,6,"???",addr_mode_IMP,6
DATA "SEC",addr_mode_IMP,2,"AND",addr_mode_ABY,4,"???",addr_mode_IMP,2,"???",addr_mode_IMP,7,"???",addr_mode_IMP,4,"AND",addr_mode_ABX,4,"ROL",addr_mode_ABX,7,"???",addr_mode_IMP,7
DATA "RTI",addr_mode_IMP,6,"EOR",addr_mode_IZX,6,"???",addr_mode_IMP,2,"???",addr_mode_IMP,8,"???",addr_mode_IMP,3,"EOR",addr_mode_ZPO,3,"LSR",addr_mode_ZPO,5,"???",addr_mode_IMP,5
DATA "PHA",addr_mode_IMP,3,"EOR",addr_mode_IMM,2,"LSR",addr_mode_IMP,2,"???",addr_mode_IMP,2,"JMP",addr_mode_ABS,3,"EOR",addr_mode_ABS,4,"LSR",addr_mode_ABS,6,"???",addr_mode_IMP,6
DATA "BVC",addr_mode_REL,2,"EOR",addr_mode_IZY,5,"???",addr_mode_IMP,2,"???",addr_mode_IMP,8,"???",addr_mode_IMP,4,"EOR",addr_mode_ZPX,4,"LSR",addr_mode_ZPX,6,"???",addr_mode_IMP,6
DATA "CLI",addr_mode_IMP,2,"EOR",addr_mode_ABY,4,"???",addr_mode_IMP,2,"???",addr_mode_IMP,7,"???",addr_mode_IMP,4,"EOR",addr_mode_ABX,4,"LSR",addr_mode_ABX,7,"???",addr_mode_IMP,7
DATA "RTS",addr_mode_IMP,6,"ADC",addr_mode_IZX,6,"???",addr_mode_IMP,2,"???",addr_mode_IMP,8,"???",addr_mode_IMP,3,"ADC",addr_mode_ZPO,3,"ROR",addr_mode_ZPO,5,"???",addr_mode_IMP,5
DATA "PHP",addr_mode_IMP,3,"ORA",addr_mode_IMM,2,"ASL",addr_mode_IMP,2,"???",addr_mode_IMP,2,"???",addr_mode_IMP,4,"ORA",addr_mode_ABS,4,"ASL",addr_mode_ABS,6,"???",addr_mode_IMP,6
DATA "BVS",addr_mode_REL,2,"ADC",addr_mode_IZY,5,"???",addr_mode_IMP,2,"???",addr_mode_IMP,8,"???",addr_mode_IMP,4,"ADC",addr_mode_ZPX,4,"ROR",addr_mode_ZPX,6,"???",addr_mode_IMP,6
DATA "SEI",addr_mode_IMP,2,"ADC",addr_mode_ABY,4,"???",addr_mode_IMP,2,"???",addr_mode_IMP,7,"???",addr_mode_IMP,4,"ADC",addr_mode_ABX,4,"ROR",addr_mode_ABX,7,"???",addr_mode_IMP,7
DATA "???",addr_mode_IMP,2,"STA",addr_mode_IZX,6,"???",addr_mode_IMP,2,"???",addr_mode_IMP,6,"STY",addr_mode_ZPO,3,"STA",addr_mode_ZPO,3,"STX",addr_mode_ZPO,3,"???",addr_mode_IMP,3
DATA "DEY",addr_mode_IMP,2,"???",addr_mode_IMP,2,"TXA",addr_mode_IMP,2,"???",addr_mode_IMP,2,"STY",addr_mode_ABS,4,"STA",addr_mode_ABS,4,"STX",addr_mode_ABS,4,"???",addr_mode_IMP,4
DATA "BCC",addr_mode_REL,2,"STA",addr_mode_IZY,6,"???",addr_mode_IMP,2,"???",addr_mode_IMP,6,"STY",addr_mode_ZPX,4,"STA",addr_mode_ZPX,4,"STX",addr_mode_ZPY,4,"???",addr_mode_IMP,4
DATA "TYA",addr_mode_IMP,2,"STA",addr_mode_ABY,5,"TXS",addr_mode_IMP,2,"???",addr_mode_IMP,5,"???",addr_mode_IMP,5,"STA",addr_mode_ABX,5,"???",addr_mode_IMP,5,"???",addr_mode_IMP,5
DATA "LDY",addr_mode_IMM,2,"LDA",addr_mode_IZX,6,"LDX",addr_mode_IMM,2,"???",addr_mode_IMP,6,"LDY",addr_mode_ZPO,3,"LDA",addr_mode_ZPO,3,"LDX",addr_mode_ZPO,3,"???",addr_mode_IMP,3
DATA "TAY",addr_mode_IMP,2,"LDA",addr_mode_IMM,2,"TAX",addr_mode_IMP,2,"???",addr_mode_IMP,2,"LDY",addr_mode_ABS,4,"LDA",addr_mode_ABS,4,"LDX",addr_mode_ABS,4,"???",addr_mode_IMP,4
DATA "BCS",addr_mode_REL,2,"LDA",addr_mode_IZY,5,"???",addr_mode_IMP,2,"???",addr_mode_IMP,5,"LDY",addr_mode_ZPX,4,"LDA",addr_mode_ZPX,4,"LDX",addr_mode_ZPY,4,"???",addr_mode_IMP,4
DATA "CLV",addr_mode_IMP,2,"ORA",addr_mode_IMM,2,"ASL",addr_mode_IMP,2,"???",addr_mode_IMP,2,"???",addr_mode_IMP,4,"ORA",addr_mode_ABS,4,"ASL",addr_mode_ABS,6,"???",addr_mode_IMP,6
DATA "CPY",addr_mode_IMM,2,"CMP",addr_mode_IZX,6,"???",addr_mode_IMP,2,"???",addr_mode_IMP,8,"CPY",addr_mode_ZPO,3,"CMP",addr_mode_ZPO,3,"DEC",addr_mode_ZPO,5,"???",addr_mode_IMP,5
DATA "INY",addr_mode_IMP,2,"CMP",addr_mode_IMM,2,"DEX",addr_mode_IMP,2,"???",addr_mode_IMP,2,"CPY",addr_mode_ABS,4,"CMP",addr_mode_ABS,4,"DEC",addr_mode_ABS,6,"???",addr_mode_IMP,6
DATA "BNE",addr_mode_REL,2,"CMP",addr_mode_IZY,5,"???",addr_mode_IMP,2,"???",addr_mode_IMP,8,"???",addr_mode_IMP,4,"CMP",addr_mode_ZPX,4,"DEC",addr_mode_ZPX,4,"???",addr_mode_IMP,6
DATA "CLD",addr_mode_IMP,2,"CMP",addr_mode_ABY,4,"NOP",addr_mode_IMP,2,"???",addr_mode_IMP,7,"???",addr_mode_IMP,4,"CMP",addr_mode_ABX,4,"DEC",addr_mode_ABX,7,"???",addr_mode_IMP,7
DATA "CPX",addr_mode_IMM,2,"SBC",addr_mode_IZX,6,"???",addr_mode_IMP,2,"???",addr_mode_IMP,8,"CPX",addr_mode_ZPO,3,"SBC",addr_mode_ZPO,3,"INC",addr_mode_ZPO,5,"???",addr_mode_IMP,5
DATA "INX",addr_mode_IMP,2,"SBC",addr_mode_IMM,2,"NOP",addr_mode_IMP,2,"???",addr_mode_IMP,2,"CPX",addr_mode_ABS,4,"SBC",addr_mode_ABS,4,"INC",addr_mode_ABS,6,"???",addr_mode_IMP,6
DATA "BEQ",addr_mode_REL,2,"SBC",addr_mode_IZY,5,"???",addr_mode_IMP,2,"???",addr_mode_IMP,8,"???",addr_mode_IMP,4,"SBC",addr_mode_ZPX,4,"INC",addr_mode_ZPX,6,"???",addr_mode_IMP,6
DATA "SED",addr_mode_IMP,2,"SBC",addr_mode_ABY,4,"NOP",addr_mode_IMP,2,"???",addr_mode_IMP,7,"???",addr_mode_ABX,4,"SBC",addr_mode_ABS,4,"INC",addr_mode_ABX,7,"???",addr_mode_IMP,7







''6502 instruction set
'DATA "BRK","ORA","???","???","???","ORA","ASL","???","PHP","ORA","ASL","???","???","ORA","ASL","???"
'DATA "BPL","ORA","???","???","???","ORA","ASL","???","CLC","ORA","???","???","???","ORA","ASL","???"
'DATA "JSR","AND","???","???","BIT","AND","ROL","???","PLP","AMD","ROL","???","BIT","AND","ROL","???"
'DATA "BMI","AND","???","???","???","AND","ROL","???","SEC","AND","???","???","???","AND","ROL","???"
'DATA "RTI","EOR","???","???","???","EOR","LSR","???","PHA","EOR","ROR","???","JMP","EOR","LSR","???"
'DATA "BVC","EOR","???","???","???","EOR","LSR","???","CLI","EOR","???","???","???","EOR","LSR","???"
'DATA "RTS","ADC","???","???","???","ADC","ROR","???","PLA","ADC","TXA","???","JMP","ADC","ROR","???"
'DATA "BVS","ADC","???","???","???","ADC","ROR","???","SEI","ADC","TXS","???","???","ADC","ROR","???"
'DATA "???","STA","???","???","STY","STA","STX","???","DEY","???","TXA","???","STY","STA","STX","???"
'DATA "BCC","STA","???","???","STY","STA","STX","???","TYA","STA","TSX","???","???","STA","???","???"
'DATA "LDY","LDA","LDX","???","LDY","LDA","LDX","???","TAY","LDA","TAX","???","LDY","LDA","LDX","???"
'DATA "BCS","LDA","???","???","LDY","LDA","LDX","???","CLV","LDA","TSX","???","LDY","LDA","LDX","???"
'DATA "CPY","CMP","???","???","CPY","CMP","DEC","???","INY","CMP","DEX","???","CPY","CMP","DEC","???"
'DATA "BNE","CMP","???","???","???","CMP","DEC","???","CLD","CMP","NOP","???","???","CMP","DEC","???"
'DATA "CPX","SBC","???","???","CPX","SBC","INC","???","INX","SBC","NOP","???","CPX","SBC","INC","???"
'DATA "BEQ","SBC","???","???","???","SBC","INC","???","SED","SBC","NOP","???","???","SBC","INC","???"





',"???","???","???","ORA","ASL","???","PHP","ORA","ASL","???","???","ORA","ASL","???"
'DATA "BPL","ORA","???","???","???","ORA","ASL","???","CLC","ORA","???","???","???","ORA","ASL","???"
'DATA "JSR","AND","???","???","BIT","AND","ROL","???","PLP","AMD","ROL","???","BIT","AND","ROL","???"
'DATA "BMI","AND","???","???","???","AND","ROL","???","SEC","AND","???","???","???","AND","ROL","???"
'DATA "RTI","EOR","???","???","???","EOR","LSR","???","PHA","EOR","ROR","???","JMP","EOR","LSR","???"
'DATA "BVC","EOR","???","???","???","EOR","LSR","???","CLI","EOR","???","???","???","EOR","LSR","???"
'DATA "RTS","ADC","???","???","???","ADC","ROR","???","PLA","ADC","TXA","???","JMP","ADC","ROR","???"
'DATA "BVS","ADC","???","???","???","ADC","ROR","???","SEI","ADC","TXS","???","???","ADC","ROR","???"
'DATA "???","STA","???","???","STY","STA","STX","???","DEY","???","TXA","???","STY","STA","STX","???"
'DATA "BCC","STA","???","???","STY","STA","STX","???","TYA","STA","TSX","???","???","STA","???","???"
'DATA "LDY","LDA","LDX","???","LDY","LDA","LDX","???","TAY","LDA","TAX","???","LDY","LDA","LDX","???"
'DATA "BCS","LDA","???","???","LDY","LDA","LDX","???","CLV","LDA","TSX","???","LDY","LDA","LDX","???"
'DATA "CPY","CMP","???","???","CPY","CMP","DEC","???","INY","CMP","DEX","???","CPY","CMP","DEC","???"
'DATA "BNE","CMP","???","???","???","CMP","DEC","???","CLD","CMP","NOP","???","???","CMP","DEC","???"
'DATA "CPX","SBC","???","???","CPX","SBC","INC","???","INX","SBC","NOP","???","CPX","SBC","INC","???"
'DATA "BEQ","SBC","???","???","???","SBC","INC","???","SED","SBC","NOP","???","???","SBC","INC","???"


REM  '$include: 'olc6502.bm'


