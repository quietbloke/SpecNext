InitSprites
	ld bc,SPRITE_SELECT_PORT
	out (c), 0	; select sprite slot 0
	ld b,0
	ld hl, SpriteImages

	ld b,SpriteImagesCount
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

; give spite a random position
	call CreateBall

	ld bc,SPRITE_ATTRIBUTE_WRITE_PORT


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
	jr z, .storehighbit
	inc a				; then inc a again
.storehighbit
	and a,%00000001			; only accept 1 bit for the msb value
 	ld (ix + SpriteXPosBit8),a	; save the MSB

	bit 0,a
	jr nz,.checkRight		; if MSB set then check if we have hit the right edge
					; otherwise check if we have hit the left edge
.checkLeft
	ld a,h
	cp 32				; have we hit the left edge
	jr nc,.updateXPos

	ld a,(ix + SpriteState)		; do we wrap or bounce
	bit 1,a
	jr z,.leftwrap

.leftbounce
	NegateDE

	ld (ix + SpriteXVelLow),de
	jr .updateXPos			; we are done checking xpos

.leftwrap
	ld a,1				; set the MSB
	ld (IX + SpriteXPosBit8),a
	ld hl,$0f00			; and set our position to 15
	jr .updateXPos			; we are done checking xpos

.checkRight
	ld a,h
	cp 15				; have we hit the right edge
	jr c,.updateXPos

	ld a,(ix + SpriteState)
	bit 1,a
	jr z,.rightwrap

.rightbounce
	NegateDE

	ld (ix + SpriteXVelLow),de
	ld hl,$0f00
	jr .updateXPos			; we are done checking xpos

.rightwrap
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
	bit 7,d				; check top or bottom based on direction
	jr z,.checkBottom

.checkTop
	cp 32				; have we hit the top edge
	jr nc,.checkBottom

	ld a,(ix + SpriteState)		; do we wrap or bounce
	bit 1,a
	jr z,.topwrap
.topbounce
	NegateDE
	ld (ix + SpriteYVelLow),de
	ld hl,$2000
	jr .updateYPos

.topwrap
	ld hl,$d000
	jr .updateYPos

.checkBottom
	cp $d0			; have we hit the bottom edge
	jr c,.updateYPos

	ld a,(ix + SpriteState)		; do we wrap or bounce
	bit 1,a
	jr z,.bottomwrap
.bottombounce
	NegateDE
	ld (ix + SpriteYVelLow),de
	ld hl,$d000
	jr .updateYPos
.bottomwrap
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

SpriteState		= 0		; bit 0 = alive, bit 1=screen bounce
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
SpriteNumber = 32				; number of sprites
SpriteData	ds SpriteNumber * SpriteDataLength	; reserve space

SpriteImagesCount = 4					; number of sprite images
SpriteImages:
Sprite1:
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



Sprite3:
	db  $E3, $E3, $E3, $E3, $E3, $10, $10, $10, $10, $10, $10, $E3, $E3, $E3, $E3, $E3;
	db  $E3, $E3, $E3, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $E3, $E3, $E3;
	db  $E3, $E3, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $E3, $E3;
	db  $E3, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $E3;
	db  $E3, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $E3;
	db  $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10;
	db  $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10;
	db  $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10;
	db  $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10;
	db  $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10;
	db  $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10;
	db  $E3, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $E3;
	db  $E3, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $E3;
	db  $E3, $E3, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $E3, $E3;
	db  $E3, $E3, $E3, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $E3, $E3, $E3;
	db  $E3, $E3, $E3, $E3, $E3, $10, $10, $10, $10, $10, $10, $E3, $E3, $E3, $E3, $E3;



Sprite4:
	db  $E3, $E3, $E3, $E3, $E3, $FF, $FF, $FF, $FF, $FF, $FF, $E3, $E3, $E3, $E3, $E3;
	db  $E3, $E3, $E3, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $E3, $E3, $E3;
	db  $E3, $E3, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $E3, $E3;
	db  $E3, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $E3;
	db  $E3, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $E3;
	db  $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF;
	db  $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF;
	db  $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF;
	db  $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF;
	db  $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF;
	db  $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF;
	db  $E3, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $E3;
	db  $E3, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $E3;
	db  $E3, $E3, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $E3, $E3;
	db  $E3, $E3, $E3, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $E3, $E3, $E3;
	db  $E3, $E3, $E3, $E3, $E3, $FF, $FF, $FF, $FF, $FF, $FF, $E3, $E3, $E3, $E3, $E3;

