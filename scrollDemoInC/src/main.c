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

/* --------------------------------- */

static void initialise();

/* --------------------------------- */

int main(void)
{
  unsigned char loresAngleSin = 0;
  unsigned char loresAngleCos = 64;
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

  unsigned char basex = 32 + 128 - 32;
  unsigned char basey = 64;
  unsigned char basepattern = 0;
  for ( unsigned char y = 0; y < 5; y++)
  {
    for ( unsigned char x = 0; x < 4; x++)
    {
      set_sprite(basex + 16 * x, basey + y * 16, basepattern + y * 4 + x);
    }
  }

  basepattern += 20;
  basex -= 16;
  basey += 16 * 5;
  
  for ( unsigned char y = 0; y < 1; y++)
  {
    for ( unsigned char x = 0; x < 6; x++)
    {
      set_sprite(basex + 16 * x, basey + y * 16, basepattern + y * 4 + x);
    }
  }

  basepattern += 6;
  basex -= 4;
  basey += 16;
  for ( unsigned char y = 0; y < 1; y++)
  {
    for ( unsigned char x = 0; x < 6; x++)
    {
      set_sprite(basex + 16 * x, basey + y * 16, basepattern + y * 4 + x);
    }
  }

  // Draw the 4 rounded corner sprites
  set_sprite(32, 32, 34);
  set_sprite(32+256-16, 32, 35);
  set_sprite(32,32+192-16, 32);
  set_sprite(32+256-16,32+192-16, 33);

// keep going till space key is pressed
  while(!in_key_pressed(IN_KEY_SCANCODE_SPACE) ){
//    for ( char p =0; p < 10; p++)
//    {
//      unsigned int x = rand()%128;
//      unsigned int y = rand()%96;
//      loResPlot(x, y, x);
//    }

    loResSetOffsetX(loresAngleSin);
    loResSetOffsetY(loresAngleCos);

    loresAngleSin += 1;
    loresAngleCos += 1;

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
