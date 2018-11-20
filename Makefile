
SAMPLES=\
	samples/sample.bas.bin \
	samples/draw.bas.bin \
	samples/zombie_chase.bas.bin

all: sources $(SAMPLES)

sources:
	cd source && make

%.bas.bin: %.bas
	./2600basic.sh $<
	
clean:
	cd source && make clean
	rm -f samples/*.asm samples/*.bin