#ifndef LOWRES_H
#define LOWRES_H

void loResSetInitPallete();
void loResPlot(unsigned char xpos, unsigned char ypos, unsigned char colourIndex);
bool loResLoadImage(char* filename);
void loResSetOffsetX(unsigned char xOffset);
void loResSetOffsetY(unsigned char yOffset);


#endif