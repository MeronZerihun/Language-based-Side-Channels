#!/bin/bash

while getopts p:1:2:o: flag
do
    case "${flag}" in
        p) pin=${OPTARG};;
        1) test1=${OPTARG};;
        2) test2=${OPTARG};;
        o) output=${OPTARG};;
    esac
done

# echo "$test1"
# echo "$test2"
# echo "$inst_trace"
# echo "$mem_trace"

# Instruction Trace
$pin/pin -t $pin/source/tools/ManualExamples/obj-intel64/itrace.so -- $test1
cat itrace.out > $output/itrace/test1.out
$pin/pin -t $pin/source/tools/ManualExamples/obj-intel64/itrace.so -- $test2
cat itrace.out > $output/itrace/test2.out

# # Memory Trace
# $pin/pin -t $pin/source/tools/ManualExamples/obj-intel64/pinatrace.so -- $test1
# cat pinatrace.out > $output/mtracee/test1.out
# $pin/pin -t $pin/source/tools/ManualExamples/obj-intel64/pinatrace.so -- $test2
# cat pinatrace.out > $output/mtrace/test2.out

diff --speed-large-files $output/itrace/test1.out $output/itrace/test2.out > $output/itrace_diff.out
grep 0x555 $output/itrace_diff.out > $output/code_itrace_diff.out
echo "Test for itrace differences - Complete!";

# diff --speed-large-files $output/mtrace/test1.out $output/mtrace/test2.out > $output/mem_trace_diff.out
# grep 0x555 $output/mem_trace_diff.out > $output/code_memtrace_diff.out
# echo "Test for mem_trace differences - Complete!";
