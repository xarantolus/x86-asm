PROGRAM_NAME=hex_naive

build: $(PROGRAM_NAME).bin

run: $(PROGRAM_NAME).bin
	echo "This text should result in the same output when put through different programs." | xxd -c 800 -p -
	echo "This text should result in the same output when put through different programs." | ./$(PROGRAM_NAME).bin


$(PROGRAM_NAME).o: $(PROGRAM_NAME).s
	as $(PROGRAM_NAME).s -o $(PROGRAM_NAME).o

$(PROGRAM_NAME).bin: $(PROGRAM_NAME).o
	gcc $(PROGRAM_NAME).o -o $(PROGRAM_NAME).bin -nostdlib -static

clean:
	rm -f $(PROGRAM_NAME).bin $(PROGRAM_NAME).o
