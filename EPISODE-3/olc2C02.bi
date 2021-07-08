'$include: 'palette.bi'



DIM SHARED tblName(2, 1024) AS _UNSIGNED _BYTE
DIM SHARED tblPalette(32) AS _UNSIGNED _BYTE
DIM SHARED framecomplete AS _BYTE
DIM SHARED cycle AS INTEGER
DIM SHARED scanline AS INTEGER





DIM SHARED nes_scrn AS _UNSIGNED LONG

nes_scrn = _NEWIMAGE(256, 240)














