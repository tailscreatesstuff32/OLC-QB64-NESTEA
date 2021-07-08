''$include: 'mapper_000.bi'






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
DIM SHARED pMapper AS _UNSIGNED LONG

REDIM SHARED vPRGMemory(0) AS _UNSIGNED _BYTE
REDIM SHARED vCHRMemory(0) AS _UNSIGNED _BYTE
DIM SHARED nMapperID AS _UNSIGNED _BYTE
'DIM SHARED nPRGBanks AS _UNSIGNED _BYTE
'DIM SHARED nCHRBanks AS _UNSIGNED _BYTE










