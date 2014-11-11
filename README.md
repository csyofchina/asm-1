See http://www.darkcoding.net/software/learning-assembler-on-linux/

Extremely basic Linux x64 assembly. Not really for public consumption. Most of these (except lib) just 'make' in the directory.

- hello: Write hello world. Exit.
- caps: Lower-case a string. This has a loop and a test in it.
- upper: Basic unix text filter. Upper case stdin to stdout.
- djb2: djb2 hash function. http://www.cse.yorku.ca/~oz/hash.html
- prt: Exercise lib/WriteHex, which prints number as hex.
- alloc: Test lib's alloc calls (which use sbrk). No output, watch it in gdb.
- allocmmap: Allocate heap memory with mmap. No output.
- lib: Re-usable macros and procedures

- cml: Work in progress. Most everything else is notes and experiments to support this.

----

Debugging with gdb:

- Include `-gstabs+` when assembling.
- Debug text filters, in gdb: `run < inputfile > outputfile`
- Show assembly, registers in gdb: `layout regs`
