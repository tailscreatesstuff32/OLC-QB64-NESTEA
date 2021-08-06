
'fully added mappers///////////

'TODO mapper 66 originally for dragonball shen long no nazo?

'$include: 'mapper_000.bi'
'$include: 'mapper_002.bi'
'$include: 'mapper_003.bi'
'$include: 'mapper_066.bi'
'//////////////////////////////


'partially added mappers///////
REM'$include: 'mapper_001.bi'
'$include: 'mapper_004.bi'
'//////////////////////////////



'future mappers////////////////
'mapper 34 mainly for dragonball shen long no nazo
'mapper 65 mainly for tetris

REM '$include: 'mapper_034.bi'
REM '$include: 'mapper_065.bi'
'///////////////////////////////

TYPE sHeader

    name_nes AS STRING * 4
    prg_rom_chunks AS _UNSIGNED _BYTE
    chr_rom_chunks AS _UNSIGNED _BYTE
    mapper1 AS _UNSIGNED _BYTE
    mapper2 AS _UNSIGNED _BYTE
    prg_ram_size AS _UNSIGNED _BYTE
    tv_system1 AS _UNSIGNED _BYTE
    tv_system2 AS _UNSIGNED _BYTE
    unused AS STRING * 5

END TYPE


DIM SHARED header AS sHeader
DIM SHARED bImageValid AS _BYTE
REDIM SHARED vPRGMemory(0) AS _UNSIGNED _BYTE
REDIM SHARED vCHRMemory(0) AS _UNSIGNED _BYTE
DIM SHARED nMapperID AS _UNSIGNED _BYTE









