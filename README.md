BasicKernel
===========
This is code that I've been writing for a basic kernel from the [Writing a Simple Operating System from Scratch](http://www.cs.bham.ac.uk/%7Eexr/lectures/opsys/10_11/lectures/os-dev.pdf) book.

Compiling
---------
I cross-compile from `x86_64` to `x86` (64 to 32-bit) on my machine, but all the code is plain `x86`. You will require `gcc` and `nasm` (as well as the normal GNU core utils) and you can run the final image using [QEMU](https://www.qemu.org/). To compile just run `make`.

Code Structure
--------------
 - `boot/`: code necessary for the boot process (i.e. loading the kernel and switching to 32-bit protected mode).
 - `kernel/`: code related to the kernel itself.
 - `drivers/`: interface code that simplifies interaction with hardware devices.
 - `bin/`: binary directory where final `os-image` is stored.

License
-------
Since this code is made with the help of the above mentioned book so generously created (yet incomplete), I've licensed this repo under the [Unlicense](/LICENSE).
