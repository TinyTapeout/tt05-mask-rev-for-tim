# SPDX-FileCopyrightText: © 2023 Uri Shaked <uri@wokwi.com>
# SPDX-License-Identifier: MIT

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles

def seven_seg_decode(bits):
    if bits == 0b0111111:
        return "0"
    if bits == 0b0000110:
        return "1"
    if bits == 0b1011011:
        return "2"
    if bits == 0b1001111:
        return "3"
    if bits == 0b1100110:
        return "4"
    if bits == 0b1101101:
        return "5"
    if bits == 0b1111101:
        return "6"
    if bits == 0b0000111:
        return "7"
    if bits == 0b1111111:
        return "8"
    if bits == 0b1101111:
        return "9"
    if bits == 0b1110111:
        return "A"
    if bits == 0b1111100:
        return "B"
    if bits == 0b0111001:
        return "C"
    if bits == 0b1011110:
        return "D"
    if bits == 0b1111001:
        return "E"
    if bits == 0b1110001:
        return "F"
    return None

@cocotb.test()
async def test_maskrev(dut):
    dut._log.info("start")
    clock = Clock(dut.clk, 10, units="us")
    cocotb.start_soon(clock.start())
    dut.mask_rev.value = 0xEFAB1337
    dut.ena.value = 1
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 10)
    dut.rst_n.value = 1
    await ClockCycles(dut.clk, 10)

    dut.index.value = 0
    await ClockCycles(dut.clk, 1)
    assert seven_seg_decode(dut.uo_out.value) == "7"

    dut.index.value = 1
    await ClockCycles(dut.clk, 1)
    assert seven_seg_decode(dut.uo_out.value) == "3"

    dut.index.value = 2
    await ClockCycles(dut.clk, 1)
    assert seven_seg_decode(dut.uo_out.value) == "3"
    
    dut.index.value = 3
    await ClockCycles(dut.clk, 1)
    assert seven_seg_decode(dut.uo_out.value) == "1"

    dut.index.value = 4
    await ClockCycles(dut.clk, 1)
    assert seven_seg_decode(dut.uo_out.value) == "B"

    dut.index.value = 5
    await ClockCycles(dut.clk, 1)
    assert seven_seg_decode(dut.uo_out.value) == "A"

    dut.index.value = 6
    await ClockCycles(dut.clk, 1)
    assert seven_seg_decode(dut.uo_out.value) == "F"

    dut.index.value = 7
    await ClockCycles(dut.clk, 1)
    assert seven_seg_decode(dut.uo_out.value) == "E"
