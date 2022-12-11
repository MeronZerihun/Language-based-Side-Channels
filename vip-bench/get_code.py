
# file = open('myfile.txt', 'r')
# Lines = file1.readlines()

import argparse
parser = argparse.ArgumentParser()

# get address of _start from trace and code
parser.add_argument("-trace", "--trace", help="Instruction Trace of _start")
parser.add_argument("-code", "--code", help="Code Address of _start")
parser.add_argument("-diff", "--diff", help="Directory containing the test diffs")

args = parser.parse_args()

trace = int(args.trace, 16)
code = int(args.code, 16)
# print("Trace {} Code {}".format(trace, code))

file_r = open(args.diff+"/code_itrace_diff.out", 'r')
lines = file_r.readlines()
for line in lines:
    ln = line.split()
    itrace = int(ln[1], 16)
    # print(itrace)
    # print(trace)
    d = itrace - trace
    addr = hex(code + d)
    with open(args.diff + "/addr_code_itrace_diff.out", 'a') as file_w:
        file_w.write(ln[0] +" "+ str(addr)+"\n")








# print( " User {} size {} ".format(
#         args.username,
#         args.size
#         ))