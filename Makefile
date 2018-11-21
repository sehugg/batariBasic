
SAMPLES=\
	samples/helloworld.bas.bin \
	samples/sample.bas.bin \
	samples/draw.bas.bin \
	samples/zombie_chase.bas.bin \

TESTS=\
	tests/empty.bas.bin \
	tests/longline.bas.bin \

all: sources $(TESTS) $(SAMPLES)

sources:
	cd source && make

%.bas.bin: %.bas
	./2600basic.sh $<
	
clean:
	cd source && make clean
	rm -f samples/*.asm samples/*.bin tests/*.asm tests/*.bin

