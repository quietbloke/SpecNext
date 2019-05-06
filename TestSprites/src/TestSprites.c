#include <stdlib.h>
#include <stddef.h>
#include <input.h>
#include <intrinsic.h>
#include <arch/zxn.h>
#include "Sprite.h"

#define SPRITE_X_MIN 16
#define SPRITE_X_MAX 320-32
#define SPRITE_Y_MIN 16
#define SPRITE_Y_MAX (256 - 32)

typedef struct Sprite{
  uint16_t xpos;
  uint8_t ypos;
} Sprite;

/* --------------------------------- */

void update_player(Sprite* player);

/* --------------------------------- */

void plot(unsigned char x, unsigned char y)
{
  *zx_pxy2saddr(x,y) |= zx_px2bitmask(x);
}

int main(void)
{
  uint8_t pattern [256];
  uint8_t index = 0;
  Sprite player = {.xpos = 180, .ypos = 80};

  index = 0;
  do {
      pattern[index] = 0x0f;
  } while(index++ != 255);

  zx_border(INK_BLUE);
  zx_cls(BRIGHT | INK_WHITE | PAPER_BLACK);

  enable_sprites();

  set_sprite_pattern_slot(0);
  set_pattern(pattern);

  set_sprite_pattern_slot(0);
  set_sprite(player.xpos, player.ypos);

// keep going till space key is pressed
  while(!in_key_pressed(IN_KEY_SCANCODE_SPACE) ){
    update_player(&player);

    set_sprite_pattern_slot(0);
    set_sprite(player.xpos, player.ypos);
    for( index = 0; index < 15; index++ )
    {
      plot(rand()%256, rand()%192);      
    }
    zx_border(INK_RED);

    intrinsic_halt();
    zx_border(INK_BLUE);

  }

  // wait till no key is pressed then a key is pressed before we quit for real
  in_wait_nokey();
  in_wait_key();

  return 0;
}

/* --------------------------------- */

void update_player(Sprite* player)
{
  if ( in_key_pressed(IN_KEY_SCANCODE_x))
  {
    player->xpos++;
    if (player->xpos >= SPRITE_X_MAX)
    {
      player->xpos = SPRITE_X_MIN;
    }
  }
  if ( in_key_pressed(IN_KEY_SCANCODE_z))
  {
    player->xpos--;
    if (player->xpos <= SPRITE_X_MIN)
    {
      player->xpos = SPRITE_X_MAX;
    }
  }

  if ( in_key_pressed(IN_KEY_SCANCODE_l))
  {
    player->ypos++;
    if (player->ypos >= SPRITE_Y_MAX)
    {
      player->ypos = SPRITE_Y_MIN;
    }
  }
  if ( in_key_pressed(IN_KEY_SCANCODE_p))
  {
    player->ypos--;
    if (player->ypos <= SPRITE_Y_MIN)
    {
      player->ypos = SPRITE_Y_MAX;
    }
  }
}