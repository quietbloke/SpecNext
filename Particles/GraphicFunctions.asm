GRAPHIC_LOWRESMODE	= %10000000
GRAPHIC_SPRITES_VISIBLE = %00000001

SetSpriteControlRegister
	ld d,a
	ld bc,TBBLUE_REGISTER_SELECT_PORT
	ld a,SPRITE_CONTROL_REGISTER
	out (c),a
	inc b
	out (c),d
	ret

;---------------
; Set X offset of layer 2
; in - a = x offset (0-255)
;---------------
SetXOffsetLayer2
        push de
        ld bc,TBBLUE_REGISTER_SELECT_PORT
        ld d,LOWRES_XOFFSET_REGISTER
        out (c),d
        inc b
        out (c),a
        pop de
        ret

SetYOffsetLayer2
        push de
        ld bc,TBBLUE_REGISTER_SELECT_PORT
        ld d,LOWRES_YOFFSET_REGISTER
        out (c),d
        inc b
        out (c),a
        pop de
        ret
