'$INCLUDE: 'olc6502.bi'

DIM SHARED ram(64 * 1024) AS _UNSIGNED INTEGER
DIM mema AS _MEM


mema = _MEM(ram())
_MEMFILL mema, mema.OFFSET, mema.SIZE, &H00 AS _UNSIGNED INTEGER
_MEMFREE mema



