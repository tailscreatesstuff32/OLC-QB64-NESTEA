'$include: 'palette.bi'



DIM SHARED tblName(2, 1024) AS _UNSIGNED _BYTE
DIM SHARED tblPattern(2, 4096) AS _UNSIGNED _BYTE
DIM SHARED tblPalette(32) AS _UNSIGNED _BYTE




' alt palette////////////////////////////////////

'this.nesPal = [
'  [101,101,101],[0,45,105],[19,31,127],[60,19,124],[96,11,98],[115,10,55],[113,15,7],[90,26,0],[52,40,0],[11,52,0],[0,60,0],[0,61,16],[0,56,64],[0,0,0],[0,0,0],[0,0,0],
'  [174,174,174],[15,99,179],[64,81,208],[120,65,204],[167,54,169],[192,52,112],[189,60,48],[159,74,0],[109,92,0],[54,109,0],[7,119,4],[0,121,61],[0,114,125],[0,0,0],[0,0,0],[0,0,0],
'  [254,254,255],[93,179,255],[143,161,255],[200,144,255],[247,133,250],[255,131,192],[255,139,127],[239,154,73],[189,172,44],[133,188,47],[85,199,83],[60,201,140],[62,194,205],[78,78,78],[0,0,0],[0,0,0],
'  [254,254,255],[188,223,255],[209,216,255],[232,209,255],[251,205,253],[255,204,229],[255,207,202],[248,213,180],[228,220,168],[204,227,169],[185,232,184],[174,232,208],[175,229,234],[182,182,182],[0,0,0],[0,0,0]
']

'/////////////////////////////////////////////////////












DIM SHARED framecomplete AS _BYTE
DIM SHARED cycle AS INTEGER
DIM SHARED scanline AS INTEGER
DIM SHARED address_latch AS _UNSIGNED _BYTE
DIM SHARED ppu_data_buffer AS _UNSIGNED _BYTE
DIM SHARED ppu_address AS _UNSIGNED INTEGER ' long for now until i see why unsigned integer is giving issues...
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

TYPE PPULOOPY
    work_in_progress AS _UNSIGNED _BYTE
END TYPE


TYPE PPUREGS

    status_reg AS _UNSIGNED _BYTE
    control_reg AS _UNSIGNED _BYTE
    mask_reg AS _UNSIGNED _BYTE
    loopy_reg AS _UNSIGNED INTEGER
    flags_status AS PPUSTATUS
    flags_mask AS PPUMASK
    flags_control AS PPUCTRL
    flags_loopy AS PPULOOPY
END TYPE









