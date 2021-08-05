'$INCLUDE: 'olc6502.bi'
'$INCLUDE: 'olc2C02.bi'
'$INCLUDE: 'olc2A03.bi'
'$include: 'cartridge.bi'


DIM SHARED nSystemClockCounter AS _UNSIGNED LONG
DIM SHARED cpuRam(2048) AS _UNSIGNED _BYTE
DIM mema AS _MEM


mema = _MEM(cpuRam())
_MEMFILL mema, mema.OFFSET, mema.SIZE, &H00 AS _UNSIGNED INTEGER
_MEMFREE mema
DIM SHARED called1 AS _UNSIGNED LONG
DIM SHARED controller(2) AS _UNSIGNED _BYTE
DIM SHARED controller_state(2) AS _UNSIGNED _BYTE

'cpuRam(0) = &H01
'cpuRam(1) = &H03


