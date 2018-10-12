; ----- Colour palette (ULA)
BLACK 			equ 0
BLUE 			equ 1
RED 			equ 2
MAGENTA 		equ 3
GREEN 			equ 4
CYAN 			equ 5
YELLOW	 		equ 6
WHITE	 		equ 7
P_BLACK			equ 0
P_BLUE			equ 1<<3
P_RED			equ 2<<3
P_MAGENTA		equ 3<<3
P_GREEN			equ 4<<3
P_CYAN			equ 5<<3
P_YELLOW		equ 6<<3
P_WHITE			equ 7<<3

; Ports
TBBLUE_REGISTER_SELECT_PORT		equ $243b
SPRITE_SELECT_PORT			equ $303b
LAYER2_ACCESS_PORT			equ $123b

SPRITE_ATTRIBUTE_WRITE_PORT		equ $57
SPRITE_PATTERN_WRITE_PORT		equ $5b

; Registers
TURBO_CONTROL_REGISTER			equ $07
SPRITE_CONTROL_REGISTER			equ $15		;Enables/disables Sprites and Lores Layer, and chooses priority of sprites and Layer 2.
LOWRES_XOFFSET_REGISTER 		equ $32
LOWRES_YOFFSET_REGISTER			equ $33

LAYER2_OFFSET_REGISTER 			equ $16
LAYER2_YOFFSET_REGISTER			equ $17
