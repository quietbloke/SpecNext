	device zxspectrum48

	org	$8000
start
	di
	ld sp,StackSpace			; set stack
	jp Initialise

;Includes
;-------------------------------
	INCLUDE "Defines.asm"
	INCLUDE "Macros.asm"
	INCLUDE "GraphicFunctions.asm"
	INCLUDE "Layer2.asm"
;	INCLUDE "Balls.asm"
	INCLUDE "Math.asm"

Initialise
	ld a, GRAPHIC_LOWRESMODE + GRAPHIC_SPRITES_VISIBLE
	call SetSpriteControlRegister		; set to lowres mode

;	ClearULA
	SetNormal
	ld a,GREEN:SetBorder			; set border to black

DrawLine
	ld hl,$4000
	ld a,0
	ld b,96					; 96 pixel rows
DrawLineOuterLoop
	push bc
	ld b,128				; 128 pixels for row
DrawLineInnerLoop
	ld (hl),a
	inc hl
	djnz DrawLineInnerLoop
	push af
	ld a,h					; 48 pixels per block. When we hit end of block
	cp $59
	jp nz,DrawLineSameBlock

	ld hl,$6000				; then point to the second block
DrawLineSameBlock
	pop af

	pop bc
	inc a
	djnz DrawLineOuterLoop

	call InitLayer2
	ei

	ld a,0
	push af
MainLoop
	ld a,RED:SetBorder			; set border to red
	pop af
	; scroll the yoffset of screen
	call SetYOffsetLayer2

	inc a					; When we have scrolled
	cp 192					; a whole screen of 192 rows
	jp nz, MainLoopScrollOK

	ld a,0					; then reset scroll 
MainLoopScrollOK
	push af
;	call SpritesUpdate
	pop af

	push af
	ld a,GREEN:SetBorder			; set border to black
	halt					; slow down to 50 hz
	jr MainLoop

;-------------------------------
StackSpaceEnd		ds 127
StackSpace		db 0

	DISPLAY ">------------- Code Range           = ",/H,start,"-",$
	DISPLAY ">------------- Code Length (Bytes)  = ",/D,$-start
	DISPLAY ">------------- Code Space Remaining = ",/D,$c000-$

	savebin "gamelayer2.bin",start,$-start

;---- Output snap file
	savesna "gamelayer2.sna",start
