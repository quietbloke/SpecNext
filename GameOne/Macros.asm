;-----------------------------------
;------ Generic helper macros ------
;-----------------------------------	
	MACRO SetBorder
		out (254),a
	ENDM
;
	MACRO ClearULA
		ld hl,$4000
		ld de,$4001
		ld bc,$1800
		ld (hl),l
		ldir
	ENDM
;
	MACRO SetNormal
		ld a,TURBO_CONTROL_REGISTER
		ld bc,TBBLUE_REGISTER_SELECT_PORT
		out (c),a
		inc b
		xor a
		out (c),a
		ei
	ENDM

	MACRO Set7mhz
		di
		ld a,TURBO_CONTROL_REGISTER
		ld bc,TBBLUE_REGISTER_SELECT_PORT
		out (c),a
		inc b
		ld a,%01
		out (c),a
	ENDM

	MACRO Set14mhz
		di
		ld a,TURBO_CONTROL_REGISTER
		ld bc,TBBLUE_REGISTER_SELECT_PORT
		out (c),a
		inc b
		IFDEF _CLAMP_TO_7MHZ
			ld a,%01
		ELSE
			ld a,%10
		ENDIF
		out (c),a
	ENDM

	MACRO Set28mhz
		di
		ld a,TURBO_CONTROL_REGISTER
		ld bc,TBBLUE_REGISTER_SELECT_PORT
		out (c),a
		inc b
		IFDEF _CLAMP_TO_7MHZ
			ld a,%01
		ELSE
			ld a,%11
		ENDIF
		out (c),a
	ENDM

	MACRO Rand256Inline
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
	ENDM

	MACRO NegateDE
		ld a,d
		xor $ff
		ld d,a

		ld a,e
		xor $ff
		inc a
		ld e,a

	ENDM

