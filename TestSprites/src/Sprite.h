#ifndef SPRITE_H
#define SPRITE_H

void enable_sprites();
void set_sprite_pattern_slot(uint8_t slot);
void set_pattern(uint8_t* sprite_pattern);
void set_sprite(uint16_t xpos, uint8_t ypos);

#endif