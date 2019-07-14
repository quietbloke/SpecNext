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

/* --------------------------------- */

static void initialise();

/* --------------------------------- */

int main(void)
{
  unsigned char loresAngleSin = 0;
  unsigned char loresAngleCos = 64;
  initialise();

  loResSetInitPallete();

//  for ( char pos=0; pos < 64; pos++)
//  {
//    loresSinOffset[pos] = (sin(2.0*3.141592 / 64 * pos) * 20);
//    signed char ypos = (cos(2.0*3.141592 / 64 * pos) * 20);
//    if ( ypos < 0 )
//    {
//      ypos -= 64;
//    }
//    loresCosOffset[pos] = ypos;
//  }

  zx_border(INK_BLUE);
  if ( !loResLoadImage("bg.bin"))
  {
    zx_border(7);
  }

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
  IO_NEXTREG_DAT = RSLS_ENABLE_LORES; 
}
