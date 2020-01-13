CPPFLAGS=-arch x86_64 -m64
DEBUG=-g -DDEBUG
OPT=-O3

BIN_DIR=./
LIB_DIR=./
LST_DIR=./

thread	: thread.cpp thread.asm
	nasm -f macho64 -g -l $(BIN_DIR)thread_a.lst thread.asm -o $(BIN_DIR)thread_a.o
	g++ -c $(OPT) $(CPP_FLAGS) thread.cpp -o $(BIN_DIR)thread_c.o
	ld $(BIN_DIR)thread_c.o $(BIN_DIR)thread_a.o -lc -no_pie -o $(BIN_DIR)thread-ld
	g++ $(BIN_DIR)thread_c.o $(BIN_DIR)thread_a.o -lc -Wl -o $(BIN_DIR)thread
	strip -no_uuid -A -u -S -X -N -x $(BIN_DIR)thread

clean :
	rm -fR $(LIB_DIR)*.o 
	rm -fR $(BIN_DIR)thread
	rm -fR $(LST_DIR)*.lst 
