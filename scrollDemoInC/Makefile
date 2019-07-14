APP := scrolldemo
LIB := sdcc_iy
SRC := src/main.c src/lores.c src/sprite.c
EMU := ../../../tools/CSpect/CSpect.exe -zxnext -s14 -w4 -r 

GFXSRC := GFX/Bg.bmp GFX/Sprites.bmp

$(APP).sna : $(SRC) $(GFXSRC)
#	zcc +zxn -vn -startup=0 -lm -clib=$(LIB) $(SRC) -o $(APP) -create-app -Cz"--sna"
	zcc +zxn -vn -startup=0 -clib=$(LIB) $(SRC) -o $(APP) -create-app -Cz"--sna"

	../../../tools/MapGrabber GFX/Bg b
	mv GFX/bg.nxi bg.bin

	../../../tools/MapGrabber GFX/Sprites spr s16 r0
	mv GFX/sprites.spr sprites.spr

run: $(APP).sna
	$(EMU) $(APP).sna

clean:
	rm *.bin
	rm *.sna	
	rm *.spr