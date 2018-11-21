SHELL=/bin/sh
CHMOD=chmod
CP=cp
RM=rm
#CFLAGS=-O2
CFLAGS=-g
#CC=cc
LEX=flex
LEXFLAGS=-t

all: 2600basic preprocess postprocess optimize

2600basic: 2600bas.c statements.c keywords.c statements.h keywords.h
	${CC} ${CFLAGS} -o 2600basic 2600bas.c statements.c keywords.c

postprocess: postprocess.c
	${CC} ${CFLAGS} -o postprocess postprocess.c

preprocess: preprocess.lex
	${LEX} ${LEXFLAGS}<preprocess.lex>lex.yy.c
	${CC} ${CFLAGS} -o preprocess lex.yy.c
	${RM} -f lex.yy.c

optimize: optimize.lex
	${LEX} ${LEXFLAGS}<optimize.lex>lex.yy.c
	${CC} ${CFLAGS} -o optimize lex.yy.c
	${RM} -f lex.yy.c

install: all

clean:
	${RM} -f a.out core 2600basic preprocess postprocess *.js *.data *.metadata *.bc

love:
	@echo "not war"

emscripten:
	make clean
	emmake make
	mv 2600basic bb2600basic.bc
	mv preprocess preprocess.bc
	mv postprocess postprocess.bc
	make bb2600basic.js preprocess.js postprocess.js

%.js: %.bc fs2600basic.js
	emcc -O2 --memory-init-file 0 \
		-s WASM=0 \
		-s MODULARIZE=1 \
		-s EXPORT_NAME=\"'$*'\" \
		-s 'EXTRA_EXPORTED_RUNTIME_METHODS=["FS"]' \
		-s FORCE_FILESYSTEM=1 \
		$< -o $@ $(ARGS_$*)

fs2600basic.js:
	python $(EMSCRIPTEN)/tools/file_packager.py fs2600basic.data \
	--preload ../includes \
	--separate-metadata --js-output=$@
