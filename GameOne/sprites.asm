InitSprites
	ld bc,SPRITE_SELECT_PORT
	out (c), 0	; select sprite slot 0
	ld b,0
	ld hl, SpriteImages

	ld b,2
.loopOuter
	push bc
	ld b,0
.loopInner
	push bc
	ld bc,SPRITE_PATTERN_WRITE_PORT
	ld a,(hl)
	out (c), a
	pop bc
	inc hl
	djnz .loopInner

	pop bc
	djnz .loopOuter

; setup sprites
	ld b,SpriteNumber
	ld hl, 0
	ld ix,SpriteData
.loop
	push bc
;	ld bc,SPRITE_SELECT_PORT
;	out (c),l

	ld bc,SPRITE_ATTRIBUTE_WRITE_PORT
;	ld a,0			; sprite number

	ld e,(ix + SpriteXPosHi)
	out (c),e
	ld e,(ix + SpriteYPosHi)
	out (c),e

	ld a,(ix + SpriteXPosBit8)
	out (c),a		; no flags 
	ld a,(ix + SpriteImage)
	set 7,a			; bit 7 is the sprite visible flag
	out (c),a		; sprite set image and make visible

	ld de,SpriteDataLength
	add ix,de
	inc hl
	pop bc
	djnz .loop

	ret
;
; ----------------------------------------------------

SpritesUpdate
	ld bc,SPRITE_SELECT_PORT
	out (c),0

	ld b,SpriteNumber
	ld hl, 0
	ld ix,SpriteData
.loop2
	push bc

	ld bc,SPRITE_ATTRIBUTE_WRITE_PORT
; ----------------------------------
; update xpos
; ----------------------------------
	ld hl,(ix + SpriteXPosLow)
	ld de,(ix + SpriteXVelLow)			

 	ld a,(ix + SpriteXPosBit8)

	add hl,de
	adc a,0
	bit 7,d				; if vel is negative
	jp z, .storehighbit
	inc a				; then inc a again
.storehighbit
	and a,%00000001			; only accept 1 bit for the msb value
 	ld (ix + SpriteXPosBit8),a	; save the MSB

	bit 0,a
	jp nz,.checkRight		; if MSB set then check if we have hit the right edge
					; otherwise check if we have hit the left edge
.checkLeft
	ld a,h
	cp 32				; have we hit the left edge
	jp nc,.updateXPos

	ld a,1				; set the MSB
	ld (IX + SpriteXPosBit8),a
	ld hl,%1000			; and set our position to 16
	jp .updateXPos			; we are done checking xpos

.checkRight
	ld a,h
	cp 16				; have we hit the right edge
	jp c,.updateXPos

	ld a,0				; reset the MSB
	ld (IX + SpriteXPosBit8),a
	ld hl,$2000			; and set our posistion to 32 

.updateXPos
	ld (ix + SpriteXPosLow),hl	; save the new xpos
	out (c),h			; and write new position to sprite

; ----------------------------------
; update ypos
; ----------------------------------
	ld de,(ix + SpriteYVelLow)
	ld hl,(ix + SpriteYPosLow)			

	add hl,de

	ld a,h
	bit 7,d
	jp z,.checkBottom
; has the sprite passed the edge of the screen
.checkTop
;	ld a,h
	cp 32				; have we hit the top edge
	jp nc,.checkBottom

	ld hl,$d000
	jp .updateYPos

.checkBottom
;	ld a,h
	cp $d0			; have we hit the bottom edge
	jp c,.updateYPos

	ld hl,$2000
	jr .updateYPos

.updateYPos
	ld (ix + SpriteYPosLow),hl
	out (c),h

; write the rest of the sprite data
	ld a,(ix + SpriteXPosBit8)
	and a,%00000001
	out (c),a			; the 8th bit for xpos is in the flags byte
	ld a,(ix + SpriteImage)
	set 7,a				; bit 7 is the sprite visible flag
	out (c),a			; sprite set image and make visible

	ld de,SpriteDataLength
	add ix,de
	inc hl
	pop bc
	dec b
	jp nz,.loop2
;djnz .loop2

	ret

SpriteState		= 0	; 1 = alive
SpriteImage 		= 1
SpriteXPosBit8 		= 2	
SpriteXPosLow 		= 3	
SpriteXPosHi 		= 4	
SpriteXVelLow		= 5
SpriteXVelHi		= 6
SpriteYPosLow		= 7
SpriteYPosHi		= 8
SpriteYVelLow		= 9
SpriteYVelHi		= 10

SpriteDataLength = 11
SpriteNumber = 6		; number of sprites
;SpriteData	ds SpriteNumber * SpriteDataLength	; reserve space

SpriteData 	db $01,$00,  $00,$00,$20,  $00,$ff,  $00,$30, $00,$00
	 	db $01,$00,  $00,$00,$40,  $00,$01,  $00,$50, $00,$00
		db $01,$01,  $00,$00,$60,  $00,$00,  $00,$70, $40,$00
		db $01,$01,  $00,$00,$80,  $00,$00,  $00,$90, $bf,$ff
		db $01,$01,  $00,$00,$a0,  $00,$00,  $00,$b0, $00,$01
		db $01,$01,  $00,$00,$c0,  $00,$00,  $00,$d0, $00,$ff

SpriteImages:
	db  $E3, $E3, $E3, $E3, $E3, $06, $06, $06, $06, $06, $06, $E3, $E3, $E3, $E3, $E3;
	db  $E3, $E3, $E3, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $E3, $E3, $E3;
	db  $E3, $E3, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $E3, $E3;
	db  $E3, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $E3;
	db  $E3, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $E3;
	db  $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06;
	db  $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06;
	db  $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06;
	db  $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06;
	db  $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06;
	db  $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06;
	db  $E3, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $E3;
	db  $E3, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $E3;
	db  $E3, $E3, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $E3, $E3;
	db  $E3, $E3, $E3, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $E3, $E3, $E3;
	db  $E3, $E3, $E3, $E3, $E3, $06, $06, $06, $06, $06, $06, $E3, $E3, $E3, $E3, $E3;



Sprite2:
	db  $E3, $E3, $E3, $E3, $E3, $E0, $E0, $E0, $E0, $E0, $E0, $E3, $E3, $E3, $E3, $E3;
	db  $E3, $E3, $E3, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E3, $E3, $E3;
	db  $E3, $E3, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E3, $E3;
	db  $E3, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E3;
	db  $E3, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E3;
	db  $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0;
	db  $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0;
	db  $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0;
	db  $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0;
	db  $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0;
	db  $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0;
	db  $E3, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E3;
	db  $E3, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E3;
	db  $E3, $E3, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E3, $E3;
	db  $E3, $E3, $E3, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E3, $E3, $E3;
	db  $E3, $E3, $E3, $E3, $E3, $E0, $E0, $E0, $E0, $E0, $E0, $E3, $E3, $E3, $E3, $E3;