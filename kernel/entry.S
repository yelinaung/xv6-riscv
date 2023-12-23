        # qemu -kernel loads the kernel at 0x80000000
        # and causes each hart (i.e. CPU) to jump there.
        # kernel.ld causes the following code to
        # be placed at 0x80000000.
.section .text
.global _entry
_entry:
        # set up a stack for C.
        # stack0 is declared in start.c,
        # with a 4096-byte stack per CPU.
        # sp = stack0 + (hartid * 4096)

        # The 'la' instruction in RISC-V assembly stands for "load address".
        # this loads address of the label `stack0` into register `sp`.
        la sp, stack0

        # This set up a per-CPU stack by multiplying the stack size 
        # Then jump to the C start() function to begin initialization.
        # 'li' (loads immediate) loads 4096 into a register `a0`
        li a0, 1024*4

        # by the hartid (CPU number) and adding it to the base stack pointer.
        # This allows each CPU to have its own independent stack.
        # csrr (control and status register) reads the CSR register mhartid
        # hardid = Hardware thread ID-entifier
        csrr a1, mhartid

        # addi (add immediate) adds 1 to register `a1`
        addi a1, a1, 1

        # mul (multiply) multiplies register `a0` by register `a1`
        mul a0, a0, a1

        # add (add) adds register `a0` to register `sp`
        add sp, sp, a0

        # jump to start() in start.c
        call start

# spin: Wait in a loop after start() returns.
# we stay on the spin instruction forever
spin:
        j spin
