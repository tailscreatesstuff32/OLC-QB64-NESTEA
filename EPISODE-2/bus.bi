'$INCLUDE: 'olc6502.bi'
'$INCLUDE: 'olc2C02.bi'
'$INCLUDE: 'olc2A03.bi'
'$include: 'cartridge.bi'

DIM SHARED ram(64 * 1024) AS _UNSIGNED INTEGER
DIM mema AS _MEM


mema = _MEM(ram())
_MEMFILL mema, mema.OFFSET, mema.SIZE, &H00 AS _UNSIGNED INTEGER
_MEMFREE mema



