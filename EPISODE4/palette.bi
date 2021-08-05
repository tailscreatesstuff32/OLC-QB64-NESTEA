

DIM SHARED nes_pal1(64 - 1) AS _UNSIGNED LONG

'FOR p = 0 TO 64 - 1
'    READ nes_pal1(p)
'NEXT p

'this.nesPal = [
'  [101,101,101],[0,45,105],[19,31,127],[60,19,124],[96,11,98],[115,10,55],[113,15,7],[90,26,0],[52,40,0],[11,52,0],[0,60,0],[0,61,16],[0,56,64],[0,0,0],[0,0,0],[0,0,0],
'  [174,174,174],[15,99,179],[64,81,208],[120,65,204],[167,54,169],[192,52,112],[189,60,48],[159,74,0],[109,92,0],[54,109,0],[7,119,4],[0,121,61],[0,114,125],[0,0,0],[0,0,0],[0,0,0],
'  [254,254,255],[93,179,255],[143,161,255],[200,144,255],[247,133,250],[255,131,192],[255,139,127],[239,154,73],[189,172,44],[133,188,47],[85,199,83],[60,201,140],[62,194,205],[78,78,78],[0,0,0],[0,0,0],
'  [254,254,255],[188,223,255],[209,216,255],[232,209,255],[251,205,253],[255,204,229],[255,207,202],[248,213,180],[228,220,168],[204,227,169],[185,232,184],[174,232,208],[175,229,234],[182,182,182],[0,0,0],[0,0,0]
'  ]


nes_pal1(0) = _RGB(84, 84, 84): '0x00
nes_pal1(1) = _RGB(0, 30, 116): '0x01
nes_pal1(2) = _RGB(8, 16, 144): '0x02
nes_pal1(3) = _RGB(48, 0, 136): '0x03
nes_pal1(4) = _RGB(68, 0, 100): '0x04
nes_pal1(5) = _RGB(92, 0, 48): '0x05
nes_pal1(6) = _RGB(84, 4, 0): '0x06
nes_pal1(7) = _RGB(60, 24, 0): '0x07
nes_pal1(8) = _RGB(32, 42, 0): '0x08
nes_pal1(9) = _RGB(8, 58, 0): '0x09
nes_pal1(10) = _RGB(0, 64, 0): '0x0A
nes_pal1(11) = _RGB(0, 60, 0): '0x0B
nes_pal1(12) = _RGB(0, 50, 60): '0x0C
nes_pal1(13) = _RGB(0, 0, 0): '0x0D
nes_pal1(14) = _RGB(0, 0, 0): '0x0E
nes_pal1(15) = _RGB(0, 0, 0): '0x0F

nes_pal1(16) = _RGB(152, 150, 152): '0x10
nes_pal1(17) = _RGB(8, 76, 196): '0x11
nes_pal1(18) = _RGB(48, 50, 236): '0x12
nes_pal1(19) = _RGB(92, 30, 228): '0x13
nes_pal1(20) = _RGB(136, 20, 176) '0x14
nes_pal1(21) = _RGB(160, 20, 100): '0x15
nes_pal1(22) = _RGB(152, 34, 32): '0x16
nes_pal1(23) = _RGB(120, 60, 0): '0x17
nes_pal1(24) = _RGB(84, 90, 0): '0x18
nes_pal1(25) = _RGB(40, 114, 0): '0x19
nes_pal1(26) = _RGB(8, 124, 0): '0x1A
nes_pal1(27) = _RGB(0, 118, 40): '0x1B
nes_pal1(28) = _RGB(0, 102, 120): '0x1C
nes_pal1(29) = _RGB(0, 0, 0): '0x1D
nes_pal1(30) = _RGB(0, 0, 0): '0x1E
nes_pal1(31) = _RGB(0, 0, 0): '0x1F

nes_pal1(32) = _RGB(236, 238, 236): '0x20
nes_pal1(33) = _RGB(76, 154, 236): '0x21
nes_pal1(34) = _RGB(120, 124, 236): '0x22
nes_pal1(35) = _RGB(176, 98, 236): '0x23
nes_pal1(36) = _RGB(228, 84, 236): '0x24
nes_pal1(37) = _RGB(236, 88, 180): '0x25
nes_pal1(38) = _RGB(236, 106, 100): '0x26
nes_pal1(39) = _RGB(212, 136, 32): '0x27
nes_pal1(40) = _RGB(160, 170, 0): '0x28
nes_pal1(41) = _RGB(116, 196, 0): '0x29
nes_pal1(42) = _RGB(76, 208, 32): '0x2A
nes_pal1(43) = _RGB(56, 204, 108): '0x2B
nes_pal1(44) = _RGB(56, 180, 204): '0x2C
nes_pal1(45) = _RGB(60, 60, 60): '0x2D
nes_pal1(46) = _RGB(0, 0, 0): '0x2E
nes_pal1(47) = _RGB(0, 0, 0): '0x2F

nes_pal1(48) = _RGB(236, 238, 236): '0x30
nes_pal1(49) = _RGB(168, 204, 236): '0x31
nes_pal1(50) = _RGB(188, 188, 236): '0x32
nes_pal1(51) = _RGB(212, 178, 236): '0x33
nes_pal1(52) = _RGB(236, 174, 236): '0x34
nes_pal1(53) = _RGB(236, 174, 212): '0x35
nes_pal1(54) = _RGB(236, 180, 176): '0x36
nes_pal1(55) = _RGB(228, 196, 144): '0x37
nes_pal1(56) = _RGB(204, 210, 120): '0x38
nes_pal1(57) = _RGB(180, 222, 120): '0x39
nes_pal1(58) = _RGB(168, 226, 144): '0x3A
nes_pal1(59) = _RGB(152, 226, 180): '0x3B
nes_pal1(60) = _RGB(160, 214, 228): '0x3C
nes_pal1(61) = _RGB(160, 162, 160): '0x3D
nes_pal1(62) = _RGB(0, 0, 0): '0x3E
nes_pal1(63) = _RGB(0, 0, 0): '0x3F

