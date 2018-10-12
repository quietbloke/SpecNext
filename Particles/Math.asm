RandomSeed dw 0

; hammers a-de
Rand192
	push hl
	ld hl,(RandomSeed)
	ld a,r
	ld d,a
	ld e,a
	add hl,de
	xor l
	add a,a
	xor h
	ld l,a
	ld (RandomSeed),hl

	bit 7,a
	jr z,.clampRand192
	and %10111111
.clampRand192
	pop hl
     	ret

; hammers a-de
Rand256
	push hl
	ld hl,(RandomSeed)
	ld a,r
	ld d,a
	ld e,a
	add hl,de
	xor l
	add a,a
	xor h
	ld l,a
	ld (RandomSeed),hl
	pop hl
	ret
