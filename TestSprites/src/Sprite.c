#include <intrinsic.h>
#include <stdlib.h>
#include <stddef.h>
#include <arch/zxn.h>

#include "Sprite.h"

#define SPRITES_VISIBLE            1
#define SPRITES_OVER_BORDER        2
#define SPRITES_ENABLE_CLIPPING    16

void enable_sprites()
{
  IO_NEXTREG_REG = REG_SPRITE_LAYER_SYSTEM;
  IO_NEXTREG_DAT = SPRITES_VISIBLE; 
}

void set_sprite_pattern_slot(uint8_t slot)
{
    IO_SPRITE_SLOT = slot & 0x3F;
}

void set_sprite(uint16_t xpos, uint8_t ypos)
{
  IO_SPRITE_ATTRIBUTE = xpos; // xpos 
  IO_SPRITE_ATTRIBUTE = ypos; // ypos
  
  IO_SPRITE_ATTRIBUTE = (xpos >> 8) & 1;
  IO_SPRITE_ATTRIBUTE = 0x80;
}

void set_pattern(uint8_t *sprite_pattern)
{
//    intrinsic_outi((void *) sprite_pattern, __IO_SPRITE_PATTERN, 256);
    uint8_t index = 0;
    do {
        IO_SPRITE_PATTERN = sprite_pattern[index];
    } while(index++ != 255);
}

