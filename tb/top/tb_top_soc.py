import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge
from cocotb.triggers import ClockCycles


# generic testbench that runs until the CPU halts then checks x10

@cocotb.test()
async def universal_test(dut):
    

    clock = Clock(dut.clk, 10, units="ns")
    cocotb.start_soon(clock.start())

    dut._log.info("Flushing RAM...")

    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 5)
    
    # flushing ram with basic values since no addi implemented yet
    dut.ram.mem_array[0].value = 1  # address 0
    dut.ram.mem_array[1].value = 2  # address 4
    dut.ram.mem_array[2].value = 3  # address 8

    dut._log.info("RAM flushed with 1 @ address 0, 2 @ address 4, 3 @ address 8")
    
    dut.rst_n.value = 1
    dut._log.info("CPU on. Waiting for assembly to reach successful branch")


    prev_pc = -1
    cycles = 0
    

    # keeping track of cycle and previous pc address to find out when it hits the infinite loop in assembly
    while cycles < 1000:
        await RisingEdge(dut.clk)
        
        try:
            current_pc = dut.cpu.cpu_pc.pc_out.value.integer
            current_instr = dut.cpu.instruction.value.integer
        
            if current_instr == 0x00100533:
                dut._log.info(f"Successful portion of assembly code reached at PC: {current_pc} after {cycles} cycles.")
                await ClockCycles(dut.clk, 5)
                break
                
            #prev_pc = current_pc

        except ValueError:
            pass

        cycles += 1

    # preventing program from stalling forever if soc broken
    if cycles >= 1000:
        assert False, "Simulation timed out. CPU never hit the expected infinite loop."



    # checking register x10 for return value, 1 = pass, anything else = fail

    return_code = dut.cpu.cpu_reg_file.internal_reg[10].value.integer


    
    assert return_code == 1, f'TEST FAILED: assembly code returned error code: {return_code}'

    
    dut._log.info("Error codes meaning:")
    dut._log.info("---------------------------------------------------------------")
    dut._log.info("Error code: 3 = failed to take branch during valid beq")
    dut._log.info("Error code: 2 = failed to not take branch during invalid beq")
    dut._log.info("Error code: 5 = failed to lw and sw properly")
    dut._log.info("---------------------------------------------------------------")
    
    dut._log.info("TEST SUCCESS: Assembly program ran self-checks and passed")
