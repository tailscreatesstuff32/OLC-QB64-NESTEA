


SCREEN _NEWIMAGE(640, 480, 256)




a$ = "1e1e1e0309280a042b17022822001d24010a2404021b09011110010515010117"
a$ = a$ + "0200140b01111b0000000000000000002f302f051a3712103b23093831062e35"
a$ = a$ + "0818350d082d1603221e010e240105260602261602222a0b0b0b000000000000"
a$ = a$ + "3d3d3e122c3e22253f301e3e3a1b3b3d1d2e3d201b3b28113530082635081437"
a$ = a$ + "110f37250a36371819190101010101013e3e3e2d373e33343f37313e3c303d3d"
a$ = a$ + "30383d33303d362b3b3926343b272e3c2d2c3c36293c3c323132010101010101"
FOR i = 0 TO 63
    r = VAL("&h" + MID$(a$, 1 + 6 * i, 2))
    g = VAL("&h" + MID$(a$, 3 + 6 * i, 2))
    b = VAL("&h" + MID$(a$, 5 + 6 * i, 2))
    pn i, r, g, b
    pn 64 + i, 0, 0, 0
    pn 128 + i, r, g, b
    pn 192 + i, r, g, b
NEXT

'FOR col = 0 TO 63
FOR y = 0 TO 3
    FOR x = 0 TO 15
        LINE (x * 20 + 0, y * 20 + 40)-(20 * x + 20 + 0, y * 20 + 20 + 40), (x + y * 16), BF
    NEXT x
NEXT y




SUB pn (n, r, g, b)
    OUT 968, n
    OUT 969, r
    OUT 969, g
    OUT 969, b
END SUB

