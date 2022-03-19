run:
	bash .github/workflows/run_all.sh

install:
	sudo apt-get install gcc

clean:
	find ./*/ -type f -name Makefile -execdir make clean \; > /dev/null

info: run
	find . -type f -name "*.bin" -exec file {} \;
