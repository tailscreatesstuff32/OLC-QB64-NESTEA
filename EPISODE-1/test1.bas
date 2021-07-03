DIM SHARED scale

scale = 1


SCREEN _NEWIMAGE(256 * scale, 240 * scale, 256)

'PSET (4, 5), 1


LINE (5 * scale, 5 * scale)-STEP(scale OR 1, scale OR 1), 1, BF

