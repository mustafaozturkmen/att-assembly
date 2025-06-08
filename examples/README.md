## Assembly Compilation Guide (AT&T Syntax, Linux x86_64)

To compile AT&T-style assembly code (`.s` or `.S` files) on Linux, you can use the **GNU toolchain**, specifically:

- `as` — assembler
- `ld` — linker

Example:
    ```bash
    as hello.s -o hello.o
    ld hello.o -o hello 
    ```
    
---

