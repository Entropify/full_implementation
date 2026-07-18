.global _start

_start:

    lw x1, 0(x0)    # x1 = 1
    lw x2, 4(x0)    # x2 = 2
    lw x3, 8(x0)    # x3 = 3

    # test alu
    add x4, x1, x2  # x4 = 1 + 2 = 3

    # test beq (should take branch)
    # it should jump to pass_1 since 3 = 3 (wow rlly?)
    beq x4, x3, pass_1
    
    # if it fails to jump, write error code 3 to x10 and halt
    add x10, x0, x4
    beq x0, x0, halt

pass_1:
    # test beq (should not take branch)
    beq x1, x2, fail_2
    beq x0, x0, pass_2  # jump over the error trap

fail_2:
    # if it did jump (chud cpu), write error code 2 to x10 and halt
    add x10, x0, x2
    beq x0, x0, halt

pass_2:
    # test lw and sw
    # store 3 from x4 into a blank space in RAM (address 12)
    sw x4, 12(x0)
    # read it back into a new register to see if it worked
    lw x5, 12(x0)
    
    # check if RAM preserved the 3
    beq x5, x3, all_pass

    # if sw or lw failed, write error code 5 to x10 and halt
    add x10, x2, x3 
    beq x0, x0, halt

all_pass:
    # write success code 1 to x10
    add x10, x0, x1

halt:
    # infinite loop to trigger cocotb detection
    beq x0, x0, 0