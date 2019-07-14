#include <stdlib.h>
#include <stddef.h>
#include <arch/zxn.h>
#include <string.h>
#include <stdbool.h>
#include <errno.h>
#include <arch/zxn/esxdos.h>

#define LOWRES_TOP_HALF     (unsigned char*)(0x4000)
#define LOWRES_BOTTOM_HALF  (unsigned char*)(0x6000)

static signed char loresSinOffsetX[] = {
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

static signed char loresSinOffsetY[] = {
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

// NOTE : Assume values for xpos, ypos are valid ( 0-127, 0-95)
void loResPlot(unsigned char xpos, unsigned char ypos, unsigned char colourIndex)
{
  unsigned char* basepokeaddress = (unsigned char *)0x4000;
  if (ypos > 47)
  {
    basepokeaddress = (unsigned char *)0x6000;
    ypos -= 48;
  }

  basepokeaddress[ypos * 128 + xpos] = colourIndex;

  return;
}

void loResSetOffsetX(unsigned char xOffset)
{
  IO_NEXTREG_REG = REG_LORES_OFFSET_X;
  IO_NEXTREG_DAT = loresSinOffsetX[xOffset] * 2; 
}

void loResSetOffsetY(unsigned char yOffset)
{
  IO_NEXTREG_REG = REG_LORES_OFFSET_Y;
  IO_NEXTREG_DAT = (loresSinOffsetX[yOffset] * 2) & 0xbf;   // NOTE : restrict to 192 for vertical values 
}

void loResSetInitPallete()
{
  IO_NEXTREG_REG = REG_PALETTE_CONTROL;
  IO_NEXTREG_DAT = RPC_SELECT_ULA_PALETTE_1 | RPC_ENABLE_ULANEXT | RPC_ENABLE_ULA_PALETTE_1;

  IO_NEXTREG_REG = REG_PALETTE_VALUE_8;
  IO_NEXTREG_DAT = 0x00;
  IO_NEXTREG_DAT = 0x20;
  IO_NEXTREG_DAT = 0x40;
  IO_NEXTREG_DAT = 0x60;
  // Temp : fill with white so I can set a border colour other than black
  for ( unsigned char l = 0; l < 125; l++)
  {
    IO_NEXTREG_DAT = 0xFF;    
  }
}

bool loResLoadImage(char* filename)
{
  uint8_t filehandle;
  errno = 0;

  filehandle = esxdos_f_open(filename, ESXDOS_MODE_R | ESXDOS_MODE_OE);
  if (errno)
  {
    return false;
  }

  unsigned char* destination = LOWRES_TOP_HALF;

  for ( unsigned char ypos = 0; ypos < 48; ypos++)
  {
    esxdos_f_read(filehandle, (void *) destination, 128);
    if (errno)
    {
      return false;
    }
    destination += 128;
  }

  destination = LOWRES_BOTTOM_HALF;

  for ( unsigned char ypos = 0; ypos < 48; ypos++)
  {
    esxdos_f_read(filehandle, (void *) destination, 128);
    if (errno)
    {
      return false;
    }
    destination += 128;
  }

  esxdos_f_close(filehandle);

  return true;
}
