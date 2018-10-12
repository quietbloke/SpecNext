; IX pointing to sprite 
CreateBall
	Rand256Inline
	and a,%00000011
	ld ( ix + SpriteImage),a

	ld a,%00000011
	ld ( ix + SpriteState),a

	Rand256Inline
	and a, %01111111
	add a,100
	ld (ix + SpriteXPosHi), a

	ld (ix + SpriteXPosLow), 0

	Rand256Inline
	and a,%01111111
	add a,64
	ld (ix + SpriteYPosHi), a
	ld (ix + SpriteYPosLow), 0

; pick a random number 
	Rand256Inline
; set the low byte velocity to the random value
	ld (ix + SpriteXVelLow), a
	push af
; if the lowbit is set then set the high byte to 1
	and a,%10000000
	cp a,%10000000
	jr c,.fastx

	ld (ix + SpriteXVelHi),2

.fastx
	pop af
	and a,%00000001
	cp a,1
	jr c,.negx

	ld a,(ix + SpriteXVelLow)
	neg
	ld (ix + SpriteXVelLow), a

	ld a,(ix + SpriteXVelHi)
	neg
	ld (ix + SpriteXVelHi), a
.negx

	Rand256Inline
	ld (ix + SpriteYVelLow), a
	and a,%00000010
	cp a,2
	jr c,.negy

	ld a,(ix + SpriteYVelLow)
	neg	
	ld (ix + SpriteYVelLow), a

	ld a,(ix + SpriteYVelHi)
	neg	
	ld (ix + SpriteYVelHi), a
.negy
	ret