# x86-asm
This repository is kind of a playground for programs written in x86-64 Assembly for Linux.

So what's in here?
* [`alphabet`](alphabet/alphabet.s): Generates the alphabet in the `.data` section and then writes it to stdout
* [`malloc`](malloc): A very bad+basic memory allocation function implementation based on the `brk` syscall
  * The example program dynamically allocates 28 bytes for a string of `a-z`, a newline and a null terminator
  * Then it outputs this generated string
* [`hex`](hex): Reads bytes from stdin and outputs them in hex on stdout
  * There's two implementations, one based on a lookup table and the other based on normal conditions
* [`uppercase`](uppercase/naive/uppercase_naive.s): Similar to `hex`; it reads bytes from stdin and prints the uppercase variant of these bytes
* [`exit`](exit): Basically just calls the exit syscall

### Installation/Run
To run these programs, you need to install `gcc` and `as` (if they aren't already installed).

All directories have `Makefile`s, so to run a program you can just switch to its directory and run `make run`:

    $ cd uppercase/naive && make run
    as uppercase_naive.s -o uppercase_naive.o
    gcc uppercase_naive.o -o uppercase_naive.bin -nostdlib -static
    echo "This text should no longer have lowercase characters (but other chars should be unaffected!)..." | ./uppercase_naive.bin
    THIS TEXT SHOULD NO LONGER HAVE LOWERCASE CHARACTERS (BUT OTHER CHARS SHOULD BE UNAFFECTED!)...

From the last line you can see that the program did output its intended text.

You can also see these programs run on [GitHub Actions](https://github.com/xarantolus/x86-asm/actions/workflows/run_all.yml).


### Useful resources
* [Linux x86-64 Syscall reference table](https://syscalls.w3challs.com/?arch=x86_64)


### [License](LICENSE)
This is free as in freedom software. Do whatever you like with it.
