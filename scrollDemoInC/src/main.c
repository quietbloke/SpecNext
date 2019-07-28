#include <stdlib.h>
#include <stddef.h>
#include <input.h>
#include <intrinsic.h>
#include <arch/zxn.h>

#include <stdio.h>
#include <string.h>
#include <stdbool.h>
//#include <math.h>
#include "lores.h"
#include "sprite.h"


static signed char sinOffsetX[] = {
	1 , 1 , 2 , 2 , 3 , 4 , 4 , 5,
	5 , 6 , 6 , 7 , 8 , 8 , 9 , 9,
	10 , 10 , 11 , 11 , 12 , 12 , 13 , 13,
	14 , 14 , 15 , 15 , 16 , 16 , 17 , 17,
	17 , 18 , 18 , 19 , 19 , 19 , 20 , 20,
	20 , 21 , 21 , 21 , 21 , 22 , 22 , 22,
	22 , 23 , 23 , 23 , 23 , 23 , 23 , 24,
	24 , 24 , 24 , 24 , 24 , 24 , 24 , 24,
	24 , 24 , 24 , 24 , 24 , 24 , 24 , 24,
	23 , 23 , 23 , 23 , 23 , 23 , 22 , 22,
	22 , 22 , 21 , 21 , 21 , 21 , 20 , 20,
	20 , 19 , 19 , 19 , 18 , 18 , 17 , 17,
	17 , 16 , 16 , 15 , 15 , 14 , 14 , 13,
	13 , 12 , 12 , 11 , 11 , 10 , 10 , 9,
	9 , 8 , 8 , 7 , 6 , 6 , 5 , 5,
	4 , 4 , 3 , 2 , 2 , 1 , 1 , 0,
	-1 ,-1 ,-2 ,-2 ,-3 ,-4 ,-4 ,-5,
	-5 ,-6 ,-6 ,-7 ,-8 ,-8 ,-9 ,-9,
	-10 ,-10 ,-11 ,-11 ,-12 ,-12 ,-13 ,-13,
	-14 ,-14 ,-15 ,-15 ,-16 ,-16 ,-17 ,-17,
	-17 ,-18 ,-18 ,-19 ,-19 ,-19 ,-20 ,-20,
	-20 ,-21 ,-21 ,-21 ,-21 ,-22 ,-22 ,-22,
	-22 ,-23 ,-23 ,-23 ,-23 ,-23 ,-23 ,-24,
	-24 ,-24 ,-24 ,-24 ,-24 ,-24 ,-24 ,-24,
	-24 ,-24 ,-24 ,-24 ,-24 ,-24 ,-24 ,-24,
	-23 ,-23 ,-23 ,-23 ,-23 ,-23 ,-22 ,-22,
	-22 ,-22 ,-21 ,-21 ,-21 ,-21 ,-20 ,-20,
	-20 ,-19 ,-19 ,-19 ,-18 ,-18 ,-17 ,-17,
	-17 ,-16 ,-16 ,-15 ,-15 ,-14 ,-14 ,-13,
	-13 ,-12 ,-12 ,-11 ,-11 ,-10 ,-10 ,-9,
	-9 ,-8 ,-8 ,-7 ,-6 ,-6 ,-5 ,-5,
	-4 ,-4 ,-3 ,-2 ,-2 ,-1 ,-1 , 0
};

static signed char sinOffsetY[] = {
	 1 , 1 , 2 , 3 , 3 , 4 , 5 , 5,
	 6 , 7 , 7 , 8 , 9 , 9 , 10 , 11,
	 11 , 12 , 12 , 13 , 14 , 14 , 15 , 15,
	 16 , 16 , 17 , 17 , 18 , 18 , 19 , 19,
	 19 , 20 , 20 , 21 , 21 , 21 , 22 , 22,
	 22 , 22 , 23 , 23 , 23 , 23 , 23 , 24,
	 24 , 24 , 24 , 24 , 24 , 24 , 24 , 24,
	 24 , 24 , 24 , 24 , 24 , 24 , 23 , 23,
	 23 , 23 , 23 , 22 , 22 , 22 , 22 , 21,
	 21 , 21 , 20 , 20 , 19 , 19 , 19 , 18,
	 18 , 17 , 17 , 16 , 16 , 15 , 15 , 14,
	 14 , 13 , 12 , 12 , 11 , 11 , 10 , 9,
	 9 , 8 , 7 , 7 , 6 , 5 , 5 , 4,
	 3 , 3 , 2 , 1 , 1 , 0 ,-1 ,-1,
	-2 ,-3 ,-3 ,-4 ,-5 ,-5 ,-6 ,-7,
	-7 ,-8 ,-9 ,-9 ,-10 ,-11 ,-11 ,-12,
	-12 ,-13 ,-14 ,-14 ,-15 ,-15 ,-16 ,-16,
	-17 ,-17 ,-18 ,-18 ,-19 ,-19 ,-19 ,-20,
	-20 ,-21 ,-21 ,-21 ,-22 ,-22 ,-22 ,-22,
	-23 ,-23 ,-23 ,-23 ,-23 ,-24 ,-24 ,-24,
	-24 ,-24 ,-24 ,-24 ,-24 ,-24 ,-24 ,-24,
	-24 ,-24 ,-24 ,-24 ,-23 ,-23 ,-23 ,-23,
	-23 ,-22 ,-22 ,-22 ,-22 ,-21 ,-21 ,-21,
	-20 ,-20 ,-19 ,-19 ,-19 ,-18 ,-18 ,-17,
	-17 ,-16 ,-16 ,-15 ,-15 ,-14 ,-14 ,-13,
	-12 ,-12 ,-11 ,-11 ,-10 ,-9 ,-9 ,-8,
	-7 ,-7 ,-6 ,-5 ,-5 ,-4 ,-3 ,-3,
	-2 ,-1 ,-1 , 0
};


/* --------------------------------- */

static void initialise();

/* --------------------------------- */

int main(void)
{
  unsigned char loresAngleSin = 0;
  unsigned char loresAngleCos = 64;

  unsigned char spriteAngleSin = 0;
  unsigned char spriteAngleCos = 0;
  initialise();

  loResSetInitPallete();

  zx_border(INK_BLUE);
  if ( !loResLoadImage("bg.bin"))
  {
    zx_border(7);
  }

  if ( !sprites_load_patterns("sprites.spr"))
  {
    zx_border(7);
  }
//  enable_sprites();

// temporary test. just draw all the sprites on screen as the appear in the original bitmap.
  set_sprite_pattern_index(0);

  // TODO: Need to build the big sprite from a table.

  unsigned char basepattern = 0;
  unsigned char spritesize = 16;

  set_sprite(32 + 128 - 32, 64, basepattern);
  set_sprite_composite(spritesize, 0, basepattern+1);
  set_sprite_composite(spritesize*2, 0, basepattern+2);
  set_sprite_composite(spritesize*3, 0, basepattern+3);

  set_sprite_composite(spritesize*0, spritesize, basepattern+4);
  set_sprite_composite(spritesize*1, spritesize, basepattern+5);
  set_sprite_composite(spritesize*2, spritesize, basepattern+6);
  set_sprite_composite(spritesize*3, spritesize, basepattern+7);

  set_sprite_composite(spritesize*0, spritesize*2, basepattern+8);
  set_sprite_composite(spritesize*1, spritesize*2, basepattern+9);
  set_sprite_composite(spritesize*2, spritesize*2, basepattern+10);
  set_sprite_composite(spritesize*3, spritesize*2, basepattern+11);

  set_sprite_composite(spritesize*0, spritesize*3, basepattern+12);
  set_sprite_composite(spritesize*1, spritesize*3, basepattern+13);
  set_sprite_composite(spritesize*2, spritesize*3, basepattern+14);
  set_sprite_composite(spritesize*3, spritesize*3, basepattern+15);

  set_sprite_composite(spritesize*0, spritesize*4, basepattern+16);
  set_sprite_composite(spritesize*1, spritesize*4, basepattern+17);
  set_sprite_composite(spritesize*2, spritesize*4, basepattern+18);
  set_sprite_composite(spritesize*3, spritesize*4, basepattern+19);

  set_sprite_composite(spritesize*-1, spritesize*5, basepattern+20);
  set_sprite_composite(spritesize*0, spritesize*5, basepattern+21);
  set_sprite_composite(spritesize*1, spritesize*5, basepattern+22);
  set_sprite_composite(spritesize*2, spritesize*5, basepattern+23);
  set_sprite_composite(spritesize*3, spritesize*5, basepattern+24);
  set_sprite_composite(spritesize*4, spritesize*5, basepattern+25);

  set_sprite_composite(spritesize*-1, spritesize*6, basepattern+26);
  set_sprite_composite(spritesize*0, spritesize*6, basepattern+27);
  set_sprite_composite(spritesize*1, spritesize*6, basepattern+28);
  set_sprite_composite(spritesize*2, spritesize*6, basepattern+29);
  set_sprite_composite(spritesize*3, spritesize*6, basepattern+30);
  set_sprite_composite(spritesize*4, spritesize*6, basepattern+31);


  // Draw the 4 rounded corner sprites
  set_sprite(32, 32, 34);
  set_sprite(32+256-16, 32, 35);
  set_sprite(32,32+192-16, 32);
  set_sprite(32+256-16,32+192-16, 33);

// keep going till space key is pressed

  while(!in_key_pressed(IN_KEY_SCANCODE_SPACE) ){

// Temp code to slow things down.
//    for ( char p =0; p < 4; p++)
//    {
//      unsigned int x = rand()%128;
//      unsigned int y = rand()%96;
//      loResPlot(x, y, x);
//    }

    loResSetOffsetX(sinOffsetX[loresAngleSin]);
    loResSetOffsetY(sinOffsetX[loresAngleCos]);

    set_sprite_pattern_index(0);
    set_sprite(sinOffsetX[spriteAngleSin] + 128, sinOffsetY[spriteAngleCos] + 52, 0);

    loresAngleSin += 1;
    loresAngleCos += 1;

    spriteAngleSin += 1;
    spriteAngleCos += 1;

    if ( spriteAngleCos > 219)
    {
      spriteAngleCos = 0;
    }

    zx_border(1);

    intrinsic_halt();
    zx_border(0);
  }

  // wait till no key is pressed then a key is pressed before we quit for real
  in_wait_nokey();
  in_wait_key();

  return 0;
}

/* --------------------------------- */

static void initialise()
{
  zx_border(INK_BLUE);

  // Enable the lowres screen
  IO_NEXTREG_REG = REG_SPRITE_LAYER_SYSTEM;
  IO_NEXTREG_DAT = RSLS_ENABLE_LORES | RSLS_SPRITES_VISIBLE; 
}
