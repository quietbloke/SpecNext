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

	Rand256Inline
	ld (ix + SpriteXVelLow), a
	and a,%00000001
	neg
	ld (ix + SpriteXVelHi), a

	Rand256Inline
	ld (ix + SpriteYVelLow), a
	and a,%00000001
	neg	
	ld (ix + SpriteYVelHi), a

	ret