'$include: 'palette.bi'



DIM SHARED tblName(2, 1024) AS _UNSIGNED _BYTE
DIM SHARED tblPattern(2, 4096) AS _UNSIGNED _BYTE
DIM SHARED tblPalette(32) AS _UNSIGNED _BYTE

tblPalette(0) = 32






DIM SHARED framecomplete AS _BYTE
DIM SHARED cycle AS INTEGER
DIM SHARED scanline AS INTEGER
'DIM SHARED control AS PPUCTRL
DIM SHARED address_latch AS _UNSIGNED _BYTE
DIM SHARED ppu_data_buffer AS _UNSIGNED _BYTE
DIM SHARED ppu_address AS _UNSIGNED INTEGER ' long for now until i see why unsigned integer is giving issues...
'DIM SHARED ppu_address1 AS _UNSIGNED INTEGER
DIM SHARED ppu_nmi AS _BYTE

'DIM SHARED ppu_status_reg AS _UNSIGNED _BYTE

DIM SHARED ppu_regs AS PPUREGS

DIM SHARED nes_scrn AS _UNSIGNED LONG

nes_scrn = _NEWIMAGE(256, 240)


'ppu regs



TYPE PPUCTRL

    nametable_x AS _UNSIGNED _BYTE
    nametable_y AS _UNSIGNED _BYTE
    increment_mode AS _UNSIGNED _BYTE
    pattern_sprite AS _UNSIGNED _BYTE
    pattern_background AS _UNSIGNED _BYTE
    sprite_size AS _UNSIGNED _BYTE
    slave_mode AS _UNSIGNED _BYTE
    enable_nmi AS _UNSIGNED _BYTE

END TYPE


TYPE PPUSTATUS

    unused AS _UNSIGNED _BYTE
    sprite_overflow AS _UNSIGNED _BYTE
    sprite_zero_hit AS _UNSIGNED _BYTE
    vertical_blank AS _UNSIGNED _BYTE

END TYPE

TYPE PPUMASK
    grayscale AS _UNSIGNED _BYTE
    render_background_left AS _UNSIGNED _BYTE
    render_sprites_left AS _UNSIGNED _BYTE
    render_background AS _UNSIGNED _BYTE
    render_sprites AS _UNSIGNED _BYTE
    enhance_red AS _UNSIGNED _BYTE
    enhance_green AS _UNSIGNED _BYTE
    enhance_blue AS _UNSIGNED _BYTE



END TYPE


TYPE PPUREGS

    status_reg AS _UNSIGNED _BYTE
    control_reg AS _UNSIGNED _BYTE
    mask_reg AS _UNSIGNED _BYTE
    loopy_reg AS _UNSIGNED INTEGER
    flags_status AS PPUSTATUS
    flags_mask AS PPUMASK
    fags_control AS PPUCTRL
END TYPE












