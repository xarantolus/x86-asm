PROGRAM_NAME=malloc
CC=gcc
CFLAGS=-g

build: $(PROGRAM_NAME).bin

run: $(PROGRAM_NAME).bin
	./$(PROGRAM_NAME).bin

$(PROGRAM_NAME).bin: $(PROGRAM_NAME).S malloc_user.S
	gcc $^ $(CFLAGS) -o $(PROGRAM_NAME).bin -nostdlib -static

clean:
	rm -f $(PROGRAM_NAME).bin $(PROGRAM_NAME).o
