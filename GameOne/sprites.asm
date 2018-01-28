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

	ld e,(ix + SpriteXPos)
	out (c),e
	ld e,(ix + SpriteYPos)
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
	ld de,(ix + SpriteXPos)			; get xpos and xvel
	ld a,e
	add a,d

; has the sprite passed the edge of the screen
.checkLeft
	cp 32				; have we hit the top edge
	jp c,.bounceXVel
.checkRight
	cp 192 + 17			; have we hit the bottom edge
	jp nc,.bounceXVel

	jr .updateXPos

.bounceXVel
	ld a,d
	neg
	ld (ix + SpriteXVel),a

	ld a,e
	add a,d

.updateXPos
	ld (ix + SpriteXPos),a			; save the new xpos
	out (c),a				; and write new position to sprite

; ----------------------------------
; update xpos
; ----------------------------------
	ld de,(ix + SpriteYPos)
	ld a,e
	add a,d

; has the sprite passed the edge of the screen
.checkTop
	cp 32				; have we hit the top edge
	jp c,.bounceYVel
;	jp .bounceYVel

.checkBottom
	cp 192 + 17			; have we hit the bottom edge
	jp nc,.bounceYVel

	jr .updateYPos

.bounceYVel
	ld a,d
	neg
	ld (ix + SpriteYVel),a

	ld a,e
	add a,d

.updateYPos
	ld (ix + SpriteYPos),a
	out (c),a

; write the rest of the sprite data
	ld a,(ix + SpriteXPosBit8)
	out (c),a			; the 8th bit for xpos is in the flags byte
	ld a,(ix + SpriteImage)
	set 7,a				; bit 7 is the sprite visible flag
	out (c),a			; sprite set image and make visible

	ld de,SpriteDataLength
	add ix,de
	inc hl
	pop bc
	djnz .loop2

	ret

SpriteState		= 0	; 1 = alive
SpriteXPosBit8 		= 1	
SpriteXPos 		= 2	
SpriteXVel		= 3
SpriteYPos		= 4
SpriteYVel		= 5
SpriteImage 		= 6

SpriteDataLength = 7
SpriteNumber = 3		; number of sprites
;SpriteData	ds SpriteNumber * SpriteDataLength	; reserve space

SpriteData 	db $01,$00,$20,$01,$30,$00,$00
		db $01,$00,$40,$00,$50,$01,$01
		db $01,$01,$00,$00,$70,$00,$01

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