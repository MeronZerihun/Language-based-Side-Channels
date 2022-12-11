#!/bin/bash

# rm -f ./edit-distance/pin/addr_code_itrace_diff.out
python3 get_code.py -trace 0x5555555ed000 -code 0x0000000000099000 -diff ./itrace/