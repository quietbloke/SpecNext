APP := testsprites
LIB := sdcc_iy
SRC := src/TestSprites.c src/Sprite.c
EMU := ../../tools/CSpect/CSpect.exe -zxnext -s14 -w4 -r 


build: $(APP).sna
	zcc +zxn -vn -startup=0 -clib=$(LIB) $(SRC) -o $(APP) -create-app -Cz"--sna"
	$(EMU) $(APP).sna

run: 
	$(EMU) -mmc=.\ $(APP).sna


clean:
	rm *.bin
	rm *.sna