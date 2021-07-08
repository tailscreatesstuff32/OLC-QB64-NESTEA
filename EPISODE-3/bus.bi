'$INCLUDE: 'olc6502.bi'
'$INCLUDE: 'olc2C02.bi'
'$INCLUDE: 'olc2A03.bi'
'$include: 'cartridge.bi'


DIM SHARED nSystemClockCounter AS _UNSIGNED LONG
DIM SHARED cpuRam(2048) AS _UNSIGNED INTEGER
DIM mema AS _MEM


mema = _MEM(cpuRam())
_MEMFILL mema, mema.OFFSET, mema.SIZE, &H00 AS _UNSIGNED INTEGER
_MEMFREE mema
DIM SHARED called1 AS _UNSIGNED LONG


